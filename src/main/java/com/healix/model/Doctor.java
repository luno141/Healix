package com.healix.model;

import java.math.BigDecimal;

/**
 * Core Java OOP Concept: Inheritance (Doctor extends User)
 */
public class Doctor extends User {
    private String doctorId;
    private String specialization;
    private String licenseNumber;
    private String education;
    private int experienceYears;
    private BigDecimal consultationFee;
    private String bio;
    private String status; // 'active', 'inactive', 'pending'

    public Doctor() {
        super();
        setRole("doctor");
    }

    public String getDoctorId() { return doctorId; }
    public void setDoctorId(String doctorId) { this.doctorId = doctorId; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
