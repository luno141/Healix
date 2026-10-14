package com.healix.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Core Java OOP Concept: Encapsulation (Private fields, Getters/Setters, Constructors)
 * Base class for all platform actors (Admin, Doctor, Patient)
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String fullName;
    private String email;
    private String phone;
    private String role; // 'admin', 'doctor', 'patient'
    private String gender;
    private String address;
    private Timestamp createdAt;

    public User() {}

    public User(String id, String fullName, String email, String phone, String role) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{id='" + id + "', fullName='" + fullName + "', email='" + email + "', role='" + role + "'}";
    }
}
