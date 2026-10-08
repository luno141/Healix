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
