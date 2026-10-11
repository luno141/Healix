'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import { 
  LayoutDashboard, Calendar, Users, Activity, Settings, 
  FileText, Bell, LogOut, HeartPulse, User, Clock, 
  MessageSquare, ClipboardList, ShieldAlert
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { createClient } from '@/lib/supabase/client';

type Role = 'admin' | 'doctor' | 'patient';

const navItems = {
  patient: [
    { name: 'Dashboard', href: '/patient/dashboard', icon: LayoutDashboard },
    { name: 'Appointments', href: '/patient/appointments', icon: Calendar },
    { name: 'Book Appointment', href: '/patient/appointments/book', icon: Clock },
    { name: 'Doctors', href: '/patient/doctors', icon: Users },
    { name: 'Medical History', href: '/patient/medical-history', icon: Activity },
    { name: 'Profile', href: '/patient/profile', icon: User },
    { name: 'Notifications', href: '/patient/notifications', icon: Bell },
  ],
  doctor: [
    { name: 'Dashboard', href: '/doctor/dashboard', icon: LayoutDashboard },
    { name: 'Schedule', href: '/doctor/schedule', icon: Clock },
    { name: 'Appointments', href: '/doctor/appointments', icon: Calendar },
    { name: 'Patients', href: '/doctor/patients', icon: Users },
    { name: 'Feedback', href: '/doctor/feedback', icon: MessageSquare },
    { name: 'Profile', href: '/doctor/profile', icon: User },
    { name: 'Notifications', href: '/doctor/notifications', icon: Bell },
  ],
  admin: [
    { name: 'Dashboard', href: '/admin/dashboard', icon: LayoutDashboard },
    { name: 'Users', href: '/admin/users', icon: Users },
    { name: 'Doctors', href: '/admin/doctors', icon: HeartPulse },
    { name: 'Patients', href: '/admin/patients', icon: ClipboardList },
    { name: 'Appointments', href: '/admin/appointments', icon: Calendar },
    { name: 'Settings', href: '/admin/settings', icon: Settings },
    { name: 'Audit Logs', href: '/admin/audit-logs', icon: ShieldAlert },
  ]
};

export function Sidebar({ role = 'patient' }: { role?: Role }) {
  const pathname = usePathname();
  const items = navItems[role] || navItems.patient;

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    window.location.href = '/login';
  };

  return (
    <div className="flex h-full w-64 flex-col bg-card border-r shadow-sm">
      <div className="flex h-16 items-center px-6 border-b">
        <HeartPulse className="h-6 w-6 text-primary mr-2" />
        <span className="text-xl font-bold tracking-tight text-foreground">Healix</span>
        <span className="ml-auto text-xs font-semibold uppercase px-2 py-0.5 rounded bg-primary/10 text-primary">
          {role}
        </span>
      </div>
      <div className="flex-1 overflow-y-auto py-4">
        <nav className="space-y-1 px-4">
          {items.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.name}
                href={item.href}
                className={cn(
                  "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all",
                  isActive 
                    ? "bg-primary text-primary-foreground shadow-sm" 
                    : "text-muted-foreground hover:bg-muted hover:text-foreground"
                )}
              >
                <item.icon className="h-4 w-4" />
                {item.name}
              </Link>
            );
          })}
        </nav>
      </div>
      <div className="p-4 border-t">
        <Button 
          variant="outline" 
          className="w-full justify-start gap-2 text-destructive hover:text-destructive hover:bg-destructive/10" 
          onClick={handleLogout}
        >
          <LogOut className="h-4 w-4" />
          Logout
        </Button>
      </div>
    </div>
  );
}
