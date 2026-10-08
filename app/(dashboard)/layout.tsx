export const dynamic = "force-dynamic";
import { DashboardLayout } from '@/components/layout/dashboard-layout';
import { redirect } from 'next/navigation';
// import { createClient } from '@/lib/supabase/server';

export default async function Layout({
  children,
}: {
  children: React.ReactNode;
}) {
  // Mocking session for layout structure since we don't have the real DB connected yet
  // const supabase = createClient();
  // const { data: { session } } = await supabase.auth.getSession();
  // if (!session) redirect('/login');
  // const { data: profile } = await supabase.from('profiles').select('role').eq('id', session.user.id).single();
  // const role = profile?.role || 'patient';
  
  const role = 'patient'; // Fallback for UI building

  return (
    <DashboardLayout role={role}>
      {children}
    </DashboardLayout>
  );
}
