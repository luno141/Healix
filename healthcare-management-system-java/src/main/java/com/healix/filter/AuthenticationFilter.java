package com.healix.filter;

import com.healix.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication and Role-Based Access Control Filter for Healix Healthcare Management System.
 * Intercepts incoming requests to secure endpoints based on user roles and authentication state.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String requestURI = httpRequest.getRequestURI();

        // Extract relative request path without context path
        String path = requestURI.substring(contextPath.length());
        if (path == null || path.isEmpty()) {
            path = "/";
        }

        // 1. Allow public paths without authentication
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Identify protected path targets
        boolean isPatientPath = path.equals("/patient") || path.startsWith("/patient/");
        boolean isDoctorPath = path.equals("/doctor") || path.startsWith("/doctor/");
        boolean isAdminPath = path.equals("/admin") || path.startsWith("/admin/");

        if (!isPatientPath && !isDoctorPath && !isAdminPath) {
            // General or unprotected application path
            chain.doFilter(request, response);
            return;
        }

        // 3. Inspect session and user authentication state
        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (role == null && user != null && user.getRole() != null) {
            role = user.getRole();
        }

        // If not authenticated and accessing protected path -> redirect to /auth?action=login
        if (session == null || user == null || role == null) {
            httpResponse.sendRedirect(contextPath + "/auth?action=login");
            return;
        }

        String userRole = role.toLowerCase().trim();

        // 4. Validate role-based permissions
        if (isPatientPath && !userRole.equals("patient")) {
            redirectUnauthorized(httpRequest, httpResponse, userRole);
            return;
        }

        if (isDoctorPath && !userRole.equals("doctor")) {
            redirectUnauthorized(httpRequest, httpResponse, userRole);
            return;
        }

        if (isAdminPath && !userRole.equals("admin")) {
            redirectUnauthorized(httpRequest, httpResponse, userRole);
            return;
        }

        // Everything OK - proceed down the filter chain
        chain.doFilter(request, response);
    }

    /**
     * Checks if the given path is publicly accessible without authentication.
     */
    private boolean isPublicPath(String path) {
        if (path.equals("/") || path.equals("/index.jsp") || path.equals("/favicon.ico")) {
            return true;
        }
        if (path.equals("/auth") || path.startsWith("/auth/")) {
            return true;
        }
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            return true;
        }
        return false;
    }

    /**
     * Redirects an authenticated user to their correct dashboard with an error message when accessing unauthorized paths.
     */
    private void redirectUnauthorized(HttpServletRequest request, HttpServletResponse response, String role)
            throws IOException {
        HttpSession session = request.getSession();
        String errorMessage = "Access denied: You do not have permission to access that resource.";
        session.setAttribute("error", errorMessage);
        session.setAttribute("errorMessage", errorMessage);

        String redirectUrl;
        switch (role) {
            case "patient":
                redirectUrl = request.getContextPath() + "/patient/dashboard?error=unauthorized";
                break;
            case "doctor":
                redirectUrl = request.getContextPath() + "/doctor/dashboard?error=unauthorized";
                break;
            case "admin":
                redirectUrl = request.getContextPath() + "/admin/dashboard?error=unauthorized";
                break;
            default:
                redirectUrl = request.getContextPath() + "/?error=unauthorized";
                break;
        }
        response.sendRedirect(redirectUrl);
    }

    @Override
    public void destroy() {
        // Filter cleanup
    }
}
