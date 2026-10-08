export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { StatsCard } from "@/components/admin/stats-card";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, UserCheck, Stethoscope, Calendar, Clock, CheckCircle, XCircle, ShieldAlert } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default async function AdminDashboardPage() {
  const supabase = await createClient();

  const { count: totalUsers } = await supabase.from("profiles").select("*", { count: "exact", head: true });
  const { count: totalDoctors } = await supabase.from("doctors").select("*", { count: "exact", head: true });
  const { count: totalPatients } = await supabase.from("patients").select("*", { count: "exact", head: true });
  const { count: totalAppointments } = await supabase.from("appointments").select("*", { count: "exact", head: true });
  
  const { count: pendingAppts } = await supabase.from("appointments").select("*", { count: "exact", head: true }).eq("status", "pending");
  const { count: completedAppts } = await supabase.from("appointments").select("*", { count: "exact", head: true }).eq("status", "completed");
  const { count: cancelledAppts } = await supabase.from("appointments").select("*", { count: "exact", head: true }).eq("status", "cancelled");

  const { data: recentLogs } = await supabase
    .from("audit_logs")
    .select("*, profiles:user_id(full_name, email)")
    .order("created_at", { ascending: false })
    .limit(5);

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">System Administration</h1>
          <p className="text-muted-foreground">High-level clinic analytics, metrics, and security audit activity.</p>
        </div>
        <div className="flex gap-2">
          <Link href="/admin/users">
            <Button variant="outline">Manage Users</Button>
          </Link>
          <Link href="/admin/settings">
            <Button>System Settings</Button>
          </Link>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatsCard title="Total Users" value={totalUsers || 0} description="Registered accounts" icon={Users} iconColor="text-blue-500" />
        <StatsCard title="Doctors" value={totalDoctors || 0} description="Medical staff" icon={Stethoscope} iconColor="text-green-500" />
        <StatsCard title="Patients" value={totalPatients || 0} description="Active patients" icon={UserCheck} iconColor="text-purple-500" />
        <StatsCard title="Total Appointments" value={totalAppointments || 0} description="All-time bookings" icon={Calendar} iconColor="text-amber-500" />
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <StatsCard title="Pending Review" value={pendingAppts || 0} description="Awaiting doctor confirmation" icon={Clock} iconColor="text-yellow-500" />
        <StatsCard title="Completed Visits" value={completedAppts || 0} description="Fulfilled consultations" icon={CheckCircle} iconColor="text-emerald-500" />
        <StatsCard title="Cancelled Bookings" value={cancelledAppts || 0} description="Dismissed or abandoned" icon={XCircle} iconColor="text-rose-500" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <ShieldAlert className="h-5 w-5 text-primary" /> Recent Security & Audit Logs
          </CardTitle>
        </CardHeader>
        <CardContent>
          {!recentLogs || recentLogs.length === 0 ? (
            <p className="text-muted-foreground py-4 text-center">No recent audit activity.</p>
          ) : (
            <div className="divide-y text-sm">
              {recentLogs.map((log: any) => (
                <div key={log.id} className="py-2.5 flex justify-between items-center">
                  <div>
                    <span className="font-semibold text-primary">{log.action}</span>
                    <span className="text-muted-foreground"> by {log.profiles?.full_name || "System"}</span>
                  </div>
                  <span className="text-xs text-muted-foreground">{new Date(log.created_at).toLocaleString()}</span>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
