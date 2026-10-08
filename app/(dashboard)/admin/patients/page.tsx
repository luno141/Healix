export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";

export default async function AdminPatientsPage() {
  const supabase = await createClient();

  const { data: patients } = await supabase
    .from("patients")
    .select("*, profiles:profile_id(full_name, email, phone)")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Patients Directory</h1>
        <p className="text-muted-foreground">Manage enrolled patients and medical contacts.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Enrolled Patients</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Patient</th>
                  <th className="py-3 px-2">Email</th>
                  <th className="py-3 px-2">Blood Group</th>
                  <th className="py-3 px-2">Emergency Phone</th>
                  <th className="py-3 px-2">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {patients?.map((p: any) => (
                  <tr key={p.id}>
                    <td className="py-3 px-2 font-medium">{p.profiles?.full_name}</td>
                    <td className="py-3 px-2">{p.profiles?.email}</td>
                    <td className="py-3 px-2">{p.blood_group || "-"}</td>
                    <td className="py-3 px-2">{p.emergency_phone || "-"}</td>
                    <td className="py-3 px-2">
                      <Button variant="outline" size="sm">Details</Button>
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
