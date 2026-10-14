package com.healix.dao;

import com.healix.exception.HealthcareException;
import com.healix.model.MedicalRecord;
import java.util.List;

public interface MedicalRecordDAO {
    MedicalRecord createRecord(MedicalRecord record) throws HealthcareException;
    List<MedicalRecord> getRecordsByPatient(String patientId) throws HealthcareException;
    List<MedicalRecord> getRecordsByDoctor(String doctorProfileId) throws HealthcareException;
}
