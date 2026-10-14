<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="navbar">
    <div class="nav-container">
        <!-- Brand / Logo -->
        <a href="${pageContext.request.contextPath}/" class="nav-brand">
            <div class="brand-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                </svg>
            </div>
            <span class="brand-name">Heal<span>ix</span></span>
        </a>

        <!-- Responsive Hamburger Toggle -->
        <button class="nav-toggle" type="button" aria-label="Toggle navigation" onclick="window.togglePublicNav ? window.togglePublicNav() : document.querySelector('.nav-links').classList.toggle('mobile-open')">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="3" y1="12" x2="21" y2="12"></line>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <line x1="3" y1="18" x2="21" y2="18"></line>
            </svg>
        </button>

        <!-- Navigation Links -->
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/" class="nav-link ${pageContext.request.requestURI.endsWith('/index.jsp') || pageContext.request.requestURI.endsWith('/') ? 'active' : ''}">Home</a>
            <a href="${pageContext.request.contextPath}/doctors" class="nav-link ${pageContext.request.requestURI.contains('/doctors') ? 'active' : ''}">Find Doctors</a>
            <a href="${pageContext.request.contextPath}/#features" class="nav-link">Services</a>
            <a href="${pageContext.request.contextPath}/#about" class="nav-link">About Us</a>
        </nav>

        <!-- Navigation Actions (Auth / Dashboard) -->
        <div class="nav-actions">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-sm">Sign In</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Get Started</a>
                </c:when>
                <c:otherwise>
                    <div class="nav-user">
                        <div class="nav-user-avatar">
                            <c:out value="${empty sessionScope.user.fullName ? 'U' : sessionScope.user.fullName.substring(0, 1).toUpperCase()}" />
                        </div>
                        <span><c:out value="${sessionScope.user.fullName}" /></span>
                    </div>

                    <c:choose>
                        <c:when test="${sessionScope.role == 'admin'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">Dashboard</a>
                        </c:when>
                        <c:when test="${sessionScope.role == 'doctor'}">
                            <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-primary btn-sm">Dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-primary btn-sm">Dashboard</a>
                        </c:otherwise>
                    </c:choose>

                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger-outline btn-sm">Sign Out</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
