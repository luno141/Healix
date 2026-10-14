<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Doctor Appointment Management" scope="request" />
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

            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Patient Appointments</h2>
                        <div class="card-subtitle">Review, confirm, complete, or cancel consultations</div>
                    </div>
                    <div class="card-header-actions">
                        <input type="text" id="appointmentSearch" class="form-control" style="max-width: 240px; padding: 0.4rem 0.75rem; font-size: 0.8125rem;" 
                            placeholder="Filter by patient name..." onkeyup="filterAppointmentTable()" />
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty appointments}">
                            <div class="table-responsive">
                                <table class="table table-hover" id="appointmentsTable">
                                    <thead>
                                        <tr>
                                            <th>Patient</th>
                                            <th>Appointment Date</th>
                                            <th>Time Slot</th>
                                            <th>Reason for Visit</th>
                                            <th>Status</th>
                                            <th>Clinical Notes</th>
                                            <th style="text-align: right; min-width: 220px;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${appointments}" var="appt">
                                            <tr data-patient-name="${appt.patientName}">
                                                <td>
                                                    <strong><c:out value="${empty appt.patientName ? 'Patient' : appt.patientName}" /></strong>
                                                </td>
                                                <td>
                                                    <strong><fmt:formatDate value="${appt.appointmentDate}" pattern="MMM dd, yyyy" /></strong>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--primary);">
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
                                                <td style="max-width: 180px; font-size: 0.8125rem; color: var(--text-muted); text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty appt.notes ? '—' : appt.notes}" />
                                                </td>
                                                <td style="text-align: right;">
                                                    <div class="table-actions" style="justify-content: flex-end;">
                                                        <!-- Confirm Action (Only for pending) -->
                                                        <c:if test="${appt.status == 'pending'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/confirm" style="display:inline;">
                                                                <input type="hidden" name="action" value="confirm" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Complete Action (Only for confirmed) -->
                                                        <c:if test="${appt.status == 'confirmed'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/complete" style="display:inline;">
                                                                <input type="hidden" name="action" value="complete" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-primary btn-sm">Complete</button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Cancel Action (for pending or confirmed) -->
                                                        <c:if test="${appt.status == 'pending' || appt.status == 'confirmed'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/appointments/cancel" style="display:inline;" onsubmit="return confirm('Cancel appointment for ${empty appt.patientName ? 'this patient' : appt.patientName}?');">
                                                                <input type="hidden" name="action" value="cancel" />
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <button type="submit" class="btn btn-danger-outline btn-sm">Cancel</button>
                                                            </form>
                                                        </c:if>

                                                        <!-- Completed State Quick Action -->
                                                        <c:if test="${appt.status == 'completed'}">
                                                            <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${appt.patientId}" class="btn btn-outline btn-sm">
                                                                Record EHR
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                </div>
                                <h3 class="empty-state-title">No Appointments on Record</h3>
                                <p class="empty-state-desc">You do not have any patient bookings assigned yet. Ensure your schedule is set to active so patients can book.</p>
                                <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-primary">Manage Schedule</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterAppointmentTable() {
    const query = document.getElementById('appointmentSearch').value.toLowerCase();
    const rows = document.querySelectorAll('#appointmentsTable tbody tr');
    rows.forEach(row => {
        const name = (row.getAttribute('data-patient-name') || '').toLowerCase();
        const text = row.textContent.toLowerCase();
        if (name.includes(query) || text.includes(query)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
