<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="System Appointments Audit" scope="request" />
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
                        <h2 class="card-title">All System Appointments</h2>
                        <div class="card-subtitle">Comprehensive operational record of all clinic bookings and consultations</div>
                    </div>
                    <div class="card-header-actions" style="display: flex; gap: 0.5rem;">
                        <select id="statusFilterSelect" class="form-select" style="width: auto; padding: 0.4rem 0.75rem; font-size: 0.8125rem;" onchange="filterAdminAppts()">
                            <option value="">All Statuses</option>
                            <option value="pending">Pending</option>
                            <option value="confirmed">Confirmed</option>
                            <option value="completed">Completed</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                        <input type="text" id="apptSearch" class="form-control" style="max-width: 230px; font-size: 0.8125rem; padding: 0.4rem 0.75rem;" 
                            placeholder="Search patient, doctor..." onkeyup="filterAdminAppts()" />
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty appointments}">
                            <div class="table-responsive">
                                <table class="table table-hover" id="adminApptsTable">
                                    <thead>
                                        <tr>
                                            <th>Patient</th>
                                            <th>Attending Doctor</th>
                                            <th>Specialization</th>
                                            <th>Date</th>
                                            <th>Time Window</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th style="text-align: right;">Administrative Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${appointments}" var="appt">
                                            <tr data-patient="${appt.patientName}" data-doctor="${appt.doctorName}" data-status="${appt.status}">
                                                <td>
                                                    <strong><c:out value="${empty appt.patientName ? 'Patient' : appt.patientName}" /></strong>
                                                </td>
                                                <td>
                                                    <strong>Dr. <c:out value="${empty appt.doctorName ? 'Specialist' : appt.doctorName}" /></strong>
                                                </td>
                                                <td>
                                                    <span class="badge badge-primary"><c:out value="${empty appt.specialization ? 'General' : appt.specialization}" /></span>
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
                                                <td style="text-align: right;">
                                                    <c:choose>
                                                        <c:when test="${appt.status == 'pending' || appt.status == 'confirmed'}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/admin/appointments/cancel" style="display:inline;" onsubmit="return confirm('As administrator, cancel this appointment between ${appt.patientName} and Dr. ${appt.doctorName}?');">
                                                                <input type="hidden" name="appointmentId" value="${appt.id}" />
                                                                <input type="hidden" name="action" value="cancel" />
                                                                <button type="submit" class="btn btn-danger-outline btn-sm">Cancel Booking</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${appt.status == 'completed'}">
                                                            <span class="badge badge-completed">Completed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-cancelled">Cancelled</span>
                                                        </c:otherwise>
                                                    </c:choose>
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
                                <p class="empty-state-desc">There are no consultations scheduled in the database at this time.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterAdminAppts() {
    const query = document.getElementById('apptSearch').value.toLowerCase();
    const status = document.getElementById('statusFilterSelect').value.toLowerCase();
    const rows = document.querySelectorAll('#adminApptsTable tbody tr');

    rows.forEach(row => {
        const patient = (row.getAttribute('data-patient') || '').toLowerCase();
        const doctor = (row.getAttribute('data-doctor') || '').toLowerCase();
        const apptStatus = (row.getAttribute('data-status') || '').toLowerCase();

        const matchesQuery = !query || patient.includes(query) || doctor.includes(query);
        const matchesStatus = !status || apptStatus === status;

        row.style.display = (matchesQuery && matchesStatus) ? '' : 'none';
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
