export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

export default async function AdminAppointmentsPage() {
  const supabase = await createClient();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("*, patients(*, profiles:profile_id(full_name)), doctors(*, profiles:profile_id(full_name))")
    .order("appointment_date", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Global Appointments</h1>
        <p className="text-muted-foreground">Comprehensive overview of all clinical bookings.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Schedule & Bookings</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Patient</th>
                  <th className="py-3 px-2">Doctor</th>
                  <th className="py-3 px-2">Date & Time</th>
                  <th className="py-3 px-2">Reason</th>
                  <th className="py-3 px-2">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {appointments?.map((a: any) => (
                  <tr key={a.id}>
                    <td className="py-3 px-2 font-medium">{a.patients?.profiles?.full_name || "Patient"}</td>
                    <td className="py-3 px-2">Dr. {a.doctors?.profiles?.full_name || "Doctor"}</td>
                    <td className="py-3 px-2">{a.appointment_date} {a.start_time?.slice(0, 5)}</td>
                    <td className="py-3 px-2 max-w-xs truncate">{a.reason}</td>
                    <td className="py-3 px-2">
                      <Badge variant={a.status === "confirmed" ? "default" : a.status === "completed" ? "secondary" : "outline"}>
                        {a.status}
                      </Badge>
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
