export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { confirmAppointment, completeAppointment, cancelAppointmentDoctor } from "@/lib/actions/doctor-appointments";

export default async function DoctorAppointmentsPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: doctor } = await supabase
    .from("doctors")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("*, patients(*, profiles:profile_id(full_name, phone))")
    .eq("doctor_id", doctor?.id || "")
    .order("appointment_date", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Appointments Roster</h1>
        <p className="text-muted-foreground">Manage consultations, confirm schedules, or complete visits.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>All Scheduled Consultations</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Patient</th>
                  <th className="py-3 px-2">Contact</th>
                  <th className="py-3 px-2">Date & Time</th>
                  <th className="py-3 px-2">Chief Complaint</th>
                  <th className="py-3 px-2">Status</th>
                  <th className="py-3 px-2">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {appointments?.map((a: any) => (
                  <tr key={a.id}>
                    <td className="py-3 px-2 font-medium">{a.patients?.profiles?.full_name || "Patient"}</td>
                    <td className="py-3 px-2 text-muted-foreground">{a.patients?.profiles?.phone || "-"}</td>
                    <td className="py-3 px-2">{a.appointment_date} {a.start_time?.slice(0, 5)}</td>
                    <td className="py-3 px-2 max-w-xs truncate">{a.reason}</td>
                    <td className="py-3 px-2">
                      <Badge variant={a.status === "confirmed" ? "default" : a.status === "completed" ? "secondary" : "outline"}>
                        {a.status}
                      </Badge>
                    </td>
                    <td className="py-3 px-2">
                      <div className="flex items-center gap-1">
                        {a.status === "pending" && (
                          <form action={async () => {
                            "use server";
                            await confirmAppointment(a.id);
                          }}>
                            <Button size="sm">Confirm</Button>
                          </form>
                        )}
                        {a.status === "confirmed" && (
                          <form action={async () => {
                            "use server";
                            await completeAppointment(a.id);
                          }}>
                            <Button size="sm" variant="secondary">Complete</Button>
                          </form>
                        )}
                        {(a.status === "pending" || a.status === "confirmed") && (
                          <form action={async () => {
                            "use server";
                            await cancelAppointmentDoctor(a.id, "Cancelled by doctor");
                          }}>
                            <Button size="sm" variant="ghost" className="text-destructive">Cancel</Button>
                          </form>
                        )}
                      </div>
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
