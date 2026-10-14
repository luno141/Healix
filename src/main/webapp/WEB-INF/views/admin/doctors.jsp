<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Doctor Faculty Administration" scope="request" />
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
                        <h2 class="card-title">Doctor Registry & Credentials</h2>
                        <div class="card-subtitle">Oversee medical credentials, practice licensure, and active doctor status</div>
                    </div>
                    <div class="card-header-actions">
                        <input type="text" id="doctorFilter" class="form-control" style="max-width: 250px; font-size: 0.8125rem; padding: 0.4rem 0.75rem;" 
                            placeholder="Filter by name, specialty, license..." onkeyup="filterDoctorTable()" />
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty doctors}">
                            <div class="table-responsive">
                                <table class="table table-hover" id="adminDoctorsTable">
                                    <thead>
                                        <tr>
                                            <th>Doctor Name</th>
                                            <th>Specialization</th>
                                            <th>License No.</th>
                                            <th>Education</th>
                                            <th>Experience</th>
                                            <th>Fee</th>
                                            <th>Account Status</th>
                                            <th style="text-align: right; min-width: 190px;">Status Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${doctors}" var="doc">
                                            <c:set var="docKey" value="${not empty doc.doctorId ? doc.doctorId : doc.id}" />
                                            <tr data-name="${doc.fullName}" data-spec="${doc.specialization}" data-lic="${doc.licenseNumber}">
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <div class="sidebar-user-avatar" style="width: 34px; height: 34px; font-size: 0.8125rem;">
                                                            <c:out value="${empty doc.fullName ? 'D' : doc.fullName.substring(0, 1).toUpperCase()}" />
                                                        </div>
                                                        <div>
                                                            <strong>Dr. <c:out value="${doc.fullName}" /></strong>
                                                            <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                                <c:out value="${doc.email}" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge badge-primary"><c:out value="${empty doc.specialization ? 'General' : doc.specialization}" /></span>
                                                </td>
                                                <td>
                                                    <code><c:out value="${empty doc.licenseNumber ? '—' : doc.licenseNumber}" /></code>
                                                </td>
                                                <td style="max-width: 160px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty doc.education ? '—' : doc.education}" />
                                                </td>
                                                <td>
                                                    <c:out value="${doc.experienceYears}" /> yrs
                                                </td>
                                                <td>
                                                    <strong>$<fmt:formatNumber value="${empty doc.consultationFee ? 0 : doc.consultationFee}" minFractionDigits="0" maxFractionDigits="2" /></strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${doc.status == 'active'}">
                                                            <span class="badge badge-completed">Active</span>
                                                        </c:when>
                                                        <c:when test="${doc.status == 'pending'}">
                                                            <span class="badge badge-pending">Pending</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-cancelled"><c:out value="${empty doc.status ? 'Inactive' : doc.status}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <form method="POST" action="${pageContext.request.contextPath}/admin/doctors/status" style="display: inline-flex; align-items: center; gap: 0.5rem; justify-content: flex-end;" onsubmit="return confirm('Update doctor status for Dr. ${doc.fullName}?');">
                                                        <input type="hidden" name="doctorId" value="${docKey}" />
                                                        <select name="status" class="form-select" style="padding: 0.3rem 0.5rem; font-size: 0.75rem; width: auto;">
                                                            <option value="active" ${doc.status == 'active' ? 'selected' : ''}>Active</option>
                                                            <option value="pending" ${doc.status == 'pending' ? 'selected' : ''}>Pending</option>
                                                            <option value="inactive" ${doc.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                        <button type="submit" class="btn btn-outline btn-sm">Update</button>
                                                    </form>
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>
                                </div>
                                <h3 class="empty-state-title">No Doctors Enrolled</h3>
                                <p class="empty-state-desc">There are no doctors registered in the system yet. Newly registered doctor profiles will appear here for verification.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterDoctorTable() {
    const query = document.getElementById('doctorFilter').value.toLowerCase();
    const rows = document.querySelectorAll('#adminDoctorsTable tbody tr');
    rows.forEach(row => {
        const name = (row.getAttribute('data-name') || '').toLowerCase();
        const spec = (row.getAttribute('data-spec') || '').toLowerCase();
        const lic = (row.getAttribute('data-lic') || '').toLowerCase();
        const text = row.textContent.toLowerCase();
        if (name.includes(query) || spec.includes(query) || lic.includes(query) || text.includes(query)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
