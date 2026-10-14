package com.healix.model;

/**
 * Core Java OOP Concept: Inheritance (Patient extends User)
 */
public class Patient extends User {
    private String patientId;
    private String bloodGroup;
    private String emergencyContact;
    private String emergencyPhone;

    public Patient() {
        super();
        setRole("patient");
    }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public String getEmergencyContact() { return emergencyContact; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }

    public String getEmergencyPhone() { return emergencyPhone; }
    public void setEmergencyPhone(String emergencyPhone) { this.emergencyPhone = emergencyPhone; }
}
