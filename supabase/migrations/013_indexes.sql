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
