<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <c:if test="${empty hideFooterCopyright || !hideFooterCopyright}">
        <footer class="site-copyright-footer" style="text-align: center; padding: 1.25rem; font-size: 0.8125rem; color: var(--text-muted); border-top: 1px solid var(--border-color); background-color: #FFFFFF;">
            <p style="margin: 0;">&copy; 2026 <strong>Healix Healthcare</strong>. All rights reserved. Transforming patient care with digital excellence.</p>
        </footer>
    </c:if>

    <!-- Global Floating Toast Container -->
    <div id="alert-toast-container" class="alert-toast-container" aria-live="polite" aria-atomic="true"></div>

    <!-- Application Core Script -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
