package com.healix.dao;

import com.healix.exception.HealthcareException;
import com.healix.model.Doctor;
import com.healix.model.DoctorAvailability;
import java.util.List;

public interface DoctorDAO {
    List<Doctor> getAllActiveDoctors() throws HealthcareException;
    Doctor getDoctorById(String doctorId) throws HealthcareException;
    Doctor getDoctorByProfileId(String profileId) throws HealthcareException;
    List<DoctorAvailability> getDoctorAvailability(String doctorId) throws HealthcareException;
    boolean addOrUpdateAvailability(DoctorAvailability availability) throws HealthcareException;
    boolean deleteAvailability(String availabilityId) throws HealthcareException;
    int getTotalDoctorCount() throws HealthcareException;
}
