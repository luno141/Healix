export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Users, Calendar, CheckCircle2, Clock, Star, Bell } from "lucide-react";
import { confirmAppointment, completeAppointment } from "@/lib/actions/doctor-appointments";

export default async function DoctorDashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("full_name")
    .eq("id", user?.id || "")
    .single();

  const { data: doctor } = await supabase
    .from("doctors")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("*, patients(*, profiles:profile_id(full_name))")
    .eq("doctor_id", doctor?.id || "")
    .order("appointment_date", { ascending: false });

  const totalAppts = appointments?.length || 0;
  const pending = appointments?.filter(a => a.status === "pending").length || 0;
  const completed = appointments?.filter(a => a.status === "completed").length || 0;

  const { data: feedbackData } = await supabase
    .from("feedback")
    .select("rating")
    .eq("doctor_id", doctor?.id || "");

  const avgRating = feedbackData && feedbackData.length > 0
    ? (feedbackData.reduce((acc, curr) => acc + curr.rating, 0) / feedbackData.length).toFixed(1)
    : "N/A";

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Doctor Console — Dr. {profile?.full_name || "Specialist"}</h1>
          <p className="text-muted-foreground">Manage your clinic roster, confirmations, and consult outcomes.</p>
        </div>
        <Link href="/doctor/schedule">
          <Button>Edit Availability Schedule</Button>
        </Link>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Pending Requests</CardTitle>
            <Clock className="h-4 w-4 text-amber-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{pending}</div>
            <p className="text-xs text-muted-foreground">Action required</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Completed Visits</CardTitle>
            <CheckCircle2 className="h-4 w-4 text-green-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{completed}</div>
            <p className="text-xs text-muted-foreground">Care rendered</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Total Appointments</CardTitle>
            <Calendar className="h-4 w-4 text-blue-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{totalAppts}</div>
            <p className="text-xs text-muted-foreground">Historical records</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium">Patient Rating</CardTitle>
            <Star className="h-4 w-4 text-yellow-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{avgRating} {avgRating !== "N/A" ? "★" : ""}</div>
            <p className="text-xs text-muted-foreground">From verified reviews</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Recent Patient Requests</CardTitle>
        </CardHeader>
        <CardContent>
          {!appointments || appointments.length === 0 ? (
            <p className="text-muted-foreground py-4 text-center">No appointments scheduled.</p>
          ) : (
            <div className="divide-y text-sm">
              {appointments.slice(0, 5).map((a: any) => (
                <div key={a.id} className="py-3 flex justify-between items-center">
                  <div>
                    <p className="font-semibold">{a.patients?.profiles?.full_name || "Patient"}</p>
                    <p className="text-xs text-muted-foreground">{a.appointment_date} at {a.start_time?.slice(0, 5)} • {a.reason}</p>
                  </div>
                  <div className="flex items-center gap-2">
                    <Badge variant={a.status === "confirmed" ? "default" : a.status === "completed" ? "secondary" : "outline"}>
                      {a.status}
                    </Badge>
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
                        <Button size="sm" variant="secondary">Mark Done</Button>
                      </form>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
