export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { cancelAppointment } from "@/lib/actions/appointment";

export default async function PatientAppointmentsPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: patient } = await supabase
    .from("patients")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("*, doctors(*, profiles:profile_id(full_name, specialization))")
    .eq("patient_id", patient?.id || "")
    .order("appointment_date", { ascending: false });

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Appointments</h1>
          <p className="text-muted-foreground">View and manage your upcoming and past bookings.</p>
        </div>
        <Link href="/patient/appointments/book">
          <Button>Book New Appointment</Button>
        </Link>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>All Appointments</CardTitle>
        </CardHeader>
        <CardContent>
          {!appointments || appointments.length === 0 ? (
            <p className="text-muted-foreground py-4">No appointments found.</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b text-sm text-muted-foreground">
                    <th className="py-3 px-2">Doctor</th>
                    <th className="py-3 px-2">Specialization</th>
                    <th className="py-3 px-2">Date & Time</th>
                    <th className="py-3 px-2">Reason</th>
                    <th className="py-3 px-2">Status</th>
                    <th className="py-3 px-2">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y text-sm">
                  {appointments.map((a: any) => (
                    <tr key={a.id}>
                      <td className="py-3 px-2 font-medium">{a.doctors?.profiles?.full_name || "Doctor"}</td>
                      <td className="py-3 px-2">{a.doctors?.specialization || "-"}</td>
                      <td className="py-3 px-2">{a.appointment_date} {a.start_time?.slice(0,5)}</td>
                      <td className="py-3 px-2 max-w-xs truncate">{a.reason || "General checkup"}</td>
                      <td className="py-3 px-2">
                        <Badge variant={a.status === "confirmed" ? "default" : a.status === "completed" ? "secondary" : "outline"}>
                          {a.status}
                        </Badge>
                      </td>
                      <td className="py-3 px-2">
                        {(a.status === "pending" || a.status === "confirmed") && (
                          <form action={async () => {
                            "use server";
                            await cancelAppointment(a.id);
                          }}>
                            <Button variant="destructive" size="sm">Cancel</Button>
                          </form>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
