package com.healix.dao.impl;

import com.healix.dao.FeedbackDAO;
import com.healix.exception.HealthcareException;
import com.healix.model.Feedback;
import com.healix.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Core Java: JDBC PreparedStatement, ResultSet, Collections
 */
public class FeedbackDAOImpl implements FeedbackDAO {

    @Override
    public Feedback createFeedback(Feedback fb) throws HealthcareException {
        String sql = "INSERT INTO public.feedback (appointment_id, patient_id, doctor_id, rating, comment) " +
                     "VALUES (?::uuid, ?::uuid, ?::uuid, ?, ?) RETURNING id, created_at";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fb.getAppointmentId());
            ps.setString(2, fb.getPatientId());
            ps.setString(3, fb.getDoctorId());
            ps.setInt(4, fb.getRating());
            ps.setString(5, fb.getComment());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    fb.setId(rs.getString("id"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
            return fb;
        } catch (SQLException e) {
            throw new HealthcareException("Error creating feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Feedback> getFeedbackByDoctor(String doctorId) throws HealthcareException {
        String sql = "SELECT f.*, p.full_name AS patient_name FROM public.feedback f " +
                     "JOIN public.patients pat ON f.patient_id = pat.id " +
                     "JOIN public.profiles p ON pat.profile_id = p.id " +
                     "WHERE (f.doctor_id = ?::uuid OR f.doctor_id IN (SELECT id FROM public.doctors WHERE profile_id = ?::uuid)) " +
                     "ORDER BY f.created_at DESC";
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorId);
            ps.setString(2, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Feedback> getFeedbackByPatient(String patientId) throws HealthcareException {
        String sql = "SELECT f.*, p.full_name AS patient_name FROM public.feedback f " +
                     "JOIN public.patients pat ON f.patient_id = pat.id " +
                     "JOIN public.profiles p ON pat.profile_id = p.id " +
                     "WHERE (f.patient_id = ?::uuid OR pat.profile_id = ?::uuid) " +
                     "ORDER BY f.created_at DESC";
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setString(2, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public double getAverageRatingForDoctor(String doctorId) throws HealthcareException {
        String sql = "SELECT COALESCE(AVG(rating), 0) AS avg_rating FROM public.feedback " +
                     "WHERE (doctor_id = ?::uuid OR doctor_id IN (SELECT id FROM public.doctors WHERE profile_id = ?::uuid))";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorId);
            ps.setString(2, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("avg_rating");
            }
            return 0;
        } catch (SQLException e) {
            throw new HealthcareException("Error computing average rating: " + e.getMessage(), e);
        }
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getString("id"));
        f.setAppointmentId(rs.getString("appointment_id"));
        f.setPatientId(rs.getString("patient_id"));
        f.setDoctorId(rs.getString("doctor_id"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        try { f.setPatientName(rs.getString("patient_name")); } catch (SQLException ignored) {}
        return f;
    }
}
