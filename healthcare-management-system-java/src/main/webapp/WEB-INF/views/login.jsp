<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In" scope="request" />
<jsp:include page="common/header.jsp" />

<div class="auth-wrapper">
    <div class="auth-card">
        <!-- Brand Header -->
        <div class="auth-header">
            <a href="${pageContext.request.contextPath}/" class="auth-brand">
                <div class="brand-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                    </svg>
                </div>
                <span class="brand-name" style="font-size: 1.5rem; font-weight: 800;">Heal<span>ix</span></span>
            </a>
            <h1 class="auth-title">Welcome Back</h1>
            <p class="auth-subtitle">Sign in to access your healthcare portal</p>
        </div>

        <!-- Feedback Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-error" role="alert">
                <div class="alert-content">
                    <c:out value="${error}" />
                </div>
                <button type="button" class="alert-close" aria-label="Close" onclick="this.parentElement.remove()">&times;</button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success" role="alert">
                <div class="alert-content">
                    <c:out value="${success}" />
                </div>
                <button type="button" class="alert-close" aria-label="Close" onclick="this.parentElement.remove()">&times;</button>
            </div>
        </c:if>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
            <div class="form-group">
                <label for="email" class="form-label">
                    Email Address <span class="required">*</span>
                </label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    class="form-control" 
                    placeholder="doctor@healix.com or patient@healix.com" 
                    value="<c:out value='${param.email}' />" 
                    required 
                    autofocus
                >
            </div>

            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.375rem;">
                    <label for="password" class="form-label" style="margin-bottom: 0;">
                        Password <span class="required">*</span>
                    </label>
                </div>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    class="form-control" 
                    placeholder="Enter your account password" 
                    required
                >
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 1.5rem;">
                Sign In to Healix
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                    <polyline points="12 5 19 12 12 19"></polyline>
                </svg>
            </button>
        </form>

        <!-- Quick Demo Credentials Guide -->
        <div class="demo-credentials-box">
            <h6>Demo Login Credentials</h6>
            <div style="display: grid; grid-template-columns: 1fr; gap: 0.25rem;">
                <div><strong>Admin:</strong> admin@healix.com / password123</div>
                <div><strong>Doctor:</strong> doctor@healix.com / password123</div>
                <div><strong>Patient:</strong> patient@healix.com / password123</div>
            </div>
        </div>

        <!-- Footer Link -->
        <div class="auth-footer">
            Don't have an account yet? 
            <a href="${pageContext.request.contextPath}/register" style="font-weight: 600;">Create Patient Account</a>
            <div style="margin-top: 0.75rem;">
                <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); font-size: 0.8125rem;">&larr; Return to Home</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
