<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Appointments" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Alert Messages -->
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
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <div class="alert-content">
                        <strong>Error:</strong> <c:out value="${error}" />
                    </div>
                    <button type="button" class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                </div>
            </c:if>

            <!-- Page Header Card -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">All Appointments</h2>
                        <div class="card-subtitle">Manage and track your healthcare consultations</div>
                    </div>
                    <div class="card-header-actions">
                        <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary btn-sm">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right:0.35rem;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                            Book Appointment
                        </a>
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty appointments}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Doctor</th>
                                            <th>Specialization</th>
                                            <th>Date</th>
                                            <th>Time Slot</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th>Notes</th>
                                            <th style="text-align: right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${appointments}" var="appt">
                                            <tr>
                                                <td>
                                                    <strong>Dr. <c:out value="${empty appt.doctorName ? 'Healthcare Specialist' : appt.doctorName}" /></strong>
                                                </td>
                                                <td>
                                                    <span class="badge badge-primary"><c:out value="${empty appt.specialization ? 'General Medicine' : appt.specialization}" /></span>
                                                </td>
                                                <td>
                                                    <strong><fmt:formatDate value="${appt.appointmentDate}" pattern="MMM dd, yyyy" /></strong>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--text-main);">
                                                        <c:out value="${appt.startTime}" />
                                                        <c:if test="${not empty appt.endTime}">
                                                            - <c:out value="${appt.endTime}" />
                                                        </c:if>
                                                    </span>
                                                </td>
                                                <td style="max-width: 180px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty appt.reason ? 'General Consultation' : appt.reason}" />
                                                </td>
                                                <td>
                                                    <span class="badge badge-${appt.status}">
                                                        <c:out value="${appt.status}" />
                                                    </span>
                                                </td>
                                                <td style="max-width: 180px; font-size: 0.8125rem; color: var(--text-muted); text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty appt.notes ? '—' : appt.notes}" />
                                                </td>
                                                <td style="text-align: right;">
                                                    <c:if test="${appt.status == 'pending' || appt.status == 'confirmed'}">
                                                        <form method="POST" action="${pageContext.request.contextPath}/patient/appointments/cancel" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment with Dr. ${empty appt.doctorName ? '' : appt.doctorName}?');">
                                                            <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                            <button type="submit" class="btn btn-danger-outline btn-sm">Cancel</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${appt.status == 'completed'}">
                                                        <span class="badge badge-completed">Completed</span>
                                                    </c:if>
                                                    <c:if test="${appt.status == 'cancelled'}">
                                                        <span class="badge badge-cancelled">Cancelled</span>
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
                                <h3 class="empty-state-title">No Appointments Found</h3>
                                <p class="empty-state-desc">You haven't scheduled any appointments yet. Select an available doctor to book a visit.</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary">Book an Appointment</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
