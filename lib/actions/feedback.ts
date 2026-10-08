"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function submitFeedback(appointmentId: string, rating: number, comment: string) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");

  const { data: appt } = await supabase
    .from("appointments")
    .select("id, doctor_id, patient_id, status")
    .eq("id", appointmentId)
    .single();

  if (!appt || appt.status !== "completed") {
    throw new Error("Feedback can only be provided for completed appointments.");
  }

  const { error } = await supabase.from("feedback").insert({
    appointment_id: appointmentId,
    patient_id: appt.patient_id,
    doctor_id: appt.doctor_id,
    rating,
    comment
  });

  if (error) throw new Error(error.message);

  revalidatePath("/patient/appointments");
  revalidatePath("/doctor/feedback");
  return { success: true };
}
