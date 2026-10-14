<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="dashboard-header">
    <div class="dashboard-header-left">
        <!-- Mobile Sidebar Toggle -->
        <button type="button" class="menu-toggle-btn" aria-label="Open sidebar menu" onclick="window.toggleMobileMenu ? window.toggleMobileMenu() : document.querySelector('.sidebar').classList.toggle('open')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="3" y1="12" x2="21" y2="12"></line>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <line x1="3" y1="18" x2="21" y2="18"></line>
            </svg>
        </button>

        <!-- Dynamic Title -->
        <div>
            <h1 class="dashboard-header-title">
                <c:choose>
                    <c:when test="${not empty pageTitle}"><c:out value="${pageTitle}" /></c:when>
                    <c:otherwise>Dashboard</c:otherwise>
                </c:choose>
            </h1>
            <div class="dashboard-header-subtitle">Healix Integrated Clinical Portal</div>
        </div>
    </div>

    <!-- Right Side: Welcome Message & User Info -->
    <div class="dashboard-header-right">
        <div class="dashboard-greeting">
            Welcome back, 
            <strong>
                <c:choose>
                    <c:when test="${not empty sessionScope.user.fullName}"><c:out value="${sessionScope.user.fullName}" /></c:when>
                    <c:otherwise>User</c:otherwise>
                </c:choose>
            </strong>
        </div>

        <div class="dashboard-user-pill">
            <div class="dashboard-user-pill-avatar">
                <c:out value="${empty sessionScope.user.fullName ? 'U' : sessionScope.user.fullName.substring(0, 1).toUpperCase()}" />
            </div>
            <span class="badge badge-role-${empty sessionScope.role ? 'patient' : sessionScope.role}">
                <c:out value="${empty sessionScope.role ? 'Patient' : sessionScope.role}" />
            </span>
        </div>
    </div>
</header>
