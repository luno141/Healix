<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Patients" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Patient Roster</h2>
                        <div class="card-subtitle">Patients who have consulted or booked appointments with you</div>
                    </div>
                    <div class="card-header-actions">
                        <input type="text" id="patientFilter" class="form-control" style="max-width: 250px; font-size: 0.8125rem; padding: 0.4rem 0.75rem;" 
                            placeholder="Search patient, blood group..." onkeyup="filterPatients()" />
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty patients}">
                            <div class="table-responsive">
                                <table class="table table-hover" id="patientsTable">
                                    <thead>
                                        <tr>
                                            <th>Patient Name</th>
                                            <th>Contact Email</th>
                                            <th>Phone Number</th>
                                            <th>Blood Group</th>
                                            <th>Emergency Contact</th>
                                            <th>Emergency Phone</th>
                                            <th style="text-align: right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${patients}" var="pat">
                                            <tr data-name="${pat.fullName}" data-blood="${pat.bloodGroup}">
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <div class="sidebar-user-avatar" style="width: 34px; height: 34px; font-size: 0.8125rem;">
                                                            <c:out value="${empty pat.fullName ? 'P' : pat.fullName.substring(0, 1).toUpperCase()}" />
                                                        </div>
                                                        <strong><c:out value="${pat.fullName}" /></strong>
                                                    </div>
                                                </td>
                                                <td>
                                                    <a href="mailto:${pat.email}" style="color: var(--primary); text-decoration: none;">
                                                        <c:out value="${pat.email}" />
                                                    </a>
                                                </td>
                                                <td>
                                                    <c:out value="${empty pat.phone ? '—' : pat.phone}" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty pat.bloodGroup}">
                                                            <span class="badge badge-primary"><c:out value="${pat.bloodGroup}" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-muted); font-size: 0.8125rem;">Unknown</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:out value="${empty pat.emergencyContact ? '—' : pat.emergencyContact}" />
                                                </td>
                                                <td>
                                                    <c:out value="${empty pat.emergencyPhone ? '—' : pat.emergencyPhone}" />
                                                </td>
                                                <td style="text-align: right;">
                                                    <c:set var="resolvedPatId" value="${not empty pat.patientId ? pat.patientId : pat.id}" />
                                                    <a href="${pageContext.request.contextPath}/doctor/medical-records?patientId=${resolvedPatId}" class="btn btn-outline btn-sm">
                                                        Add Record
                                                    </a>
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                </div>
                                <h3 class="empty-state-title">No Patients Found</h3>
                                <p class="empty-state-desc">Patients who schedule an appointment or have consultations with you will appear in this directory.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterPatients() {
    const query = document.getElementById('patientFilter').value.toLowerCase();
    const rows = document.querySelectorAll('#patientsTable tbody tr');
    rows.forEach(row => {
        const name = (row.getAttribute('data-name') || '').toLowerCase();
        const blood = (row.getAttribute('data-blood') || '').toLowerCase();
        const text = row.textContent.toLowerCase();
        if (name.includes(query) || blood.includes(query) || text.includes(query)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
