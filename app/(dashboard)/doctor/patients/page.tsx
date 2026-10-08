export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import Link from "next/link";

export default async function DoctorPatientsPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: doctor } = await supabase
    .from("doctors")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("patient_id, patients(*, profiles:profile_id(full_name, email, phone, date_of_birth, gender))")
    .eq("doctor_id", doctor?.id || "");

  const uniquePatientsMap = new Map();
  appointments?.forEach((a: any) => {
    if (a.patients && !uniquePatientsMap.has(a.patient_id)) {
      uniquePatientsMap.set(a.patient_id, a.patients);
    }
  });

  const patients = Array.from(uniquePatientsMap.values());

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Assigned Patients</h1>
        <p className="text-muted-foreground">Review patient profiles, contact info, and medical records.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Patient Registry</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Patient</th>
                  <th className="py-3 px-2">Gender</th>
                  <th className="py-3 px-2">Blood Group</th>
                  <th className="py-3 px-2">Emergency Phone</th>
                  <th className="py-3 px-2">Records</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {patients.map((p: any) => (
                  <tr key={p.id}>
                    <td className="py-3 px-2 font-medium">{p.profiles?.full_name}</td>
                    <td className="py-3 px-2 capitalize">{p.profiles?.gender || "-"}</td>
                    <td className="py-3 px-2">{p.blood_group || "-"}</td>
                    <td className="py-3 px-2">{p.emergency_phone || "-"}</td>
                    <td className="py-3 px-2">
                      <Link href={`/doctor/patients/${p.id}`}>
                        <Button variant="outline" size="sm">View Chart</Button>
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
