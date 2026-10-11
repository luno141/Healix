import { describe, it, expect } from 'vitest';

type Role = 'admin' | 'doctor' | 'patient';

function canAccessRoute(role: Role, route: string): boolean {
  if (route.startsWith('/admin') && role !== 'admin') return false;
  if (route.startsWith('/doctor') && role !== 'doctor') return false;
  if (route.startsWith('/patient') && role !== 'patient') return false;
  return true;
}

describe('RBAC Route Protection Logic', () => {
  it('allows admin to access admin routes', () => {
    expect(canAccessRoute('admin', '/admin/dashboard')).toBe(true);
    expect(canAccessRoute('admin', '/admin/users')).toBe(true);
  });

  it('blocks patient and doctor from admin routes', () => {
    expect(canAccessRoute('patient', '/admin/dashboard')).toBe(false);
    expect(canAccessRoute('doctor', '/admin/settings')).toBe(false);
  });

  it('allows doctor only on doctor routes', () => {
    expect(canAccessRoute('doctor', '/doctor/schedule')).toBe(true);
    expect(canAccessRoute('patient', '/doctor/schedule')).toBe(false);
  });

  it('allows patient on patient routes', () => {
    expect(canAccessRoute('patient', '/patient/appointments/book')).toBe(true);
    expect(canAccessRoute('doctor', '/patient/appointments/book')).toBe(false);
  });
});
