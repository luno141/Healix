export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { markAsRead, markAllAsRead } from "@/lib/actions/notification";

export default async function PatientNotificationsPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: notifications } = await supabase
    .from("notifications")
    .select("*")
    .eq("user_id", user?.id || "")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Notifications</h1>
          <p className="text-muted-foreground">Keep track of appointment updates and health alerts.</p>
        </div>
        <form action={async () => { "use server"; await markAllAsRead(); }}>
          <Button variant="outline" size="sm">Mark all as read</Button>
        </form>
      </div>

      <div className="space-y-3">
        {!notifications || notifications.length === 0 ? (
          <Card>
            <CardContent className="py-8 text-center text-muted-foreground">
              You have no notifications.
            </CardContent>
          </Card>
        ) : (
          notifications.map((n: any) => (
            <Card key={n.id} className={n.is_read ? "opacity-70" : "border-primary"}>
              <CardContent className="p-4 flex items-center justify-between">
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="font-semibold text-sm">{n.title}</h3>
                    {!n.is_read && <Badge variant="default" className="text-xs">New</Badge>}
                  </div>
                  <p className="text-sm text-muted-foreground">{n.message}</p>
                  <p className="text-xs text-muted-foreground mt-1">{new Date(n.created_at).toLocaleString()}</p>
                </div>
                {!n.is_read && (
                  <form action={async () => {
                    "use server";
                    await markAsRead(n.id);
                  }}>
                    <Button variant="ghost" size="sm">Mark read</Button>
                  </form>
                )}
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
