<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP - Attendance Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            /* Palette: one teal family + amber highlight; status colours stay semantic */
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
            --warning-color: #e08e0b;
            --info-color: #3b82c4;

            --radius: 12px;
            --space-1: 8px;
            --space-2: 16px;
            --space-3: 24px;

            /* Sidebar widths are also defined in sidebar.jsp (collapsed state is handled there) */
            --sidebar-width: 250px;
            --sidebar-width-collapsed: 72px;
        }

        body, html {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: row;
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            background-color: var(--background-light);
        }

        .main-wrapper {
            flex: 1;
            min-width: 0;
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
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        .content-container {
            padding: var(--space-3);
            flex: 1;
            max-width: 1900px;
            margin: 0 auto;
            width: 100%;
        }

        /* ---- Summary cards ---- */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: var(--space-2);
            margin-bottom: var(--space-3);
        }

        .summary-card {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            padding: var(--space-2) var(--space-2) 14px;
            box-shadow: 0 2px 10px var(--card-shadow);
            text-align: center;
            border-top: 4px solid var(--accent-color);
        }

        .summary-card.present { border-top-color: var(--success-color); }
        .summary-card.absent { border-top-color: var(--danger-color); }
        .summary-card.halfday { border-top-color: var(--warning-color); }
        .summary-card.leave { border-top-color: var(--info-color); }
        .summary-card.hours { border-top-color: var(--highlight-color); }

        .summary-card i { font-size: 22px; margin-bottom: 6px; }
        .summary-card.present i { color: var(--success-color); }
        .summary-card.absent i { color: var(--danger-color); }
        .summary-card.halfday i { color: var(--warning-color); }
        .summary-card.leave i { color: var(--info-color); }
        .summary-card.hours i { color: var(--highlight-color); }

        .summary-card h3 { font-size: 28px; font-weight: 700; margin: 4px 0; color: var(--text-color); }
        .summary-card p { font-size: 12px; letter-spacing: 0.04em; color: var(--muted-color); margin: 0; }

        /* ---- Toolbar panels ---- */
        .bulk-actions,
        .filter-container {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            padding: var(--space-2) var(--space-3);
            box-shadow: 0 2px 10px var(--card-shadow);
            margin-bottom: var(--space-2);
            border: 1px solid var(--border-color);
        }

        .filter-container {
            border-left: 4px solid var(--accent-color);
            padding: 12px var(--space-3);
        }

        .bulk-actions hr {
            border-color: var(--border-color);
            opacity: 1;
        }

        .bulk-actions .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .bulk-actions .form-select:focus,
        .hours-input:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 3px rgba(72, 159, 181, 0.22);
            outline: none;
        }

        .month-nav #monthSelect { min-width: 130px; }
        .month-nav #yearSelect { min-width: 90px; }

        .legend {
            display: flex;
            gap: var(--space-2);
            flex-wrap: wrap;
            font-size: 13px;
            align-items: center;
            color: var(--text-color);
        }

        .legend .dot {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 6px;
            vertical-align: middle;
        }

        /* ---- Grid ---- */
        .grid-wrapper {
            background-color: var(--surface-color);
            border-radius: var(--radius);
            box-shadow: 0 2px 12px var(--card-shadow);
            padding: 0;
            overflow: auto;
            max-height: 70vh;
            border: 1px solid var(--border-color);
            border-top: 4px solid var(--secondary-color);
        }

        table.attendance-grid {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            min-width: 1000px;
        }

        table.attendance-grid thead th {
            background-color: #eaf3f6;
            color: var(--primary-color);
            font-weight: 600;
            font-size: 13px;
            border-bottom: 2px solid var(--accent-color);
            padding: 10px 6px;
            text-align: center;
            white-space: nowrap;
            position: sticky;
            top: 0;
            z-index: 2;
        }

        table.attendance-grid thead th.emp-col,
        table.attendance-grid tbody td.emp-col {
            position: sticky;
            left: 0;
            background-color: #eaf3f6;
            z-index: 3;
            text-align: left;
            min-width: 210px;
            padding-left: var(--space-2);
            border-right: 2px solid var(--accent-color);
        }

        table.attendance-grid tbody td.emp-col {
            background-color: var(--surface-color);
            z-index: 1;
            font-weight: 500;
        }

        table.attendance-grid tbody td.emp-col .row-select,
        table.attendance-grid thead th.emp-col #selectAllRows {
            margin-right: 8px;
            accent-color: var(--primary-color);
        }

        table.attendance-grid th.day-col,
        table.attendance-grid td.day-cell {
            min-width: 84px;
            width: 84px;
        }

        table.attendance-grid th.weekend,
        table.attendance-grid td.weekend {
            background-color: #e9f1f4;
        }

        table.attendance-grid thead th.weekend {
            background-color: #d9e8ed;
            color: var(--muted-color);
        }

        table.attendance-grid tbody td {
            padding: 10px 6px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }

        table.attendance-grid tbody tr:hover td:not(.weekend) {
            background-color: #f6fafb;
        }

        table.attendance-grid tbody tr:hover td.emp-col {
            background-color: #f6fafb;
        }

        .attendance-cell {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }

        .status-dot {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 700;
            color: white;
            user-select: none;
            transition: transform 0.15s ease;
        }

        .status-dot:hover { transform: scale(1.12); }

        .status-dot.status-0 { background-color: #d5dde1; color: #55666e; }
        .status-dot.status-1 { background-color: var(--success-color); }
        .status-dot.status-2 { background-color: var(--danger-color); }
        .status-dot.status-3 { background-color: var(--warning-color); }
        .status-dot.status-4 { background-color: var(--info-color); }

        .hours-input {
            width: 56px;
            padding: 3px 6px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            font-size: 12px;
            text-align: center;
            background-color: #fff;
        }

        /* ---- Buttons ---- */
        .btn-success {
            background-color: var(--success-color);
            border-color: var(--success-color);
        }

        .btn-success:hover {
            background-color: #278660;
            border-color: #278660;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        /* Sidebar handles its own drawer on mobile; the content just uses the full width */
        @media (max-width: 768px) {
            .main-wrapper { margin-left: 0; width: 100%; }
            .erp-header { padding-left: 68px; }
            .content-container { padding: var(--space-2); }
            .bulk-actions, .filter-container { padding: 12px var(--space-2); }
        }

        /* ---- Alerts ---- */
        .alert-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            max-width: 400px;
        }

        .alert-custom {
            padding: 14px var(--space-2);
            border-radius: 10px;
            margin-bottom: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18);
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .alert-success { background-color: var(--success-color); color: white; }
        .alert-danger { background-color: var(--danger-color); color: white; }
        .alert-info { background-color: var(--info-color); color: white; }
        .alert-warning { background-color: var(--warning-color); color: white; }

        /* ---- Loading spinner ---- */
        .spinner-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(14, 61, 71, 0.55);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 10000;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <c:set var="currentPage" value="employees" scope="request" />
    <c:set var="currentSubPage" value="attendance" scope="request" />
    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper" id="main-wrapper">
        <header class="erp-header">
            <div class="container-fluid">
                <h1><i class="fas fa-calendar-check me-2"></i>ATTENDANCE MARKING</h1>
            </div>
        </header>

        <!-- Alert Container -->
        <div class="alert-container" id="alertContainer"></div>

        <!-- Flash message from the controller (read by JS on load) -->
        <c:if test="${not empty message}">
            <div id="flashData" style="display:none"
                 data-message="${fn:escapeXml(message)}"
                 data-ok="${req_status == true}"></div>
        </c:if>

        <!-- Loading Spinner -->
        <div class="spinner-overlay" id="loadingSpinner">
            <div class="spinner"></div>
        </div>

        <div class="container-fluid content-container">
            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card present">
                    <i class="fas fa-user-check"></i>
                    <h3 id="cardPresent">${presentCount != null ? presentCount : 0}</h3>
                    <p>PRESENT (MONTH)</p>
                </div>
                <div class="summary-card absent">
                    <i class="fas fa-user-times"></i>
                    <h3 id="cardAbsent">${absentCount != null ? absentCount : 0}</h3>
                    <p>ABSENT (MONTH)</p>
                </div>
                <div class="summary-card halfday">
                    <i class="fas fa-user-clock"></i>
                    <h3 id="cardHalfday">${halfdayCount != null ? halfdayCount : 0}</h3>
                    <p>HALF DAY (MONTH)</p>
                </div>
                <div class="summary-card leave">
                    <i class="fas fa-user-minus"></i>
                    <h3 id="cardLeave">${leaveCount != null ? leaveCount : 0}</h3>
                    <p>ON LEAVE (MONTH)</p>
                </div>
                <div class="summary-card hours">
                    <i class="fas fa-clock"></i>
                    <h3 id="cardHours">${totalHours != null ? totalHours : 0}</h3>
                    <p>HOURS WORKED (MONTH)</p>
                </div>
            </div>

            <!-- Bulk Actions -->
            <div class="bulk-actions">
                <div class="row align-items-center gy-2">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center flex-wrap gap-2">
                            <label class="mb-0 fw-semibold">Month:</label>

                            <!-- Hidden value (yyyy-MM) used by highlightWeekends() -->
                            <input type="hidden" id="monthPicker" value="${selectedMonth}">

                            <div class="month-nav d-flex align-items-center gap-2">
                                <button type="button" id="prevMonthBtn" class="btn btn-sm btn-outline-secondary" title="Previous month">
                                    <i class="fas fa-chevron-left"></i>
                                </button>

                                <select id="monthSelect" class="form-select form-select-sm" aria-label="Select month">
                                    <option value="1"  ${selectedMonthNumber == 1  ? 'selected' : ''}>January</option>
                                    <option value="2"  ${selectedMonthNumber == 2  ? 'selected' : ''}>February</option>
                                    <option value="3"  ${selectedMonthNumber == 3  ? 'selected' : ''}>March</option>
                                    <option value="4"  ${selectedMonthNumber == 4  ? 'selected' : ''}>April</option>
                                    <option value="5"  ${selectedMonthNumber == 5  ? 'selected' : ''}>May</option>
                                    <option value="6"  ${selectedMonthNumber == 6  ? 'selected' : ''}>June</option>
                                    <option value="7"  ${selectedMonthNumber == 7  ? 'selected' : ''}>July</option>
                                    <option value="8"  ${selectedMonthNumber == 8  ? 'selected' : ''}>August</option>
                                    <option value="9"  ${selectedMonthNumber == 9  ? 'selected' : ''}>September</option>
                                    <option value="10" ${selectedMonthNumber == 10 ? 'selected' : ''}>October</option>
                                    <option value="11" ${selectedMonthNumber == 11 ? 'selected' : ''}>November</option>
                                    <option value="12" ${selectedMonthNumber == 12 ? 'selected' : ''}>December</option>
                                </select>

                                <select id="yearSelect" class="form-select form-select-sm" aria-label="Select year">
                                    <c:forEach var="y" begin="${selectedYear - 5}" end="${selectedYear + 2}">
                                        <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                                    </c:forEach>
                                </select>

                                <button type="button" id="nextMonthBtn" class="btn btn-sm btn-outline-secondary" title="Next month">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                            <button type="button" id="selectAllBtn" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-check-square me-1"></i>Select All
                            </button>
                            <button type="button" id="clearSelectionBtn" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-square me-1"></i>Clear Selection
                            </button>
                        </div>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <button type="button" id="saveAttendanceBtn" class="btn btn-success">
                            <i class="fas fa-save me-2"></i>Save Month
                        </button>
                    </div>
                </div>

                <!-- Quick fill -->
                <hr class="my-3">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <span class="fw-semibold">Quick fill:</span>

                    <select id="bulkScope" class="form-select form-select-sm" style="width:auto" aria-label="Apply to">
                        <option value="all">All employees</option>
                        <option value="selected">Selected employees only</option>
                    </select>

                    <div class="btn-group btn-group-sm" role="group" aria-label="Quick fill status">
                        <button type="button" class="btn btn-outline-success quick-fill" data-status="1">
                            <i class="fas fa-user-check me-1"></i>Present
                        </button>
                        <button type="button" class="btn btn-outline-warning quick-fill" data-status="3">
                            <i class="fas fa-user-clock me-1"></i>Half Day
                        </button>
                        <button type="button" class="btn btn-outline-info quick-fill" data-status="4">
                            <i class="fas fa-user-minus me-1"></i>Leave
                        </button>
                        <button type="button" class="btn btn-outline-danger quick-fill" data-status="2">
                            <i class="fas fa-user-times me-1"></i>Absent
                        </button>
                        <button type="button" class="btn btn-outline-secondary quick-fill" data-status="0">
                            <i class="fas fa-eraser me-1"></i>Clear
                        </button>
                    </div>

                    <div class="form-check mb-0">
                        <input class="form-check-input" type="checkbox" id="skipWeekends" checked>
                        <label class="form-check-label" for="skipWeekends">Skip weekends</label>
                    </div>
                    <div class="form-check mb-0">
                        <input class="form-check-input" type="checkbox" id="onlyUnmarked">
                        <label class="form-check-label" for="onlyUnmarked">Only unmarked days</label>
                    </div>
                </div>
                <div class="text-muted small mt-2">
                    <i class="fas fa-info-circle me-1"></i>Changes are only stored when you click <b>Save Month</b>.
                </div>
            </div>

            <!-- Legend -->
            <div class="filter-container">
                <div class="legend">
                    <span><span class="dot" style="background:var(--success-color)"></span>Present</span>
                    <span><span class="dot" style="background:var(--danger-color)"></span>Absent</span>
                    <span><span class="dot" style="background:var(--warning-color)"></span>Half Day</span>
                    <span><span class="dot" style="background:var(--info-color)"></span>Leave</span>
                    <span><span class="dot" style="background:#ced4da"></span>Not Marked</span>
                    <span class="text-muted ms-3"><i class="fas fa-mouse-pointer me-1"></i>Click status to cycle</span>
                    <span class="text-muted ms-3"><i class="fas fa-clock me-1"></i>Enter hours for Present/Half Day</span>
                </div>
            </div>

            <!-- Attendance Grid -->
            <div class="grid-wrapper">
                <form id="attendanceForm" action="save-attendance-month" method="post">
                    <!-- FIX: post the zero-padded yyyy-MM value (e.g. 2026-09), not the bare month number -->
                    <input type="hidden" name="month" value="${selectedMonth}">
                    <input type="hidden" name="year" value="${selectedYear}">

                    <table class="attendance-grid" id="attendanceGrid">
                        <thead>
                            <tr>
                                <th class="emp-col">
                                    <input type="checkbox" id="selectAllRows" title="Select all employees">
                                    Employee
                                </th>
                                <!-- FIX: weekend class is applied by JS (highlightWeekends) using real dates -->
                                <c:forEach var="day" items="${daysInMonth}">
                                    <th class="day-col" data-day="${day}">${day}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="employee" items="${empList}">
                                <tr data-employee-id="${employee.userId}">
                                    <td class="emp-col">
                                        <input type="checkbox" class="row-select" title="Select this employee">
                                        ${fn:escapeXml(employee.userName)}
                                    </td>
                                    <c:forEach var="day" items="${daysInMonth}">
                                        <c:set var="attendance" value="${monthAttendance[employee.userId][day]}" />
                                        <c:set var="statusId" value="${empty attendance ? 0 : attendance.statusId}" />
                                        <c:set var="hoursWorked" value="${empty attendance || empty attendance.hoursWorked ? 0 : attendance.hoursWorked}" />
                                        <c:set var="showHours" value="${statusId == 1 || statusId == 3}" />

                                        <td class="day-cell" data-day="${day}">
                                            <div class="attendance-cell">
                                                <input type="hidden" class="attendance-status"
                                                       name="attendance_${employee.userId}_${day}"
                                                       value="${statusId}">
                                                <input type="hidden" class="attendance-hours"
                                                       name="hours_${employee.userId}_${day}"
                                                       value="${hoursWorked}">
                                                <span class="status-dot status-${statusId}"
                                                      onclick="cycleStatus(this)"
                                                      title="Click to change status"></span>
                                                <!-- FIX: always rendered; JS shows/hides it -->
                                                <input type="number" class="hours-input"
                                                       min="0" max="24" step="0.5"
                                                       value="${hoursWorked}"
                                                       style="${showHours ? '' : 'display:none'}"
                                                       onchange="updateHours(this)">
                                            </div>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        // Status cycle order: Not Marked -> Present -> Absent -> Half Day -> Leave -> Not Marked ...
        var STATUS_ORDER = [0, 1, 2, 3, 4];
        var STATUS_LABEL = { 0: '', 1: 'P', 2: 'A', 3: 'H', 4: 'L' };
        var DEFAULT_HOURS = { 1: 8, 3: 4 };

        var ICON_MAP = {
            'success': 'check-circle',
            'danger': 'exclamation-circle',
            'warning': 'exclamation-triangle',
            'info': 'info-circle'
        };

        // keepHours = true on page load so saved hours are not overwritten
        function applyStatusToDot(dotEl, statusId, keepHours) {
            dotEl.className = 'status-dot status-' + statusId;
            dotEl.textContent = STATUS_LABEL[statusId];

            var cell = $(dotEl).closest('.attendance-cell');
            var hoursInput = cell.find('.hours-input');

            if (statusId === 1 || statusId === 3) {          // Present or Half Day
                if (!keepHours && !parseFloat(hoursInput.val())) {
                    hoursInput.val(DEFAULT_HOURS[statusId]);
                }
                hoursInput.show();
            } else {
                hoursInput.val(0).hide();
            }

            cell.find('.attendance-hours').val(hoursInput.val() || 0);
            cell.find('.attendance-status').val(statusId);
        }

        function cycleStatus(dotEl) {
            var current = parseInt($(dotEl).closest('.attendance-cell').find('.attendance-status').val(), 10) || 0;
            var idx = STATUS_ORDER.indexOf(current);
            var next = STATUS_ORDER[(idx + 1) % STATUS_ORDER.length];
            applyStatusToDot(dotEl, next, false);
            updateSummaryCounters();
        }

        function updateHours(inputEl) {
            var $input = $(inputEl);
            var cell = $input.closest('.attendance-cell');
            var status = parseInt(cell.find('.attendance-status').val(), 10);

            if (status !== 1 && status !== 3) {
                $input.val(0);
            }
            cell.find('.attendance-hours').val($input.val() || 0);
            updateSummaryCounters();
        }

        function updateSummaryCounters() {
            var counts = { 1: 0, 2: 0, 3: 0, 4: 0 };
            var totalHours = 0;

            $('.attendance-status').each(function () {
                var v = parseInt($(this).val(), 10);
                if (counts.hasOwnProperty(v)) counts[v]++;

                if (v === 1 || v === 3) {
                    totalHours += parseFloat($(this).closest('.attendance-cell').find('.hours-input').val()) || 0;
                }
            });

            $('#cardPresent').text(counts[1]);
            $('#cardAbsent').text(counts[2]);
            $('#cardHalfday').text(counts[3]);
            $('#cardLeave').text(counts[4]);
            $('#cardHours').text(totalHours.toFixed(1));
        }

        // Alert system
        function showAlert(message, type) {
            type = type || 'info';
            var alertId = 'alert-' + Date.now() + '-' + Math.floor(Math.random() * 1000);
            var iconClass = ICON_MAP[type] || ICON_MAP['info'];

            var $alert = $('<div class="alert-custom"></div>')
                .attr('id', alertId)
                .addClass('alert-' + type);
            $alert.append($('<i class="fas me-2"></i>').addClass('fa-' + iconClass));
            $alert.append(document.createTextNode(message));
            $alert.append(
                $('<button type="button" class="btn-close btn-close-white float-end"></button>')
                    .on('click', function () { removeAlert(alertId); })
            );

            $('#alertContainer').append($alert);
            setTimeout(function () { removeAlert(alertId); }, 5000);
        }

        function removeAlert(alertId) {
            $('#' + alertId).fadeOut(function () { $(this).remove(); });
        }

        // Highlight weekends using real calendar dates
        function highlightWeekends() {
            var monthValue = $('#monthPicker').val();
            if (!monthValue) return;

            var parts = monthValue.split('-');
            var year = parseInt(parts[0], 10);
            var month = parseInt(parts[1], 10) - 1;   // JS months are 0-11

            $('th.day-col, td.day-cell').each(function () {
                var day = parseInt($(this).data('day'), 10);
                var dow = new Date(year, month, day).getDay();   // 0 = Sun, 6 = Sat
                if (dow === 0 || dow === 6) {
                    $(this).addClass('weekend');
                }
            });
        }

        $(document).ready(function () {
            // Initialise dots without overwriting saved hours
            $('.status-dot').each(function () {
                var val = parseInt($(this).closest('.attendance-cell').find('.attendance-status').val(), 10) || 0;
                applyStatusToDot(this, val, true);
            });

            highlightWeekends();
            updateSummaryCounters();

            // Show flash message from the server, if any
            var flash = document.getElementById('flashData');
            if (flash) {
                showAlert(flash.getAttribute('data-message'),
                          flash.getAttribute('data-ok') === 'true' ? 'success' : 'danger');
            }

            // Month / year selection
            function goToMonth(year, month) {
                // roll over year boundaries (e.g. month 13 -> Jan next year)
                while (month < 1)  { month += 12; year--; }
                while (month > 12) { month -= 12; year++; }
                var mm = month < 10 ? '0' + month : '' + month;
                window.location.href = 'attendance-mark-setup?month=' + year + '-' + mm;
            }

            $('#monthSelect, #yearSelect').on('change', function () {
                goToMonth(parseInt($('#yearSelect').val(), 10), parseInt($('#monthSelect').val(), 10));
            });

            $('#prevMonthBtn').on('click', function () {
                goToMonth(parseInt($('#yearSelect').val(), 10), parseInt($('#monthSelect').val(), 10) - 1);
            });

            $('#nextMonthBtn').on('click', function () {
                goToMonth(parseInt($('#yearSelect').val(), 10), parseInt($('#monthSelect').val(), 10) + 1);
            });

            // Select all rows
            $('#selectAllRows').on('change', function () {
                $('.row-select').prop('checked', $(this).is(':checked'));
            });

            $('#selectAllBtn').on('click', function () {
                $('.row-select, #selectAllRows').prop('checked', true);
            });

            $('#clearSelectionBtn').on('click', function () {
                $('.row-select, #selectAllRows').prop('checked', false);
            });

            // Quick fill (All Present / Half Day / Leave / Absent / Clear)
            $('.quick-fill').on('click', function () {
                var status = parseInt($(this).data('status'), 10);
                var scope = $('#bulkScope').val();
                var skipWeekends = $('#skipWeekends').is(':checked');
                var onlyUnmarked = $('#onlyUnmarked').is(':checked');

                var rows = (scope === 'selected')
                    ? $('.row-select:checked').closest('tr')
                    : $('#attendanceGrid tbody tr');

                if (rows.length === 0) {
                    showAlert(scope === 'selected'
                        ? 'Tick at least one employee, or choose "All employees"'
                        : 'No employees to update', 'warning');
                    return;
                }

                var changed = 0;
                rows.each(function () {
                    $(this).find('td.day-cell').each(function () {
                        if (skipWeekends && $(this).hasClass('weekend')) return;

                        var cell = $(this).find('.attendance-cell');
                        var current = parseInt(cell.find('.attendance-status').val(), 10) || 0;
                        if (onlyUnmarked && current !== 0) return;

                        applyStatusToDot(cell.find('.status-dot')[0], status, false);
                        changed++;
                    });
                });

                updateSummaryCounters();
                showAlert('Updated ' + changed + ' day(s) for ' + rows.length + ' employee(s)',
                          changed > 0 ? 'success' : 'info');
            });

            // Save attendance
            $('#saveAttendanceBtn').on('click', function () {
                if (!confirm('Save attendance for the whole month? This will overwrite any existing entries.')) {
                    return;
                }
                // FIX: spinner shown only after the user confirms
                $('#loadingSpinner').css('display', 'flex');
                $('#saveAttendanceBtn').prop('disabled', true);
                $('#attendanceForm').trigger('submit');
            });
        });
    </script>
</body>
</html>
