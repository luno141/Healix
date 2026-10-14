<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Patient Dashboard" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Feedback Notification Banners -->
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

            <!-- Quick Action Bar -->
            <div class="quick-actions-bar">
                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                    Book Appointment
                </a>
                <a href="${pageContext.request.contextPath}/patient/doctors" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    Find Specialists
                </a>
                <a href="${pageContext.request.contextPath}/patient/medical-history" class="btn btn-outline-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                    Medical Records
                </a>
            </div>

            <!-- Stats Overview Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty upcomingCount ? 0 : upcomingCount}" /></div>
                        <div class="stat-label">Upcoming Appointments</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon secondary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty completedCount ? 0 : completedCount}" /></div>
                        <div class="stat-label">Completed Visits</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon accent">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalAppointments ? 0 : totalAppointments}" /></div>
                        <div class="stat-label">Total Appointments</div>
                    </div>
                </div>
            </div>

            <!-- Recent Appointments Card -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Recent Appointments</h2>
                        <div class="card-subtitle">Overview of your most recent consultations and visits</div>
                    </div>
                    <div class="card-header-actions">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline btn-sm">View All</a>
                    </div>
                </div>
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty recentAppointments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Doctor</th>
                                            <th>Specialization</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th style="text-align: right;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentAppointments}" var="appt">
                                            <tr>
                                                <td>
                                                    <strong>Dr. <c:out value="${empty appt.doctorName ? 'Specialist' : appt.doctorName}" /></strong>
                                                </td>
                                                <td>
                                                    <span class="badge badge-primary"><c:out value="${empty appt.specialization ? 'General' : appt.specialization}" /></span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${appt.appointmentDate}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td>
                                                    <c:out value="${appt.startTime}" />
                                                </td>
                                                <td style="max-width: 200px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty appt.reason ? 'Routine consultation' : appt.reason}" />
                                                </td>
                                                <td>
                                                    <span class="badge badge-${appt.status}">
                                                        <c:out value="${appt.status}" />
                                                    </span>
                                                </td>
                                                <td style="text-align: right;">
                                                    <c:if test="${appt.status == 'pending' || appt.status == 'confirmed'}">
                                                        <form method="POST" action="${pageContext.request.contextPath}/patient/appointments/cancel" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment?');">
                                                            <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                            <button type="submit" class="btn btn-danger-outline btn-sm">Cancel</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${appt.status == 'completed'}">
                                                        <span style="font-size: 0.8125rem; color: var(--success); font-weight: 600;">Completed</span>
                                                    </c:if>
                                                    <c:if test="${appt.status == 'cancelled'}">
                                                        <span style="font-size: 0.8125rem; color: var(--text-muted);">Cancelled</span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                </div>
                                <h3 class="empty-state-title">No Appointments Yet</h3>
                                <p class="empty-state-desc">You do not have any appointments scheduled. Book your first appointment with our verified medical specialists.</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary">Book Appointment</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
