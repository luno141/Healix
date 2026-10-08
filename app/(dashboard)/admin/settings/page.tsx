export const dynamic = "force-dynamic";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { revalidatePath } from "next/cache";

export default async function AdminSettingsPage() {
  const supabase = await createClient();

  const { data: settings } = await supabase
    .from("system_settings")
    .select("*");

  async function updateSetting(formData: FormData) {
    "use server";
    const supabase = await createClient();
    for (const [key, value] of formData.entries()) {
      if (key.startsWith("setting_")) {
        const settingKey = key.replace("setting_", "");
        await supabase
          .from("system_settings")
          .update({ setting_value: value, updated_at: new Date().toISOString() })
          .eq("setting_key", settingKey);
      }
    }
    revalidatePath("/admin/settings");
  }

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">System Settings</h1>
        <p className="text-muted-foreground">Adjust global platform operational variables and booking parameters.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Configuration</CardTitle>
          <CardDescription>Changes apply instantly across the platform</CardDescription>
        </CardHeader>
        <CardContent>
          <form action={updateSetting} className="space-y-4">
            {settings?.map((s: any) => (
              <div key={s.id} className="space-y-2">
                <Label htmlFor={`setting_${s.setting_key}`} className="capitalize">
                  {s.setting_key.replace(/_/g, " ")}
                </Label>
                <Input
                  id={`setting_${s.setting_key}`}
                  name={`setting_${s.setting_key}`}
                  defaultValue={s.setting_value}
                />
                {s.description && <p className="text-xs text-muted-foreground">{s.description}</p>}
              </div>
            ))}
            <Button type="submit" className="w-full">Save System Settings</Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
