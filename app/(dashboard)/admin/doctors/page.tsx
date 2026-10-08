export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

export default async function AdminDoctorsPage() {
  const supabase = await createClient();

  const { data: doctors } = await supabase
    .from("doctors")
    .select("*, profiles:profile_id(full_name, email, phone)")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Doctors Directory</h1>
        <p className="text-muted-foreground">Verify practitioner credentials and toggle practicing statuses.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Medical Personnel</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b text-muted-foreground">
                  <th className="py-3 px-2">Doctor</th>
                  <th className="py-3 px-2">Specialization</th>
                  <th className="py-3 px-2">License #</th>
                  <th className="py-3 px-2">Fee</th>
                  <th className="py-3 px-2">Status</th>
                  <th className="py-3 px-2">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y">
                {doctors?.map((doc: any) => (
                  <tr key={doc.id}>
                    <td className="py-3 px-2 font-medium">Dr. {doc.profiles?.full_name}</td>
                    <td className="py-3 px-2">{doc.specialization}</td>
                    <td className="py-3 px-2 font-mono text-xs">{doc.license_number}</td>
                    <td className="py-3 px-2">${doc.consultation_fee}</td>
                    <td className="py-3 px-2">
                      <Badge variant={doc.status === "active" ? "default" : "outline"}>{doc.status}</Badge>
                    </td>
                    <td className="py-3 px-2">
                      <Button variant="outline" size="sm">Edit Status</Button>
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
