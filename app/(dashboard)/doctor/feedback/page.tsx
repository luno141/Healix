export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Star } from "lucide-react";

export default async function DoctorFeedbackPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: doctor } = await supabase
    .from("doctors")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: feedback } = await supabase
    .from("feedback")
    .select("*, patients(*, profiles:profile_id(full_name))")
    .eq("doctor_id", doctor?.id || "")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Patient Reviews & Feedback</h1>
        <p className="text-muted-foreground">Verified reviews and comments from completed consultations.</p>
      </div>

      <div className="space-y-4">
        {!feedback || feedback.length === 0 ? (
          <Card>
            <CardContent className="py-8 text-center text-muted-foreground">
              No feedback entries recorded yet.
            </CardContent>
          </Card>
        ) : (
          feedback.map((f: any) => (
            <Card key={f.id}>
              <CardHeader>
                <div className="flex justify-between items-center">
                  <CardTitle className="text-base">{f.patients?.profiles?.full_name || "Verified Patient"}</CardTitle>
                  <div className="flex items-center text-yellow-500 font-bold">
                    <Star className="h-4 w-4 fill-yellow-500 mr-1" />
                    <span>{f.rating} / 5</span>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">{f.comment || "No written review provided."}</p>
                <p className="text-xs text-muted-foreground mt-2">{new Date(f.created_at).toLocaleDateString()}</p>
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
