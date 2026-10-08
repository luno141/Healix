-- Create system_settings table
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_key TEXT UNIQUE NOT NULL,
    setting_value JSONB NOT NULL,
    description TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by UUID REFERENCES profiles(id)
);

-- Insert default settings
INSERT INTO system_settings (setting_key, setting_value, description)
VALUES 
    ('appointment_slot_duration', '30'::jsonb, 'Default duration for appointments in minutes'),
    ('max_appointments_per_day', '20'::jsonb, 'Maximum number of appointments a doctor can have in a day'),
    ('allow_patient_cancellation', 'true'::jsonb, 'Allow patients to cancel their appointments'),
    ('allow_patient_rescheduling', 'true'::jsonb, 'Allow patients to reschedule their appointments'),
    ('maintenance_mode', 'false'::jsonb, 'Put the system in maintenance mode'),
    ('system_name', '"Healix"'::jsonb, 'Name of the healthcare system');
