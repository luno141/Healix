export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default async function AdminAuditLogsPage() {
  const supabase = await createClient();

  const { data: logs } = await supabase
    .from("audit_logs")
    .select("*, profiles:user_id(full_name, email)")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Security Audit Logs</h1>
        <p className="text-muted-foreground">Immutable operational records of administrative and clinical events.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Activity Ledger</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Timestamp</th>
                  <th className="py-3 px-2">Actor</th>
                  <th className="py-3 px-2">Action</th>
                  <th className="py-3 px-2">Entity Type</th>
                  <th className="py-3 px-2">Details</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {logs?.map((log: any) => (
                  <tr key={log.id}>
                    <td className="py-3 px-2 text-xs text-muted-foreground">
                      {new Date(log.created_at).toLocaleString()}
                    </td>
                    <td className="py-3 px-2 font-medium">{log.profiles?.full_name || "System"}</td>
                    <td className="py-3 px-2 font-mono text-xs">{log.action}</td>
                    <td className="py-3 px-2 capitalize">{log.entity_type}</td>
                    <td className="py-3 px-2 font-mono text-xs max-w-xs truncate">
                      {JSON.stringify(log.metadata || {})}
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
