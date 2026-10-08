# Database Architecture — Healix

## Tables
1. `profiles`: Connected 1:1 with `auth.users`, storing `role` (admin, doctor, patient), name, contacts.
2. `doctors`: Specialization, fee, license, experience, practicing status.
3. `patients`: Medical contacts, blood group, emergency info.
4. `doctor_availability`: Weekly consultation windows per doctor.
5. `appointments`: Booking slots, statuses (`pending`, `confirmed`, `completed`, `cancelled`).
6. `medical_records`: Chart entries, diagnoses, treatments recorded by physicians.
7. `feedback`: Rating (1-5) and testimonials for completed visits.
8. `notifications`: Real-time user notification ledger.
9. `audit_logs`: Immutable ledger of administrative and sensitive access events.
10. `system_settings`: Key-value configurable clinic policies.
