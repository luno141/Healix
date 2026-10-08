"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { createAppointment, getAvailableSlots } from "@/lib/actions/appointment";
import { toast } from "sonner";

export default function BookAppointmentPage() {
  const router = useRouter();
  const supabase = createClient();

  const [doctors, setDoctors] = useState<any[]>([]);
  const [selectedDoctor, setSelectedDoctor] = useState<string>("");
  const [selectedDate, setSelectedDate] = useState<string>("");
  const [slots, setSlots] = useState<string[]>([]);
  const [selectedSlot, setSelectedSlot] = useState<string>("");
  const [reason, setReason] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    async function loadDoctors() {
      const { data } = await supabase
        .from("doctors")
        .select("*, profiles:profile_id(full_name)")
        .eq("status", "active");
      if (data) setDoctors(data);
    }
    loadDoctors();
  }, []);

  useEffect(() => {
    if (selectedDoctor && selectedDate) {
      getAvailableSlots(selectedDoctor, selectedDate).then(setSlots);
    } else {
      setSlots([]);
    }
  }, [selectedDoctor, selectedDate]);

  const handleBook = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedDoctor || !selectedDate || !selectedSlot) {
      toast.error("Please select a doctor, date, and time slot.");
      return;
    }

    setLoading(true);
    try {
      await createAppointment({
        doctorId: selectedDoctor,
        appointmentDate: selectedDate,
        startTime: selectedSlot,
        reason: reason || "General Consultation",
      });
      toast.success("Appointment booked successfully!");
      router.push("/patient/appointments");
    } catch (err: any) {
      toast.error(err.message || "Failed to book appointment");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Book an Appointment</h1>
        <p className="text-muted-foreground">Choose your doctor, pick a date and time slot.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Appointment Details</CardTitle>
          <CardDescription>All fields are required</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleBook} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="doctor">Select Doctor</Label>
              <select
                id="doctor"
                className="w-full flex h-9 rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                value={selectedDoctor}
                onChange={(e) => setSelectedDoctor(e.target.value)}
                required
              >
                <option value="">-- Select a Doctor --</option>
                {doctors.map((d) => (
                  <option key={d.id} value={d.id}>
                    Dr. {d.profiles?.full_name} ({d.specialization}) - ${d.consultation_fee}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="date">Select Date</Label>
              <Input
                id="date"
                type="date"
                min={new Date().toISOString().split("T")[0]}
                value={selectedDate}
                onChange={(e) => setSelectedDate(e.target.value)}
                required
              />
            </div>

            {selectedDoctor && selectedDate && (
              <div className="space-y-2">
                <Label>Available Slots</Label>
                {slots.length === 0 ? (
                  <p className="text-sm text-muted-foreground">No slots available on this date.</p>
                ) : (
                  <div className="grid grid-cols-4 gap-2">
                    {slots.map((slot) => (
                      <Button
                        key={slot}
                        type="button"
                        variant={selectedSlot === slot ? "default" : "outline"}
                        className="text-xs py-1"
                        onClick={() => setSelectedSlot(slot)}
                      >
                        {slot}
                      </Button>
                    ))}
                  </div>
                )}
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="reason">Reason for Visit</Label>
              <Input
                id="reason"
                placeholder="e.g. Annual checkup, chest discomfort, fever..."
                value={reason}
                onChange={(e) => setReason(e.target.value)}
                required
              />
            </div>

            <Button type="submit" className="w-full" disabled={loading || !selectedSlot}>
              {loading ? "Booking..." : "Confirm & Book Appointment"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
