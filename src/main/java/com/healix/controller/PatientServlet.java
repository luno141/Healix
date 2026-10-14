package com.healix.controller;

import com.healix.dao.AppointmentDAO;
import com.healix.dao.DoctorDAO;
import com.healix.dao.MedicalRecordDAO;
import com.healix.dao.impl.AppointmentDAOImpl;
import com.healix.dao.impl.DoctorDAOImpl;
import com.healix.dao.impl.MedicalRecordDAOImpl;
import com.healix.exception.HealthcareException;
import com.healix.exception.SlotConflictException;
import com.healix.model.Appointment;
import com.healix.model.Doctor;
import com.healix.model.MedicalRecord;
import com.healix.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.List;

/**
 * Core Java Servlet: PatientServlet - Patient dashboard controller
 * Demonstrates pathInfo routing, JDBC queries, Collections, JSON output
 */
@WebServlet(name = "PatientServlet", urlPatterns = {"/patient/*"})
public class PatientServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private MedicalRecordDAO medicalRecordDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        medicalRecordDAO = new MedicalRecordDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        String userId = (String) request.getSession().getAttribute("userId");

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response, userId);
                    break;
                case "/doctors":
                    showDoctors(request, response);
                    break;
                case "/book":
                    showBookingForm(request, response);
                    break;
                case "/appointments":
                    showAppointments(request, response, userId);
                    break;
                case "/medical-history":
                    showMedicalHistory(request, response, userId);
                    break;
                case "/available-slots":
                    getAvailableSlots(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    break;
            }
        } catch (HealthcareException e) {
            System.err.println("[Healix] PatientServlet error: " + e.getMessage());
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
            switch (pathInfo) {
                case "/book":
                    handleBookAppointment(request, response, userId);
                    break;
                case "/appointments/cancel":
                    handleCancelAppointment(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    break;
            }
        } catch (Exception e) {
            System.err.println("[Healix] PatientServlet POST error: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }

    /**
     * Looks up the patients table ID from the profile ID stored in session.
     */
    private String getPatientTableId(String profileId) throws HealthcareException {
        String sql = "SELECT id FROM public.patients WHERE profile_id = ?::uuid";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("id");
            }
        } catch (SQLException e) {
            throw new HealthcareException("Error looking up patient: " + e.getMessage(), e);
        }
        return null;
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, HealthcareException {
        String patientId = getPatientTableId(userId);
        if (patientId != null) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patientId);
            request.setAttribute("recentAppointments", appointments);

            long upcoming = appointments.stream()
                .filter(a -> "pending".equals(a.getStatus()) || "confirmed".equals(a.getStatus()))
                .count();
            long completed = appointments.stream()
                .filter(a -> "completed".equals(a.getStatus()))
                .count();
            request.setAttribute("upcomingCount", upcoming);
            request.setAttribute("completedCount", completed);
            request.setAttribute("totalAppointments", appointments.size());
        } else {
            request.setAttribute("upcomingCount", 0L);
            request.setAttribute("completedCount", 0L);
            request.setAttribute("totalAppointments", 0);
        }
        request.setAttribute("pageTitle", "Patient Dashboard");
        request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp").forward(request, response);
    }

    private void showDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        List<Doctor> doctors = doctorDAO.getAllActiveDoctors();
        request.setAttribute("doctors", doctors);
        request.setAttribute("pageTitle", "Our Doctors");
        request.getRequestDispatcher("/WEB-INF/views/patient/doctors.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        List<Doctor> doctors = doctorDAO.getAllActiveDoctors();
        request.setAttribute("doctors", doctors);
        request.setAttribute("pageTitle", "Book Appointment");
        request.getRequestDispatcher("/WEB-INF/views/patient/book.jsp").forward(request, response);
    }

    private void showAppointments(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, HealthcareException {
        String patientId = getPatientTableId(userId);
        if (patientId != null) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patientId);
            request.setAttribute("appointments", appointments);
        }
        request.setAttribute("pageTitle", "My Appointments");
        request.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(request, response);
    }

    private void showMedicalHistory(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, HealthcareException {
        String patientId = getPatientTableId(userId);
        if (patientId != null) {
            List<MedicalRecord> records = medicalRecordDAO.getRecordsByPatient(patientId);
            request.setAttribute("records", records);
        }
        request.setAttribute("pageTitle", "Medical History");
        request.getRequestDispatcher("/WEB-INF/views/patient/medical-history.jsp").forward(request, response);
    }

    /**
     * AJAX endpoint: returns JSON array of available time slots
     */
    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response)
            throws IOException, HealthcareException {
        String doctorId = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (doctorId == null || dateStr == null) {
            out.print("[]");
            return;
        }

        try {
            java.sql.Date date = java.sql.Date.valueOf(dateStr);
            List<String> slots = appointmentDAO.getAvailableSlots(doctorId, date);
            // Build JSON array manually (Core Java string manipulation)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < slots.size(); i++) {
                if (i > 0) json.append(",");
                json.append("\"").append(slots.get(i)).append("\"");
            }
            json.append("]");
            out.print(json.toString());
        } catch (IllegalArgumentException e) {
            out.print("[]");
        }
    }

    private void handleBookAppointment(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException, HealthcareException {
        String doctorId = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");
        String startTimeStr = request.getParameter("startTime");
        String reason = request.getParameter("reason");

        if (doctorId == null || dateStr == null || startTimeStr == null) {
            request.setAttribute("error", "Please fill in all required fields.");
            showBookingForm(request, response);
            return;
        }

        try {
            String patientId = getPatientTableId(userId);
            if (patientId == null) {
                request.setAttribute("error", "Patient profile not found. Please contact support.");
                showBookingForm(request, response);
                return;
            }

            Appointment appt = new Appointment();
            appt.setPatientId(patientId);
            appt.setDoctorId(doctorId);
            appt.setAppointmentDate(java.sql.Date.valueOf(dateStr));
            appt.setStartTime(java.sql.Time.valueOf(startTimeStr + ":00"));

            // Calculate end time (add 30 minutes by default)
            java.sql.Time start = appt.getStartTime();
            long endMs = start.getTime() + (30 * 60 * 1000);
            appt.setEndTime(new java.sql.Time(endMs));

            appt.setReason(reason != null ? reason.trim() : "General consultation");

            Appointment created = appointmentDAO.createAppointment(appt);
            System.out.println("[Healix] Appointment created: " + created.getId());
            response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment+booked+successfully!");

        } catch (SlotConflictException e) {
            request.setAttribute("error", "This time slot is no longer available. Please choose another.");
            showBookingForm(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date or time format.");
            showBookingForm(request, response);
        }
    }

    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, HealthcareException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId != null) {
            appointmentDAO.updateStatus(appointmentId, "cancelled", "Cancelled by patient");
            System.out.println("[Healix] Appointment cancelled: " + appointmentId);
        }
        response.sendRedirect(request.getContextPath() + "/patient/appointments?success=Appointment+cancelled.");
    }
}
