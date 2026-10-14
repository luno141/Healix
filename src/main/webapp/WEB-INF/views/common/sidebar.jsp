<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- Mobile Sidebar Overlay Backdrop -->
<div class="sidebar-overlay" onclick="window.toggleMobileMenu()"></div>

<aside class="sidebar">
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
            <div class="brand-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                </svg>
            </div>
            <span>Healix</span>
        </a>
        <button type="button" class="sidebar-close-btn" aria-label="Close sidebar" onclick="window.toggleMobileMenu()">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>

    <!-- User Profile Box -->
    <div class="sidebar-user-info">
        <div class="sidebar-user-avatar">
            <c:out value="${empty sessionScope.user.fullName ? 'U' : sessionScope.user.fullName.substring(0, 1).toUpperCase()}" />
        </div>
        <div class="sidebar-user-details">
            <div class="sidebar-user-name" title="${sessionScope.user.fullName}">
                <c:out value="${empty sessionScope.user.fullName ? 'Healix User' : sessionScope.user.fullName}" />
            </div>
            <div class="sidebar-user-role">
                <span class="badge badge-role-${empty sessionScope.role ? 'patient' : sessionScope.role}">
                    <c:out value="${empty sessionScope.role ? 'Patient' : sessionScope.role}" />
                </span>
            </div>
        </div>
    </div>

    <!-- Navigation Menu According to Role -->
    <div class="sidebar-nav">
        <c:set var="currentUri" value="${pageContext.request.requestURI}" />

        <c:choose>
            <%-- ================= PATIENT NAVIGATION ================= --%>
            <c:when test="${sessionScope.role == 'patient' || empty sessionScope.role}">
                <div class="sidebar-section-title">Patient Portal</div>
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/patient/dashboard" class="sidebar-link ${currentUri.contains('/patient/dashboard') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </span>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="sidebar-link ${currentUri.contains('/patient/appointments') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/patient/book" class="sidebar-link ${currentUri.contains('/patient/book') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                            </span>
                            <span>Book Appointment</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/patient/doctors" class="sidebar-link ${currentUri.contains('/patient/doctors') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </span>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/patient/medical-history" class="sidebar-link ${currentUri.contains('/patient/medical-history') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            </span>
                            <span>Medical History</span>
                        </a>
                    </li>
                </ul>
            </c:when>

            <%-- ================= DOCTOR NAVIGATION ================= --%>
            <c:when test="${sessionScope.role == 'doctor'}">
                <div class="sidebar-section-title">Doctor Workspace</div>
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="sidebar-link ${currentUri.contains('/doctor/dashboard') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </span>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/schedule" class="sidebar-link ${currentUri.contains('/doctor/schedule') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </span>
                            <span>Schedule</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/appointments" class="sidebar-link ${currentUri.contains('/doctor/appointments') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Appointments</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/patients" class="sidebar-link ${currentUri.contains('/doctor/patients') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </span>
                            <span>Patients</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/medical-records" class="sidebar-link ${currentUri.contains('/doctor/medical-records') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                            </span>
                            <span>Medical Records</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/doctor/feedback" class="sidebar-link ${currentUri.contains('/doctor/feedback') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            </span>
                            <span>Feedback</span>
                        </a>
                    </li>
                </ul>
            </c:when>

            <%-- ================= ADMIN NAVIGATION ================= --%>
            <c:when test="${sessionScope.role == 'admin'}">
                <div class="sidebar-section-title">Administration</div>
                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${currentUri.contains('/admin/dashboard') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </span>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link ${currentUri.contains('/admin/users') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </span>
                            <span>Users</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/doctors" class="sidebar-link ${currentUri.contains('/admin/doctors') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>
                            </span>
                            <span>Doctors</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="sidebar-link ${currentUri.contains('/admin/appointments') ? 'active' : ''}">
                            <span class="sidebar-link-icon">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <span>Appointments</span>
                        </a>
                    </li>
                </ul>
            </c:when>
        </c:choose>
    </div>

    <!-- Sidebar Footer -->
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-link" onclick="return window.confirmAction ? window.confirmAction('Are you sure you want to log out?', this) : true;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
            <span>Log Out</span>
        </a>
    </div>
</aside>
