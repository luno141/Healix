package com.healix.dao;

import com.healix.exception.HealthcareException;
import com.healix.exception.SlotConflictException;
import com.healix.model.Appointment;
import java.sql.Date;
import java.util.List;

public interface AppointmentDAO {
    Appointment createAppointment(Appointment appointment) throws HealthcareException, SlotConflictException;
    List<Appointment> getAppointmentsByPatient(String patientId) throws HealthcareException;
    List<Appointment> getAppointmentsByDoctor(String doctorId) throws HealthcareException;
    List<Appointment> getAllAppointments() throws HealthcareException;
    boolean updateStatus(String appointmentId, String newStatus, String notes) throws HealthcareException;
    List<String> getAvailableSlots(String doctorId, Date date) throws HealthcareException;
    int getTotalAppointmentCount() throws HealthcareException;
    int getPendingAppointmentCount() throws HealthcareException;
}
