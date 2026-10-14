# Healix - Healthcare Management System

Healix is an enterprise-grade Online Healthcare Management System built using **Core Java (Java 21)**, **Jakarta Servlets (MVC architecture)**, **JSP**, **JDBC with HikariCP Connection Pooling**, and **PostgreSQL (Supabase)**.

The application is deployed with an embedded **Apache Tomcat 10** server for standalone, zero-configuration local execution.

---

## 🌟 Key Features

### Role-Based Access Control (RBAC)
- **Patient Portal**:
  - View dashboard statistics and upcoming appointments.
  - Browse qualified doctors filtered by medical specialization.
  - Book consultation slots with dynamic slot conflict detection and double-booking concurrency control.
  - View electronic medical records and historical diagnosis/treatment data.
  - Cancel pending/confirmed appointments.
- **Doctor Portal**:
  - View daily schedule and appointment queues.
  - Manage weekly availability windows (set days, start/end times, slot durations).
  - Confirm, complete, or cancel patient appointments.
  - Access patient charts and register consultation notes, diagnoses, and medical treatments.
  - Review patient ratings and feedback.
- **Admin Governance**:
  - Centralized dashboard displaying total user counts, active doctors, appointments, and pending queues.
  - Manage user accounts and modify user roles.
  - Inspect practitioner licensing, qualifications, and operational statuses.
  - Global oversight of all clinic appointments.

---

## 🏗️ Architecture & Core Java Concepts

This project is built from first principles demonstrating core object-oriented software engineering:

- **Model-View-Controller (MVC)**:
  - **Models (`com.healix.model`)**: Encapsulated domain entities (`User`, `Doctor`, `Patient`, `Appointment`, `DoctorAvailability`, `MedicalRecord`, `Feedback`).
  - **Controllers (`com.healix.controller`)**: Dedicated `HttpServlet` classes (`HomeServlet`, `AuthServlet`, `PatientServlet`, `DoctorServlet`, `AdminServlet`) managing GET/POST requests and session states.
  - **Views (`WEB-INF/views`)**: Server-rendered JSP templates utilizing standard JSTL 3.0 tags with clean, responsive styling.
- **Object-Oriented Programming (OOP)**:
  - **Encapsulation**: Private state with accessor/mutator methods across all data models.
  - **Inheritance**: `Doctor extends User` and `Patient extends User` sharing identity and authentication attributes.
  - **Polymorphism & Abstraction**: Data Access Object (DAO) pattern separating interfaces (`UserDAO`, `DoctorDAO`, `AppointmentDAO`, `MedicalRecordDAO`, `FeedbackDAO`) from concrete JDBC implementations.
- **Concurrency & Concurrency Control**:
  - Double-booking prevention enforced via transactional validation in `AppointmentDAOImpl`.
- **Exception Hierarchy**:
  - Custom checked and domain exceptions (`HealthcareException`, `SlotConflictException`, `AuthenticationException`).
- **Connection Pooling & Singleton**:
  - Thread-safe HikariCP connection pool managed via a thread-safe `DBConnection` Singleton.
- **Security & Interceptors**:
  - `AuthenticationFilter` implementing `jakarta.servlet.Filter` to intercept unauthenticated or unauthorized role access.

---

## 🚀 Getting Started

### Prerequisites
- **JDK 21 or higher**
- **Gradle 8.5+** (or Maven 3.9+)

### Installation & Launch

1. Clone the repository:
   ```bash
   git clone git@github.com:luno141/Healix.git
   cd Healix
   ```

2. Start the application using the runner script:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

   *Alternatively, build and run directly via Gradle:*
   ```bash
   gradle build -x test
   gradle run
   ```

3. Open your browser and navigate to:
   ```
   http://localhost:8080/
   ```

---

## 📁 Project Directory Structure

```
.
├── build.gradle                    # Gradle build configuration
├── pom.xml                         # Maven build configuration
├── run.sh                          # One-click startup script
├── src/
│   └── main/
│       ├── java/com/healix/
│       │   ├── controller/         # Jakarta Servlets (Controllers)
│       │   │   ├── HomeServlet.java
│       │   │   ├── AuthServlet.java
│       │   │   ├── PatientServlet.java
│       │   │   ├── DoctorServlet.java
│       │   │   └── AdminServlet.java
│       │   ├── dao/                # DAO interfaces & JDBC implementations
│       │   │   ├── AppointmentDAO.java
│       │   │   ├── DoctorDAO.java
│       │   │   ├── FeedbackDAO.java
│       │   │   ├── MedicalRecordDAO.java
│       │   │   ├── UserDAO.java
│       │   │   └── impl/
│       │   ├── exception/          # Custom exceptions
│       │   ├── filter/             # Security & RBAC Servlet Filter
│       │   │   └── AuthenticationFilter.java
│       │   ├── model/              # Domain POJOs (OOP & Inheritance)
│       │   │   ├── User.java
│       │   │   ├── Doctor.java
│       │   │   ├── Patient.java
│       │   │   ├── Appointment.java
│       │   │   └── ...
│       │   ├── server/             # Embedded Tomcat 10 launcher
│       │   │   └── MainServer.java
│       │   └── util/               # Singleton DB connection & BCrypt utility
│       ├── resources/
│       │   └── db.properties       # Database credentials & pooling config
│       └── webapp/
│           ├── css/style.css       # Complete application styling
│           ├── js/main.js          # Client-side AJAX & interactions
│           └── WEB-INF/
│               ├── web.xml         # Deployment descriptor
│               └── views/          # JSP view templates (Admin, Doctor, Patient)
└── supabase/
    └── migrations/                 # PostgreSQL database migrations
```

---

## 🗄️ Database Schema & Migrations

Database migrations are located in `supabase/migrations/`:
- `001_initial_schema.sql` - Core extensions & database settings
- `002_profiles.sql` - User identities & profile triggers
- `003_doctors.sql` - Doctor credentials, specializations, licenses
- `004_patients.sql` - Patient medical records & emergency contacts
- `005_doctor_availability.sql` - Weekly recurring consultation slots
- `006_appointments.sql` - Appointment scheduling & status constraints
- `007_medical_records.sql` - Consultation notes & diagnostic logs
- `008_medical_record_files.sql` - Attached medical files & reports
- `009_feedback.sql` - Patient ratings and reviews
- `010_notifications.sql` - System alerts & notification queue
- `011_system_settings.sql` - Global administrative parameters
- `012_audit_logs.sql` - System audit trail
- `013_indexes.sql` - Performance query indexes
- `014_rls_policies.sql` - Row-level security definitions

---

## 🔒 Security Best Practices
- **Password Salting & Hashing**: BCrypt encryption for user credentials.
- **SQL Injection Prevention**: Parameterized `PreparedStatement` across all queries.
- **Session Management**: Secure HTTP sessions with strict timeouts and invalidation on logout.
- **RBAC Enforcement**: Server-level filter authorization preventing privilege escalation.

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
