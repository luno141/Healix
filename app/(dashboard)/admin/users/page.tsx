export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { revalidatePath } from "next/cache";

export default async function AdminUsersPage() {
  const supabase = await createClient();

  const { data: users } = await supabase
    .from("profiles")
    .select("*")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">User Management</h1>
        <p className="text-muted-foreground">Control credentials, access roles, and active account statuses.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>All Platform Users</CardTitle>
        </CardHeader>
        <CardContent>
          {!users || users.length === 0 ? (
            <p className="text-muted-foreground py-4">No users found.</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-sm">
                <thead>
                  <tr className="border-b text-muted-foreground">
                    <th className="py-3 px-2">Name</th>
                    <th className="py-3 px-2">Email</th>
                    <th className="py-3 px-2">Role</th>
                    <th className="py-3 px-2">Joined</th>
                    <th className="py-3 px-2">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y">
                  {users.map((u: any) => (
                    <tr key={u.id}>
                      <td className="py-3 px-2 font-medium">{u.full_name}</td>
                      <td className="py-3 px-2">{u.email}</td>
                      <td className="py-3 px-2">
                        <Badge variant={u.role === "admin" ? "destructive" : u.role === "doctor" ? "default" : "secondary"}>
                          {u.role}
                        </Badge>
                      </td>
                      <td className="py-3 px-2 text-muted-foreground">{new Date(u.created_at).toLocaleDateString()}</td>
                      <td className="py-3 px-2">
                        <Button variant="outline" size="sm">Manage</Button>
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
