package com.healix.model;

import java.sql.Time;

public class DoctorAvailability {
    private String id;
    private String doctorId;
    private int dayOfWeek; // 0=Sunday, 1=Monday... 6=Saturday
    private Time startTime;
    private Time endTime;
    private int slotDuration; // in minutes
    private boolean isAvailable;

    public DoctorAvailability() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getDoctorId() { return doctorId; }
    public void setDoctorId(String doctorId) { this.doctorId = doctorId; }

    public int getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(int dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public int getSlotDuration() { return slotDuration; }
    public void setSlotDuration(int slotDuration) { this.slotDuration = slotDuration; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public String getDayName() {
        String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        if (dayOfWeek >= 0 && dayOfWeek < days.length) return days[dayOfWeek];
        return "Unknown";
    }
}
