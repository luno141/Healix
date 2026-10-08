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
