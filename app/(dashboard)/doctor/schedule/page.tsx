export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createAvailability, deleteAvailability } from "@/lib/actions/availability";

export default async function DoctorSchedulePage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data: doctor } = await supabase
    .from("doctors")
    .select("id")
    .eq("profile_id", user?.id || "")
    .single();

  const { data: availability } = await supabase
    .from("doctor_availability")
    .select("*")
    .eq("doctor_id", doctor?.id || "")
    .order("day_of_week", { ascending: true });

  const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  async function handleAddSlot(formData: FormData) {
    "use server";
    const dayOfWeek = parseInt(formData.get("dayOfWeek") as string, 10);
    const startTime = formData.get("startTime") as string;
    const endTime = formData.get("endTime") as string;
    const slotDuration = parseInt(formData.get("slotDuration") as string || "30", 10);

    if (!doctor?.id) return;
    await createAvailability(doctor.id, {
      day_of_week: dayOfWeek,
      start_time: startTime,
      end_time: endTime,
      slot_duration: slotDuration,
      is_available: true
    });
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Practice Schedule</h1>
        <p className="text-muted-foreground">Define your weekly consultation hours and patient slot intervals.</p>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Configure Available Shift</CardTitle>
            <CardDescription>Add or update your consultation hours</CardDescription>
          </CardHeader>
          <CardContent>
            <form action={handleAddSlot} className="space-y-4">
              <div className="space-y-2">
                <Label>Day of the Week</Label>
                <select name="dayOfWeek" className="w-full flex h-9 rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm" required>
                  {days.map((name, idx) => (
                    <option key={name} value={idx}>{name}</option>
                  ))}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Start Time</Label>
                  <Input name="startTime" type="time" defaultValue="09:00" required />
                </div>
                <div className="space-y-2">
                  <Label>End Time</Label>
                  <Input name="endTime" type="time" defaultValue="17:00" required />
                </div>
              </div>
              <div className="space-y-2">
                <Label>Slot Duration (minutes)</Label>
                <Input name="slotDuration" type="number" defaultValue={30} min={15} max={120} required />
              </div>
              <Button type="submit" className="w-full">Save Availability Shift</Button>
            </form>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Active Weekly Schedule</CardTitle>
            <CardDescription>Your current configured hours</CardDescription>
          </CardHeader>
          <CardContent>
            {!availability || availability.length === 0 ? (
              <p className="text-muted-foreground text-sm py-4">No hours set yet. Configure your slots on the left.</p>
            ) : (
              <div className="divide-y text-sm">
                {availability.map((a: any) => (
                  <div key={a.id} className="py-2.5 flex justify-between items-center">
                    <div>
                      <p className="font-semibold">{days[a.day_of_week]}</p>
                      <p className="text-xs text-muted-foreground">
                        {a.start_time?.slice(0, 5)} - {a.end_time?.slice(0, 5)} ({a.slot_duration} min slots)
                      </p>
                    </div>
                    <form action={async () => {
                      "use server";
                      await deleteAvailability(a.id);
                    }}>
                      <Button variant="ghost" size="sm" className="text-destructive">Remove</Button>
                    </form>
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
