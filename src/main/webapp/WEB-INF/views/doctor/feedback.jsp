<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Patient Reviews & Ratings" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Average Rating Summary Card -->
            <div class="card" style="margin-bottom: 2rem;">
                <div class="card-body" style="padding: 2rem;">
                    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1.5rem;">
                        <div style="display: flex; align-items: center; gap: 1.5rem;">
                            <div style="text-align: center; min-width: 120px;">
                                <div style="font-size: 3rem; font-weight: 800; color: var(--text-main); line-height: 1;">
                                    <fmt:formatNumber value="${empty avgRating ? 0 : avgRating}" minFractionDigits="1" maxFractionDigits="1" />
                                </div>
                                <div style="font-size: 0.8125rem; color: var(--text-muted); font-weight: 600; margin-top: 0.25rem;">Out of 5.0</div>
                            </div>

                            <div>
                                <div class="star-rating" style="font-size: 1.5rem; color: #F59E0B; margin-bottom: 0.25rem;">
                                    <c:set var="roundedRating" value="${avgRating + 0.5}" />
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= avgRating}">
                                                <span class="star filled">&#9733;</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="star" style="color: #CBD5E1;">&#9733;</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <div style="font-size: 0.875rem; color: var(--text-muted);">
                                    Overall Satisfaction Score based on verified patient appointments
                                </div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 2rem;">
                            <div style="text-align: center;">
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--text-main);">
                                    <c:out value="${empty feedbackList ? 0 : feedbackList.size()}" />
                                </div>
                                <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Total Reviews</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Feedback List / Cards -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Patient Testimonials & Reviews</h2>
                        <div class="card-subtitle">Direct feedback submitted following completed consultations</div>
                    </div>
                </div>

                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty feedbackList}">
                            <div class="feedback-grid">
                                <c:forEach items="${feedbackList}" var="fb">
                                    <div class="feedback-card">
                                        <div class="feedback-header">
                                            <div style="display: flex; align-items: center; gap: 0.625rem;">
                                                <div class="sidebar-user-avatar" style="width: 32px; height: 32px; font-size: 0.75rem;">
                                                    <c:out value="${empty fb.patientName ? 'P' : fb.patientName.substring(0, 1).toUpperCase()}" />
                                                </div>
                                                <div class="feedback-author">
                                                    <c:out value="${empty fb.patientName ? 'Verified Patient' : fb.patientName}" />
                                                </div>
                                            </div>
                                            <div class="feedback-date">
                                                <fmt:formatDate value="${fb.createdAt}" pattern="MMM dd, yyyy" />
                                            </div>
                                        </div>

                                        <!-- Stars -->
                                        <div style="margin-bottom: 0.625rem; font-size: 1.125rem;">
                                            <c:forEach begin="1" end="5" var="s">
                                                <c:choose>
                                                    <c:when test="${s <= fb.rating}">
                                                        <span style="color: #F59E0B;">&#9733;</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #CBD5E1;">&#9733;</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>

                                        <!-- Comment -->
                                        <div class="feedback-comment">
                                            "<c:out value="${empty fb.comment ? 'No written comment provided.' : fb.comment}" />"
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                </div>
                                <h3 class="empty-state-title">No Reviews Yet</h3>
                                <p class="empty-state-desc">Patient reviews will appear here once patients complete consultations with you and submit their feedback.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
