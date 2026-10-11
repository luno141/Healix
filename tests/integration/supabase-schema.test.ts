import { describe, it, expect } from 'vitest';
import { createClient } from '@supabase/supabase-js';

const url = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://gjvwnabfommajpsgneud.supabase.co';
const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_OSnaiQFuGHORg2X3NjQDag_0mZMQwGN';
const supabase = createClient(url, key);

describe('Live Supabase Schema & Public Policies', () => {
  it('allows public read of system settings table', async () => {
    const { data, error } = await supabase.from('system_settings').select('*');
    expect(error).toBeNull();
    expect(data).toBeDefined();
    expect(Array.isArray(data)).toBe(true);
    expect(data!.length).toBeGreaterThan(0);
  });

  it('verifies active doctor availability table accessibility', async () => {
    const { data, error } = await supabase.from('doctor_availability').select('*');
    expect(error).toBeNull();
    expect(Array.isArray(data)).toBe(true);
  });
});
