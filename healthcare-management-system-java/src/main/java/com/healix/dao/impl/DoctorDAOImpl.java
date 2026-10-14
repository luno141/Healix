package com.healix.dao.impl;

import com.healix.dao.DoctorDAO;
import com.healix.exception.HealthcareException;
import com.healix.model.Doctor;
import com.healix.model.DoctorAvailability;
import com.healix.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAOImpl implements DoctorDAO {

    @Override
    public List<Doctor> getAllActiveDoctors() throws HealthcareException {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT d.id as doctor_id, d.profile_id, d.specialization, d.license_number, d.education, " +
                     "d.experience_years, d.consultation_fee, d.bio, d.status, p.full_name, p.email, p.phone " +
                     "FROM public.doctors d " +
                     "JOIN public.profiles p ON d.profile_id = p.id " +
                     "WHERE d.status = 'active' " +
                     "ORDER BY d.experience_years DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Doctor d = new Doctor();
                d.setDoctorId(rs.getString("doctor_id"));
                d.setId(rs.getString("profile_id"));
                d.setFullName(rs.getString("full_name"));
                d.setEmail(rs.getString("email"));
                d.setPhone(rs.getString("phone"));
                d.setSpecialization(rs.getString("specialization"));
                d.setLicenseNumber(rs.getString("license_number"));
                d.setEducation(rs.getString("education"));
                d.setExperienceYears(rs.getInt("experience_years"));
                d.setConsultationFee(rs.getBigDecimal("consultation_fee"));
                d.setBio(rs.getString("bio"));
                d.setStatus(rs.getString("status"));
                list.add(d);
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error retrieving active doctors: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public Doctor getDoctorById(String doctorId) throws HealthcareException {
        String sql = "SELECT d.id as doctor_id, d.profile_id, d.specialization, d.license_number, d.education, " +
                     "d.experience_years, d.consultation_fee, d.bio, d.status, p.full_name, p.email, p.phone " +
                     "FROM public.doctors d " +
                     "JOIN public.profiles p ON d.profile_id = p.id " +
                     "WHERE d.id = ?::uuid";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor d = new Doctor();
                    d.setDoctorId(rs.getString("doctor_id"));
                    d.setId(rs.getString("profile_id"));
                    d.setFullName(rs.getString("full_name"));
                    d.setEmail(rs.getString("email"));
                    d.setPhone(rs.getString("phone"));
                    d.setSpecialization(rs.getString("specialization"));
                    d.setLicenseNumber(rs.getString("license_number"));
                    d.setEducation(rs.getString("education"));
                    d.setExperienceYears(rs.getInt("experience_years"));
                    d.setConsultationFee(rs.getBigDecimal("consultation_fee"));
                    d.setBio(rs.getString("bio"));
                    d.setStatus(rs.getString("status"));
                    return d;
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching doctor: " + e.getMessage(), e);
        }
        return null;
    }

    @Override
    public Doctor getDoctorByProfileId(String profileId) throws HealthcareException {
        String sql = "SELECT d.id as doctor_id, d.profile_id, d.specialization, d.license_number, d.education, " +
                     "d.experience_years, d.consultation_fee, d.bio, d.status, p.full_name, p.email, p.phone " +
                     "FROM public.doctors d " +
                     "JOIN public.profiles p ON d.profile_id = p.id " +
                     "WHERE d.profile_id = ?::uuid";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor d = new Doctor();
                    d.setDoctorId(rs.getString("doctor_id"));
                    d.setId(rs.getString("profile_id"));
                    d.setFullName(rs.getString("full_name"));
                    d.setEmail(rs.getString("email"));
                    d.setPhone(rs.getString("phone"));
                    d.setSpecialization(rs.getString("specialization"));
                    d.setLicenseNumber(rs.getString("license_number"));
                    d.setEducation(rs.getString("education"));
                    d.setExperienceYears(rs.getInt("experience_years"));
                    d.setConsultationFee(rs.getBigDecimal("consultation_fee"));
                    d.setBio(rs.getString("bio"));
                    d.setStatus(rs.getString("status"));
                    return d;
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching doctor by profile ID: " + e.getMessage(), e);
        }
        return null;
    }

    @Override
    public List<DoctorAvailability> getDoctorAvailability(String doctorId) throws HealthcareException {
        List<DoctorAvailability> list = new ArrayList<>();
        String sql = "SELECT id, doctor_id, day_of_week, start_time, end_time, slot_duration, is_available " +
                     "FROM public.doctor_availability " +
                     "WHERE doctor_id = ?::uuid " +
                     "ORDER BY day_of_week ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DoctorAvailability da = new DoctorAvailability();
                    da.setId(rs.getString("id"));
                    da.setDoctorId(rs.getString("doctor_id"));
                    da.setDayOfWeek(rs.getInt("day_of_week"));
                    da.setStartTime(rs.getTime("start_time"));
                    da.setEndTime(rs.getTime("end_time"));
                    da.setSlotDuration(rs.getInt("slot_duration"));
                    da.setAvailable(rs.getBoolean("is_available"));
                    list.add(da);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error getting doctor availability: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public boolean addOrUpdateAvailability(DoctorAvailability availability) throws HealthcareException {
        String sql = "INSERT INTO public.doctor_availability (doctor_id, day_of_week, start_time, end_time, slot_duration, is_available) " +
                     "VALUES (?::uuid, ?, ?, ?, ?, ?) " +
                     "ON CONFLICT (doctor_id, day_of_week) DO UPDATE " +
                     "SET start_time = EXCLUDED.start_time, end_time = EXCLUDED.end_time, slot_duration = EXCLUDED.slot_duration, is_available = EXCLUDED.is_available";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, availability.getDoctorId());
            ps.setInt(2, availability.getDayOfWeek());
            ps.setTime(3, availability.getStartTime());
            ps.setTime(4, availability.getEndTime());
            ps.setInt(5, availability.getSlotDuration());
            ps.setBoolean(6, availability.isAvailable());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new HealthcareException("Error setting availability: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean deleteAvailability(String availabilityId) throws HealthcareException {
        String sql = "DELETE FROM public.doctor_availability WHERE id = ?::uuid";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, availabilityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new HealthcareException("Error deleting availability slot: " + e.getMessage(), e);
        }
    }

    @Override
    public int getTotalDoctorCount() throws HealthcareException {
        String sql = "SELECT COUNT(*) FROM public.doctors WHERE status = 'active'";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            throw new HealthcareException("Error counting doctors: " + e.getMessage(), e);
        }
        return 0;
    }
}
