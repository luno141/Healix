package com.healix.exception;

/**
 * Thrown when an appointment slot is already occupied or unavailable (double-booking prevention).
 */
public class SlotConflictException extends HealthcareException {
    public SlotConflictException(String message) {
        super(message);
    }
}
