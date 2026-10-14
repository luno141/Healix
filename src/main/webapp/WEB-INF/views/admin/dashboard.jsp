<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="System Administration Dashboard" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Notification Banners -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <div class="alert-content">
                        <strong>Success!</strong> <c:out value="${param.success}" />
                    </div>
                    <button type="button" class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-error">
                    <div class="alert-content">
                        <strong>Error:</strong> <c:out value="${param.error}" />
                    </div>
                    <button type="button" class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                </div>
            </c:if>

            <!-- Quick Management Navigation Links -->
            <div class="quick-actions-bar">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    Manage Users
                </a>
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>
                    Manage Doctors
                </a>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    All Appointments
                </a>
            </div>

            <!-- Stats Cards Grid -->
            <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));">
                <!-- Total Users -->
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalUsers ? 0 : totalUsers}" /></div>
                        <div class="stat-label">Total Platform Users</div>
                    </div>
                </div>

                <!-- Total Doctors -->
                <div class="stat-card">
                    <div class="stat-icon secondary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalDoctors ? 0 : totalDoctors}" /></div>
                        <div class="stat-label">Active Doctors</div>
                    </div>
                </div>

                <!-- Total Patients -->
                <div class="stat-card">
                    <div class="stat-icon accent">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><path d="M12 6v6l4 2"></path></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalPatients ? 0 : totalPatients}" /></div>
                        <div class="stat-label">Registered Patients</div>
                    </div>
                </div>

                <!-- Total Appointments -->
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalAppointments ? 0 : totalAppointments}" /></div>
                        <div class="stat-label">Total Appointments</div>
                    </div>
                </div>

                <!-- Pending Appointments -->
                <div class="stat-card">
                    <div class="stat-icon danger">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty pendingAppointments ? 0 : pendingAppointments}" /></div>
                        <div class="stat-label">Pending Approval</div>
                    </div>
                </div>
            </div>

            <!-- Management Sections Hub -->
            <div class="card-grid" style="grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));">
                <!-- User Administration Card -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">User Role Management</h3>
                    </div>
                    <div class="card-body">
                        <p style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                            View all platform accounts, oversee registered patients, and elevate permissions between Admin, Doctor, and Patient roles.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline btn-block">
                            Browse User Accounts &rarr;
                        </a>
                    </div>
                </div>

                <!-- Doctor Management Card -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Clinical Faculty & Doctors</h3>
                    </div>
                    <div class="card-body">
                        <p style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                            Review doctor credentialing, medical licenses, active specializations, practice bios, and consultation pricing schedules.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-outline btn-block">
                            View Doctor Directory &rarr;
                        </a>
                    </div>
                </div>

                <!-- System Appointments Card -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Global Appointment Operations</h3>
                    </div>
                    <div class="card-body">
                        <p style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                            Supervise enterprise clinic operations, resolve schedule conflicts, inspect consultation pipelines, and cancel overdue bookings.
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-outline btn-block">
                            Inspect System Bookings &rarr;
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
