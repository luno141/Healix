"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function confirmAppointment(appointmentId: string) {
  const supabase = await createClient();
  const { data: appt, error } = await supabase
    .from("appointments")
    .update({ status: "confirmed" })
    .eq("id", appointmentId)
    .select("patient_id, appointment_date, start_time")
    .single();

  if (error) throw new Error(error.message);

  if (appt) {
    const { data: patient } = await supabase
      .from("patients")
      .select("profile_id")
      .eq("id", appt.patient_id)
      .single();

    if (patient) {
      await supabase.from("notifications").insert({
        user_id: patient.profile_id,
        title: "Appointment Confirmed",
        message: `Your appointment for ${appt.appointment_date} at ${appt.start_time} has been confirmed.`,
        type: "appointment_confirmed"
      });
    }
  }

  revalidatePath("/doctor/appointments");
  revalidatePath("/doctor/dashboard");
  return { success: true };
}

export async function completeAppointment(appointmentId: string) {
  const supabase = await createClient();
  const { data: appt, error } = await supabase
    .from("appointments")
    .update({ status: "completed" })
    .eq("id", appointmentId)
    .select("patient_id")
    .single();

  if (error) throw new Error(error.message);

  if (appt) {
    const { data: patient } = await supabase
      .from("patients")
      .select("profile_id")
      .eq("id", appt.patient_id)
      .single();

    if (patient) {
      await supabase.from("notifications").insert({
        user_id: patient.profile_id,
        title: "Appointment Completed",
        message: "Your appointment has been marked as complete. Please leave a rating and feedback!",
        type: "appointment_completed"
      });
    }
  }

  revalidatePath("/doctor/appointments");
  revalidatePath("/doctor/dashboard");
  return { success: true };
}

export async function cancelAppointmentDoctor(appointmentId: string, reason?: string) {
  const supabase = await createClient();
  const { data: appt, error } = await supabase
    .from("appointments")
    .update({ status: "cancelled", notes: reason })
    .eq("id", appointmentId)
    .select("patient_id, appointment_date")
    .single();

  if (error) throw new Error(error.message);

  if (appt) {
    const { data: patient } = await supabase
      .from("patients")
      .select("profile_id")
      .eq("id", appt.patient_id)
      .single();

    if (patient) {
      await supabase.from("notifications").insert({
        user_id: patient.profile_id,
        title: "Appointment Cancelled",
        message: `Your appointment on ${appt.appointment_date} was cancelled by your doctor.`,
        type: "appointment_cancelled"
      });
    }
  }

  revalidatePath("/doctor/appointments");
  revalidatePath("/doctor/dashboard");
  return { success: true };
}

export async function addAppointmentNotes(appointmentId: string, notes: string) {
  const supabase = await createClient();
  const { error } = await supabase
    .from("appointments")
    .update({ notes })
    .eq("id", appointmentId);

  if (error) throw new Error(error.message);
  revalidatePath("/doctor/appointments");
  return { success: true };
}
