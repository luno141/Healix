package com.healix.dao.impl;

import com.healix.dao.MedicalRecordDAO;
import com.healix.exception.HealthcareException;
import com.healix.model.MedicalRecord;
import com.healix.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAOImpl implements MedicalRecordDAO {

    @Override
    public MedicalRecord createRecord(MedicalRecord record) throws HealthcareException {
        String sql = "INSERT INTO public.medical_records (patient_id, created_by, record_type, title, description, diagnosis, treatment) " +
                     "VALUES (?::uuid, ?::uuid, ?, ?, ?, ?, ?) RETURNING id, created_at";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, record.getPatientId());
            ps.setString(2, record.getCreatedBy());
            ps.setString(3, record.getRecordType());
            ps.setString(4, record.getTitle());
            ps.setString(5, record.getDescription());
            ps.setString(6, record.getDiagnosis());
            ps.setString(7, record.getTreatment());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    record.setId(rs.getString("id"));
                    record.setCreatedAt(rs.getTimestamp("created_at"));
                    return record;
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error creating medical record: " + e.getMessage(), e);
        }
        return record;
    }

    @Override
    public List<MedicalRecord> getRecordsByPatient(String patientProfileId) throws HealthcareException {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT mr.id, mr.patient_id, mr.created_by, mr.record_type, mr.title, " +
                     "mr.description, mr.diagnosis, mr.treatment, mr.created_at, " +
                     "p.full_name as doctor_name " +
                     "FROM public.medical_records mr " +
                     "JOIN public.patients pat ON mr.patient_id = pat.id " +
                     "LEFT JOIN public.profiles p ON mr.created_by = p.id " +
                     "WHERE (pat.profile_id = ?::uuid OR pat.id = ?::uuid) " +
                     "ORDER BY mr.created_at DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientProfileId);
            ps.setString(2, patientProfileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicalRecord mr = new MedicalRecord();
                    mr.setId(rs.getString("id"));
                    mr.setPatientId(rs.getString("patient_id"));
                    mr.setCreatedBy(rs.getString("created_by"));
                    mr.setDoctorName(rs.getString("doctor_name"));
                    mr.setRecordType(rs.getString("record_type"));
                    mr.setTitle(rs.getString("title"));
                    mr.setDescription(rs.getString("description"));
                    mr.setDiagnosis(rs.getString("diagnosis"));
                    mr.setTreatment(rs.getString("treatment"));
                    mr.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(mr);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error retrieving medical records: " + e.getMessage(), e);
        }
        return list;
    }

    @Override
    public List<MedicalRecord> getRecordsByDoctor(String doctorProfileId) throws HealthcareException {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT mr.id, mr.patient_id, mr.created_by, mr.record_type, mr.title, " +
                     "mr.description, mr.diagnosis, mr.treatment, mr.created_at " +
                     "FROM public.medical_records mr " +
                     "WHERE mr.created_by = ?::uuid " +
                     "ORDER BY mr.created_at DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorProfileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicalRecord mr = new MedicalRecord();
                    mr.setId(rs.getString("id"));
                    mr.setPatientId(rs.getString("patient_id"));
                    mr.setCreatedBy(rs.getString("created_by"));
                    mr.setRecordType(rs.getString("record_type"));
                    mr.setTitle(rs.getString("title"));
                    mr.setDescription(rs.getString("description"));
                    mr.setDiagnosis(rs.getString("diagnosis"));
                    mr.setTreatment(rs.getString("treatment"));
                    mr.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(mr);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching doctor's clinical records: " + e.getMessage(), e);
        }
        return list;
    }
}
