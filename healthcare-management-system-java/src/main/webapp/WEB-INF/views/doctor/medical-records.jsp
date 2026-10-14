<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Clinical Medical Records" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Alert Messages -->
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

            <div style="display: grid; grid-template-columns: 1fr 1.6fr; gap: 2rem; align-items: start;">
                <!-- Add Record Form Card -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">New Medical Record</h2>
                            <div class="card-subtitle">Document consultation findings and care plans</div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="${pageContext.request.contextPath}/doctor/medical-records">
                            <!-- Patient Selection -->
                            <div class="form-group">
                                <label for="patientId" class="form-label">Patient <span class="required">*</span></label>
                                <c:choose>
                                    <c:when test="${not empty patients}">
                                        <select id="patientId" name="patientId" class="form-select" required>
                                            <option value="">-- Choose Patient --</option>
                                            <c:forEach items="${patients}" var="p">
                                                <c:set var="resolvedPId" value="${not empty p.patientId ? p.patientId : p.id}" />
                                                <option value="${resolvedPId}" ${(param.patientId == resolvedPId) ? 'selected' : ''}>
                                                    <c:out value="${p.fullName}" /> (<c:out value="${empty p.email ? p.phone : p.email}" />)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" id="patientId" name="patientId" class="form-control" 
                                            value="${param.patientId}" placeholder="Enter Patient ID (UUID)" required />
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Record Type -->
                            <div class="form-group">
                                <label for="recordType" class="form-label">Record Type <span class="required">*</span></label>
                                <select id="recordType" name="recordType" class="form-select" required>
                                    <option value="Consultation">Clinical Consultation</option>
                                    <option value="Diagnosis">Diagnostic Assessment</option>
                                    <option value="Prescription">Prescription & Medication</option>
                                    <option value="Lab Test">Laboratory Investigation</option>
                                    <option value="Follow-up">Follow-up Evaluation</option>
                                    <option value="Discharge Summary">Discharge Summary</option>
                                </select>
                            </div>

                            <!-- Title -->
                            <div class="form-group">
                                <label for="title" class="form-label">Record Title <span class="required">*</span></label>
                                <input type="text" id="title" name="title" class="form-control" 
                                    placeholder="e.g. Acute Bronchitis Evaluation" required />
                            </div>

                            <!-- Diagnosis -->
                            <div class="form-group">
                                <label for="diagnosis" class="form-label">Clinical Diagnosis</label>
                                <textarea id="diagnosis" name="diagnosis" rows="2" class="form-textarea" 
                                    placeholder="Enter verified ICD/clinical diagnosis..."></textarea>
                            </div>

                            <!-- Treatment / Rx -->
                            <div class="form-group">
                                <label for="treatment" class="form-label">Treatment Plan / Prescription</label>
                                <textarea id="treatment" name="treatment" rows="2" class="form-textarea" 
                                    placeholder="Dosage, medication schedule, therapies, or lifestyle instructions..."></textarea>
                            </div>

                            <!-- Description / Notes -->
                            <div class="form-group">
                                <label for="description" class="form-label">Clinical Observations & Notes</label>
                                <textarea id="description" name="description" rows="3" class="form-textarea" 
                                    placeholder="Detailed patient history, physical examination, vitals, etc."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block">
                                Save Medical Record
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Existing Medical Records Table Card -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Recorded Clinical Entries</h2>
                            <div class="card-subtitle">EHR entries authored by you</div>
                        </div>
                        <div class="card-header-actions">
                            <input type="text" id="recordSearch" class="form-control" style="max-width: 200px; font-size: 0.8125rem; padding: 0.35rem 0.65rem;" 
                                placeholder="Search records..." onkeyup="filterRecordsTable()" />
                        </div>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty records}">
                                <div class="table-responsive">
                                    <table class="table table-hover" id="recordsTable">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Patient ID</th>
                                                <th>Type</th>
                                                <th>Title</th>
                                                <th>Diagnosis</th>
                                                <th>Treatment</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${records}" var="rec">
                                                <tr>
                                                    <td style="white-space: nowrap;">
                                                        <strong><fmt:formatDate value="${rec.createdAt}" pattern="MMM dd, yyyy" /></strong>
                                                        <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                            <fmt:formatDate value="${rec.createdAt}" pattern="HH:mm" />
                                                        </div>
                                                    </td>
                                                    <td style="max-width: 120px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; font-size: 0.8125rem;">
                                                        <code><c:out value="${rec.patientId}" /></code>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-primary">
                                                            <c:out value="${empty rec.recordType ? 'Consultation' : rec.recordType}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <strong><c:out value="${rec.title}" /></strong>
                                                    </td>
                                                    <td style="max-width: 160px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                        <c:out value="${empty rec.diagnosis ? '—' : rec.diagnosis}" />
                                                    </td>
                                                    <td style="max-width: 160px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                                                        <c:out value="${empty rec.treatment ? '—' : rec.treatment}" />
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
                                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                    </div>
                                    <h3 class="empty-state-title">No Medical Records Created Yet</h3>
                                    <p class="empty-state-desc">You have not documented any medical records yet. Use the form to write your first clinical consultation note.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function filterRecordsTable() {
    const query = document.getElementById('recordSearch').value.toLowerCase();
    const rows = document.querySelectorAll('#recordsTable tbody tr');
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(query) ? '' : 'none';
    });
}
</script>

<jsp:include page="../common/footer.jsp" />
