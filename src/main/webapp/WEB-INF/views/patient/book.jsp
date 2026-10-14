<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Book an Appointment" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="dashboard-layout">
    <jsp:include page="../common/sidebar.jsp" />
    <div class="dashboard-main">
        <jsp:include page="../common/dashboard-header.jsp" />

        <div class="dashboard-content">
            <!-- Error Banner -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <div class="alert-content">
                        <strong>Booking Failed:</strong> <c:out value="${error}" />
                    </div>
                    <button type="button" class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                </div>
            </c:if>

            <!-- Success Banner -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <div class="alert-content">
                        <strong>Booking Confirmed!</strong> <c:out value="${success}" />
                        <div style="margin-top: 0.5rem;">
                            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-primary btn-sm">
                                View My Appointments
                            </a>
                        </div>
                    </div>
                    <button type="button" class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                </div>
            </c:if>

            <div class="card" style="max-width: 760px; margin: 0 auto;">
                <div class="card-header">
                    <div>
                        <h2 class="card-title">Schedule a Consultation</h2>
                        <div class="card-subtitle">Choose a specialist, date, and available time slot</div>
                    </div>
                </div>

                <div class="card-body">
                    <form id="bookingForm" method="POST" action="${pageContext.request.contextPath}/patient/book">
                        <!-- Step 1: Select Doctor -->
                        <div class="form-group">
                            <label for="doctorId" class="form-label">
                                Select Doctor <span class="required">*</span>
                            </label>
                            <select id="doctorId" name="doctorId" class="form-select" required onchange="handleDoctorOrDateChange()">
                                <option value="">-- Choose a healthcare specialist --</option>
                                <c:forEach items="${doctors}" var="doc">
                                    <c:set var="docVal" value="${not empty doc.doctorId ? doc.doctorId : doc.id}" />
                                    <option value="${docVal}" 
                                        ${(not empty selectedDoctor && selectedDoctor == docVal) || (not empty param.doctorId && param.doctorId == docVal) ? 'selected' : ''}>
                                        Dr. <c:out value="${doc.fullName}" /> - <c:out value="${doc.specialization}" /> 
                                        ($<fmt:formatNumber value="${doc.consultationFee}" minFractionDigits="0" maxFractionDigits="2" />)
                                    </option>
                                </c:forEach>
                            </select>
                            <span class="form-help">Select the specialist you wish to consult.</span>
                        </div>

                        <!-- Step 2: Select Date -->
                        <div class="form-group">
                            <label for="appointmentDate" class="form-label">
                                Preferred Date <span class="required">*</span>
                            </label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" 
                                value="${not empty selectedDate ? selectedDate : param.date}" 
                                required onchange="handleDoctorOrDateChange()" />
                            <span class="form-help">Appointments can only be scheduled for today or upcoming dates.</span>
                        </div>

                        <!-- Step 3: Available Time Slots -->
                        <div class="form-group">
                            <label class="form-label">
                                Available Time Slots <span class="required">*</span>
                            </label>
                            
                            <div id="slotsLoading" style="display: none; padding: 1rem; text-align: center; color: var(--text-muted); font-size: 0.875rem;">
                                <span style="display: inline-block; animation: spin 1s linear infinite; margin-right: 0.5rem;">&#x21bb;</span>
                                Loading available slots...
                            </div>

                            <div id="slotsMessage" style="display: none; padding: 1rem; background-color: var(--bg-alt); border-radius: var(--radius-md); font-size: 0.875rem; color: var(--text-muted); text-align: center;">
                                Please select both a doctor and date to check open slots.
                            </div>

                            <div id="slotsContainer" class="slot-container">
                                <!-- Server-rendered slots if available -->
                                <c:if test="${not empty slots}">
                                    <c:forEach items="${slots}" var="slot" varStatus="loop">
                                        <div class="slot-item">
                                            <input type="radio" id="slot_${loop.index}" name="startTime" value="${slot}" required />
                                            <label for="slot_${loop.index}"><c:out value="${slot}" /></label>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                            <span class="form-help" id="slotsHelp">Select an open slot from the doctor's weekly practice hours.</span>
                        </div>

                        <!-- Step 4: Reason / Symptoms -->
                        <div class="form-group">
                            <label for="reason" class="form-label">
                                Reason for Consultation <span class="required">*</span>
                            </label>
                            <textarea id="reason" name="reason" rows="3" class="form-textarea" 
                                placeholder="Briefly describe your symptoms, primary concerns, or goal for this visit..." required><c:out value="${param.reason}" /></textarea>
                        </div>

                        <!-- Submit Buttons -->
                        <div style="display: flex; gap: 1rem; align-items: center; margin-top: 1.5rem;">
                            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg" style="flex: 1;">
                                Confirm & Book Appointment
                            </button>
                            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline-secondary">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Enforce minimum date of today
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    const dateInput = document.getElementById('appointmentDate');
    if (dateInput) {
        dateInput.min = today;
        if (!dateInput.value) {
            dateInput.value = today;
        }
    }
    
    // Initial fetch if doctor is already selected
    const docSelect = document.getElementById('doctorId');
    const slotsCont = document.getElementById('slotsContainer');
    if (docSelect && docSelect.value && (!slotsCont || slotsCont.children.length === 0)) {
        fetchAvailableSlots(docSelect.value, dateInput.value);
    } else if (!docSelect || !docSelect.value) {
        const slotsMsg = document.getElementById('slotsMessage');
        if (slotsMsg && (!slotsCont || slotsCont.children.length === 0)) {
            slotsMsg.style.display = 'block';
        }
    }
});

function handleDoctorOrDateChange() {
    const doctorId = document.getElementById('doctorId').value;
    const date = document.getElementById('appointmentDate').value;
    const slotsMsg = document.getElementById('slotsMessage');
    const slotsCont = document.getElementById('slotsContainer');

    if (!doctorId || !date) {
        if (slotsCont) slotsCont.innerHTML = '';
        if (slotsMsg) {
            slotsMsg.style.display = 'block';
            slotsMsg.textContent = 'Please choose both a doctor and date to check open slots.';
        }
        return;
    }

    fetchAvailableSlots(doctorId, date);
}

function fetchAvailableSlots(doctorId, date) {
    const loading = document.getElementById('slotsLoading');
    const container = document.getElementById('slotsContainer');
    const message = document.getElementById('slotsMessage');

    loading.style.display = 'block';
    message.style.display = 'none';
    container.innerHTML = '';

    const url = '${pageContext.request.contextPath}/patient/available-slots?doctorId=' + encodeURIComponent(doctorId) + '&date=' + encodeURIComponent(date);

    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network error fetching slots');
            }
            return response.json();
        })
        .then(slots => {
            loading.style.display = 'none';
            if (!slots || slots.length === 0) {
                message.style.display = 'block';
                message.textContent = 'No available appointment slots found for this date. The doctor may be off or fully booked.';
                return;
            }

            slots.forEach((slot, idx) => {
                const item = document.createElement('div');
                item.className = 'slot-item';

                const input = document.createElement('input');
                input.type = 'radio';
                input.id = 'slot_dyn_' + idx;
                input.name = 'startTime';
                input.value = slot;
                input.required = true;

                const label = document.createElement('label');
                label.htmlFor = 'slot_dyn_' + idx;
                label.textContent = slot;

                item.appendChild(input);
                item.appendChild(label);
                container.appendChild(item);
            });
        })
        .catch(err => {
            loading.style.display = 'none';
            message.style.display = 'block';
            message.textContent = 'Select a valid doctor and date to view slots, or contact clinic reception.';
        });
}
</script>

<jsp:include page="../common/footer.jsp" />
