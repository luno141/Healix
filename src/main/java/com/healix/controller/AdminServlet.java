package com.healix.controller;

import com.healix.dao.AppointmentDAO;
import com.healix.dao.DoctorDAO;
import com.healix.dao.UserDAO;
import com.healix.dao.impl.AppointmentDAOImpl;
import com.healix.dao.impl.DoctorDAOImpl;
import com.healix.dao.impl.UserDAOImpl;
import com.healix.exception.HealthcareException;
import com.healix.model.Appointment;
import com.healix.model.Doctor;
import com.healix.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Core Java Servlet: AdminServlet - Admin dashboard controller
 * Demonstrates centralized management, polymorphic DAO usage, and Collections
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin/*"})
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private DoctorDAO doctorDAO;
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        appointmentDAO = new AppointmentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/dashboard";

        try {
            switch (pathInfo) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/users":
                    showUsers(request, response);
                    break;
                case "/doctors":
                    showDoctors(request, response);
                    break;
                case "/appointments":
                    showAppointments(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (HealthcareException e) {
            System.err.println("[Healix] AdminServlet error: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "";

        try {
            switch (pathInfo) {
                case "/appointments/cancel":
                    handleCancelAppointment(request, response);
                    break;
                case "/users/update-role":
                    handleUpdateRole(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (HealthcareException e) {
            System.err.println("[Healix] AdminServlet POST error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=" + e.getMessage());
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        int totalUsers = userDAO.getTotalUserCount();
        int totalDoctors = doctorDAO.getTotalDoctorCount();
        int totalAppointments = appointmentDAO.getTotalAppointmentCount();
        int pendingAppointments = appointmentDAO.getPendingAppointmentCount();

        // Calculate total patients = totalUsers - totalDoctors - admins (approximate)
        int totalPatients = Math.max(0, totalUsers - totalDoctors - 1);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("pageTitle", "Admin Dashboard");
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("pageTitle", "Manage Users");
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void showDoctors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        List<Doctor> doctors = doctorDAO.getAllActiveDoctors();
        request.setAttribute("doctors", doctors);
        request.setAttribute("pageTitle", "Manage Doctors");
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
    }

    private void showAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, HealthcareException {
        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        request.setAttribute("appointments", appointments);
        request.setAttribute("pageTitle", "All Appointments");
        request.getRequestDispatcher("/WEB-INF/views/admin/appointments.jsp").forward(request, response);
    }

    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, HealthcareException {
        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId != null) {
            appointmentDAO.updateStatus(appointmentId, "cancelled", "Cancelled by admin");
            System.out.println("[Healix] Admin cancelled appointment: " + appointmentId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/appointments?success=Appointment+cancelled.");
    }

    private void handleUpdateRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException, HealthcareException {
        String userId = request.getParameter("userId");
        String newRole = request.getParameter("role");
        if (userId != null && newRole != null) {
            userDAO.updateUserRole(userId, newRole);
            System.out.println("[Healix] Admin updated user " + userId + " role to " + newRole);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?success=Role+updated.");
    }
}
