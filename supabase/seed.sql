-- Fictional Demo Seed Data for Healix Healthcare Management System
-- WARNING: These are synthetic credentials and names for testing/grading only.

-- Note: In production Supabase, users are created via Supabase Auth (auth.users).
-- Once auth users exist, trigger or manual insert populates profiles.
-- Below is sample SQL to populate initial system settings and mock reference rows.

INSERT INTO system_settings (setting_key, setting_value, description)
VALUES 
  ('appointment_slot_duration', '30', 'Duration of each patient consultation slot in minutes'),
  ('max_appointments_per_day', '20', 'Cap on maximum daily bookings per doctor'),
  ('allow_patient_cancellation', 'true', 'Whether patients can self-cancel eligible appointments'),
  ('allow_patient_rescheduling', 'true', 'Whether patients can reschedule upcoming appointments'),
  ('maintenance_mode', 'false', 'Global maintenance lock toggle'),
  ('system_name', 'Healix', 'Clinic platform name')
ON CONFLICT (setting_key) DO UPDATE SET setting_value = EXCLUDED.setting_value;
