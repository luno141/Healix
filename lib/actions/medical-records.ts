'use server';

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function createMedicalRecord(patientId: string, data: {
  record_type: string;
  title: string;
  description: string;
  diagnosis: string;
  treatment: string;
}, formData?: FormData) {
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

  // If a file was attached in the formData
  if (formData) {
    const file = formData.get("file") as File;
    if (file && file.size > 0) {
      const fileExt = file.name.split('.').pop();
      const filePath = `${patientId}/${record.id}_${Date.now()}.${fileExt}`;
      const fileBuffer = await file.arrayBuffer();

      const { error: uploadError } = await supabase.storage
        .from("medical-files")
        .upload(filePath, fileBuffer, {
          contentType: file.type,
          upsert: true
        });

      if (!uploadError) {
        await supabase.from("medical_record_files").insert({
          record_id: record.id,
          file_name: file.name,
          file_path: filePath,
          file_type: file.type
        });
      }
    }
  }

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
  revalidatePath(`/doctor/patients/${patientId}`);
  revalidatePath("/patient/medical-history");
  return record;
}

export async function getMedicalFileUrl(filePath: string) {
  const supabase = await createClient();
  const { data, error } = await supabase.storage
    .from("medical-files")
    .createSignedUrl(filePath, 3600); // 1 hour secure signed URL

  if (error) return null;
  return data.signedUrl;
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
