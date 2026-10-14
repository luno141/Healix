<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Doctor Schedule & Availability" scope="request" />
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

            <div style="display: grid; grid-template-columns: 1fr 1.6fr; gap: 2rem; align-items: start;">
                <!-- Add / Edit Availability Form Card -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title" id="formTitle">Set Weekly Availability</h2>
                            <div class="card-subtitle">Define active practice hours and slot length</div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form id="scheduleForm" method="POST" action="${pageContext.request.contextPath}/doctor/schedule">
                            <!-- Hidden ID if editing -->
                            <input type="hidden" id="availabilityId" name="availabilityId" value="" />

                            <!-- Day of Week -->
                            <div class="form-group">
                                <label for="dayOfWeek" class="form-label">Day of Week <span class="required">*</span></label>
                                <select id="dayOfWeek" name="dayOfWeek" class="form-select" required>
                                    <option value="">-- Choose Day --</option>
                                    <option value="0">Sunday</option>
                                    <option value="1">Monday</option>
                                    <option value="2">Tuesday</option>
                                    <option value="3">Wednesday</option>
                                    <option value="4">Thursday</option>
                                    <option value="5">Friday</option>
                                    <option value="6">Saturday</option>
                                </select>
                            </div>

                            <!-- Start Time & End Time -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="startTime" class="form-label">Start Time <span class="required">*</span></label>
                                    <input type="time" id="startTime" name="startTime" class="form-control" value="09:00" required />
                                </div>
                                <div class="form-group">
                                    <label for="endTime" class="form-label">End Time <span class="required">*</span></label>
                                    <input type="time" id="endTime" name="endTime" class="form-control" value="17:00" required />
                                </div>
                            </div>

                            <!-- Slot Duration -->
                            <div class="form-group">
                                <label for="slotDuration" class="form-label">Consultation Slot Duration <span class="required">*</span></label>
                                <select id="slotDuration" name="slotDuration" class="form-select" required>
                                    <option value="15">15 Minutes</option>
                                    <option value="20">20 Minutes</option>
                                    <option value="30" selected>30 Minutes (Recommended)</option>
                                    <option value="45">45 Minutes</option>
                                    <option value="60">60 Minutes (1 Hour)</option>
                                </select>
                                <span class="form-help">Patients will book appointments in chunks of this length.</span>
                            </div>

                            <!-- Available Status -->
                            <div class="form-check" style="margin-top: 1rem; margin-bottom: 1.5rem;">
                                <input type="checkbox" id="isAvailable" name="isAvailable" class="form-check-input" value="true" checked />
                                <label for="isAvailable" class="form-check-label">Mark as Active & Available for Bookings</label>
                            </div>

                            <div style="display: flex; gap: 0.75rem;">
                                <button type="submit" id="saveScheduleBtn" class="btn btn-primary" style="flex: 1;">
                                    Save Availability
                                </button>
                                <button type="button" id="resetScheduleBtn" class="btn btn-outline-secondary" onclick="resetScheduleForm()" style="display: none;">
                                    Reset
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Current Availability Schedule Table Card -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h2 class="card-title">Configured Practice Hours</h2>
                            <div class="card-subtitle">Your published weekly recurring schedule</div>
                        </div>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${not empty availability}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Day</th>
                                                <th>Working Hours</th>
                                                <th>Slot Duration</th>
                                                <th>Status</th>
                                                <th style="text-align: right;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${availability}" var="slot">
                                                <tr>
                                                    <td>
                                                        <strong><c:out value="${slot.dayName}" /></strong>
                                                    </td>
                                                    <td>
                                                        <span style="font-weight: 600; color: var(--primary);">
                                                            <c:out value="${slot.startTime}" /> - <c:out value="${slot.endTime}" />
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:out value="${slot.slotDuration}" /> mins
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${slot.available}">
                                                                <span class="badge badge-completed">Available</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-cancelled">Unavailable</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td style="text-align: right;">
                                                        <div class="table-actions" style="justify-content: flex-end;">
                                                            <!-- Edit Button -->
                                                            <button type="button" class="btn btn-outline btn-sm"
                                                                onclick="editSlot('${slot.id}', ${slot.dayOfWeek}, '${slot.startTime}', '${slot.endTime}', ${slot.slotDuration}, ${slot.available})">
                                                                Edit
                                                            </button>

                                                            <!-- Delete Form -->
                                                            <form method="POST" action="${pageContext.request.contextPath}/doctor/schedule/delete" style="display: inline;" onsubmit="return confirm('Delete availability for ${slot.dayName}?');">
                                                                <input type="hidden" name="availabilityId" value="${slot.id}" />
                                                                <input type="hidden" name="id" value="${slot.id}" />
                                                                <button type="submit" class="btn btn-danger-outline btn-sm">Delete</button>
                                                            </form>
                                                        </div>
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
                                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    </div>
                                    <h3 class="empty-state-title">No Practice Hours Configured</h3>
                                    <p class="empty-state-desc">You have not defined your working schedule yet. Use the form on the left to set up your weekly availability so patients can book appointments.</p>
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
function editSlot(id, day, start, end, duration, available) {
    document.getElementById('formTitle').textContent = 'Edit Schedule Slot';
    document.getElementById('availabilityId').value = id;
    document.getElementById('dayOfWeek').value = day;
    // Format start and end time if contains seconds (HH:mm:ss -> HH:mm)
    document.getElementById('startTime').value = (start.length > 5) ? start.substring(0, 5) : start;
    document.getElementById('endTime').value = (end.length > 5) ? end.substring(0, 5) : end;
    document.getElementById('slotDuration').value = duration;
    document.getElementById('isAvailable').checked = (available === true || available === 'true');
    document.getElementById('saveScheduleBtn').textContent = 'Update Availability';
    document.getElementById('resetScheduleBtn').style.display = 'inline-block';
    
    // Scroll form into view
    document.getElementById('scheduleForm').scrollIntoView({ behavior: 'smooth' });
}

function resetScheduleForm() {
    document.getElementById('formTitle').textContent = 'Set Weekly Availability';
    document.getElementById('availabilityId').value = '';
    document.getElementById('scheduleForm').reset();
    document.getElementById('saveScheduleBtn').textContent = 'Save Availability';
    document.getElementById('resetScheduleBtn').style.display = 'none';
}
</script>

<jsp:include page="../common/footer.jsp" />
