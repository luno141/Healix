<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | Healix Healthcare</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --badge-bg: #e0f2fe;
            --badge-text: #0369a1;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .error-card {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 1rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
            max-width: 520px;
            width: 100%;
            padding: 2.5rem;
            text-align: center;
        }
        .brand {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.75rem;
            color: var(--primary);
            font-weight: 700;
            font-size: 1.5rem;
            text-decoration: none;
        }
        .brand svg {
            width: 32px;
            height: 32px;
            fill: none;
            stroke: currentColor;
            stroke-width: 2.25;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .status-badge {
            display: inline-block;
            background-color: var(--badge-bg);
            color: var(--badge-text);
            font-size: 0.875rem;
            font-weight: 600;
            padding: 0.35rem 0.85rem;
            border-radius: 9999px;
            margin-bottom: 1rem;
            letter-spacing: 0.025em;
        }
        .error-code {
            font-size: 4.5rem;
            font-weight: 800;
            line-height: 1;
            color: var(--text-main);
            margin-bottom: 0.75rem;
        }
        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 0.75rem;
        }
        .error-desc {
            font-size: 0.975rem;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 2rem;
        }
        .action-group {
            display: flex;
            gap: 0.75rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-size: 0.95rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .btn-primary {
            background-color: var(--primary);
            color: #ffffff;
            border: 1px solid var(--primary);
        }
        .btn-primary:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
        }
        .btn-secondary {
            background-color: #ffffff;
            color: var(--text-main);
            border: 1px solid var(--border);
        }
        .btn-secondary:hover {
            background-color: #f1f5f9;
        }
        .footer-text {
            margin-top: 2rem;
            font-size: 0.825rem;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
    <div class="error-card">
        <a href="${pageContext.request.contextPath}/" class="brand">
            <svg viewBox="0 0 24 24">
                <path d="M12 2v20M2 12h20M7 7l10 10M17 7l-10 10" />
            </svg>
            <span>Healix</span>
        </a>
        <br>
        <span class="status-badge">Error 404</span>
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-desc">
            The page or clinical resource you are attempting to reach does not exist, has been moved, or is temporarily unavailable.
        </p>
        <div class="action-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Back to Home</a>
            <button onclick="window.history.back()" class="btn btn-secondary">Go Back</button>
        </div>
    </div>
    <div class="footer-text">
        &copy; 2026 Healix Healthcare Management System. All rights reserved.
    </div>
</body>
</html>
