export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { revalidatePath } from "next/cache";

export default async function PatientProfilePage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user?.id || "")
    .single();

  const { data: patient } = await supabase
    .from("patients")
    .select("*")
    .eq("profile_id", user?.id || "")
    .single();

  async function updateProfile(formData: FormData) {
    "use server";
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    const fullName = formData.get("fullName") as string;
    const phone = formData.get("phone") as string;
    const address = formData.get("address") as string;
    const bloodGroup = formData.get("bloodGroup") as string;
    const emergencyContact = formData.get("emergencyContact") as string;
    const emergencyPhone = formData.get("emergencyPhone") as string;

    await supabase
      .from("profiles")
      .update({ full_name: fullName, phone, address })
      .eq("id", user?.id || "");

    await supabase
      .from("patients")
      .update({ blood_group: bloodGroup, emergency_contact: emergencyContact, emergency_phone: emergencyPhone })
      .eq("profile_id", user?.id || "");

    revalidatePath("/patient/profile");
  }

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Personal Profile</h1>
        <p className="text-muted-foreground">Manage your personal and emergency contact details.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Profile Details</CardTitle>
        </CardHeader>
        <CardContent>
          <form action={updateProfile} className="space-y-4">
            <div className="space-y-2">
              <Label>Full Name</Label>
              <Input name="fullName" defaultValue={profile?.full_name || ""} required />
            </div>
            <div className="space-y-2">
              <Label>Email</Label>
              <Input defaultValue={profile?.email || ""} disabled />
            </div>
            <div className="space-y-2">
              <Label>Phone</Label>
              <Input name="phone" defaultValue={profile?.phone || ""} />
            </div>
            <div className="space-y-2">
              <Label>Address</Label>
              <Input name="address" defaultValue={profile?.address || ""} />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Blood Group</Label>
                <Input name="bloodGroup" defaultValue={patient?.blood_group || ""} placeholder="e.g. O+, A-" />
              </div>
              <div className="space-y-2">
                <Label>Emergency Contact Name</Label>
                <Input name="emergencyContact" defaultValue={patient?.emergency_contact || ""} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Emergency Contact Phone</Label>
              <Input name="emergencyPhone" defaultValue={patient?.emergency_phone || ""} />
            </div>
            <Button type="submit" className="w-full">Save Profile Changes</Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
