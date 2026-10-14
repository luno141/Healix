<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Smart Healthcare Management" scope="request" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<main class="main-content">
    <!-- ================= HERO SECTION ================= -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-grid">
                <div class="hero-content">
                    <div class="hero-badge">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        Next-Generation Clinical Care
                    </div>
                    <h1 class="hero-title">
                        Precision Healthcare, <span>Seamlessly Connected.</span>
                    </h1>
                    <p class="hero-subtitle">
                        Healix unites patients, certified medical practitioners, and clinical administrators into a unified digital ecosystem. Book consultations, track diagnostic histories, and receive world-class care without friction.
                    </p>

                    <div class="hero-actions">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/${sessionScope.role}/dashboard" class="btn btn-primary btn-lg">
                                    Go to Dashboard
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg">
                                    Get Started Free
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg">
                                    Sign In
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="hero-stats">
                        <div>
                            <div class="hero-stat-number">50+</div>
                            <div class="hero-stat-label">Certified Specialists</div>
                        </div>
                        <div>
                            <div class="hero-stat-number">15,000+</div>
                            <div class="hero-stat-label">Consultations Done</div>
                        </div>
                        <div>
                            <div class="hero-stat-number">99.4%</div>
                            <div class="hero-stat-label">Patient Satisfaction</div>
                        </div>
                    </div>
                </div>

                <div class="hero-visual">
                    <!-- Interactive Sample Preview Cards -->
                    <div class="hero-card-preview">
                        <div class="stat-icon primary">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <div style="flex: 1;">
                            <div style="font-weight: 700; font-size: 0.9375rem; color: var(--text-main);">Dr. Sarah Jenkins, MD</div>
                            <div style="font-size: 0.8125rem; color: var(--text-muted);">Cardiology Specialist</div>
                        </div>
                        <span class="badge badge-confirmed">Confirmed</span>
                    </div>

                    <div class="hero-card-preview">
                        <div class="stat-icon secondary">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        </div>
                        <div style="flex: 1;">
                            <div style="font-weight: 700; font-size: 0.9375rem; color: var(--text-main);">Automated Slot Match</div>
                            <div style="font-size: 0.8125rem; color: var(--text-muted);">Zero Double-Bookings Guarantee</div>
                        </div>
                        <span class="badge badge-completed">Verified</span>
                    </div>

                    <div class="hero-card-preview">
                        <div class="stat-icon accent">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        </div>
                        <div style="flex: 1;">
                            <div style="font-weight: 700; font-size: 0.9375rem; color: var(--text-main);">Clinical Rating: 4.9 / 5.0</div>
                            <div class="star-rating">
                                <span class="star filled">&#9733;</span>
                                <span class="star filled">&#9733;</span>
                                <span class="star filled">&#9733;</span>
                                <span class="star filled">&#9733;</span>
                                <span class="star filled">&#9733;</span>
                                <span class="star-rating-text">(1,420 Reviews)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ================= FEATURES SECTION ================= -->
    <section id="features" class="features-section">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">Platform Capabilities</span>
                <h2 class="section-title">Designed for Seamless Healthcare</h2>
                <p class="section-subtitle">
                    Engineered to streamline appointments, clinical operations, and health record management with maximum security and ease.
                </p>
            </div>

            <div class="features-grid">
                <!-- Feature 1 -->
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </div>
                    <h3 class="feature-title">Online Appointments</h3>
                    <p class="feature-desc">
                        Instantly check physician availability and schedule visits with real-time conflict detection and instant status updates.
                    </p>
                </div>

                <!-- Feature 2 -->
                <div class="feature-card">
                    <div class="feature-icon" style="background-color: var(--secondary-light); color: var(--secondary);">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="8.5" cy="7" r="4"></circle>
                            <polyline points="17 11 19 13 23 9"></polyline>
                        </svg>
                    </div>
                    <h3 class="feature-title">Expert Doctors</h3>
                    <p class="feature-desc">
                        Connect with accredited medical professionals across diverse specialties with complete bios, qualifications, and consultation rates.
                    </p>
                </div>

                <!-- Feature 3 -->
                <div class="feature-card">
                    <div class="feature-icon" style="background-color: var(--accent-light); color: var(--accent);">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                        </svg>
                    </div>
                    <h3 class="feature-title">Medical Records</h3>
                    <p class="feature-desc">
                        Maintain comprehensive diagnostic histories, treatment prescriptions, and physician notes securely stored in digital format.
                    </p>
                </div>

                <!-- Feature 4 -->
                <div class="feature-card">
                    <div class="feature-icon" style="background-color: #EDE9FE; color: #7C3AED;">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                        </svg>
                    </div>
                    <h3 class="feature-title">24/7 Support & Care</h3>
                    <p class="feature-desc">
                        Our round-the-clock infrastructure ensures your appointment requests and medical inquiries are managed with urgency and reliability.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- ================= ABOUT SECTION ================= -->
    <section id="about" class="about-section">
        <div class="container">
            <div class="about-grid">
                <div>
                    <span class="section-badge">About Healix</span>
                    <h2 class="section-title">Built for Modern Medical Workflows</h2>
                    <p style="color: var(--text-muted); margin-bottom: 1.25rem;">
                        Healix was established to modernize clinical administration and empower patients with direct, transparent access to their healthcare providers. From real-time calendar scheduling to secure record archives, Healix simplifies complex medical routines.
                    </p>
                    
                    <div class="about-checklist">
                        <div class="about-checklist-item">
                            <div class="about-checklist-icon">&#10003;</div>
                            <span>Zero-conflict dynamic scheduling with automated slot allocation</span>
                        </div>
                        <div class="about-checklist-item">
                            <div class="about-checklist-icon">&#10003;</div>
                            <span>Enterprise-grade security with encrypted credential authentication</span>
                        </div>
                        <div class="about-checklist-item">
                            <div class="about-checklist-icon">&#10003;</div>
                            <span>Dedicated portals customized for Patients, Physicians, and System Admins</span>
                        </div>
                        <div class="about-checklist-item">
                            <div class="about-checklist-icon">&#10003;</div>
                            <span>Transparent rating and review system to build genuine patient trust</span>
                        </div>
                    </div>

                    <div style="margin-top: 2rem;">
                        <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline">
                            Explore Doctor Directory
                        </a>
                    </div>
                </div>

                <div>
                    <div class="card" style="margin-bottom: 0;">
                        <div class="card-header">
                            <h3 class="card-title">Our Clinical Promise</h3>
                        </div>
                        <div class="card-body">
                            <p style="font-size: 0.9375rem; color: var(--text-muted); line-height: 1.7;">
                                "Healthcare is not merely an industry; it is a sacred covenant of trust between doctors and patients. Healix eliminates bureaucratic bottlenecks, long waiting queues, and scattered paperwork so medical teams can focus entirely on patient healing."
                            </p>
                            <div style="margin-top: 1.5rem; display: flex; align-items: center; gap: 1rem;">
                                <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--primary); color: #FFF; display: flex; align-items: center; justify-content: center; font-weight: 700;">
                                    HX
                                </div>
                                <div>
                                    <div style="font-weight: 700; color: var(--text-main);">Healix Clinical Advisory Board</div>
                                    <div style="font-size: 0.8125rem; color: var(--text-muted);">Committed to Digital Health Excellence</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CTA Banner Inside About -->
            <div class="cta-banner">
                <h2 class="cta-title">Ready to Experience Modern Healthcare?</h2>
                <p class="cta-subtitle">
                    Register in less than two minutes and schedule your next appointment with leading healthcare specialists.
                </p>
                <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-lg">
                        Create Patient Account
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg" style="color: #FFFFFF; border-color: #FFFFFF;">
                        Sign In to Healix
                    </a>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="common/footer.jsp" />
