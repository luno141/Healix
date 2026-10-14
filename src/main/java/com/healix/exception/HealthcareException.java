package com.healix.exception;

/**
 * Core Java Exception Concept: Custom checked/runtime exception for Healthcare System
 */
public class HealthcareException extends Exception {
    public HealthcareException(String message) {
        super(message);
    }

    public HealthcareException(String message, Throwable cause) {
        super(message, cause);
    }
}
