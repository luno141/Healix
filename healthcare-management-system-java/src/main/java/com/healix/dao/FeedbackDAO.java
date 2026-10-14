package com.healix.dao;

import com.healix.exception.HealthcareException;
import com.healix.model.Feedback;
import java.util.List;

/**
 * Core Java Concept: Interface / Abstraction (DAO Pattern)
 */
public interface FeedbackDAO {
    Feedback createFeedback(Feedback feedback) throws HealthcareException;
    List<Feedback> getFeedbackByDoctor(String doctorId) throws HealthcareException;
    List<Feedback> getFeedbackByPatient(String patientId) throws HealthcareException;
    double getAverageRatingForDoctor(String doctorId) throws HealthcareException;
}
