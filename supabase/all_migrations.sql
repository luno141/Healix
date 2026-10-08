-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Create profiles table
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    role TEXT NOT NULL CHECK (role IN ('admin', 'doctor', 'patient')) DEFAULT 'patient',
    avatar_url TEXT,
    date_of_birth DATE,
    gender TEXT CHECK (gender IN ('male', 'female', 'other')),
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, email, role)
    VALUES (
        new.id,
        new.raw_user_meta_data->>'full_name',
        new.email,
        COALESCE(new.raw_user_meta_data->>'role', 'patient')
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
-- Create doctors table
CREATE TABLE doctors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    specialization TEXT NOT NULL,
    experience_years INTEGER NOT NULL DEFAULT 0,
    education TEXT NOT NULL,
    license_number TEXT NOT NULL UNIQUE,
    bio TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive', 'pending')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(profile_id)
);
-- Create patients table
CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    blood_group TEXT,
    medical_history TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(profile_id)
);

-- Function to handle new patient profile creation
CREATE OR REPLACE FUNCTION public.handle_new_patient_profile()
RETURNS TRIGGER AS $$
BEGIN
    IF new.role = 'patient' THEN
        INSERT INTO public.patients (profile_id)
        VALUES (new.id);
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new patient profile
CREATE TRIGGER on_profile_created_create_patient
    AFTER INSERT ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_patient_profile();
-- Create doctor_availability table
CREATE TABLE doctor_availability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_duration INTEGER NOT NULL DEFAULT 30,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(doctor_id, day_of_week)
);
-- Create appointments table
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    reason TEXT,
    notes TEXT,
    status TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled', 'no_show', 'rescheduled')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for fast querying
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient_date ON appointments(patient_id, appointment_date);

-- Partial unique index to prevent double booking for exact same slots
CREATE UNIQUE INDEX uk_doctor_appointment_slot 
ON appointments(doctor_id, appointment_date, start_time) 
WHERE status IN ('pending', 'confirmed');
-- Create medical_records table
CREATE TABLE medical_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    diagnosis TEXT NOT NULL,
    symptoms TEXT,
    treatment_plan TEXT,
    prescriptions TEXT,
    notes TEXT,
    created_by UUID NOT NULL REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Create medical_record_files table
CREATE TABLE medical_record_files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    record_id UUID NOT NULL REFERENCES medical_records(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_type TEXT,
    file_size INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Create feedback table
CREATE TABLE feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID NOT NULL UNIQUE REFERENCES appointments(id) ON DELETE CASCADE,
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Create notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index on user_id and is_read
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
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
-- Create audit_logs table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id UUID,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
-- Additional performance indexes

-- profiles
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_email ON profiles(email);

-- doctors
CREATE INDEX idx_doctors_specialization ON doctors(specialization);
CREATE INDEX idx_doctors_status ON doctors(status);

-- appointments
CREATE INDEX idx_appointments_status ON appointments(status);

-- notifications
CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at);
-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_record_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Helper function to check if user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Profiles Policies
CREATE POLICY "Users can read own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Admins can read all profiles" ON profiles FOR SELECT USING (public.is_admin());
CREATE POLICY "Public can read basic doctor profiles" ON profiles FOR SELECT USING (role = 'doctor');

CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id) 
WITH CHECK (
    auth.uid() = id AND 
    role = (SELECT role FROM profiles WHERE id = auth.uid()) -- Prevent role update
);
CREATE POLICY "Admins can update all profiles" ON profiles FOR UPDATE USING (public.is_admin());

-- Doctors Policies
CREATE POLICY "Anyone can read active doctors" ON doctors FOR SELECT USING (status = 'active');
CREATE POLICY "Admins can CRUD all doctors" ON doctors FOR ALL USING (public.is_admin());
CREATE POLICY "Doctor can update own record" ON doctors FOR UPDATE USING (profile_id = auth.uid());
CREATE POLICY "Doctor can read own record" ON doctors FOR SELECT USING (profile_id = auth.uid());

-- Patients Policies
CREATE POLICY "Patient can read own record" ON patients FOR SELECT USING (profile_id = auth.uid());
CREATE POLICY "Patient can update own record" ON patients FOR UPDATE USING (profile_id = auth.uid());
CREATE POLICY "Admin can read all patients" ON patients FOR SELECT USING (public.is_admin());
CREATE POLICY "Doctor can read patients they have appointments with" ON patients FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM appointments a
        JOIN doctors d ON a.doctor_id = d.id
        WHERE a.patient_id = patients.id AND d.profile_id = auth.uid()
    )
);

-- Doctor Availability Policies
CREATE POLICY "Anyone can read availability" ON doctor_availability FOR SELECT USING (true);
CREATE POLICY "Doctor can manage own availability" ON doctor_availability FOR ALL USING (
    doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
);
CREATE POLICY "Admin can manage all availability" ON doctor_availability FOR ALL USING (public.is_admin());

-- Appointments Policies
CREATE POLICY "Patient can read own appointments" ON appointments FOR SELECT USING (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);
CREATE POLICY "Patient can create appointments" ON appointments FOR INSERT WITH CHECK (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);
CREATE POLICY "Patient can update own appointments" ON appointments FOR UPDATE USING (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);

CREATE POLICY "Doctor can read assigned appointments" ON appointments FOR SELECT USING (
    doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
);
CREATE POLICY "Doctor can update assigned appointments" ON appointments FOR UPDATE USING (
    doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
);

CREATE POLICY "Admin can read/update all appointments" ON appointments FOR ALL USING (public.is_admin());

-- Medical Records Policies
CREATE POLICY "Patient can read own records" ON medical_records FOR SELECT USING (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);
CREATE POLICY "Doctor can read records for patients they have appointments with" ON medical_records FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM appointments a
        WHERE a.patient_id = medical_records.patient_id 
        AND a.doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
    )
);
CREATE POLICY "Doctor can create/update records" ON medical_records FOR ALL USING (
    created_by = auth.uid() OR doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
);
CREATE POLICY "Admin can read all records" ON medical_records FOR SELECT USING (public.is_admin());

-- Medical Record Files Policies
CREATE POLICY "Patient can read own record files" ON medical_record_files FOR SELECT USING (
    record_id IN (
        SELECT id FROM medical_records WHERE patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
    )
);
CREATE POLICY "Doctor can manage record files" ON medical_record_files FOR ALL USING (
    record_id IN (
        SELECT id FROM medical_records WHERE doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
    )
);
CREATE POLICY "Admin can read all record files" ON medical_record_files FOR SELECT USING (public.is_admin());

-- Feedback Policies
CREATE POLICY "Patient can create feedback" ON feedback FOR INSERT WITH CHECK (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);
CREATE POLICY "Patient can read own feedback" ON feedback FOR SELECT USING (
    patient_id IN (SELECT id FROM patients WHERE profile_id = auth.uid())
);
CREATE POLICY "Doctor can read feedback about them" ON feedback FOR SELECT USING (
    doctor_id IN (SELECT id FROM doctors WHERE profile_id = auth.uid())
);
CREATE POLICY "Admin can read all feedback" ON feedback FOR SELECT USING (public.is_admin());

-- Notifications Policies
CREATE POLICY "User can read own notifications" ON notifications FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "User can update own notifications" ON notifications FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY "System/admin can create notifications" ON notifications FOR INSERT WITH CHECK (public.is_admin() OR auth.uid() IS NOT NULL);

-- Audit Logs Policies
CREATE POLICY "Only admin can read audit logs" ON audit_logs FOR SELECT USING (public.is_admin());
CREATE POLICY "Authenticated users can insert audit logs" ON audit_logs FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- System Settings Policies
CREATE POLICY "Admin can CRUD system settings" ON system_settings FOR ALL USING (public.is_admin());
CREATE POLICY "Authenticated users can read settings" ON system_settings FOR SELECT USING (auth.uid() IS NOT NULL);
