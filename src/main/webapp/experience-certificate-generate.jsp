<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Experience Certificate Request</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome (6.x, same as the other pages and the sidebar) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Same palette as the side nav and the other pages */
            --primary-color: #16697a;
            --primary-dark: #0e3d47;
            --secondary-color: #489fb5;
            --accent-color: #82c0cc;
            --highlight-color: #ffa62b;
            --background-light: #f0f5f7;
            --surface-color: #ffffff;
            --text-color: #24343d;
            --muted-color: #64777f;
            --border-color: #dfe8ec;
            --card-shadow: rgba(22, 105, 122, 0.10);
            --success-color: #2f9e6f;
            --danger-color: #d64545;

            --radius: 12px;
            --space-1: 8px;
            --space-2: 16px;
            --space-3: 24px;

            /* Sidebar widths (collapsed state is switched in sidebar.jsp) */
            --sidebar-width: 250px;
            --sidebar-width-collapsed: 72px;
        }

        * { box-sizing: border-box; }

        body, html {
            min-height: 100%;
            margin: 0;
        }

        body {
            display: flex;
            flex-direction: row;
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            background:
                radial-gradient(circle at top right, rgba(22, 105, 122, 0.07), transparent 45%),
                var(--background-light);
        }

        /* ---- Page shell: sits to the right of the fixed sidebar ---- */
        .main-wrapper {
            flex: 1;
            min-width: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin-left: var(--sidebar-width);
            width: calc(100% - var(--sidebar-width));
            transition: margin-left 0.25s ease, width 0.25s ease;
        }

        .content-container {
            padding: var(--space-3);
            flex: 1;
            max-width: 1000px;
            margin: 0 auto;
            width: 100%;
        }

        /* ---- Header banner ---- */
        .header {
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: var(--radius);
            margin-bottom: var(--space-2);
            padding: var(--space-2) var(--space-3);
            box-shadow: 0 6px 18px rgba(22, 105, 122, 0.22);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: "";
            position: absolute;
            top: -50px;
            right: -30px;
            width: 180px;
            height: 180px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .header > * { position: relative; }

        .header img {
            border-radius: 50%;
            border: 2px solid var(--accent-color);
        }

        .header h3 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.25rem;
        }

        .header p { opacity: 0.85; font-size: 0.9rem; }

        /* ---- Breadcrumb ---- */
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin: 0 0 var(--space-2);
        }

        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .breadcrumb-item a:hover { color: var(--primary-dark); text-decoration: underline; }

        .breadcrumb-item.active {
            color: var(--text-color);
            font-weight: 600;
            font-size: 0.9rem;
        }

        /* ---- Certificate card ---- */
        .certificate-container {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            box-shadow: 0 6px 24px var(--card-shadow);
            padding: 32px 36px;
            border: 1px solid var(--border-color);
            border-top: 4px solid var(--secondary-color);
        }

        .certificate-header {
            text-align: center;
            padding-bottom: var(--space-3);
            margin-bottom: var(--space-3);
            border-bottom: 1px dashed var(--border-color);
        }

        .certificate-header p { margin: 0; color: var(--muted-color); font-size: 0.9rem; }

        .form-title {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            letter-spacing: 0.03em;
            color: var(--primary-color);
            font-size: 1.35rem;
            margin-bottom: 4px;
        }

        /* Section headings inside the form */
        .form-section-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            font-size: 1rem;
            color: var(--primary-color);
            margin: var(--space-3) 0 var(--space-2);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .form-section-title:first-of-type { margin-top: 0; }

        .form-section-title i {
            width: 34px;
            height: 34px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: rgba(22, 105, 122, 0.10);
            color: var(--primary-color);
            font-size: 0.95rem;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--text-color);
            margin-bottom: 6px;
        }

        .required-mark { color: var(--danger-color); }

        .form-control, .form-select {
            border-radius: 10px;
            border: 1.5px solid var(--border-color);
            padding: 10px 14px;
            font-size: 0.92rem;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            background-color: #fbfdfe;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 4px rgba(72, 159, 181, 0.20);
            background-color: #fff;
            outline: none;
        }

        .field-icon-wrap { position: relative; }

        .field-icon-wrap i.field-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
            font-size: 0.9rem;
            pointer-events: none;
        }

        .field-icon-wrap .form-control,
        .field-icon-wrap .form-select { padding-left: 38px; }

        textarea.form-control { resize: vertical; }

        /* ---- Buttons ---- */
        .form-actions {
            border-top: 1px dashed var(--border-color);
            margin-top: var(--space-3);
            padding-top: var(--space-3);
        }

        .btn-generate {
            border-radius: 999px;
            padding: 11px 32px;
            font-weight: 600;
            letter-spacing: 0.02em;
            border: none;
            color: #fff;
            background: linear-gradient(135deg, var(--success-color), #23815a);
            box-shadow: 0 6px 16px rgba(47, 158, 111, 0.28);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-generate:hover {
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 10px 22px rgba(47, 158, 111, 0.35);
        }

        .btn-outline-danger {
            border-radius: 999px;
            padding: 11px 26px;
            font-weight: 600;
            border-width: 1.5px;
        }

        .btn-outline-danger:hover { transform: translateY(-2px); }

        /* ---- Footer ---- */
        .footer {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            font-size: 14px;
            padding: var(--space-3);
            margin-top: auto;
        }

        .footer a {
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .footer a:hover { color: var(--highlight-color); }

        /* ---- Small screens ---- */
        @media (max-width: 768px) {
            .main-wrapper { margin-left: 0; width: 100%; }
            .content-container { padding: 68px var(--space-2) var(--space-2); }
            .certificate-container { padding: 22px 18px; }
            .header { padding: 14px var(--space-2); }
            .footer { padding: var(--space-2); }
        }
    </style>
</head>
<body>
    <!-- Highlight "Employees > Experience Certificate" in the side nav -->
    <c:set var="currentPage" value="employees" scope="request" />
    <c:set var="currentSubPage" value="certificate" scope="request" />
    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper" id="main-wrapper">
        <!-- Content Container -->
        <div class="content-container">

            <!-- Header -->
            <jsp:useBean id="now" class="java.util.Date" />
            <div class="header d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div class="d-flex align-items-center">
                    <img src="img/logo.jpg" alt="Logo" class="me-3" style="width: 50px; height: 50px; object-fit: cover;">
                    <div>
                        <h3 class="mb-0 fw-bold">Experience Certificate Request</h3>
                        <p class="mb-0"><fmt:formatDate value="${now}" pattern="MMMM d, yyyy" /></p>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <a href="contractor-dashboard.jsp" class="btn btn-link text-light" title="Back to Dashboard">
                        <i class="fas fa-home me-2"></i> Dashboard
                    </a>
                </div>
            </div>

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="contractor-dashboard.jsp">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/hr">Human Resources</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Experience Certificate Request</li>
                </ol>
            </nav>

            <!-- Main Certificate Request Form -->
            <div class="certificate-container">
                <div class="certificate-header">
                    <h4 class="form-title">EXPERIENCE CERTIFICATE REQUEST FORM</h4>
                    <p>Please fill out the form with accurate information to generate the experience certificate</p>
                </div>

                <form action="print-experience-certificate" method="get" id="certificateForm">

                    <div class="form-section-title"><i class="fas fa-id-card"></i> Employee Details</div>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="name" class="form-label">Employee Full Name <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-user field-icon"></i>
                                <input type="text" class="form-control" id="name" name="name" placeholder="Enter full name" required>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="employeeId" class="form-label">Employee ID <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-hashtag field-icon"></i>
                                <input type="text" class="form-control" id="employeeId" name="employeeId" placeholder="e.g., EMP12345" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="designation" class="form-label">Designation <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-user-tag field-icon"></i>
                                <input type="text" class="form-control" id="designation" name="designation" placeholder="e.g., Software Engineer" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-calendar-alt"></i> Employment Period</div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="joinDate" class="form-label">Date of Joining <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-calendar-plus field-icon"></i>
                                <input type="date" class="form-control" id="joinDate" name="joinDate" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="releaseDate" class="form-label">Date of Release <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-calendar-minus field-icon"></i>
                                <input type="date" class="form-control" id="releaseDate" name="releaseDate" required>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="department" class="form-label">Department <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-building field-icon"></i>
                                <input type="text" class="form-control" id="department" name="department" placeholder="e.g., Information Technology" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email Address <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-envelope field-icon"></i>
                                <input type="email" class="form-control" id="email" name="email" placeholder="e.g., johndoe@example.com" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-briefcase"></i> Work Summary</div>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="projectsWorked" class="form-label">Projects Worked On</label>
                            <textarea class="form-control" id="projectsWorked" name="projectsWorked" rows="3" placeholder="List major projects and responsibilities"></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="skills" class="form-label">Skills &amp; Technologies</label>
                            <textarea class="form-control" id="skills" name="skills" rows="3" placeholder="e.g., Java, SQL, JavaScript, React, etc."></textarea>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-certificate"></i> Certificate Details</div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="performance" class="form-label">Performance Rating <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-star field-icon"></i>
                                <select class="form-select" id="performance" name="performance" required>
                                    <option value="" disabled>Select Rating</option>
                                    <option value="Outstanding">Outstanding</option>
                                    <option value="Excellent">Excellent</option>
                                    <option value="Very Good" selected>Very Good</option>
                                    <option value="Good">Good</option>
                                    <option value="Satisfactory">Satisfactory</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="certificateType" class="form-label">Certificate Type <span class="required-mark">*</span></label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-file-alt field-icon"></i>
                                <select class="form-select" id="certificateType" name="certificateType" required>
                                    <option value="" disabled>Select Type</option>
                                    <option value="Standard" selected>Standard Experience Certificate</option>
                                    <option value="Detailed">Detailed Experience Certificate</option>
                                    <option value="Recommendation">Recommendation Letter</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="remarks" class="form-label">Additional Remarks</label>
                            <textarea class="form-control" id="remarks" name="remarks" rows="3" placeholder="Any specific achievements or comments to be included"></textarea>
                        </div>
                    </div>

                    <div class="row form-actions">
                        <div class="col-md-12 text-center">
                            <button type="submit" class="btn btn-generate me-3">
                                <i class="fas fa-certificate me-2"></i>Generate Certificate
                            </button>

                            <button type="reset" class="btn btn-outline-danger">
                                <i class="fas fa-undo me-2"></i>Reset Form
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer (inside the wrapper so it lines up with the content, not under the sidebar) -->
        <footer class="footer">
            <div class="container-fluid">
                <div class="row justify-content-between align-items-center gy-2">
                    <div class="col-md-6">
                        <p class="mb-0">&copy; 2025 Titanium Contractor Operations Hub. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <ul class="list-unstyled mb-0">
                            <li class="d-inline-block me-3">
                                <a href="/privacy"><i class="fas fa-shield-alt me-1"></i>Privacy Policy</a>
                            </li>
                            <li class="d-inline-block me-3">
                                <a href="/terms"><i class="fas fa-file-contract me-1"></i>Terms of Service</a>
                            </li>
                            <li class="d-inline-block">
                                <a href="/contact"><i class="fas fa-envelope me-1"></i>Contact Us</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>
    </div>

    <!-- Bootstrap JS (needed by the sidebar submenus) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        // The sidebar (open/close, submenus, mobile drawer) is handled entirely inside sidebar.jsp.
        $(document).ready(function () {

            // Release date can't be earlier than the joining date
            $('#joinDate').on('change', function () {
                $('#releaseDate').attr('min', $(this).val());
            });

            $('#certificateForm').on('submit', function (event) {
                if (!validateForm()) {
                    event.preventDefault();
                }
            });

            function validateForm() {
                var joinDate = new Date($('#joinDate').val());
                var releaseDate = new Date($('#releaseDate').val());

                if (joinDate >= releaseDate) {
                    alert('Release date must be after the join date');
                    return false;
                }

                var email = $('#email').val();
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    alert('Please enter a valid email address');
                    return false;
                }

                return true;
            }
        });
    </script>
</body>
</html>
