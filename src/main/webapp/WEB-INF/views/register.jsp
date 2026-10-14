<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Patient Registration" scope="request" />
<jsp:include page="common/header.jsp" />

<div class="auth-wrapper">
    <div class="auth-card auth-card-wide">
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
            <h1 class="auth-title">Create Patient Account</h1>
            <p class="auth-subtitle">Join Healix to schedule visits and view your health history</p>
        </div>

        <!-- Feedback Alert -->
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

        <!-- Registration Form -->
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="fullName" class="form-label">
                    Full Name <span class="required">*</span>
                </label>
                <input 
                    type="text" 
                    id="fullName" 
                    name="fullName" 
                    class="form-control" 
                    placeholder="e.g. Eleanor Vance" 
                    value="<c:out value='${param.fullName}' />" 
                    required 
                    autofocus
                >
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email" class="form-label">
                        Email Address <span class="required">*</span>
                    </label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-control" 
                        placeholder="patient@example.com" 
                        value="<c:out value='${param.email}' />" 
                        required
                    >
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">
                        Phone Number <span class="required">*</span>
                    </label>
                    <input 
                        type="tel" 
                        id="phone" 
                        name="phone" 
                        class="form-control" 
                        placeholder="e.g. +1 555-019-2834" 
                        value="<c:out value='${param.phone}' />" 
                        required
                    >
                </div>
            </div>

            <div class="form-group">
                <label for="gender" class="form-label">
                    Gender
                </label>
                <select id="gender" name="gender" class="form-select">
                    <option value="">-- Select Gender (Optional) --</option>
                    <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Male</option>
                    <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Female</option>
                    <option value="Other" ${param.gender == 'Other' ? 'selected' : ''}>Other / Prefer not to say</option>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password" class="form-label">
                        Password <span class="required">*</span>
                    </label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="At least 6 characters" 
                        minlength="6" 
                        required
                    >
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        Confirm Password <span class="required">*</span>
                    </label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        class="form-control" 
                        placeholder="Repeat your password" 
                        minlength="6" 
                        required
                    >
                </div>
            </div>

            <div class="form-check" style="margin-top: 0.5rem; margin-bottom: 1.5rem;">
                <input type="checkbox" id="termsCheck" class="form-check-input" required checked>
                <label for="termsCheck" class="form-check-label" style="font-size: 0.8125rem; color: var(--text-muted);">
                    I agree to the <a href="#" style="text-decoration: underline;">Terms of Clinical Care</a> and <a href="#" style="text-decoration: underline;">Privacy Policy</a>.
                </label>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg">
                Create Account
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <line x1="20" y1="8" x2="20" y2="14"></line>
                    <line x1="23" y1="11" x2="17" y2="11"></line>
                </svg>
            </button>
        </form>

        <!-- Footer Link -->
        <div class="auth-footer">
            Already registered with Healix? 
            <a href="${pageContext.request.contextPath}/login" style="font-weight: 600;">Sign in here</a>
            <div style="margin-top: 0.75rem;">
                <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); font-size: 0.8125rem;">&larr; Return to Home</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
