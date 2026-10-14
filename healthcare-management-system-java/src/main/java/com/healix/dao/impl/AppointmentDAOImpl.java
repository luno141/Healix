package com.healix.dao.impl;

import com.healix.dao.AppointmentDAO;
import com.healix.exception.HealthcareException;
import com.healix.exception.SlotConflictException;
import com.healix.model.Appointment;
import com.healix.util.DBConnection;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class AppointmentDAOImpl implements AppointmentDAO {

    @Override
    public Appointment createAppointment(Appointment appt) throws HealthcareException, SlotConflictException {
        // Enforce concurrency validation via JDBC Transaction
        String checkConflictSql = "SELECT id FROM public.appointments " +
                                  "WHERE doctor_id = ?::uuid AND appointment_date = ? " +
                                  "AND start_time = ? AND status IN ('pending', 'confirmed')";

        // If patientId is a profileId, lookup patient table id
        String getPatientIdSql = "SELECT id FROM public.patients WHERE profile_id = ?::uuid";

        String insertSql = "INSERT INTO public.appointments (patient_id, doctor_id, appointment_date, start_time, end_time, reason, status) " +
                           "VALUES (?::uuid, ?::uuid, ?, ?, ?, ?, 'pending') RETURNING id, created_at";

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            conn.setAutoCommit(false); // Begin transaction for double-booking prevention

            try {
                // 1. Resolve patient table id
                String resolvedPatientId = appt.getPatientId();
                try (PreparedStatement psPat = conn.prepareStatement(getPatientIdSql)) {
                    psPat.setString(1, appt.getPatientId());
                    try (ResultSet rs = psPat.executeQuery()) {
                        if (rs.next()) {
                            resolvedPatientId = rs.getString("id");
                        }
                    }
                }

                // 2. Check for slot collision
                try (PreparedStatement psCheck = conn.prepareStatement(checkConflictSql)) {
                    psCheck.setString(1, appt.getDoctorId());
                    psCheck.setDate(2, appt.getAppointmentDate());
                    psCheck.setTime(3, appt.getStartTime());
                    try (ResultSet rsCheck = psCheck.executeQuery()) {
                        if (rsCheck.next()) {
                            throw new SlotConflictException("The selected time slot " + appt.getStartTime() + " on " + appt.getAppointmentDate() + " has already been reserved by another patient.");
                        }
                    }
                }

                // 3. Insert appointment record
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setString(1, resolvedPatientId);
                    psInsert.setString(2, appt.getDoctorId());
                    psInsert.setDate(3, appt.getAppointmentDate());
                    psInsert.setTime(4, appt.getStartTime());
                    psInsert.setTime(5, appt.getEndTime());
                    psInsert.setString(6, appt.getReason());

                    try (ResultSet rs = psInsert.executeQuery()) {
                        if (rs.next()) {
                            appt.setId(rs.getString("id"));
                            appt.setCreatedAt(rs.getTimestamp("created_at"));
                            appt.setStatus("pending");
                        }
                    }
                }

                conn.commit(); // Transaction successful
                return appt;

            } catch (SlotConflictException sce) {
                conn.rollback();
                throw sce;
            } catch (SQLException e) {
                conn.rollback();
                throw new HealthcareException("Appointment creation failed: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new HealthcareException("Database connection error: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Appointment> getAppointmentsByPatient(String patientProfileId) throws HealthcareException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.start_time, a.end_time, " +
                     "a.reason, a.status, a.notes, a.created_at, " +
                     "dp.full_name as doctor_name, d.specialization " +
                     "FROM public.appointments a " +
                     "JOIN public.patients pat ON a.patient_id = pat.id " +
                     "JOIN public.doctors d ON a.doctor_id = d.id " +
                     "JOIN public.profiles dp ON d.profile_id = dp.id " +
                     "WHERE (pat.profile_id = ?::uuid OR pat.id = ?::uuid) " +
                     "ORDER BY a.appointment_date DESC, a.start_time DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientProfileId);
            ps.setString(2, patientProfileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setId(rs.getString("id"));
                    a.setPatientId(rs.getString("patient_id"));
                    a.setDoctorId(rs.getString("doctor_id"));
                    a.setAppointmentDate(rs.getDate("appointment_date"));
                    a.setStartTime(rs.getTime("start_time"));
                    a.setEndTime(rs.getTime("end_time"));
                    a.setReason(rs.getString("reason"));
                    a.setStatus(rs.getString("status"));
                    a.setNotes(rs.getString("notes"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setDoctorName(rs.getString("doctor_name"));
                    a.setSpecialization(rs.getString("specialization"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching patient appointments: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<Appointment> getAppointmentsByDoctor(String doctorProfileId) throws HealthcareException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.start_time, a.end_time, " +
                     "a.reason, a.status, a.notes, a.created_at, " +
                     "pp.full_name as patient_name, pp.phone as patient_phone " +
                     "FROM public.appointments a " +
                     "JOIN public.doctors d ON a.doctor_id = d.id " +
                     "JOIN public.patients pat ON a.patient_id = pat.id " +
                     "JOIN public.profiles pp ON pat.profile_id = pp.id " +
                     "WHERE (d.profile_id = ?::uuid OR d.id = ?::uuid) " +
                     "ORDER BY a.appointment_date DESC, a.start_time ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorProfileId);
            ps.setString(2, doctorProfileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setId(rs.getString("id"));
                    a.setPatientId(rs.getString("patient_id"));
                    a.setDoctorId(rs.getString("doctor_id"));
                    a.setAppointmentDate(rs.getDate("appointment_date"));
                    a.setStartTime(rs.getTime("start_time"));
                    a.setEndTime(rs.getTime("end_time"));
                    a.setReason(rs.getString("reason"));
                    a.setStatus(rs.getString("status"));
                    a.setNotes(rs.getString("notes"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setPatientName(rs.getString("patient_name"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching doctor appointments: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<Appointment> getAllAppointments() throws HealthcareException {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, a.appointment_date, a.start_time, a.end_time, " +
                     "a.reason, a.status, a.notes, a.created_at, " +
                     "pp.full_name as patient_name, dp.full_name as doctor_name, d.specialization " +
                     "FROM public.appointments a " +
                     "JOIN public.patients pat ON a.patient_id = pat.id " +
                     "JOIN public.profiles pp ON pat.profile_id = pp.id " +
                     "JOIN public.doctors d ON a.doctor_id = d.id " +
                     "JOIN public.profiles dp ON d.profile_id = dp.id " +
                     "ORDER BY a.appointment_date DESC, a.start_time ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getString("id"));
                a.setPatientId(rs.getString("patient_id"));
                a.setDoctorId(rs.getString("doctor_id"));
                a.setAppointmentDate(rs.getDate("appointment_date"));
                a.setStartTime(rs.getTime("start_time"));
                a.setEndTime(rs.getTime("end_time"));
                a.setReason(rs.getString("reason"));
                a.setStatus(rs.getString("status"));
                a.setNotes(rs.getString("notes"));
                a.setCreatedAt(rs.getTimestamp("created_at"));
                a.setPatientName(rs.getString("patient_name"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setSpecialization(rs.getString("specialization"));
                list.add(a);
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error retrieving global appointments: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public boolean updateStatus(String appointmentId, String newStatus, String notes) throws HealthcareException {
        String sql = "UPDATE public.appointments SET status = ?, notes = COALESCE(?, notes), updated_at = NOW() WHERE id = ?::uuid";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, notes);
            ps.setString(3, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new HealthcareException("Error updating appointment status: " + e.getMessage(), e);
        }
    }

    @Override
    public List<String> getAvailableSlots(String doctorId, Date date) throws HealthcareException {
        // Core Java Collections & Algorithms: Calculate slot intervals and subtract booked ones
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK) - 1; // 0=Sunday, 1=Monday...

        String availSql = "SELECT start_time, end_time, slot_duration FROM public.doctor_availability " +
                          "WHERE doctor_id = ?::uuid AND day_of_week = ? AND is_available = true";

        String bookedSql = "SELECT start_time FROM public.appointments " +
                           "WHERE doctor_id = ?::uuid AND appointment_date = ? AND status IN ('pending', 'confirmed')";

        List<String> availableSlots = new ArrayList<>();
        Set<String> bookedSlots = new HashSet<>();

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Get already booked slots
            try (PreparedStatement psBooked = conn.prepareStatement(bookedSql)) {
                psBooked.setString(1, doctorId);
                psBooked.setDate(2, date);
                try (ResultSet rs = psBooked.executeQuery()) {
                    while (rs.next()) {
                        bookedSlots.add(rs.getTime("start_time").toString().substring(0, 5));
                    }
                }
            }

            // Get availability window
            try (PreparedStatement psAvail = conn.prepareStatement(availSql)) {
                psAvail.setString(1, doctorId);
                psAvail.setInt(2, dayOfWeek);
                try (ResultSet rs = psAvail.executeQuery()) {
                    if (rs.next()) {
                        Time start = rs.getTime("start_time");
                        Time end = rs.getTime("end_time");
                        int duration = rs.getInt("slot_duration");
                        if (duration <= 0) duration = 30;

                        long current = start.getTime();
                        long endTime = end.getTime();

                        while (current + (duration * 60 * 1000L) <= endTime) {
                            Time slotTime = new Time(current);
                            String slotStr = slotTime.toString().substring(0, 5);
                            if (!bookedSlots.contains(slotStr)) {
                                availableSlots.add(slotStr);
                            }
                            current += (duration * 60 * 1000L);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error calculating available slots: " + e.getMessage(), e);
        }

        return availableSlots;
    }

    @Override
    public int getTotalAppointmentCount() throws HealthcareException {
        String sql = "SELECT COUNT(*) FROM public.appointments";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new HealthcareException("Error counting appointments: " + e.getMessage(), e);
        }
        return 0;
    }

    @Override
    public int getPendingAppointmentCount() throws HealthcareException {
        String sql = "SELECT COUNT(*) FROM public.appointments WHERE status = 'pending'";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new HealthcareException("Error counting pending appointments: " + e.getMessage(), e);
        }
        return 0;
    }
}
