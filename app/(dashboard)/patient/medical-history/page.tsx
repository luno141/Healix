export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { FileText, Calendar, User } from "lucide-react";

export default async function PatientMedicalHistoryPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: patient } = await supabase
    .from("patients")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: records } = await supabase
    .from("medical_records")
    .select("*, profiles:created_by(full_name)")
    .eq("patient_id", patient?.id || "")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Medical History</h1>
        <p className="text-muted-foreground">Access your verified clinical notes, diagnoses, and treatments.</p>
      </div>

      <div className="space-y-4">
        {!records || records.length === 0 ? (
          <Card>
            <CardContent className="py-8 text-center text-muted-foreground">
              No medical records found.
            </CardContent>
          </Card>
        ) : (
          records.map((r: any) => (
            <Card key={r.id}>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div className="space-y-1">
                    <CardTitle className="text-lg">{r.title}</CardTitle>
                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <span className="flex items-center gap-1">
                        <Calendar className="h-3.5 w-3.5" /> {new Date(r.created_at).toLocaleDateString()}
                      </span>
                      <span className="flex items-center gap-1">
                        <User className="h-3.5 w-3.5" /> Dr. {r.profiles?.full_name || "Physician"}
                      </span>
                    </div>
                  </div>
                  <Badge>{r.record_type}</Badge>
                </div>
              </CardHeader>
              <CardContent className="space-y-3 text-sm">
                {r.diagnosis && (
                  <div>
                    <span className="font-semibold text-foreground">Diagnosis: </span>
                    <span className="text-muted-foreground">{r.diagnosis}</span>
                  </div>
                )}
                {r.treatment && (
                  <div>
                    <span className="font-semibold text-foreground">Treatment: </span>
                    <span className="text-muted-foreground">{r.treatment}</span>
                  </div>
                )}
                {r.description && (
                  <div>
                    <span className="font-semibold text-foreground">Notes: </span>
                    <span className="text-muted-foreground">{r.description}</span>
                  </div>
                )}
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
