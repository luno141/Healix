export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Calendar, CheckCircle2, Clock, FileText, Bell, PlusCircle } from "lucide-react";

export default async function PatientDashboard() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("full_name")
    .eq("id", user?.id)
    .single();

  const { data: patient } = await supabase
    .from("patients")
    .select("id")
    .eq("profile_id", user?.id)
    .single();

  const { data: appointments } = await supabase
    .from("appointments")
    .select("*, doctors(*, profiles:profile_id(full_name, specialization))")
    .eq("patient_id", patient?.id || "")
    .order("appointment_date", { ascending: false })
    .limit(5);

  const totalAppts = appointments?.length || 0;
  const completedAppts = appointments?.filter(a => a.status === "completed").length || 0;
  const pendingAppts = appointments?.filter(a => a.status === "pending" || a.status === "confirmed").length || 0;

  const { count: recordsCount } = await supabase
    .from("medical_records")
    .select("*", { count: "exact", head: true })
    .eq("patient_id", patient?.id || "");

  const { count: unreadCount } = await supabase
    .from("notifications")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user?.id || "")
    .eq("is_read", false);

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Welcome back, {profile?.full_name || "Patient"}</h1>
          <p className="text-muted-foreground">Manage your healthcare appointments and records.</p>
        </div>
        <Link href="/patient/appointments/book">
          <Button className="flex items-center gap-2">
            <PlusCircle className="h-4 w-4" /> Book Appointment
          </Button>
        </Link>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Upcoming / Pending</CardTitle>
            <Clock className="h-4 w-4 text-blue-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{pendingAppts}</div>
            <p className="text-xs text-muted-foreground">Scheduled visits</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Completed Visits</CardTitle>
            <CheckCircle2 className="h-4 w-4 text-green-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{completedAppts}</div>
            <p className="text-xs text-muted-foreground">Past consultations</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Medical Records</CardTitle>
            <FileText className="h-4 w-4 text-amber-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{recordsCount || 0}</div>
            <p className="text-xs text-muted-foreground">Clinical charts & notes</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Notifications</CardTitle>
            <Bell className="h-4 w-4 text-purple-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{unreadCount || 0}</div>
            <p className="text-xs text-muted-foreground">Unread alerts</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Recent Appointments</CardTitle>
        </CardHeader>
        <CardContent>
          {!appointments || appointments.length === 0 ? (
            <div className="text-center py-6 text-muted-foreground">No recent appointments found.</div>
          ) : (
            <div className="divide-y">
              {appointments.map((a: any) => (
                <div key={a.id} className="py-3 flex items-center justify-between">
                  <div>
                    <p className="font-semibold">{a.doctors?.profiles?.full_name || "Doctor"}</p>
                    <p className="text-sm text-muted-foreground">{a.doctors?.specialization} • {a.appointment_date} at {a.start_time}</p>
                  </div>
                  <Badge variant={a.status === "completed" ? "default" : a.status === "confirmed" ? "secondary" : "outline"}>
                    {a.status}
                  </Badge>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
