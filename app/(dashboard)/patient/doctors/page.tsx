export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { Stethoscope, Award, DollarSign } from "lucide-react";

export default async function PatientDoctorsPage() {
  const supabase = await createClient();
  const { data: doctors } = await supabase
    .from("doctors")
    .select("*, profiles:profile_id(full_name, email, phone, avatar_url)")
    .eq("status", "active");

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Our Specialists</h1>
        <p className="text-muted-foreground">Find trusted doctors across multiple healthcare specialties.</p>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {doctors?.map((doc: any) => (
          <Card key={doc.id} className="flex flex-col justify-between">
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center font-bold text-primary">
                  {doc.profiles?.full_name?.charAt(0) || "D"}
                </div>
                <div>
                  <CardTitle className="text-lg">Dr. {doc.profiles?.full_name}</CardTitle>
                  <p className="text-sm text-primary font-medium">{doc.specialization}</p>
                </div>
              </div>
            </CardHeader>
            <CardContent className="space-y-3">
              <p className="text-sm text-muted-foreground line-clamp-2">{doc.bio || "Certified medical practitioner."}</p>
              <div className="text-xs space-y-1 text-muted-foreground">
                <div className="flex items-center gap-2">
                  <Award className="h-3.5 w-3.5" /> {doc.qualification} ({doc.experience_years} yrs exp)
                </div>
                <div className="flex items-center gap-2">
                  <DollarSign className="h-3.5 w-3.5" /> ${doc.consultation_fee} per consultation
                </div>
              </div>
              <Link href={`/patient/appointments/book?doctor=${doc.id}`} className="block pt-2">
                <Button className="w-full" size="sm">Book Appointment</Button>
              </Link>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
