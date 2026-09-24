<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP - Employee List</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Same palette as the side nav, attendance and registration pages */
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
            max-width: 1700px;
            margin: 0 auto;
            width: 100%;
        }

        /* ===== Page heading ===== */
        .page-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: var(--space-3);
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border-color);
        }

        .page-heading .heading-icon {
            width: 46px;
            height: 46px;
            min-width: 46px;
            border-radius: var(--radius);
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            box-shadow: 0 6px 14px rgba(22, 105, 122, 0.28);
        }

        .page-heading h4 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.25rem;
            margin: 0;
            color: var(--text-color);
        }

        .page-heading .text-muted-sub {
            font-size: 0.84rem;
            color: var(--muted-color);
            margin-top: 2px;
        }

        #selectedContractor {
            display: inline-block;
            background: rgba(22, 105, 122, 0.10);
            color: var(--primary-color);
            padding: 3px 12px;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
            vertical-align: middle;
        }

        #selectedContractor:empty { display: none; }

        /* ===== Filter / search panel ===== */
        .filter-container {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            box-shadow: 0 4px 16px var(--card-shadow);
            border: 1px solid var(--border-color);
            border-left: 4px solid var(--secondary-color);
            padding: var(--space-3);
            margin-bottom: var(--space-3);
        }

        .filter-container label {
            font-size: 0.75rem;
            letter-spacing: 0.04em;
            color: var(--muted-color);
        }

        .filter-container .form-select {
            border-radius: 10px;
            border: 1.5px solid var(--border-color);
            padding: 10px 14px;
            font-size: 0.92rem;
            background-color: #fbfdfe;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .filter-container .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 4px rgba(72, 159, 181, 0.20);
            outline: none;
        }

        #searchEmployeeBtn, #generatePdfBtn {
            border-radius: 10px;
            padding: 10px 16px;
            font-weight: 600;
            font-size: 0.88rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
        }

        #searchEmployeeBtn {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            border: none;
            color: #fff;
            box-shadow: 0 6px 14px rgba(22, 105, 122, 0.28);
        }

        #searchEmployeeBtn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(22, 105, 122, 0.34);
        }

        #generatePdfBtn {
            border: 1.5px solid var(--primary-color);
            color: var(--primary-color);
            background: #fff;
        }

        #generatePdfBtn:hover {
            background: var(--primary-color);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(22, 105, 122, 0.22);
        }

        /* ===== Table card ===== */
        .table-responsive {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            box-shadow: 0 4px 16px var(--card-shadow);
            padding: 22px;
            overflow-x: auto;
            border: 1px solid var(--border-color);
            border-top: 4px solid var(--secondary-color);
        }

        table.dataTable {
            width: 100% !important;
            border-collapse: separate;
            border-spacing: 0;
        }

        table.dataTable thead th {
            background-color: #eaf3f6;
            color: var(--primary-color);
            font-weight: 700;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            border-bottom: 2px solid var(--accent-color);
            padding: 12px 16px;
            text-align: left;
            white-space: nowrap;
        }

        table.dataTable tbody td {
            padding: 10px 16px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-color);
            font-size: 0.9rem;
        }

        table.dataTable tbody tr { transition: background 0.15s ease; }
        table.dataTable tbody tr:hover { background-color: #f1f8fa; }

        table.dataTable input[type="checkbox"] { accent-color: var(--primary-color); }

        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--secondary-color);
            box-shadow: 0 2px 6px rgba(22, 105, 122, 0.2);
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            margin: 0 3px;
            font-size: 15px;
            border-radius: 8px;
            text-decoration: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .action-btn.edit {
            color: var(--primary-color);
            background: rgba(22, 105, 122, 0.10);
        }

        .action-btn.delete {
            color: var(--danger-color);
            background: rgba(214, 69, 69, 0.10);
        }

        .action-btn:hover {
            transform: scale(1.08);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
        }

        .empty-row td {
            text-align: center;
            padding: 28px 16px !important;
            color: var(--muted-color) !important;
        }

        /* ===== DataTables controls ===== */
        .dt-top {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: var(--space-1) var(--space-2);
            margin-bottom: var(--space-2);
        }

        .dt-bottom {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: var(--space-1) var(--space-2);
            margin-top: var(--space-2);
        }

        .dt-buttons { margin: 0; }

        .dt-button {
            background: var(--light-color) !important;
            border: 1px solid var(--border-color) !important;
            border-radius: 8px !important;
            color: var(--text-color) !important;
            font-size: 0.85rem !important;
            margin-right: 6px !important;
            padding: 7px 14px !important;
            box-shadow: none !important;
            transition: background-color 0.2s ease, color 0.2s ease !important;
        }

        .dt-button:hover {
            background-color: var(--primary-color) !important;
            border-color: var(--primary-color) !important;
            color: #fff !important;
        }

        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            margin: 0;
            padding: 0;
            float: none;
            color: var(--muted-color);
            font-size: 0.88rem;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border-radius: 8px;
            border: 1.5px solid var(--border-color);
            padding: 6px 12px;
            margin-left: 6px;
            background: #fbfdfe;
        }

        .dataTables_wrapper .dataTables_filter input:focus,
        .dataTables_wrapper .dataTables_length select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 3px rgba(72, 159, 181, 0.20);
            outline: none;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 5px 12px;
            margin: 0 2px;
            border-radius: 6px;
            border: 1px solid var(--border-color) !important;
            background: #fff !important;
            color: var(--text-color) !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: var(--primary-color) !important;
            color: #fff !important;
            border-color: var(--primary-color) !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover {
            background: #fff !important;
            color: #b6c2c8 !important;
            border-color: var(--border-color) !important;
        }

        /* ===== Footer ===== */
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

        /* ===== Small screens ===== */
        @media (max-width: 768px) {
            .main-wrapper { margin-left: 0; width: 100%; }
            .erp-header { padding-left: 68px; }
            .content-container { padding: var(--space-2); }
            .filter-container { padding: var(--space-2); }
            .table-responsive { padding: 14px; }
            .footer { padding: var(--space-2); }
        }
    </style>
</head>
<body>
    <!-- Highlight "Employees > Employee List" in the side nav -->
    <c:set var="currentPage" value="employees" scope="request" />
    <c:set var="currentSubPage" value="list" scope="request" />
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

            <!-- Page Heading -->
            <div class="page-heading">
                <div class="heading-icon"><i class="fas fa-users"></i></div>
                <div>
                    <h4>List of Employees <span id="selectedContractor"></span></h4>
                    <div class="text-muted-sub">Browse, search and manage all registered employees</div>
                </div>
            </div>

            <!-- Filter and Search Section -->
            <div class="filter-container">
                <div class="row align-items-end g-3">
                    <div class="col-md-6">
                        <label for="cont" class="form-label text-uppercase fw-semibold">
                            <i class="fas fa-hard-hat me-1"></i> Select Contractor
                        </label>
                        <select id="cont" name="cont" class="form-select">
                            <option value="">-- Choose Contractor --</option>
                            <c:forEach var="contList" items="${contractorList}">
                                <option value="${contList.contractorId}">${contList.contractorName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <button type="button" class="btn w-100" id="searchEmployeeBtn">
                            <i class="fas fa-search me-2"></i>Search Employee
                        </button>
                    </div>
                    <div class="col-md-3">
                        <button type="button" class="btn w-100" id="generatePdfBtn">
                            <i class="fas fa-file-pdf me-2"></i>Generate PDF
                        </button>
                    </div>
                </div>
            </div>

            <!-- Employee Table -->
            <div class="table-responsive">
                <table id="employeeTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll" title="Select all employees" /></th>
                            <th>#</th>
                            <th>Profile</th>
                            <th>Employee Name</th>
                            <th>Mobile No</th>
                            <th>Code No</th>
                            <th>ESI</th>
                            <th>UAN</th>
                            <th>PF No</th>
                            <th>PCC</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="employeeBody">
                        <tr class="empty-row"><td colspan="11">Please select a contractor and click Search</td></tr>
                    </tbody>
                </table>
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

    <!-- Scripts -->
    <!-- Bootstrap JS (needed by the sidebar submenus) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.5/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.5/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <!-- jsPDF + autotable for client-side PDF generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.5.25/dist/jspdf.plugin.autotable.min.js"></script>

    <script>
    // The sidebar (open/close, submenus, mobile drawer) is handled entirely inside sidebar.jsp.
    $(document).ready(function () {
        var employeeTable = null;

        // Escape values before putting them into HTML
        function esc(v) {
            return String(v == null ? '' : v).replace(/[&<>"']/g, function (c) {
                return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
            });
        }

        function messageRow(html) {
            return '<tr class="empty-row"><td colspan="11">' + html + '</td></tr>';
        }

        function destroyTable() {
            if (employeeTable) {
                employeeTable.destroy();
                employeeTable = null;
            }
            $('#selectAll').prop('checked', false);
        }

        function initTable() {
            employeeTable = $('#employeeTable').DataTable({
                responsive: true,
                dom: '<"dt-top"Bf>rt<"dt-bottom"lip>',
                buttons: [
                    { extend: 'copy',  text: '<i class="far fa-copy me-1"></i> Copy',       className: 'btn-sm' },
                    { extend: 'excel', text: '<i class="far fa-file-excel me-1"></i> Excel', className: 'btn-sm' },
                    { extend: 'csv',   text: '<i class="fas fa-file-csv me-1"></i> CSV',     className: 'btn-sm' },
                    { extend: 'print', text: '<i class="fas fa-print me-1"></i> Print',      className: 'btn-sm' }
                ],
                columnDefs: [
                    { orderable: false, targets: [0, 2, -1] }
                ],
                order: [[1, 'asc']],
                language: {
                    search: "<i class='fas fa-search me-1'></i>Search:",
                    lengthMenu: "<i class='fas fa-list me-1'></i>Show _MENU_ entries",
                    info: "Showing _START_ to _END_ of _TOTAL_ employees",
                    paginate: {
                        first: '<i class="fas fa-angle-double-left"></i>',
                        previous: '<i class="fas fa-angle-left"></i>',
                        next: '<i class="fas fa-angle-right"></i>',
                        last: '<i class="fas fa-angle-double-right"></i>'
                    }
                },
                pageLength: 10,
                lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
            });
        }

        function fetchEmployees() {
            var contractorId = $('#cont').val();
            var contractorName = $('#cont option:selected').text();

            // Contractor label next to the heading
            $('#selectedContractor').text(contractorId ? contractorName : '');

            // Always tear down the old DataTable before touching the rows
            destroyTable();

            if (!contractorId) {
                $('#employeeBody').html(messageRow('Please select a contractor and click Search'));
                return;
            }

            $('#employeeBody').html(messageRow('<i class="fas fa-spinner fa-spin me-2"></i>Loading...'));

            $.ajax({
                url: 'get-employee-list',
                type: 'GET',
                data: { contractorId: contractorId },
                dataType: 'json',
                success: function (response) {
                    if (!response || !Array.isArray(response) || response.length === 0) {
                        $('#employeeBody').html(messageRow('No employees found'));
                        return;
                    }

                    var tbody = '';
                    $.each(response, function (index, emp) {
                        var profileImg = emp.profImg ? 'other-docs/' + emp.profImg : 'img/manicon.jpg';
                        var id = esc(emp.userId);

                        tbody += '<tr>' +
                            '<td><input type="checkbox" class="row-select" data-id="' + id + '" /></td>' +
                            '<td>' + (index + 1) + '</td>' +
                            '<td><img src="' + esc(profileImg) + '" class="profile-img" alt="Profile"></td>' +
                            '<td>' + esc(emp.userName) + '</td>' +
                            '<td>' + esc(emp.mobileNo) + '</td>' +
                            '<td>' + esc(emp.codeNo) + '</td>' +
                            '<td>' + esc(emp.esiNo) + '</td>' +
                            '<td>' + esc(emp.uanNo) + '</td>' +
                            '<td>' + esc(emp.pfNo) + '</td>' +
                            '<td>' + esc(emp.pccNo) + '</td>' +
                            '<td>' +
                                '<a href="redirect?param=edit-employee-details&id=' + id + '" class="action-btn edit" title="Edit">' +
                                    '<i class="fas fa-edit"></i>' +
                                '</a>' +
                                '<a href="redirect?param=delete-employee-details&id=' + id + '" class="action-btn delete" title="Delete" ' +
                                   'onclick="return confirm(\'Are you sure you want to delete this employee?\')">' +
                                    '<i class="fas fa-trash-alt"></i>' +
                                '</a>' +
                            '</td>' +
                        '</tr>';
                    });

                    $('#employeeBody').html(tbody);
                    initTable();
                },
                error: function (xhr, status, error) {
                    console.error('AJAX Error:', status, error);
                    $('#employeeBody').html(messageRow('Failed to load data: ' + esc(error)));
                }
            });
        }

        // Search (one handler only)
        $('#searchEmployeeBtn').on('click', function (e) {
            e.preventDefault();
            fetchEmployees();
        });

        // Select all: works across every page of the table
        $(document).on('change', '#selectAll', function () {
            var checked = $(this).is(':checked');
            if (employeeTable) {
                employeeTable.$('input.row-select').prop('checked', checked);
            }
        });

        // Generate PDF for the selected rows (across all pages)
        $('#generatePdfBtn').on('click', function () {
            if (!employeeTable) {
                alert('Please search for a contractor and select at least one employee.');
                return;
            }

            var rows = [];
            employeeTable.$('input.row-select:checked').each(function () {
                var cells = $(this).closest('tr').children('td');
                var name = cells.eq(3).text().trim();
                var code = cells.eq(5).text().trim();
                var esi  = cells.eq(6).text().trim();
                var uan  = cells.eq(7).text().trim();
                var pcc  = cells.eq(9).text().trim();
                // DATE, Sl.No and No. of Persons are left blank for handwriting
                rows.push(['', '', '', name, code, esi, uan, pcc]);
            });

            if (rows.length === 0) {
                alert('Please select at least one employee to generate PDF.');
                return;
            }

            var jsPDF = window.jspdf.jsPDF;
            var doc = new jsPDF('p', 'pt', 'a4');
            var selectedContractor = $('#cont option:selected').text().trim();
            var isSuseendran = selectedContractor.toLowerCase().indexOf('suseendran') !== -1;

            doc.autoTable({
                head: [['DATE', 'SI.No', 'No. of Persons', 'NAME', 'Code No', 'ESI', 'UAN NO', 'PCC']],
                body: rows,
                startY: 40,
                theme: 'grid',
                styles: {
                    fontSize: 10,
                    cellPadding: 4,
                    textColor: '#000000',
                    lineColor: '#000000',
                    lineWidth: 0.5,
                    fillColor: [255, 255, 255]
                },
                headStyles: {
                    textColor: '#000000',
                    fillColor: [255, 255, 255],
                    lineColor: '#000000',
                    lineWidth: 0.5
                },
                bodyStyles: {
                    fillColor: [255, 255, 255],
                    lineColor: '#000000'
                },
                tableLineWidth: 0.5,
                tableLineColor: '#000000',
                margin: { bottom: isSuseendran ? 70 : 40 },
                didDrawPage: function () {
                    if (!isSuseendran) return;
                    var pageWidth = doc.internal.pageSize.getWidth();
                    var pageHeight = doc.internal.pageSize.getHeight();
                    doc.setFontSize(10);
                    doc.text('Contractor', pageWidth - 40, pageHeight - 42, { align: 'right' });
                    doc.text('V. Suseendran', pageWidth - 40, pageHeight - 26, { align: 'right' });
                }
            });

            var lastY = doc.lastAutoTable.finalY || 40;
            doc.setFontSize(10);
            doc.text('Total Selected Persons: ' + rows.length, 40, lastY + 20);
            doc.save('employee-list.pdf');
        });
    });
    </script>
</body>
</html>
