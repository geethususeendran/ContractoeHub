<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petty Contractor's Bill - Titanium Operations Hub</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Tempus Dominus DateTimePicker CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.39.0/css/tempusdominus-bootstrap-4.min.css">

    <style>
        :root {
            /* Professional Color Palette */
             --primary-color: #16697a;       /* Deep teal */
            --secondary-color: #489fb5;     /* Lighter teal */
            --accent-color: #82c0cc;        /* Soft teal accent */
            --background-light: #f8f9fa;    /* Very light gray */
            --text-color: #2c3e50;          /* Dark slate gray */
            --card-shadow: rgba(0, 0, 0, 0.1);
            --highlight-color: #ffa62b;     /* Warm orange for highlights */
            --success-color: #2ecc71;       /* Bright green */
            --danger-color: #e74c3c;        /* Bright red */
            --warning-color: #f39c12;       /* Warm orange */
        }

        body {
            background-color: var(--background-light);
            font-family: 'Inter', 'Segoe UI', 'Arial', sans-serif;
            color: var(--text-color);
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .sidebar {
            height: 100vh;
           background: linear-gradient(135deg, var(--primary-color), #0e3d47);
            color: white;
            padding-top: 20px;
            position: fixed;
            left: 0;
            top: 0;
            box-shadow: 4px 0 15px var(--card-shadow);
            z-index: 1000;
            width: 250px;
            overflow-y: auto;
            transition: all 0.3s ease;
        }
        
        .sidebar-collapsed {
            width: 70px;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 20px;
            background-color: var(--background-light);
            flex-grow: 1;
            min-height: calc(100vh - 140px);
            transition: all 0.3s ease;
        }
        
        .main-content-expanded {
            margin-left: 70px;
        }

        .sidebar .text-center img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid var(--accent-color);
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.85);
            padding: 12px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255,255,255,0.15);
        }
        
        .sidebar .nav-link i {
            font-size: 1.1rem;
            width: 24px;
            text-align: center;
            margin-right: 10px;
        }
        
        .sidebar .nav-link .nav-text {
            margin-left: 12px;
            transition: opacity 0.3s ease;
        }
        
        .sidebar-collapsed .nav-text {
            opacity: 0;
            width: 0;
            display: none;
        }
        
        .sidebar-collapsed .text-center p,
        .sidebar-collapsed .text-center h5 {
            display: none;
        }
        
        .sidebar-collapsed .text-center img {
            width: 40px;
            height: 40px;
        }
        
        .sidebar-toggle {
            background-color: var(--primary-color);
            border: none;
            color: white;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            position: absolute;
            top: 10px;
            right: -15px;
            cursor: pointer;
            z-index: 1001;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .nav-category {
            color: rgba(255,255,255,0.6);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 20px 20px 10px;
            transition: opacity 0.3s ease;
        }
        
        .sidebar-collapsed .nav-category {
            opacity: 0;
            display: none;
        }
        
        .has-submenu {
            position: relative;
        }
        
        .submenu {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            padding-left: 30px;
        }
        
        .submenu.show {
            max-height: 500px;
        }
        
        .submenu-toggle {
            position: absolute;
            right: 15px;
            top: 12px;
            color: rgba(255,255,255,0.7);
            transition: transform 0.3s;
        }
        
        .rotate-toggle {
            transform: rotate(180deg);
        }

        .header {
           background: linear-gradient(135deg, var(--primary-color), #0e3d47);
            color: white;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header img {
            border-radius: 50%;
            border: 2px solid var(--accent-color);
        }

        .bill-form-container {
            background-color: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .form-label {
            color: var(--text-color);
            font-weight: 500;
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(22, 105, 122, 0.25);
        }
        
        .form-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--accent-color);
        }
        
        .btn-submit {
           background: linear-gradient(135deg, var(--primary-color), #0e3d47);
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        
        .mobile-sidebar-toggle {
            display: none;
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            margin: 10px;
            position: fixed;
            top: 10px;
            left: 10px;
            z-index: 1002;
        }
        
        .form-section {
            padding: 20px;
            background-color: var(--background-light);
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .footer {
           background: linear-gradient(135deg, var(--primary-color), #0e3d47);
            color: white;
            font-size: 14px;
            padding: 20px;
            margin-top: auto;
        }

        .footer a {
            color: white;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer a:hover {
            color: var(--highlight-color);
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
            }
            
            .sidebar.show-mobile {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding-top: 60px;
            }
            
            .mobile-sidebar-toggle {
                display: block;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
              .required-mark {
        color: #dc3545;
        font-weight: bold;
    }
    
    .form-label {
        font-weight: 500;
    }
    
    .btn-primary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            padding: 10px 20px;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
    
    .btn-outline-danger {
        border-color: var(--danger-color);
        color: var(--danger-color);
        padding: 10px 20px;
        border-radius: 5px;
    }
    
    .btn-outline-danger:hover {
        background-color: var(--danger-color);
        color: white;
    }
    
    .bill-form-container {
        background-color: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        margin-bottom: 30px;
    }
    
    /* Add a simple reset function if not already present */
    function resetForm() {
        document.querySelector("form").reset();
        // Reset any previews if needed
    }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Mobile Sidebar Toggle Button -->
            <button class="mobile-sidebar-toggle" id="mobile-sidebar-toggle">
                <i class="fas fa-bars"></i>
            </button>
        
        <jsp:include page="sidebar.jsp" />

            <!-- Main Content Area -->
            <div class="col-md-10 main-content" id="main-content">
                <!-- Top Header -->
                <div class="header d-flex justify-content-between align-items-center p-3 rounded-3">
                    <div class="d-flex align-items-center">
                        <img src="img/logo.jpg" alt="Logo" class="me-3" style="width: 50px; height: 50px; object-fit: cover;">
                        <div>
                            <h3 class="mb-0 fw-bold">Petty Contractor's Bill</h3>
                            <p class="mb-0 fs-6">April 26, 2025</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <!-- Notifications Button -->
                        <button class="btn btn-link text-light me-3" id="notifications-btn" title="Notifications">
                            <i class="fas fa-bell me-2"></i>
                            <span class="badge rounded-circle bg-danger">3</span>
                        </button>
                        <!-- Logout Button -->
                        <a href="/logout" class="btn btn-link text-light" title="Logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Logout
                        </a>
                    </div>
                </div>
                
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="contractor-dashboard.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/finance">Finance</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Petty Contractor's Bill</li>
                    </ol>
                </nav>

                <!-- Bill Form -->
                <div class="row">
    <div class="col-12">
        <div class="bill-form-container">
            <h4 class="form-title">PETTY CONTRACTOR'S BILL DETAILS</h4>
            
            <form action="/petty-Bill-details" method="get" class="needs-validation" novalidate>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="regNo" class="form-label">Reg No <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="regNo" id="regNo" placeholder="Auto-filled when contractor is selected" readonly required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="DateOfIssue" class="form-label">Date of Issue <span class="required-mark">*</span></label>
                        <div class="input-group date" id="issueDatePicker" data-target-input="nearest">
                            <input type="text" class="form-control datetimepicker-input" data-target="#issueDatePicker" name="DateOfIssue" id="DateOfIssue" placeholder="DD-MM-YYYY" autocomplete="off" required>
                            <div class="input-group-append" data-target="#issueDatePicker" data-toggle="datetimepicker">
                                <div class="input-group-text"><i class="fas fa-calendar"></i></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="iomDate" class="form-label">IOM Date <span class="required-mark">*</span></label>
                        <div class="input-group date" id="iomDatePicker" data-target-input="nearest">
                            <input type="text" class="form-control datetimepicker-input" data-target="#iomDatePicker" name="iomDate" id="iomDate" placeholder="DD-MM-YYYY" autocomplete="off" required>
                            <div class="input-group-append" data-target="#iomDatePicker" data-toggle="datetimepicker">
                                <div class="input-group-text"><i class="fas fa-calendar"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="contractorId" class="form-label">Contractor Name <span class="required-mark">*</span></label>
                        <select class="form-select" name="contractorId" id="contractorId" required>
                            <option value="">Select Contractor</option>
                            <c:forEach var="contractor" items="${contractorList}">
                                <option value="${contractor.contractorId}">${contractor.contractorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="serialNo" class="form-label">Serial No <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="serialNo" id="serialNo" placeholder="Enter serial with prefix e.g. v.sus/2025-2026" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="serviceCode" class="form-label">Service Code <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="serviceCode" id="serviceCode" readonly placeholder="Auto-filled from contractor" required>
                    </div>
                    <input type="hidden" name="contractorPrefix" id="contractorPrefix">
                    <div class="col-md-4 mb-3">
                        <label for="locationOfWork" class="form-label">Location of Work <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="locationOfWork" id="locationOfWork" placeholder="Enter work location" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="descriptionOfWork" class="form-label">Description of Work <span class="required-mark">*</span></label>
                        <textarea class="form-control" name="descriptionOfWork" id="descriptionOfWork" placeholder="Enter work description" rows="3" required></textarea>
                    </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="dateUndertaken" class="form-label">Date Work Undertaken <span class="required-mark">*</span></label>
                        <div class="input-group date" id="workDatePicker" data-target-input="nearest">
                            <input type="text" class="form-control datetimepicker-input" data-target="#workDatePicker" name="dateUndertaken" id="dateUndertaken" placeholder="DD-MM-YYYY" autocomplete="off" required>
                            <div class="input-group-append" data-target="#workDatePicker" data-toggle="datetimepicker">
                                <div class="input-group-text"><i class="fas fa-calendar"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="entryPassNo" class="form-label">Entry Pass No <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="entryPassNo" id="entryPassNo" placeholder="Enter entry pass number" required>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="department" class="form-label">Department & Section <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="department" id="department" placeholder="Enter department and section" required>
                    </div>
                </div>
                <input type="hidden" name="conName" id="conName">
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label for="address" class="form-label">Address <span class="required-mark">*</span></label>
                        <textarea class="form-control" name="address" id="address" rows="3" readonly required></textarea>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="billamount" class="form-label">Bill Amount <span class="required-mark">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="text" class="form-control" name="billamount" id="billamount" placeholder="Enter bill amount" required>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <!-- Optional field if needed, left blank to maintain row structure -->
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-md-12 text-center">
                        <button type="submit" class="btn btn-primary me-3">
                            <i class="fas fa-save me-2"></i> Submit Registration
                        </button>
                        <button type="reset" class="btn btn-outline-danger" onclick="resetForm()">
                            <i class="fas fa-undo me-2"></i> Reset Form
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var contractorMap = {
                    '1': {
                        regNo: 'C004',
                        prefix: 'v.sus/',
                        suffix:'/2025-2026',
                        serviceCode: '998519',
                        name: 'Suseendran V',
                        address: '\n TC:32/387, Thyvilakom House Kochuveli\nKarikkakom P.O Thiruvananthapuram-695021\nGSTIN: 32ABMPV7915L1Z0'
                    },
                    '2': {
                        regNo: 'C005',
                        prefix: 'k.ani/',
                        suffix:'/2025-2026',
                        serviceCode: '998519',
                        name: 'Anilkumar',
                        address: '\nTC:32/299(8), Matha Green Gardens\nKochuveli Thiruvananthapuram-695021\nGSTIN: 32AJCPA6156G1ZQ'
                    }
                };

                var contractorSelect = document.getElementById('contractorId');
                var regNoInput = document.getElementById('regNo');
                var contractorPrefixInput = document.getElementById('contractorPrefix');
                var serialInput = document.getElementById('serialNo');
                var serviceCodeInput = document.getElementById('serviceCode');
                var nameInput = document.getElementById('conName');
                var addressInput = document.getElementById('address');

                contractorSelect.addEventListener('change', function() {
                    var selected = contractorSelect.value;
                    if (contractorMap[selected]) {
                        var suffix = serialInput.value || '';
                        Object.values(contractorMap).forEach(function(contractor) {
                            if (suffix.startsWith(contractor.prefix)) {
                                suffix = suffix.slice(contractor.prefix.length);
                            }
                        });
                        regNoInput.value = contractorMap[selected].regNo;
                        contractorPrefixInput.value = contractorMap[selected].prefix;
                        serialInput.value = contractorMap[selected].prefix + suffix;
                        serviceCodeInput.value = contractorMap[selected].serviceCode;
                        nameInput.value = contractorMap[selected].name;
                        addressInput.value = contractorMap[selected].address;
                    } else {
                        regNoInput.value = '';
                        contractorPrefixInput.value = '';
                        serialInput.value = '';
                        serviceCodeInput.value = '';
                        nameInput.value = '';
                        addressInput.value = '';
                    }
                });
            });
        </script>
    </div>
</div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <div class="row justify-content-between">
                <div class="col-md-6">
                    <p class="mb-0">© 2025 Titanium Contractor Operations Hub. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <ul class="list-unstyled mb-0">
                        <li class="d-inline-block me-3">
                            <a href="/privacy" title="Privacy Policy">Privacy Policy</a>
                        </li>
                        <li class="d-inline-block me-3">
                            <a href="/terms" title="Terms of Service">Terms of Service</a>
                        </li>
                        <li class="d-inline-block">
                            <a href="/contact" title="Contact Us">Contact Us</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <!-- Moment.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <!-- Tempus Dominus DateTimePicker JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.39.0/js/tempusdominus-bootstrap-4.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize date pickers
            $('#issueDatePicker, #iomDatePicker, #workDatePicker').datetimepicker({
                format: 'DD-MM-YYYY',
                icons: {
                    time: 'far fa-clock',
                    date: 'far fa-calendar',
                    up: 'fas fa-arrow-up',
                    down: 'fas fa-arrow-down',
                    previous: 'fas fa-chevron-left',
                    next: 'fas fa-chevron-right',
                    today: 'far fa-calendar-check',
                    clear: 'fas fa-trash',
                    close: 'fas fa-times'
                }
            });
            
            // Set today's date as default
            var today = new Date();
            $('#issueDatePicker').datetimepicker('date', today);
            
            // Validate form on submit
            (function() {
                'use strict';
                window.addEventListener('load', function() {
                    // Fetch all forms we want to apply validation to
                    var forms = document.getElementsByClassName('needs-validation');
                    // Loop over them and prevent submission
                    var validation = Array.prototype.filter.call(forms, function(form) {
                        form.addEventListener('submit', function(event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();
            
            // Sidebar toggle functionality
            $('#sidebar-toggle').click(function() {
                $('#sidebar').toggleClass('sidebar-collapsed');
                $('#main-content').toggleClass('main-content-expanded');
                $('#toggle-icon').toggleClass('fa-chevron-left fa-chevron-right');
            });
            
            // Mobile sidebar toggle
            $('#mobile-sidebar-toggle').click(function() {
                $('#sidebar').toggleClass('show-mobile');
            });
            
            // Submenu toggle
            $('.has-submenu > a').click(function(e) {
                e.preventDefault();
                $(this).find('.submenu-toggle').toggleClass('rotate-toggle');
                let submenuId = $(this).attr('href');
                $(submenuId).toggleClass('show');
            });
            
            // Close sidebar when clicking outside on mobile
            $(document).on('click', function(e) {
                if ($(window).width() <= 768) {
                    if (!$(e.target).closest('#sidebar, #mobile-sidebar-toggle').length) {
                        $('#sidebar').removeClass('show-mobile');
                    }
                }
            });
            
            // Format bill amount input to currency
            $('#billamount').on('input', function() {
                let value = $(this).val().replace(/[^\d]/g, '');
                if (value) {
                    value = parseInt(value, 10).toLocaleString('en-IN');
                }
                $(this).val(value);