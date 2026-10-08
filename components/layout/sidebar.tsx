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

type Role = 'admin' | 'doctor' | 'patient';

const navItems = {
  patient: [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { name: 'Appointments', href: '/appointments', icon: Calendar },
    { name: 'Book Appointment', href: '/book', icon: Clock },
    { name: 'Doctors', href: '/doctors', icon: Users },
    { name: 'Medical History', href: '/history', icon: Activity },
    { name: 'Profile', href: '/profile', icon: User },
    { name: 'Notifications', href: '/notifications', icon: Bell },
  ],
  doctor: [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { name: 'Schedule', href: '/schedule', icon: Clock },
    { name: 'Appointments', href: '/appointments', icon: Calendar },
    { name: 'Patients', href: '/patients', icon: Users },
    { name: 'Feedback', href: '/feedback', icon: MessageSquare },
    { name: 'Profile', href: '/profile', icon: User },
    { name: 'Notifications', href: '/notifications', icon: Bell },
  ],
  admin: [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { name: 'Users', href: '/admin/users', icon: Users },
    { name: 'Doctors', href: '/admin/doctors', icon: HeartPulse },
    { name: 'Patients', href: '/admin/patients', icon: ClipboardList },
    { name: 'Appointments', href: '/admin/appointments', icon: Calendar },
    { name: 'Settings', href: '/admin/settings', icon: Settings },
    { name: 'Analytics', href: '/admin/analytics', icon: Activity },
    { name: 'Audit Logs', href: '/admin/logs', icon: ShieldAlert },
  ]
};

export function Sidebar({ role = 'patient' }: { role?: Role }) {
  const pathname = usePathname();
  const items = navItems[role];

  return (
    <div className="flex h-full w-64 flex-col bg-white border-r">
      <div className="flex h-16 items-center px-6 border-b">
        <HeartPulse className="h-6 w-6 text-primary mr-2" />
        <span className="text-xl font-bold tracking-tight">Healix</span>
      </div>
      <div className="flex-1 overflow-y-auto py-4">
        <nav className="space-y-1 px-4">
          {items.map((item) => {
            const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`);
            return (
              <Link
                key={item.name}
                href={item.href}
                className={cn(
                  "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-all",
                  isActive 
                    ? "bg-primary text-primary-foreground" 
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
        <Button variant="outline" className="w-full justify-start gap-2" >
          <Link href="/login">
            <LogOut className="h-4 w-4" />
            Logout
          </Link>
        </Button>
      </div>
    </div>
  );
}
