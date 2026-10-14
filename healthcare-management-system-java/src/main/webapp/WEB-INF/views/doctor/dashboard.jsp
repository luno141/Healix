<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Doctor Dashboard" scope="request" />
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

            <!-- Quick Actions Toolbar -->
            <div class="quick-actions-bar">
                <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    Manage Practice Schedule
                </a>
                <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    All Appointments
                </a>
                <a href="${pageContext.request.contextPath}/doctor/medical-records" class="btn btn-outline-secondary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.5rem;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                    Add Medical Record
                </a>
            </div>

            <!-- Doctor Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon primary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty todayCount ? 0 : todayCount}" /></div>
                        <div class="stat-label">Today's Appointments</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon secondary">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty totalPatients ? 0 : totalPatients}" /></div>
                        <div class="stat-label">Total Patients</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon accent">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><c:out value="${empty pendingCount ? 0 : pendingCount}" /></div>
                        <div class="stat-label">Pending Approval</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon primary" style="background-color: #FEF3C7; color: #D97706;">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="#F59E0B" stroke="#F59E0B" stroke-width="1.5"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <fmt:formatNumber value="${empty avgRating ? 0 : avgRating}" minFractionDigits="1" maxFractionDigits="1" />
                            <small style="font-size: 1rem; color: var(--text-muted); font-weight: 500;">/ 5.0</small>
                        </div>
                        <div class="stat-label">Average Patient Rating</div>
                    </div>
                </div>
            </div>

            <!-- Today's Consultations Table -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Today's Appointment Schedule</h2>
                        <div class="card-subtitle">Scheduled patient sessions for today</div>
                    </div>
                    <div class="card-header-actions">
                        <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline btn-sm">Full Roster</a>
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty todayAppointments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Patient</th>
                                            <th>Time Window</th>
                                            <th>Reason for Visit</th>
                                            <th>Status</th>
                                            <th style="text-align: right;">Clinical Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${todayAppointments}" var="appt">
                                            <tr>
                                                <td>
                                                    <strong><c:out value="${empty appt.patientName ? 'Patient' : appt.patientName}" /></strong>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 700; color: var(--primary);">
                                                        <c:out value="${appt.startTime}" />
                                                        <c:if test="${not empty appt.endTime}">
                                                            - <c:out value="${appt.endTime}" />
                                                        </c:if>
                                                    </span>
                                                </td>
                                                <td style="max-width: 200px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty appt.reason ? 'General Consultation' : appt.reason}" />
                                                </td>
                                                <td>
                                                    <span class="badge badge-${appt.status}">
                                                        <c:out value="${appt.status}" />
                                                    </span>
                                                </td>
                                                <td style="text-align: right;">
                                                    <div class="table-actions" style="justify-content: flex-end;">
                                                        <c:if test="${appt.status == 'pending'}">
                                                            <!-- Confirm Action -->
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/confirm" style="display:inline;">
                                                                <input type="hidden" name="action" value="confirm" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                                                            </form>
                                                            <!-- Cancel Action -->
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/cancel" style="display:inline;" onsubmit="return confirm('Cancel this appointment?');">
                                                                <input type="hidden" name="action" value="cancel" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-danger-outline btn-sm">Cancel</button>
                                                            </form>
                                                        </c:if>

                                                        <c:if test="${appt.status == 'confirmed'}">
                                                            <!-- Complete Action -->
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/complete" style="display:inline;">
                                                                <input type="hidden" name="action" value="complete" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-primary btn-sm">Complete</button>
                                                            </form>
                                                            <!-- Cancel Action -->
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/cancel" style="display:inline;" onsubmit="return confirm('Cancel this confirmed appointment?');">
                                                                <input type="hidden" name="action" value="cancel" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-danger-outline btn-sm">Cancel</button>
                                                            </form>
                                                        </c:if>

                                                        <c:if test="${appt.status == 'completed'}">
                                                            <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${appt.patientId}" class="btn btn-outline btn-sm">
                                                                Add Record
                                                            </a>
                                                        </c:if>

                                                        <c:if test="${appt.status == 'cancelled'}">
                                                            <span style="font-size: 0.8125rem; color: var(--text-muted);">Cancelled</span>
                                                        </c:if>
                                                    </div>
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                                <h3 class="empty-state-title">No Consultations Scheduled For Today</h3>
                                <p class="empty-state-desc">You do not have any patient appointments booked for today. You can check your upcoming schedule or adjust your availability hours.</p>
                                <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">Update Schedule</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
