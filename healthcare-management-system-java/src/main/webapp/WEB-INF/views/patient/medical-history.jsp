<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Medical History" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Electronic Health Records</h2>
                        <div class="card-subtitle">Complete chronological history of your clinical visits, diagnoses, and treatments</div>
                    </div>
                    <div class="card-header-actions">
                        <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline btn-sm">
                            View Appointments
                        </a>
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty records}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date & Time</th>
                                            <th>Doctor</th>
                                            <th>Record Type</th>
                                            <th>Title</th>
                                            <th>Diagnosis</th>
                                            <th>Treatment / Plan</th>
                                            <th>Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${records}" var="record">
                                            <tr>
                                                <td style="white-space: nowrap;">
                                                    <strong><fmt:formatDate value="${record.createdAt}" pattern="MMM dd, yyyy" /></strong>
                                                    <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                        <fmt:formatDate value="${record.createdAt}" pattern="HH:mm" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <strong>Dr. <c:out value="${empty record.doctorName ? 'Healthcare Practitioner' : record.doctorName}" /></strong>
                                                </td>
                                                <td>
                                                    <span class="badge badge-primary">
                                                        <c:out value="${empty record.recordType ? 'Consultation' : record.recordType}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <strong><c:out value="${record.title}" /></strong>
                                                </td>
                                                <td style="color: var(--text-main);">
                                                    <c:out value="${empty record.diagnosis ? 'None recorded' : record.diagnosis}" />
                                                </td>
                                                <td style="color: var(--text-main);">
                                                    <c:out value="${empty record.treatment ? 'No specific treatment' : record.treatment}" />
                                                </td>
                                                <td style="max-width: 250px; font-size: 0.8125rem; color: var(--text-muted); text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                    <c:out value="${empty record.description ? '—' : record.description}" />
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
                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                </div>
                                <h3 class="empty-state-title">No Medical Records Found</h3>
                                <p class="empty-state-desc">Your clinical records, prescriptions, and diagnoses from consultations will appear here once entered by your attending doctors.</p>
                                <a href="${pageContext.request.contextPath}/patient/book" class="btn btn-primary">Book Consultation</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
