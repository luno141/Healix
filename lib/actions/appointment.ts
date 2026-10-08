"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function getAvailableSlots(doctorId: string, dateStr: string) {
  const supabase = await createClient();
  const dateObj = new Date(dateStr);
  const dayOfWeek = dateObj.getDay();

  const { data: availability, error: availError } = await supabase
    .from("doctor_availability")
    .select("*")
    .eq("doctor_id", doctorId)
    .eq("day_of_week", dayOfWeek)
    .eq("is_available", true)
    .single();

  if (availError || !availability) {
    return [];
  }

  const { data: bookedAppointments } = await supabase
    .from("appointments")
    .select("start_time, end_time, status")
    .eq("doctor_id", doctorId)
    .eq("appointment_date", dateStr)
    .in("status", ["pending", "confirmed"]);

  const bookedSlots = new Set((bookedAppointments || []).map((a) => a.start_time.slice(0, 5)));

  const slots: string[] = [];
  const [startH, startM] = availability.start_time.split(":").map(Number);
  const [endH, endM] = availability.end_time.split(":").map(Number);
  const slotDuration = availability.slot_duration || 30;

  let currentMin = startH * 60 + startM;
  const endMin = endH * 60 + endM;

  while (currentMin + slotDuration <= endMin) {
    const h = Math.floor(currentMin / 60).toString().padStart(2, "0");
    const m = (currentMin % 60).toString().padStart(2, "0");
    const slotStr = `${h}:${m}`;
    if (!bookedSlots.has(slotStr)) {
      slots.push(slotStr);
    }
    currentMin += slotDuration;
  }

  return slots;
}

export async function createAppointment(data: {
  doctorId: string;
  appointmentDate: string;
  startTime: string;
  reason: string;
}) {
  const supabase = await createClient();
  const { data: { user }, error: userError } = await supabase.auth.getUser();
  if (userError || !user) throw new Error("Unauthorized");

  const { data: patient } = await supabase
    .from("patients")
    .select("id")
    .eq("profile_id", user.id)
    .single();

  if (!patient) throw new Error("Patient record not found");

  const [h, m] = data.startTime.split(":").map(Number);
  const endMinutes = h * 60 + m + 30;
  const endH = Math.floor(endMinutes / 60).toString().padStart(2, "0");
  const endM = (endMinutes % 60).toString().padStart(2, "0");
  const endTime = `${endH}:${endM}:00`;

  const { data: existing } = await supabase
    .from("appointments")
    .select("id")
    .eq("doctor_id", data.doctorId)
    .eq("appointment_date", data.appointmentDate)
    .eq("start_time", `${data.startTime}:00`)
    .in("status", ["pending", "confirmed"]);

  if (existing && existing.length > 0) {
    throw new Error("This slot is already booked.");
  }

  const { data: appointment, error } = await supabase
    .from("appointments")
    .insert({
      patient_id: patient.id,
      doctor_id: data.doctorId,
      appointment_date: data.appointmentDate,
      start_time: `${data.startTime}:00`,
      end_time: endTime,
      reason: data.reason,
      status: "pending"
    })
    .select()
    .single();

  if (error) throw new Error(error.message);

  const { data: doctor } = await supabase
    .from("doctors")
    .select("profile_id")
    .eq("id", data.doctorId)
    .single();

  if (doctor) {
    await supabase.from("notifications").insert({
      user_id: doctor.profile_id,
      title: "New Appointment Request",
      message: `You have a new appointment booking request for ${data.appointmentDate} at ${data.startTime}.`,
      type: "appointment_booked"
    });
  }

  revalidatePath("/patient/appointments");
  revalidatePath("/patient/dashboard");
  return appointment;
}

export async function cancelAppointment(appointmentId: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");

  const { error } = await supabase
    .from("appointments")
    .update({ status: "cancelled" })
    .eq("id", appointmentId);

  if (error) throw new Error(error.message);

  revalidatePath("/patient/appointments");
  revalidatePath("/doctor/appointments");
  return { success: true };
}

export async function rescheduleAppointment(appointmentId: string, newDate: string, newStartTime: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");

  const [h, m] = newStartTime.split(":").map(Number);
  const endMinutes = h * 60 + m + 30;
  const endH = Math.floor(endMinutes / 60).toString().padStart(2, "0");
  const endM = (endMinutes % 60).toString().padStart(2, "0");
  const endTime = `${endH}:${endM}:00`;

  const { error } = await supabase
    .from("appointments")
    .update({
      appointment_date: newDate,
      start_time: `${newStartTime}:00`,
      end_time: endTime,
      status: "rescheduled"
    })
    .eq("id", appointmentId);

  if (error) throw new Error(error.message);

  revalidatePath("/patient/appointments");
  revalidatePath("/doctor/appointments");
  return { success: true };
}
