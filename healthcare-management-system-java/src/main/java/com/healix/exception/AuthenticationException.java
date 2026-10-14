package com.healix.exception;

/**
 * Thrown on invalid login credentials or unauthorized role access.
 */
public class AuthenticationException extends HealthcareException {
    public AuthenticationException(String message) {
        super(message);
    }
}
