<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titanium Contractor Operations Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 (same as the sidebar and the other pages) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Same palette as the side nav and the other pages */
            --brand: #16697a;
            --brand-dark: #0e3d47;
            --brand-light: #489fb5;
            --brand-soft: rgba(22, 105, 122, 0.10);
            --accent: #82c0cc;
            --highlight: #ffa62b;

            --success: #2f9e6f;
            --warning: #e08e0b;
            --danger: #d64545;

            --surface: #ffffff;
            --bg: #f0f5f7;
            --text-dark: #24343d;
            --text-muted: #64777f;
            --border: #dfe8ec;
            --border-soft: #eaf0f3;

            --radius-lg: 14px;
            --radius-md: 12px;
            --space-1: 8px;
            --space-2: 16px;
            --space-3: 24px;
            --shadow-soft: 0 2px 14px rgba(22, 105, 122, 0.08);
            --shadow-hover: 0 12px 28px rgba(22, 105, 122, 0.16);

            /* Sidebar widths (collapsed state is switched in sidebar.jsp) */
            --sidebar-width: 250px;
            --sidebar-width-collapsed: 72px;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Inter', Arial, Helvetica, sans-serif;
            background:
                radial-gradient(circle at top right, rgba(22, 105, 122, 0.08), transparent 40%),
                var(--bg);
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* Sits to the right of the fixed sidebar and follows its collapsed state */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: var(--space-3) 32px 48px;
            transition: margin-left 0.25s ease;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ===== Top header ===== */
        .top-header {
            background: var(--surface);
            padding: 14px 22px;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-soft);
            border: 1px solid var(--border-soft);
            margin-bottom: var(--space-3) !important;
        }

        .top-header img {
            box-shadow: 0 2px 8px rgba(22, 105, 122, 0.25);
            border: 2px solid var(--border);
        }

        .top-header h3 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.35rem;
            letter-spacing: -0.02em;
            color: var(--text-dark);
        }

        .top-header small { font-weight: 500; color: var(--text-muted); }

        .top-header .btn-primary {
            background: linear-gradient(135deg, var(--brand), var(--brand-dark));
            border: none;
            padding: 8px 18px;
            border-radius: 999px;
            font-weight: 600;
            letter-spacing: 0.02em;
            box-shadow: 0 4px 12px rgba(22, 105, 122, 0.3);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .top-header .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(22, 105, 122, 0.38);
        }

        /* ===== Welcome banner ===== */
        .welcome-banner {
            background: linear-gradient(135deg, var(--brand), var(--brand-light));
            color: #fff;
            padding: 30px 36px;
            border-radius: var(--radius-lg);
            position: relative;
            overflow: hidden;
            box-shadow: 0 12px 28px rgba(22, 105, 122, 0.28);
        }

        .welcome-banner::before {
            content: "";
            position: absolute;
            top: -60px;
            right: -60px;
            width: 220px;
            height: 220px;
            background: rgba(255, 255, 255, 0.12);
            border-radius: 50%;
        }

        .welcome-banner::after {
            content: "";
            position: absolute;
            bottom: -80px;
            right: 100px;
            width: 180px;
            height: 180px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }

        .welcome-banner h2 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 6px;
            position: relative;
            z-index: 1;
        }

        .welcome-banner p {
            position: relative;
            z-index: 1;
            opacity: 0.92;
            font-size: 1rem;
        }

        /* ===== Stats grid ===== */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: var(--space-2);
            margin-top: var(--space-3);
        }

        .stat-card {
            background: var(--surface);
            padding: 20px 22px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-soft);
            border: 1px solid var(--border-soft);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--brand), var(--brand-light));
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }

        .stat-card .h5 {
            font-family: 'Poppins', sans-serif;
            font-weight: 700;
            font-size: 1.6rem;
            margin-bottom: 2px;
            color: var(--text-dark);
        }

        .stat-card .text-muted {
            font-size: 0.8rem;
            font-weight: 500;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            color: var(--text-muted) !important;
        }

        .stat-card i {
            padding: 14px;
            border-radius: var(--radius-md);
            background: var(--brand-soft);
        }

        /* Bootstrap's default blue would clash with the teal palette */
        .stat-card i.text-primary { color: var(--brand) !important; background: var(--brand-soft); }
        .stat-card i.text-success { color: var(--success) !important; background: rgba(47, 158, 111, 0.12); }
        .stat-card i.text-warning { color: var(--warning) !important; background: rgba(224, 142, 11, 0.12); }
        .stat-card i.text-danger  { color: var(--danger) !important;  background: rgba(214, 69, 69, 0.12); }

        /* ===== Content panels ===== */
        .content-grid {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: var(--space-3);
            margin-top: var(--space-3);
            align-items: start;
        }

        .panel {
            background: var(--surface);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-soft);
            border: 1px solid var(--border-soft);
            padding: 22px 24px;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--space-2);
        }

        .panel-header h5 {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            font-size: 1.05rem;
            margin: 0;
        }

        .panel-header a {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--brand);
            text-decoration: none;
        }

        .panel-header a:hover { color: var(--brand-dark); text-decoration: underline; }

        .panel-nested {
            margin-top: var(--space-3);
            box-shadow: none;
            background: #f5f9fa;
        }

        .panel-stack > .panel + .panel { margin-top: var(--space-3); }

        /* Activity feed */
        .activity-item {
            display: flex;
            gap: 14px;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-soft);
        }

        .activity-item:last-of-type { border-bottom: none; }

        .activity-icon {
            width: 38px;
            height: 38px;
            min-width: 38px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
        }

        .activity-icon.brand   { background: var(--brand-soft);              color: var(--brand); }
        .activity-icon.success { background: rgba(47, 158, 111, 0.12);       color: var(--success); }
        .activity-icon.warning { background: rgba(224, 142, 11, 0.12);       color: var(--warning); }
        .activity-icon.danger  { background: rgba(214, 69, 69, 0.12);        color: var(--danger); }

        .activity-title {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-dark);
            margin-bottom: 2px;
        }

        .activity-time {
            font-size: 0.78rem;
            color: var(--text-muted);
        }

        /* Task list */
        .task-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid var(--border-soft);
        }

        .task-item:last-of-type { border-bottom: none; }

        .task-priority {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            min-width: 8px;
        }

        .task-name {
            font-size: 0.88rem;
            font-weight: 500;
            color: var(--text-dark);
            flex: 1;
        }

        .task-badge {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 999px;
        }

        .prio-high   .task-priority { background: var(--danger); }
        .prio-high   .task-badge    { background: rgba(214, 69, 69, 0.12);  color: var(--danger); }
        .prio-medium .task-priority { background: var(--warning); }
        .prio-medium .task-badge    { background: rgba(224, 142, 11, 0.12); color: var(--warning); }
        .prio-info   .task-priority { background: var(--brand); }
        .prio-info   .task-badge    { background: var(--brand-soft);        color: var(--brand); }
        .prio-low    .task-priority { background: var(--success); }
        .prio-low    .task-badge    { background: rgba(47, 158, 111, 0.12); color: var(--success); }

        /* Team overview progress bars */
        .progress-row { margin-bottom: var(--space-2); }
        .progress-row:last-child { margin-bottom: 0; }

        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .progress-track {
            background: var(--border-soft);
            border-radius: 999px;
            height: 8px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, var(--brand), var(--brand-light));
        }

        .progress-fill.success { background: linear-gradient(90deg, var(--success), #5fc79a); }
        .progress-fill.warning { background: linear-gradient(90deg, var(--warning), var(--highlight)); }

        /* Quick actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .quick-action-btn {
            background: #f5f9fa;
            border: 1px solid var(--border-soft);
            border-radius: var(--radius-md);
            padding: 14px 10px;
            text-align: center;
            text-decoration: none;
            color: var(--text-dark);
            font-size: 0.82rem;
            font-weight: 600;
            transition: background-color 0.2s ease, color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
        }

        .quick-action-btn i {
            display: block;
            font-size: 1.3rem;
            margin-bottom: 6px;
            color: var(--brand);
        }

        .quick-action-btn:hover {
            background: var(--brand);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 8px 16px rgba(22, 105, 122, 0.25);
        }

        .quick-action-btn:hover i { color: #fff; }

        @media (max-width: 992px) {
            .content-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .main-content { margin-left: 0; padding: 68px var(--space-2) var(--space-2); }
            .welcome-banner { padding: 24px 22px; }
        }
    </style>
</head>
<body>
    <!-- Highlight "Dashboard" in the side nav -->
    <c:set var="currentPage" value="dashboard" scope="request" />
    <jsp:include page="sidebar.jsp" />

    <div class="main-content" id="main-content">
        <div class="top-header d-flex justify-content-between align-items-center mb-3">
            <div class="d-flex align-items-center gap-3">
                <img src="img/logo.jpg" alt="Logo" style="width:48px;height:48px;border-radius:8px;object-fit:cover;">
                <div>
                    <h3 class="mb-0">Operations Hub</h3>
                    <small>Welcome back</small>
                </div>
            </div>
            <div>
                <a href="/logout" class="btn btn-sm btn-primary"><i class="fas fa-sign-out-alt me-1"></i> Logout</a>
            </div>
        </div>

        <div class="welcome-banner">
            <h2>Welcome back!</h2>
            <p class="mb-0">Quick overview of your operations.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="h5">254</div>
                        <div class="text-muted">Total Employees</div>
                    </div>
                    <div><i class="fas fa-users fa-2x text-primary"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="h5">98%</div>
                        <div class="text-muted">Attendance Rate</div>
                    </div>
                    <div><i class="fas fa-user-check fa-2x text-success"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="h5">&#8377;2.4L</div>
                        <div class="text-muted">Inventory Value</div>
                    </div>
                    <div><i class="fas fa-boxes fa-2x text-warning"></i></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="h5">8</div>
                        <div class="text-muted">Pending Tasks</div>
                    </div>
                    <div><i class="fas fa-tasks fa-2x text-danger"></i></div>
                </div>
            </div>
        </div>

        <div class="content-grid">
            <div class="panel">
                <div class="panel-header">
                    <h5>Recent Activity</h5>
                    <a href="#">View all</a>
                </div>

                <div class="activity-item">
                    <div class="activity-icon brand"><i class="fas fa-user-plus"></i></div>
                    <div>
                        <div class="activity-title">New employee onboarded &mdash; Ravi Kumar</div>
                        <div class="activity-time">10 minutes ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon success"><i class="fas fa-check"></i></div>
                    <div>
                        <div class="activity-title">Attendance synced for Site B</div>
                        <div class="activity-time">42 minutes ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon warning"><i class="fas fa-box"></i></div>
                    <div>
                        <div class="activity-title">Inventory restock request approved</div>
                        <div class="activity-time">1 hour ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon danger"><i class="fas fa-exclamation"></i></div>
                    <div>
                        <div class="activity-title">Task overdue &mdash; Site inspection report</div>
                        <div class="activity-time">3 hours ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon brand"><i class="fas fa-file-invoice"></i></div>
                    <div>
                        <div class="activity-title">Invoice #4521 generated for Client A</div>
                        <div class="activity-time">5 hours ago</div>
                    </div>
                </div>

                <div class="panel panel-nested">
                    <div class="panel-header">
                        <h5>Team Overview</h5>
                    </div>
                    <div class="progress-row">
                        <div class="progress-label"><span>On-site Workforce</span><span>82%</span></div>
                        <div class="progress-track"><div class="progress-fill" style="width:82%;"></div></div>
                    </div>
                    <div class="progress-row">
                        <div class="progress-label"><span>Training Completion</span><span>67%</span></div>
                        <div class="progress-track"><div class="progress-fill success" style="width:67%;"></div></div>
                    </div>
                    <div class="progress-row">
                        <div class="progress-label"><span>Safety Compliance</span><span>94%</span></div>
                        <div class="progress-track"><div class="progress-fill warning" style="width:94%;"></div></div>
                    </div>
                </div>
            </div>

            <div class="panel-stack">
                <div class="panel">
                    <div class="panel-header">
                        <h5>Quick Actions</h5>
                    </div>
                    <div class="quick-actions">
                        <a href="/employee-registration" class="quick-action-btn"><i class="fas fa-user-plus"></i>Add Employee</a>
                        <a href="/attendance-mark-setup" class="quick-action-btn"><i class="fas fa-calendar-check"></i>Mark Attendance</a>
                        <a href="/inventory-manage" class="quick-action-btn"><i class="fas fa-box-open"></i>Inventory</a>
                        <a href="/petty-bill" class="quick-action-btn"><i class="fas fa-file-invoice-dollar"></i>New Invoice</a>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h5>Pending Tasks</h5>
                        <a href="#">View all</a>
                    </div>

                    <div class="task-item prio-high">
                        <div class="task-priority"></div>
                        <div class="task-name">Site inspection report &mdash; Block C</div>
                        <div class="task-badge">High</div>
                    </div>
                    <div class="task-item prio-medium">
                        <div class="task-priority"></div>
                        <div class="task-name">Review vendor quotations</div>
                        <div class="task-badge">Medium</div>
                    </div>
                    <div class="task-item prio-info">
                        <div class="task-priority"></div>
                        <div class="task-name">Update payroll records</div>
                        <div class="task-badge">Medium</div>
                    </div>
                    <div class="task-item prio-low">
                        <div class="task-priority"></div>
                        <div class="task-name">Approve leave requests</div>
                        <div class="task-badge">Low</div>
                    </div>
                    <div class="task-item prio-high">
                        <div class="task-priority"></div>
                        <div class="task-name">Client A contract renewal</div>
                        <div class="task-badge">High</div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap JS (needed by the sidebar submenus) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
</body>
</html>
