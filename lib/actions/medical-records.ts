"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function createMedicalRecord(patientId: string, data: {
  record_type: string;
  title: string;
  description: string;
  diagnosis: string;
  treatment: string;
}) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");

  const { data: record, error } = await supabase
    .from("medical_records")
    .insert({
      patient_id: patientId,
      created_by: user.id,
      ...data
    })
    .select()
    .single();

  if (error) throw new Error(error.message);

  const { data: patient } = await supabase
    .from("patients")
    .select("profile_id")
    .eq("id", patientId)
    .single();

  if (patient) {
    await supabase.from("notifications").insert({
      user_id: patient.profile_id,
      title: "Medical Record Added",
      message: `A new medical record "${data.title}" was added to your chart.`,
      type: "medical_record_updated"
    });
  }

  revalidatePath("/doctor/patients");
  revalidatePath("/patient/medical-history");
  return record;
}

export async function updateMedicalRecord(recordId: string, data: any) {
  const supabase = await createClient();
  const { data: record, error } = await supabase
    .from("medical_records")
    .update(data)
    .eq("id", recordId)
    .select()
    .single();

  if (error) throw new Error(error.message);
  revalidatePath("/doctor/medical-records/" + recordId);
  return record;
}

export async function getMedicalRecords(patientId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("medical_records")
    .select("*, medical_record_files(*), profiles:created_by(full_name)")
    .eq("patient_id", patientId)
    .order("created_at", { ascending: false });

  if (error) return [];
  return data || [];
}
