<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP - Employee Registration</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Same palette as the side nav and the attendance page */
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
            --light-color: #f5f7fa;
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

        .erp-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: var(--space-2) var(--space-3);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
        }

        .erp-header h1 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        .content-container {
            padding: var(--space-3);
            flex: 1;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        /* ---- Top card (logo, date, notifications) ---- */
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

        /* ---- Registration card ---- */
        .registration-container {
            background: var(--surface-color);
            border-radius: var(--radius);
            box-shadow: 0 6px 24px var(--card-shadow);
            padding: 32px 36px;
            border: 1px solid var(--border-color);
            border-top: 4px solid var(--secondary-color);
        }

        .registration-header {
            text-align: center;
            padding-bottom: var(--space-3);
            margin-bottom: var(--space-3);
            border-bottom: 1px dashed var(--border-color);
        }

        .registration-header .form-title {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            letter-spacing: 0.03em;
            color: var(--primary-color);
            font-size: 1.35rem;
            margin-bottom: 4px;
        }

        .registration-header p { margin: 0; color: var(--muted-color); font-size: 0.9rem; }

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

        /* ---- File upload ---- */
        .image-upload-container {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: var(--space-2);
            background: #fbfdfe;
            border: 1.5px dashed var(--accent-color);
            border-radius: var(--radius);
            padding: var(--space-2) 20px;
            transition: border-color 0.2s ease, background 0.2s ease;
        }

        .image-upload-container:hover {
            border-color: var(--secondary-color);
            background: #f1f8fa;
        }

        .image-upload-container .btn-outline-secondary {
            border-radius: 999px;
            border-color: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 600;
            padding: 8px 20px;
            font-size: 0.85rem;
            margin: 0;
        }

        .image-upload-container .btn-outline-secondary:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: #fff;
        }

        #file-name {
            font-size: 0.85rem;
            color: var(--text-color);
            font-weight: 500;
        }

        .image-preview-container { display: flex; align-items: center; }

        .image-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid var(--accent-color);
        }

        /* ---- Buttons ---- */
        .form-actions {
            border-top: 1px dashed var(--border-color);
            margin-top: var(--space-3);
            padding-top: var(--space-3);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        #btnSubmit, #btnUpdate {
            border-radius: 999px;
            padding: 11px 32px;
            font-weight: 600;
            letter-spacing: 0.02em;
            box-shadow: 0 6px 16px rgba(22, 105, 122, 0.25);
            border: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        #btnSubmit { background: linear-gradient(135deg, var(--secondary-color), var(--primary-color)); }
        #btnUpdate { background: linear-gradient(135deg, var(--success-color), #23815a); }

        #btnSubmit:hover, #btnUpdate:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 22px rgba(22, 105, 122, 0.32);
        }

        .btn-outline-danger {
            border-radius: 999px;
            padding: 11px 26px;
            font-weight: 600;
        }

        /* ---- Footer ---- */
        .footer {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            font-size: 14px;
            padding: var(--space-3) var(--space-3);
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
            .erp-header { padding-left: 68px; }
            .content-container { padding: var(--space-2); }
            .registration-container { padding: 22px 18px; }
            .header { padding: 14px var(--space-2); }
            .footer { padding: var(--space-2); }
        }
    </style>
</head>
<body>
    <!-- Highlight "Employees > Registration" in the side nav -->
    <c:set var="currentPage" value="employees" scope="request" />
    <c:set var="currentSubPage" value="registration" scope="request" />
    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper" id="main-wrapper">
        <!-- Header -->
        <header class="erp-header">
            <div class="container-fluid">
                <h1><i class="fas fa-users-cog me-2"></i>Employee Management System</h1>
            </div>
        </header>

        <!-- Main Content Area -->
        <div class="content-container">
            <!-- Top card -->
            <jsp:useBean id="now" class="java.util.Date" />
            <div class="header d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div class="d-flex align-items-center">
                    <img src="img/logo.jpg" alt="Logo" class="me-3" style="width: 50px; height: 50px; object-fit: cover;">
                    <div>
                        <h3 class="mb-0 fw-bold">Employee Registration</h3>
                        <p class="mb-0"><fmt:formatDate value="${now}" pattern="MMMM d, yyyy" /></p>
                    </div>
                </div>
                <div class="d-flex align-items-center">
                    <button type="button" class="btn btn-link text-light me-2" id="notifications-btn" title="Notifications">
                        <i class="fas fa-bell me-2"></i>
                        <span class="badge rounded-circle bg-danger">3</span>
                    </button>
                    <a href="/logout" class="btn btn-link text-light" title="Logout">
                        <i class="fas fa-sign-out-alt me-2"></i> Logout
                    </a>
                </div>
            </div>

            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="contractor-dashboard.jsp">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/employees">Human Resources</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Employee Registration</li>
                </ol>
            </nav>

            <!-- Registration Form -->
            <div class="registration-container">
                <div class="registration-header">
                    <h4 class="form-title">EMPLOYEE REGISTRATION FORM</h4>
                    <p>Please fill out the form with employee information</p>
                </div>

                <form action="submit-employee-details" id="myForm" method="POST" enctype="multipart/form-data">
                    <input type="hidden" id="userId" name="userId" value='<c:if test="${not empty editEmpList}">${editEmpList.userId}</c:if><c:if test="${empty editEmpList}">0</c:if>'>

                    <div class="form-section-title"><i class="fas fa-id-card"></i> Personal Information</div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="name" class="form-label">Full Name</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-user field-icon"></i>
                                <input type="text" id="name" name="name" value="${editEmpList.userName}" class="form-control" placeholder="Enter full name">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="aadhar" class="form-label">Aadhaar Number</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-address-card field-icon"></i>
                                <input type="text" id="aadhar" name="aadhar" value="${editEmpList.adhaarNo}" class="form-control" placeholder="Enter Aadhaar number">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="dob" class="form-label">Date of Birth</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-birthday-cake field-icon"></i>
                                <input type="date" id="dob" name="dob" value="${editEmpList.dateOfBirth}" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="mobile" class="form-label">Mobile Number</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-phone field-icon"></i>
                                <input type="text" id="mobile" name="mobile" value="${editEmpList.mobileNo}" class="form-control" placeholder="Enter mobile number">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-envelope field-icon"></i>
                                <input type="email" id="email" name="email" value="${editEmpList.emailId}" class="form-control" placeholder="Enter email address">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="contractorName" class="form-label">Contractor Name</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-hard-hat field-icon"></i>
                                <select id="contractorName" name="contractorName" class="form-control">
                                    <option value="">Select Contractor</option>
                                    <c:forEach var="contractor" items="${contractorList}">
                                        <option value="${contractor.contractorId}">
                                            ${contractor.contractorName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-briefcase"></i> Employment &amp; Statutory Details</div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="role" class="form-label">Employee Role</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-user-tag field-icon"></i>
                                <select id="role" name="role" class="form-control">
                                    <option value="">Select Role</option>
                                    <c:forEach var="role" items="${roleList}">
                                        <option value="${role.roleId}">
                                            ${role.roleName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="code" class="form-label">Code No</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-hashtag field-icon"></i>
                                <input type="text" id="code" name="code" value="${editEmpList.codeNo}" class="form-control" placeholder="Enter code number">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="esi" class="form-label">ESI</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-file-medical field-icon"></i>
                                <input type="text" id="esi" name="esi" value="${editEmpList.esiNo}" class="form-control" placeholder="Enter ESI number">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="uan" class="form-label">UAN Number</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-fingerprint field-icon"></i>
                                <input type="text" id="uan" name="uan" value="${editEmpList.uanNo}" class="form-control" placeholder="Enter UAN number">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="pf" class="form-label">PF Number</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-piggy-bank field-icon"></i>
                                <input type="text" id="pf" name="pf" value="${editEmpList.pfNo}" class="form-control" placeholder="Enter PF number">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="pcc" class="form-label">PCC Number</label>
                            <div class="field-icon-wrap">
                                <i class="fas fa-file-signature field-icon"></i>
                                <input type="text" id="pcc" name="pcc" value="${editEmpList.pccNo}" class="form-control" placeholder="Enter PCC number">
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-camera"></i> Documents &amp; Photo</div>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label for="customFile" class="form-label">Profile Photo</label>
                            <div class="image-upload-container">
                                <input type="file" id="customFile" name="customFile"
                                       class="form-control"
                                       accept="image/*,.pdf"
                                       onchange="previewImage(event)"
                                       style="display:none;">
                                <label for="customFile" class="btn btn-outline-secondary">
                                    <i class="fas fa-upload me-1"></i> Choose File
                                </label>
                                <span id="file-name">No file chosen</span>
                                <div class="image-preview-container">
                                    <img id="preview-image" class="image-preview" alt="Preview" style="display: none;">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row form-actions">
                        <div class="col-md-12 text-center">
                            <c:choose>
                                <c:when test="${empty editEmpList}">
                                    <button type="submit" id="btnSubmit" class="btn btn-primary me-3">
                                        <i class="fas fa-paper-plane me-1"></i> Submit Registration
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" id="btnUpdate" class="btn btn-success me-3">
                                        <i class="fas fa-save me-1"></i> Update Details
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <button type="reset" class="btn btn-outline-danger" onclick="resetForm()">
                                <i class="fas fa-undo me-2"></i> Reset Form
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

    <!-- Toast -->
    <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 11000;">
        <div id="employeeToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="toastMessage"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Flash message from the session (read once, then removed) -->
    <c:if test="${not empty sessionScope.message}">
        <div id="flashData" hidden
             data-message="<c:out value='${sessionScope.message}' />"
             data-ok="${sessionScope.req_status == true}"></div>
        <c:remove var="message" scope="session" />
        <c:remove var="req_status" scope="session" />
    </c:if>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        // The sidebar (open/close, submenus, mobile drawer) is handled entirely inside sidebar.jsp.
        $(document).ready(function () {
            var flash = document.getElementById('flashData');
            if (flash) {
                var ok = flash.getAttribute('data-ok') === 'true';
                var toastEl = $('#employeeToast');
                $('#toastMessage').text(flash.getAttribute('data-message'));
                toastEl.toggleClass('bg-success', ok).toggleClass('bg-danger', !ok);
                new bootstrap.Toast(toastEl[0]).show();
            }
        });

        // Preview image function
        function previewImage(event) {
            var file = event.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var preview = document.getElementById('preview-image');
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    document.getElementById('file-name').textContent = file.name;
                };
                reader.readAsDataURL(file);
            }
        }

        // Reset form function
        function resetForm() {
            document.getElementById('myForm').reset();
            document.getElementById('preview-image').style.display = 'none';
            document.getElementById('file-name').textContent = 'No file chosen';
        }
    </script>
</body>
</html>
