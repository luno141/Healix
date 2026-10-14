# Healix - Healthcare Management System

Healix is a comprehensive, production-grade Healthcare Management System engineered to streamline clinic workflows, patient consultation scheduling, electronic medical records (EMR), and administrative governance.

The platform provides dual runtime architectures:
1. **Java Enterprise Edition (Servlet / JSP / MVC)** - Built with Core Java principles, Jakarta Servlets, JDBC with connection pooling, and embedded Apache Tomcat.
2. **Next.js & TypeScript Modern Web Application** - Built with Next.js App Router, React Server Components, Tailwind CSS, and Shadcn UI.
3. **Database & Infrastructure** - PostgreSQL powered by Supabase with Row Level Security (RLS), custom triggers, and role-based access control.

---

## 🌟 Key Features

### Role-Based Access Control (RBAC)
- **Patient Portal**: Browse active practitioners by medical discipline, schedule appointments with conflict prevention algorithms, view personal medical histories, and leave verified ratings.
- **Doctor Portal**: Manage weekly consultation availability, inspect daily queues, approve/complete/cancel visits, update patient diagnostic notes, and record medical treatments.
- **Admin Governance**: Centralized dashboard for user accounts, doctor onboarding, system audit logs, and global appointment operations.

### Core Modules
- **Slot Conflict & Concurrency Prevention**: Strict double-booking prevention ensuring no overlapping active slots exist for any doctor.
- **Electronic Medical Records (EMR)**: Secure creation and indexing of diagnoses, prescriptions, treatment plans, and document storage.
- **Real-Time Dashboards & Metrics**: Dynamic reporting of appointment throughput, patient rosters, and doctor ratings.

---

## 🏗️ System Architecture

### 1. Java MVC Web Application (`healthcare-management-system-java/`)
- **Controller Layer**: Jakarta Servlets (`HomeServlet`, `AuthServlet`, `PatientServlet`, `DoctorServlet`, `AdminServlet`) routing request actions using MVC principles.
- **Security & RBAC**: `AuthenticationFilter` implementing interceptor filtering across role endpoints (`/patient/*`, `/doctor/*`, `/admin/*`).
- **Data Access Object (DAO) Pattern**: Interfaces (`UserDAO`, `DoctorDAO`, `AppointmentDAO`, `MedicalRecordDAO`, `FeedbackDAO`) with concrete JDBC implementations using `PreparedStatement`, transactional rollbacks, and HikariCP connection pooling.
- **Object-Oriented Design**: Encapsulation, inheritance hierarchies (`Doctor extends User`, `Patient extends User`), custom exception architecture (`HealthcareException`, `SlotConflictException`), and collections stream pipelines.
- **Presentation**: Standard Jakarta Server Pages (JSP) using JSTL 3.0 and responsive CSS.
- **Embedded Server**: Built-in Apache Tomcat 10 container for zero-configuration, standalone execution.

### 2. Next.js Web Application (`/`)
- **Full-Stack Framework**: Next.js (App Router) + TypeScript + React.
- **Styling & UI**: Tailwind CSS, Radix UI primitives, Lucide Icons.
- **State & Server Actions**: Server-side data fetching with Supabase SSR clients and cookie-based authentication.
- **Automated Testing**: Vitest test suites with GitHub Actions CI workflows.

---

## 🚀 Getting Started

### Prerequisites
- **For Java Web App**: JDK 21+ and Gradle (or Maven).
- **For Next.js Web App**: Node.js 18+ and npm / pnpm.
- **Database**: PostgreSQL (Supabase instance).

---

### Running the Java MVC Web App

1. Navigate to the Java project folder:
   ```bash
   cd healthcare-management-system-java
   ```

2. Launch using the startup script:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

   Alternatively, use Gradle directly:
   ```bash
   gradle build -x test
   gradle run
   ```

3. Open your browser and navigate to:
   ```
   http://localhost:8080/
   ```

---

### Running the Next.js Web App

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables in `.env.local`:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=your_publishable_key
   SUPABASE_SECRET_KEY=your_secret_key
   ```

3. Run development server:
   ```bash
   npm run dev
   ```

4. Open your browser at:
   ```
   http://localhost:3000/
   ```

5. Run test suite:
   ```bash
   npm test
   ```

---

## 🗄️ Database Setup

Database schema migrations are located in `supabase/migrations/`:
- `001_initial_schema.sql` - Core database configuration & UUID extensions
- `002_profiles.sql` - Profiles schema & auth triggers
- `003_doctors.sql` - Doctor profiles, credentials & licensing
- `004_patients.sql` - Patient medical metadata & emergency contacts
- `005_doctor_availability.sql` - Weekly slot definitions
- `006_appointments.sql` - Appointment records & conflict constraints
- `007_medical_records.sql` - EMR diagnoses & consultation notes
- `008_medical_record_files.sql` - Uploaded diagnostic documents
- `009_feedback.sql` - Patient ratings and review systems
- `010_notifications.sql` - System alerts & notifications
- `011_system_settings.sql` - Configurable clinic settings
- `012_audit_logs.sql` - Immutable audit trail
- `013_indexes.sql` - High-performance query indexes
- `014_rls_policies.sql` - Row-level security governance

---

## 🔒 Security Best Practices
- **Password Security**: Cryptographic salting and hashing via BCrypt.
- **SQL Injection Prevention**: Exclusive usage of parameterized queries (`PreparedStatement`).
- **Session Management**: Secure HTTP-only cookies and invalidation timeouts.
- **Database Security**: Enforced RLS policies restricting read/write access per authenticated user role.

---

## 📄 License
This project is open-source and licensed under the MIT License.
