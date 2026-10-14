<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Find Doctors" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Header Section with Search Filter -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--text-main); margin-bottom: 0.25rem;">Medical Specialists</h2>
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Connect with certified doctors and book your consultation</p>
                </div>
                <div style="min-width: 280px;">
                    <input type="text" id="doctorSearchInput" class="form-control" placeholder="Search by name, specialization, education..." onkeyup="filterDoctors()" />
                </div>
            </div>

            <!-- Doctors Grid -->
            <c:choose>
                <c:when test="${not empty doctors}">
                    <div class="doctor-grid" id="doctorCardsGrid">
                        <c:forEach items="${doctors}" var="doc">
                            <div class="doctor-card" data-doctor-name="${doc.fullName}" data-specialization="${doc.specialization}" data-education="${doc.education}">
                                <div class="doctor-card-top">
                                    <div class="doctor-avatar-circle">
                                        <c:out value="${empty doc.fullName ? 'D' : doc.fullName.substring(0, 1).toUpperCase()}" />
                                    </div>
                                    <div class="doctor-title-group">
                                        <div class="doctor-name">Dr. <c:out value="${doc.fullName}" /></div>
                                        <div class="doctor-spec"><c:out value="${empty doc.specialization ? 'General Practitioner' : doc.specialization}" /></div>
                                        <div style="margin-top: 0.25rem;">
                                            <span class="badge ${doc.status == 'active' ? 'badge-completed' : 'badge-pending'}">
                                                <c:out value="${empty doc.status ? 'active' : doc.status}" />
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="doctor-meta-list">
                                    <c:if test="${not empty doc.education}">
                                        <div class="doctor-meta-item">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                            <span><strong>Education:</strong> <c:out value="${doc.education}" /></span>
                                        </div>
                                    </c:if>
                                    <div class="doctor-meta-item">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        <span><strong>Experience:</strong> <c:out value="${doc.experienceYears}" /> years</span>
                                    </div>
                                    <c:if test="${not empty doc.licenseNumber}">
                                        <div class="doctor-meta-item">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="9" x2="15" y2="9"></line><line x1="9" y1="13" x2="15" y2="13"></line><line x1="9" y1="17" x2="11" y2="17"></line></svg>
                                            <span><strong>License:</strong> <c:out value="${doc.licenseNumber}" /></span>
                                        </div>
                                    </c:if>
                                </div>

                                <c:if test="${not empty doc.bio}">
                                    <div class="doctor-bio">
                                        <c:out value="${doc.bio}" />
                                    </div>
                                </c:if>

                                <div class="doctor-card-footer">
                                    <div class="doctor-fee">
                                        $<fmt:formatNumber value="${empty doc.consultationFee ? 0 : doc.consultationFee}" minFractionDigits="0" maxFractionDigits="2" />
                                        <small>/ consultation</small>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/patient/book?doctorId=${not empty doc.doctorId ? doc.doctorId : doc.id}" class="btn btn-primary btn-sm">
                                        Book Visit
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-body">
                            <div class="empty-state">
                                <div class="empty-state-icon">
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                </div>
                                <h3 class="empty-state-title">No Doctors Available</h3>
                                <p class="empty-state-desc">There are currently no active doctors registered in the system. Please check back shortly.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
function filterDoctors() {
    const query = document.getElementById('doctorSearchInput').value.toLowerCase();
    const cards = document.querySelectorAll('.doctor-card');
    cards.forEach(card => {
        const name = (card.getAttribute('data-doctor-name') || '').toLowerCase();
        const spec = (card.getAttribute('data-specialization') || '').toLowerCase();
        const edu = (card.getAttribute('data-education') || '').toLowerCase();
        if (name.includes(query) || spec.includes(query) || edu.includes(query)) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
