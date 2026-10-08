export type UserRole = 'admin' | 'doctor' | 'patient';
export type DoctorStatus = 'active' | 'inactive' | 'pending';
export type AppointmentStatus = 'pending' | 'confirmed' | 'completed' | 'cancelled' | 'rescheduled' | 'no_show';

export interface Profile {
  id: string; // UUID
  full_name: string;
  email: string;
  phone?: string;
  role: UserRole;
  avatar_url?: string;
  date_of_birth?: string;
  gender?: string;
  address?: string;
  created_at: string;
  updated_at: string;
}

export interface Doctor {
  id: string; // UUID
  profile_id: string; // UUID
  specialization: string;
  license_number: string;
  qualification: string;
  experience_years: number;
  consultation_fee: number;
  bio?: string;
  status: DoctorStatus;
  created_at: string;
  updated_at: string;
}

export interface Patient {
  id: string; // UUID
  profile_id: string; // UUID
  blood_group?: string;
  emergency_contact?: string;
  emergency_phone?: string;
  created_at: string;
  updated_at: string;
}

export interface DoctorAvailability {
  id: string; // UUID
  doctor_id: string; // UUID
  day_of_week: number; // 0-6
  start_time: string;
  end_time: string;
  slot_duration: number;
  is_available: boolean;
  created_at: string;
  updated_at: string;
}

export interface Appointment {
  id: string; // UUID
  patient_id: string; // UUID
  doctor_id: string; // UUID
  appointment_date: string;
  start_time: string;
  end_time: string;
  reason: string;
  status: AppointmentStatus;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface MedicalRecord {
  id: string; // UUID
  patient_id: string; // UUID
  created_by: string; // UUID
  record_type: string;
  title: string;
  description: string;
  diagnosis?: string;
  treatment?: string;
  created_at: string;
  updated_at: string;
}

export interface MedicalRecordFile {
  id: string; // UUID
  record_id: string; // UUID
  file_path: string;
  file_name: string;
  file_type: string;
  created_at: string;
}

export interface Feedback {
  id: string; // UUID
  appointment_id: string; // UUID
  patient_id: string; // UUID
  doctor_id: string; // UUID
  rating: number; // 1-5
  comment?: string;
  created_at: string;
}

export interface Notification {
  id: string; // UUID
  user_id: string; // UUID
  title: string;
  message: string;
  type: string;
  is_read: boolean;
  created_at: string;
}

export interface AuditLog {
  id: string; // UUID
  user_id: string; // UUID
  action: string;
  entity_type: string;
  entity_id: string;
  metadata: Record<string, any>;
  ip_address?: string;
  created_at: string;
}

export interface SystemSetting {
  id: string; // UUID
  setting_key: string;
  setting_value: any;
  description?: string;
  updated_by: string; // UUID
  updated_at: string;
}

export type DoctorWithProfile = Doctor & { profile: Profile };
export type PatientWithProfile = Patient & { profile: Profile };
export type AppointmentWithDetails = Appointment & { 
  doctor: DoctorWithProfile; 
  patient: PatientWithProfile;
};

export interface AdminDashboardStats {
  totalPatients: number;
  totalDoctors: number;
  totalAppointments: number;
  revenue: number;
}

export interface DoctorDashboardStats {
  totalPatients: number;
  upcomingAppointments: number;
  completedAppointments: number;
  totalEarnings: number;
}

export interface PatientDashboardStats {
  upcomingAppointments: number;
  pastAppointments: number;
  totalMedicalRecords: number;
}
