package com.healix.dao;

import com.healix.exception.HealthcareException;
import com.healix.model.User;
import java.util.List;

/**
 * Core Java Concept: Interface / Abstraction (DAO Pattern)
 */
public interface UserDAO {
    User authenticate(String email, String password) throws HealthcareException;
    User registerPatient(String fullName, String email, String password, String phone) throws HealthcareException;
    User getUserById(String id) throws HealthcareException;
    User getUserByEmail(String email) throws HealthcareException;
    List<User> getAllUsers() throws HealthcareException;
    boolean updateUserRole(String userId, String newRole) throws HealthcareException;
    int getTotalUserCount() throws HealthcareException;
}
