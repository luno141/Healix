/**
 * Healix Healthcare Management System - Core Client JavaScript
 * Version: 1.0.0
 */

(function () {
  'use strict';

  /**
   * Determine application context path from base tag or script src
   */
  function getContextPath() {
    // If context path is defined globally by JSP
    if (window.APP_CONTEXT_PATH !== undefined) {
      return window.APP_CONTEXT_PATH;
    }
    // Fallback: derive from window.location or return empty string
    return '';
  }

  /**
   * Confirmation dialog before executing an action or submitting a form
   * @param {string} message - Message to display in confirm dialog
   * @param {HTMLFormElement|Event} [target] - Optional form element to submit or event to prevent
   * @returns {boolean} True if confirmed, false otherwise
   */
  window.confirmAction = function (message, target) {
    const isConfirmed = window.confirm(message || 'Are you sure you want to proceed?');
    if (!isConfirmed) {
      if (target && typeof target.preventDefault === 'function') {
        target.preventDefault();
      }
      return false;
    }
    if (target && target instanceof HTMLFormElement) {
      target.submit();
    }
    return true;
  };

  /**
   * Displays a temporary alert notification toast
   * @param {string} message - Message text to display
   * @param {string} type - 'success', 'error', 'danger', 'warning', 'info'
   * @param {number} [duration=5000] - Duration in ms before auto-dismiss
   */
  window.showAlert = function (message, type, duration) {
    const alertType = (type === 'error' || type === 'danger') ? 'danger' : (type || 'info');
    const displayDuration = duration !== undefined ? duration : 5000;

    let container = document.getElementById('alert-toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'alert-toast-container';
      container.className = 'alert-toast-container';
      document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `alert alert-${alertType} alert-toast`;
    toast.setAttribute('role', 'alert');

    // Choose appropriate icon
    let iconSvg = '';
    if (alertType === 'success') {
      iconSvg = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>';
    } else if (alertType === 'danger') {
      iconSvg = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
    } else if (alertType === 'warning') {
      iconSvg = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>';
    } else {
      iconSvg = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>';
    }

    toast.innerHTML = `
      <div style="display:flex; align-items:center; gap:0.625rem; flex:1;">
        <span>${iconSvg}</span>
        <div class="alert-content">${escapeHtml(message)}</div>
      </div>
      <button type="button" class="alert-close" aria-label="Close" onclick="this.parentElement.remove()">&times;</button>
    `;

    container.appendChild(toast);

    if (displayDuration > 0) {
      setTimeout(() => {
        toast.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(20px)';
        setTimeout(() => toast.remove(), 400);
      }, displayDuration);
    }
  };

  /**
   * Toggle mobile navigation sidebar and backdrop
   */
  window.toggleMobileMenu = function () {
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');
    if (sidebar) {
      sidebar.classList.toggle('open');
    }
    if (overlay) {
      overlay.classList.toggle('active');
    }
  };

  /**
   * Toggle public navbar links on small screens
   */
  window.togglePublicNav = function () {
    const navLinks = document.querySelector('.nav-links');
    if (navLinks) {
      navLinks.classList.toggle('mobile-open');
    }
  };

  /**
   * Helper to format time strings (e.g., '14:30:00' -> '2:30 PM')
   * @param {string} timeStr - Time in HH:mm or HH:mm:ss format
   * @returns {string} Formatted 12-hour time
   */
  window.formatTime = function (timeStr) {
    if (!timeStr) return '';
    try {
      const parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;
      let hours = parseInt(parts[0], 10);
      const minutes = parts[1];
      const ampm = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      hours = hours ? hours : 12; // 0 hour should be 12
      return `${hours}:${minutes} ${ampm}`;
    } catch (e) {
      return timeStr;
    }
  };

  /**
   * Helper to format date strings (e.g., '2026-10-14' -> 'Oct 14, 2026')
   * @param {string|Date} dateInput - Date string or Date object
   * @returns {string} Formatted date string
   */
  window.formatDate = function (dateInput) {
    if (!dateInput) return '';
    try {
      const d = (dateInput instanceof Date) ? dateInput : new Date(dateInput);
      if (isNaN(d.getTime())) {
        return dateInput;
      }
      return d.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      });
    } catch (e) {
      return String(dateInput);
    }
  };

  /**
   * Helper to escape HTML characters
   */
  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  /**
   * Fetch available appointment slots via AJAX and populate target select element
   * @param {string|number} doctorId - Doctor identifier
   * @param {string} date - Date string in YYYY-MM-DD
   * @param {string} [selectElementId='slotSelect'] - ID of select element to populate
   */
  window.loadAvailableSlots = function (doctorId, date, selectElementId) {
    const targetId = selectElementId || 'slotSelect';
    const select = document.getElementById(targetId) || document.querySelector('select[name="slot"]') || document.querySelector('select[name="startTime"]');

    if (!select) {
      console.warn('Target select element not found for loadAvailableSlots: ' + targetId);
      return;
    }

    if (!doctorId || !date) {
      select.innerHTML = '<option value="">-- Select doctor and date first --</option>';
      select.disabled = true;
      return;
    }

    select.disabled = true;
    select.innerHTML = '<option value="">Loading available slots...</option>';

    const contextPath = getContextPath();
    const endpoint = `${contextPath}/patient/available-slots?doctorId=${encodeURIComponent(doctorId)}&date=${encodeURIComponent(date)}`;

    fetch(endpoint, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
      .then(response => {
        if (!response.ok) {
          throw new Error('Failed to fetch slots from server (HTTP ' + response.status + ')');
        }
        return response.json();
      })
      .then(slots => {
        select.innerHTML = '';
        if (!Array.isArray(slots) || slots.length === 0) {
          select.innerHTML = '<option value="">No available slots for this date</option>';
          select.disabled = true;
          return;
        }

        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = '-- Choose a time slot --';
        select.appendChild(defaultOption);

        slots.forEach(slot => {
          const option = document.createElement('option');
          // Support slot as string "09:00:00" or object {startTime: "09:00:00", endTime: "09:30:00"}
          if (typeof slot === 'string') {
            option.value = slot;
            option.textContent = window.formatTime(slot);
          } else if (typeof slot === 'object' && slot !== null) {
            const start = slot.startTime || slot.start || slot.time || '';
            const end = slot.endTime || slot.end || '';
            option.value = start;
            if (end) {
              option.textContent = `${window.formatTime(start)} - ${window.formatTime(end)}`;
            } else {
              option.textContent = window.formatTime(start);
            }
          }
          select.appendChild(option);
        });

        select.disabled = false;
      })
      .catch(error => {
        console.error('Error fetching available slots:', error);
        select.innerHTML = '<option value="">Error loading slots. Please retry.</option>';
        select.disabled = true;
        if (window.showAlert) {
          window.showAlert('Could not load appointment slots. Please try again.', 'error');
        }
      });
  };

  /**
   * DOM Ready Initializations
   */
  document.addEventListener('DOMContentLoaded', function () {
    // 1. Auto-dismiss existing alert messages after 5 seconds
    const existingAlerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    existingAlerts.forEach(function (alertEl) {
      setTimeout(function () {
        alertEl.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        alertEl.style.opacity = '0';
        alertEl.style.transform = 'translateY(-6px)';
        setTimeout(function () {
          alertEl.remove();
        }, 500);
      }, 5000);
    });

    // 2. Alert close button listener for static alerts
    document.addEventListener('click', function (e) {
      if (e.target && (e.target.classList.contains('alert-close') || e.target.closest('.alert-close'))) {
        const btn = e.target.classList.contains('alert-close') ? e.target : e.target.closest('.alert-close');
        const alertBox = btn.closest('.alert');
        if (alertBox) {
          alertBox.remove();
        }
      }
    });

    // 3. Mobile sidebar overlay click outside to close
    const overlay = document.querySelector('.sidebar-overlay');
    if (overlay) {
      overlay.addEventListener('click', function () {
        window.toggleMobileMenu();
      });
    }

    // 4. Close mobile sidebar on Escape key
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') {
        const sidebar = document.querySelector('.sidebar.open');
        if (sidebar) {
          window.toggleMobileMenu();
        }
      }
    });

    // 5. Automatic client-side validation for password match on registration forms
    const registerForm = document.querySelector('form[action*="register"]');
    if (registerForm) {
      registerForm.addEventListener('submit', function (e) {
        const pwd = registerForm.querySelector('input[name="password"]');
        const confirmPwd = registerForm.querySelector('input[name="confirmPassword"]');
        if (pwd && confirmPwd && pwd.value !== confirmPwd.value) {
          e.preventDefault();
          window.showAlert('Passwords do not match. Please verify.', 'danger');
          confirmPwd.focus();
        }
      });
    }
  });

})();
