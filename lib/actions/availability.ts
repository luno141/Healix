"use server";

import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";

export async function createAvailability(doctorId: string, data: {
  day_of_week: number;
  start_time: string;
  end_time: string;
  slot_duration: number;
  is_available: boolean;
}) {
  const supabase = await createClient();
  const { data: result, error } = await supabase
    .from("doctor_availability")
    .upsert({
      doctor_id: doctorId,
      ...data
    })
    .select()
    .single();

  if (error) throw new Error(error.message);
  revalidatePath("/doctor/schedule");
  return result;
}

export async function updateAvailability(availabilityId: string, data: any) {
  const supabase = await createClient();
  const { data: result, error } = await supabase
    .from("doctor_availability")
    .update(data)
    .eq("id", availabilityId)
    .select()
    .single();

  if (error) throw new Error(error.message);
  revalidatePath("/doctor/schedule");
  return result;
}

export async function deleteAvailability(availabilityId: string) {
  const supabase = await createClient();
  const { error } = await supabase
    .from("doctor_availability")
    .delete()
    .eq("id", availabilityId);

  if (error) throw new Error(error.message);
  revalidatePath("/doctor/schedule");
  return { success: true };
}

export async function getDoctorAvailability(doctorId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("doctor_availability")
    .select("*")
    .eq("doctor_id", doctorId)
    .order("day_of_week", { ascending: true });

  if (error) return [];
  return data || [];
}
