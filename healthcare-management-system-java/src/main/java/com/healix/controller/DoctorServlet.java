package com.healix.controller;

import com.healix.dao.AppointmentDAO;
import com.healix.dao.DoctorDAO;
import com.healix.dao.FeedbackDAO;
import com.healix.dao.MedicalRecordDAO;
import com.healix.dao.impl.AppointmentDAOImpl;
import com.healix.dao.impl.DoctorDAOImpl;
import com.healix.dao.impl.FeedbackDAOImpl;
import com.healix.dao.impl.MedicalRecordDAOImpl;
import com.healix.exception.HealthcareException;
import com.healix.model.*;
import com.healix.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Core Java Servlet: DoctorServlet - Doctor dashboard controller
 * Demonstrates inheritance (extends HttpServlet), polymorphism (DAO interfaces),
 * Collections (ArrayList, Stream), and JDBC transactions
 */
@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor/*"})
public class DoctorServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private FeedbackDAO feedbackDAO;
    private MedicalRecordDAO medicalRecordDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        feedbackDAO = new FeedbackDAOImpl();
        medicalRecordDAO = new MedicalRecordDAOImpl();
    }

    /**
     * Looks up the doctors table record from the profile ID.
     */
    private Doctor getDoctorFromSession(String profileId) throws HealthcareException {
        return doctorDAO.getDoctorByProfileId(profileId);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        String userId = (String) request.getSession().getAttribute("userId");

        try {
            Doctor doctor = getDoctorFromSession(userId);
            if (doctor == null) {
                request.setAttribute("error", "Doctor profile not found.");
                request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
                return;
            }

            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response, doctor);
                    break;
                case "/schedule":
                    showSchedule(request, response, doctor);
                    break;
                case "/appointments":
                    showAppointments(request, response, doctor);
                    break;
                case "/patients":
                    showPatients(request, response, doctor);
                    break;
                case "/medical-records":
                    showMedicalRecords(request, response, doctor);
                    break;
                case "/feedback":
                    showFeedback(request, response, doctor);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                    break;
            }
        } catch (HealthcareException e) {
            System.err.println("[Healix] DoctorServlet error: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "";

        String userId = (String) request.getSession().getAttribute("userId");

        try {
            Doctor doctor = getDoctorFromSession(userId);
            if (doctor == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=login");
                return;
            }

            switch (pathInfo) {
                case "/schedule":
                    handleAddAvailability(request, response, doctor);
                    break;
                case "/schedule/delete":
                    handleDeleteAvailability(request, response);
                    break;
                case "/appointments/confirm":
                    handleUpdateStatus(request, response, "confirmed", "Confirmed by doctor");
                    break;
                case "/appointments/complete":
                    handleUpdateStatus(request, response, "completed", "Completed");
                    break;
                case "/appointments/cancel":
                    handleUpdateStatus(request, response, "cancelled", "Cancelled by doctor");
                    break;
                case "/medical-records":
                    handleCreateMedicalRecord(request, response, doctor);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                    break;
            }
        } catch (HealthcareException e) {
            System.err.println("[Healix] DoctorServlet POST error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard?error=" + e.getMessage());
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctor.getDoctorId());

        // Today's appointments using Java Collections stream filtering
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        List<Appointment> todayAppts = new ArrayList<>();
        long pendingCount = 0;
        for (Appointment a : appointments) {
            if (a.getAppointmentDate() != null && a.getAppointmentDate().toString().equals(today.toString())) {
                todayAppts.add(a);
            }
            if ("pending".equals(a.getStatus())) pendingCount++;
        }

        // Count unique patients
        long totalPatients = appointments.stream()
            .map(Appointment::getPatientId)
            .distinct()
            .count();

        double avgRating = feedbackDAO.getAverageRatingForDoctor(doctor.getDoctorId());

        request.setAttribute("todayAppointments", todayAppts);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("todayCount", todayAppts.size());
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("pageTitle", "Doctor Dashboard");
        request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp").forward(request, response);
    }

    private void showSchedule(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        List<DoctorAvailability> availability = doctorDAO.getDoctorAvailability(doctor.getDoctorId());
        request.setAttribute("availability", availability);
        request.setAttribute("pageTitle", "Manage Schedule");
        request.getRequestDispatcher("/WEB-INF/views/doctor/schedule.jsp").forward(request, response);
    }

    private void showAppointments(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctor.getDoctorId());
        request.setAttribute("appointments", appointments);
        request.setAttribute("pageTitle", "Appointments");
        request.getRequestDispatcher("/WEB-INF/views/doctor/appointments.jsp").forward(request, response);
    }

    private void showPatients(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        // Get unique patients from appointments using JDBC
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT DISTINCT p.id AS patient_id, pr.full_name, pr.email, pr.phone, pr.gender, " +
                     "pat.blood_group, pat.emergency_contact, pat.emergency_phone " +
                     "FROM public.appointments a " +
                     "JOIN public.patients pat ON a.patient_id = pat.id " +
                     "JOIN public.profiles pr ON pat.profile_id = pr.id " +
                     "WHERE a.doctor_id = ?::uuid ORDER BY pr.full_name";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient pat = new Patient();
                    pat.setPatientId(rs.getString("patient_id"));
                    pat.setFullName(rs.getString("full_name"));
                    pat.setEmail(rs.getString("email"));
                    pat.setPhone(rs.getString("phone"));
                    pat.setGender(rs.getString("gender"));
                    pat.setBloodGroup(rs.getString("blood_group"));
                    pat.setEmergencyContact(rs.getString("emergency_contact"));
                    pat.setEmergencyPhone(rs.getString("emergency_phone"));
                    patients.add(pat);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching patients: " + e.getMessage(), e);
        }
        request.setAttribute("patients", patients);
        request.setAttribute("pageTitle", "My Patients");
        request.getRequestDispatcher("/WEB-INF/views/doctor/patients.jsp").forward(request, response);
    }

    private void showMedicalRecords(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        String profileId = (String) request.getSession().getAttribute("userId");
        List<MedicalRecord> records = medicalRecordDAO.getRecordsByDoctor(profileId);

        // Fetch patients for the create form
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT DISTINCT pat.id AS patient_id, pr.full_name " +
                     "FROM public.appointments a " +
                     "JOIN public.patients pat ON a.patient_id = pat.id " +
                     "JOIN public.profiles pr ON pat.profile_id = pr.id " +
                     "WHERE a.doctor_id = ?::uuid ORDER BY pr.full_name";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient pat = new Patient();
                    pat.setPatientId(rs.getString("patient_id"));
                    pat.setFullName(rs.getString("full_name"));
                    patients.add(pat);
                }
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error fetching patients for records: " + e.getMessage(), e);
        }

        request.setAttribute("records", records);
        request.setAttribute("patients", patients);
        request.setAttribute("pageTitle", "Medical Records");
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical-records.jsp").forward(request, response);
    }

    private void showFeedback(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws ServletException, IOException, HealthcareException {
        List<Feedback> feedbackList = feedbackDAO.getFeedbackByDoctor(doctor.getDoctorId());
        double avgRating = feedbackDAO.getAverageRatingForDoctor(doctor.getDoctorId());
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("pageTitle", "Feedback & Reviews");
        request.getRequestDispatcher("/WEB-INF/views/doctor/feedback.jsp").forward(request, response);
    }

    private void handleAddAvailability(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws IOException, HealthcareException {
        DoctorAvailability avail = new DoctorAvailability();
        avail.setDoctorId(doctor.getDoctorId());
        avail.setDayOfWeek(Integer.parseInt(request.getParameter("dayOfWeek")));
        avail.setStartTime(java.sql.Time.valueOf(request.getParameter("startTime") + ":00"));
        avail.setEndTime(java.sql.Time.valueOf(request.getParameter("endTime") + ":00"));
        avail.setSlotDuration(Integer.parseInt(request.getParameter("slotDuration")));
        avail.setAvailable(true);

        doctorDAO.addOrUpdateAvailability(avail);
        System.out.println("[Healix] Availability added for doctor: " + doctor.getDoctorId());
        response.sendRedirect(request.getContextPath() + "/doctor/schedule?success=Availability+saved!");
    }

    private void handleDeleteAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException, HealthcareException {
        String availabilityId = request.getParameter("availabilityId");
        if (availabilityId != null) {
            doctorDAO.deleteAvailability(availabilityId);
        }
        response.sendRedirect(request.getContextPath() + "/doctor/schedule?success=Slot+deleted.");
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response,
                                     String newStatus, String notes)
            throws IOException, HealthcareException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId != null) {
            appointmentDAO.updateStatus(appointmentId, newStatus, notes);
            System.out.println("[Healix] Appointment " + appointmentId + " -> " + newStatus);
        }
        response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=Appointment+" + newStatus + ".");
    }

    private void handleCreateMedicalRecord(HttpServletRequest request, HttpServletResponse response, Doctor doctor)
            throws IOException, HealthcareException {
        String profileId = (String) request.getSession().getAttribute("userId");

        MedicalRecord record = new MedicalRecord();
        record.setPatientId(request.getParameter("patientId"));
        record.setCreatedBy(profileId);
        record.setRecordType(request.getParameter("recordType"));
        record.setTitle(request.getParameter("title"));
        record.setDescription(request.getParameter("description"));
        record.setDiagnosis(request.getParameter("diagnosis"));
        record.setTreatment(request.getParameter("treatment"));

        medicalRecordDAO.createRecord(record);
        System.out.println("[Healix] Medical record created by doctor: " + doctor.getDoctorId());
        response.sendRedirect(request.getContextPath() + "/doctor/medical-records?success=Record+created.");
    }
}
