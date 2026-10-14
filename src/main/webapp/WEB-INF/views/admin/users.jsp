<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="User Account Administration" scope="request" />
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
                        <h2 class="card-title">Registered Accounts</h2>
                        <div class="card-subtitle">Manage user credentials, security status, and platform role authorizations</div>
                    </div>
                    <div class="card-header-actions" style="display: flex; gap: 0.5rem;">
                        <select id="roleFilterSelect" class="form-select" style="width: auto; padding: 0.4rem 0.75rem; font-size: 0.8125rem;" onchange="filterUserTable()">
                            <option value="">All Roles</option>
                            <option value="admin">Admin</option>
                            <option value="doctor">Doctor</option>
                            <option value="patient">Patient</option>
                        </select>
                        <input type="text" id="userSearch" class="form-control" style="max-width: 220px; padding: 0.4rem 0.75rem; font-size: 0.8125rem;" 
                            placeholder="Search name, email, phone..." onkeyup="filterUserTable()" />
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty users}">
                            <div class="table-responsive">
                                <table class="table table-hover" id="usersTable">
                                    <thead>
                                        <tr>
                                            <th>User Name</th>
                                            <th>Email Address</th>
                                            <th>Phone</th>
                                            <th>System Role</th>
                                            <th>Registration Date</th>
                                            <th style="text-align: right; min-width: 200px;">Assign Role</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${users}" var="usr">
                                            <tr data-name="${usr.fullName}" data-email="${usr.email}" data-role="${usr.role}">
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                        <div class="sidebar-user-avatar" style="width: 34px; height: 34px; font-size: 0.8125rem;">
                                                            <c:out value="${empty usr.fullName ? 'U' : usr.fullName.substring(0, 1).toUpperCase()}" />
                                                        </div>
                                                        <div>
                                                            <strong><c:out value="${usr.fullName}" /></strong>
                                                            <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                                <code><c:out value="${usr.id}" /></code>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <a href="mailto:${usr.email}" style="color: var(--primary); text-decoration: none;">
                                                        <c:out value="${usr.email}" />
                                                    </a>
                                                </td>
                                                <td>
                                                    <c:out value="${empty usr.phone ? '—' : usr.phone}" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${usr.role == 'admin'}">
                                                            <span class="badge badge-role-admin" style="background-color: #EDE9FE; color: #6D28D9; border: 1px solid #DDD6FE;">Admin</span>
                                                        </c:when>
                                                        <c:when test="${usr.role == 'doctor'}">
                                                            <span class="badge badge-role-doctor" style="background-color: #E0E7FF; color: #3730A3; border: 1px solid #C7D2FE;">Doctor</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-role-patient" style="background-color: #DCFCE7; color: #166534; border: 1px solid #BBF7D0;">Patient</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${usr.createdAt}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td style="text-align: right;">
                                                    <form method="POST" action="${pageContext.request.contextPath}/admin/users/role" style="display: inline-flex; align-items: center; gap: 0.5rem; justify-content: flex-end;" onsubmit="return confirm('Change role for ${usr.fullName}?');">
                                                        <input type="hidden" name="userId" value="${usr.id}" />
                                                        <select name="newRole" class="form-select" style="padding: 0.3rem 0.5rem; font-size: 0.75rem; width: auto;">
                                                            <option value="patient" ${usr.role == 'patient' ? 'selected' : ''}>Patient</option>
                                                            <option value="doctor" ${usr.role == 'doctor' ? 'selected' : ''}>Doctor</option>
                                                            <option value="admin" ${usr.role == 'admin' ? 'selected' : ''}>Admin</option>
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                </div>
                                <h3 class="empty-state-title">No Users Found</h3>
                                <p class="empty-state-desc">There are currently no registered users matching your criteria.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterUserTable() {
    const query = document.getElementById('userSearch').value.toLowerCase();
    const role = document.getElementById('roleFilterSelect').value.toLowerCase();
    const rows = document.querySelectorAll('#usersTable tbody tr');

    rows.forEach(row => {
        const name = (row.getAttribute('data-name') || '').toLowerCase();
        const email = (row.getAttribute('data-email') || '').toLowerCase();
        const userRole = (row.getAttribute('data-role') || '').toLowerCase();

        const matchesQuery = !query || name.includes(query) || email.includes(query);
        const matchesRole = !role || userRole === role;

        row.style.display = (matchesQuery && matchesRole) ? '' : 'none';
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
