'use client';

import { Menu, Search, Bell, User, LogOut } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Sidebar } from './sidebar';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import Link from 'next/link';
import { createClient } from '@/lib/supabase/client';

export function Header({ role = 'patient' }: { role?: 'admin' | 'doctor' | 'patient' }) {
  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    window.location.href = '/login';
  };

  const profileHref = `/${role}/profile`;
  const notifHref = `/${role}/notifications`;

  return (
    <header className="sticky top-0 z-30 flex h-16 items-center gap-4 border-b bg-background px-4 sm:px-6">
      <Sheet>
        <SheetTrigger className="md:hidden inline-flex items-center justify-center rounded-md border border-input bg-background p-2 text-sm font-medium shadow-sm hover:bg-accent hover:text-accent-foreground">
          <Menu className="h-5 w-5" />
          <span className="sr-only">Toggle Menu</span>
        </SheetTrigger>
        <SheetContent side="left" className="p-0 w-64">
          <Sidebar role={role} />
        </SheetContent>
      </Sheet>

      <div className="flex-1 flex items-center justify-between">
        <div className="w-full max-w-sm hidden md:flex items-center relative">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            type="search"
            placeholder="Search records, appointments..."
            className="w-full bg-background pl-8 md:w-[300px] lg:w-[400px]"
          />
        </div>
      </div>

      <div className="flex items-center gap-4">
        <Link href={role === 'admin' ? '/admin/audit-logs' : notifHref}>
          <Button variant="ghost" size="icon" className="relative">
            <Bell className="h-5 w-5" />
            <Badge className="absolute -top-1 -right-1 h-4 w-4 flex items-center justify-center rounded-full p-0 text-[10px]">
              •
            </Badge>
            <span className="sr-only">Notifications</span>
          </Button>
        </Link>

        <DropdownMenu>
          <DropdownMenuTrigger>
            <div className="flex items-center gap-2 cursor-pointer p-1 rounded-full hover:bg-muted">
              <Avatar className="h-8 w-8">
                <AvatarFallback className="bg-primary/10 text-primary font-bold uppercase">
                  {role.charAt(0)}
                </AvatarFallback>
              </Avatar>
            </div>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-48">
            <DropdownMenuLabel className="capitalize">{role} Account</DropdownMenuLabel>
            <DropdownMenuSeparator />
            {role !== 'admin' && (
              <DropdownMenuItem>
                <Link href={profileHref} className="w-full">Profile Settings</Link>
              </DropdownMenuItem>
            )}
            {role === 'admin' && (
              <DropdownMenuItem>
                <Link href="/admin/settings" className="w-full">System Settings</Link>
              </DropdownMenuItem>
            )}
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleLogout} className="text-destructive cursor-pointer">
              <LogOut className="h-4 w-4 mr-2" />
              Sign Out
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
