"use server";

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

// Helper to check admin status
async function requireAdmin() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Unauthorized');
  
  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single();
    
  if (profile?.role !== 'admin') throw new Error('Forbidden');
  return supabase;
}

export async function getUsers(filters: any, page: number = 1, pageSize: number = 10) {
  const supabase = await requireAdmin();
  const offset = (page - 1) * pageSize;

  let query = supabase
    .from('profiles')
    .select('*', { count: 'exact' });

  if (filters.role) query = query.eq('role', filters.role);
  if (filters.status) query = query.eq('status', filters.status);
  if (filters.search) query = query.or(`first_name.ilike.%${filters.search}%,last_name.ilike.%${filters.search}%,email.ilike.%${filters.search}%`);

  const { data, count, error } = await query
    .range(offset, offset + pageSize - 1)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return { users: data, totalCount: count || 0 };
}

export async function createUser(data: any) {
  const supabase = await requireAdmin();
  // Call to Edge Function or similar to handle admin user creation.
  // For now we assume calling a custom stored procedure or standard insert if RLS allows admin.
  // In a real scenario, Supabase admin client is needed to bypass auth restrictions.
  throw new Error('Not fully implemented: Requires Supabase service role key to create auth users directly.');
}

export async function updateUser(userId: string, data: any) {
  const supabase = await requireAdmin();
  const { error } = await supabase
    .from('profiles')
    .update(data)
    .eq('id', userId);

  if (error) throw new Error(error.message);
  revalidatePath('/admin/users');
}

export async function deactivateUser(userId: string) {
  return updateUser(userId, { status: 'inactive' });
}

export async function reactivateUser(userId: string) {
  return updateUser(userId, { status: 'active' });
}

export async function deleteUser(userId: string) {
  const supabase = await requireAdmin();
  // Assuming cascade delete or checking for dependents
  const { error } = await supabase.from('profiles').delete().eq('id', userId);
  if (error) throw new Error(error.message);
  revalidatePath('/admin/users');
}

export async function getDashboardStats() {
  const supabase = await requireAdmin();
  
  const [users, doctors, patients, appointments, today, pending, completed, cancelled] = await Promise.all([
    supabase.from('profiles').select('*', { count: 'exact', head: true }),
    supabase.from('profiles').select('*', { count: 'exact', head: true }).eq('role', 'doctor'),
    supabase.from('profiles').select('*', { count: 'exact', head: true }).eq('role', 'patient'),
    supabase.from('appointments').select('*', { count: 'exact', head: true }),
    supabase.from('appointments').select('*', { count: 'exact', head: true }).eq('date', new Date().toISOString().split('T')[0]),
    supabase.from('appointments').select('*', { count: 'exact', head: true }).eq('status', 'scheduled'),
    supabase.from('appointments').select('*', { count: 'exact', head: true }).eq('status', 'completed'),
    supabase.from('appointments').select('*', { count: 'exact', head: true }).eq('status', 'cancelled'),
  ]);

  return {
    totalUsers: users.count || 0,
    totalDoctors: doctors.count || 0,
    totalPatients: patients.count || 0,
    totalAppointments: appointments.count || 0,
    todayAppointments: today.count || 0,
    pendingAppointments: pending.count || 0,
    completedAppointments: completed.count || 0,
    cancelledAppointments: cancelled.count || 0,
  };
}

export async function getAnalyticsData() {
  const supabase = await requireAdmin();
  // Mocking aggregation queries due to Supabase REST limitations on complex groupings without RPC
  return {
    appointmentsPerMonth: [
      { month: 'Jan', count: 40 },
      { month: 'Feb', count: 30 },
      { month: 'Mar', count: 50 },
    ],
    statusDistribution: [
      { name: 'Completed', value: 400 },
      { name: 'Pending', value: 300 },
      { name: 'Cancelled', value: 100 },
    ],
    registrations: [
      { date: '2023-01', users: 10 },
      { date: '2023-02', users: 20 },
    ],
    specializations: [
      { name: 'Cardiology', count: 12 },
      { name: 'Neurology', count: 8 },
    ]
  };
}

export async function getAuditLogs(filters: any, page: number = 1, pageSize: number = 10) {
  const supabase = await requireAdmin();
  const offset = (page - 1) * pageSize;

  let query = supabase.from('audit_logs').select('*', { count: 'exact' });
  if (filters.search) query = query.or(`action.ilike.%${filters.search}%,user_id.eq.${filters.search}`);
  if (filters.entity_type) query = query.eq('entity_type', filters.entity_type);

  const { data, count, error } = await query
    .range(offset, offset + pageSize - 1)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return { logs: data, totalCount: count || 0 };
}

export async function updateSystemSetting(key: string, value: any) {
  const supabase = await requireAdmin();
  const { error } = await supabase
    .from('system_settings')
    .upsert({ key, value, updated_at: new Date().toISOString() });
    
  if (error) throw new Error(error.message);
  revalidatePath('/admin/settings');
}

export async function getSystemSettings() {
  const supabase = await requireAdmin();
  const { data, error } = await supabase.from('system_settings').select('*');
  if (error) throw new Error(error.message);
  return data;
}
