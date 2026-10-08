export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { createMedicalRecord } from "@/lib/actions/medical-records";
import { Badge } from "@/components/ui/badge";

export default async function DoctorPatientDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id: patientId } = await params;
  const supabase = await createClient();

  const { data: patient } = await supabase
    .from("patients")
    .select("*, profiles:profile_id(*)")
    .eq("id", patientId)
    .single();

  const { data: records } = await supabase
    .from("medical_records")
    .select("*")
    .eq("patient_id", patientId)
    .order("created_at", { ascending: false });

  async function handleAddRecord(formData: FormData) {
    "use server";
    const title = formData.get("title") as string;
    const recordType = formData.get("recordType") as string;
    const diagnosis = formData.get("diagnosis") as string;
    const treatment = formData.get("treatment") as string;
    const description = formData.get("description") as string;

    await createMedicalRecord(patientId, {
      title,
      record_type: recordType,
      diagnosis,
      treatment,
      description
    });
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Patient Chart — {patient?.profiles?.full_name}</h1>
        <p className="text-muted-foreground">Blood Group: {patient?.blood_group || "N/A"} • Gender: {patient?.profiles?.gender || "N/A"}</p>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Add Medical Record / Note</CardTitle>
            <CardDescription>Clinical documentation will immediately update patient records</CardDescription>
          </CardHeader>
          <CardContent>
            <form action={handleAddRecord} className="space-y-4">
              <div className="space-y-2">
                <Label>Record Title</Label>
                <Input name="title" placeholder="e.g. Follow-up consultation" required />
              </div>
              <div className="space-y-2">
                <Label>Record Type</Label>
                <select name="recordType" className="w-full flex h-9 rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm" required>
                  <option value="consultation">Consultation</option>
                  <option value="diagnosis">Diagnosis</option>
                  <option value="lab_result">Lab Result</option>
                  <option value="prescription">Prescription</option>
                </select>
              </div>
              <div className="space-y-2">
                <Label>Diagnosis</Label>
                <Input name="diagnosis" placeholder="Diagnostic impression..." required />
              </div>
              <div className="space-y-2">
                <Label>Treatment Plan</Label>
                <Input name="treatment" placeholder="Prescribed regimen or therapy..." required />
              </div>
              <div className="space-y-2">
                <Label>Clinical Notes</Label>
                <Textarea name="description" placeholder="Observations, vitals, next steps..." required />
              </div>
              <Button type="submit" className="w-full">Save Chart Entry</Button>
            </form>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Medical History</CardTitle>
          </CardHeader>
          <CardContent>
            {!records || records.length === 0 ? (
              <p className="text-muted-foreground text-sm py-4">No records documented for this patient.</p>
            ) : (
              <div className="space-y-4">
                {records.map((r: any) => (
                  <div key={r.id} className="border rounded-md p-3 space-y-2 text-sm">
                    <div className="flex justify-between items-center">
                      <span className="font-semibold">{r.title}</span>
                      <Badge variant="outline">{r.record_type}</Badge>
                    </div>
                    <p><span className="text-muted-foreground">Dx:</span> {r.diagnosis}</p>
                    <p><span className="text-muted-foreground">Tx:</span> {r.treatment}</p>
                    <p className="text-xs text-muted-foreground">{new Date(r.created_at).toLocaleString()}</p>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
