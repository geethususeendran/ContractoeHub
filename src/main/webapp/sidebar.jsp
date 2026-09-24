<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar CSS -->
<style>
    /* ---- Layout variables (the page's .main-wrapper reads --sidebar-width) ---- */
    :root {
        --sidebar-width: 250px;
        --sidebar-width-collapsed: 72px;
    }

    body.sidebar-collapsed {
        --sidebar-width: var(--sidebar-width-collapsed);
    }

    /* ---- Sidebar shell ---- */
    .sidebar {
        background: linear-gradient(180deg, #16697a 0%, #0b3a45 100%);
        color: #fff;
        width: var(--sidebar-width);
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        padding: 56px 0 24px;
        z-index: 1000;
        transition: width 0.25s ease, transform 0.25s ease;
        overflow-y: auto;
        overflow-x: hidden;
        box-shadow: 2px 0 14px rgba(0, 0, 0, 0.18);
        scrollbar-width: thin;
        scrollbar-color: rgba(255, 255, 255, 0.25) transparent;
    }

    .sidebar-toggle {
        position: absolute;
        top: 12px;
        right: 14px;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(255, 255, 255, 0.08);
        border: none;
        border-radius: 8px;
        color: #fff;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .sidebar-toggle:hover,
    .sidebar-toggle:focus-visible {
        background: rgba(255, 255, 255, 0.2);
        outline: none;
    }

    /* ---- Profile ---- */
    .sidebar-profile {
        text-align: center;
        padding: 4px 16px 20px;
        margin-bottom: 8px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.12);
    }

    .sidebar .rounded-circle {
        width: 72px;
        height: 72px;
        object-fit: cover;
        border: 3px solid rgba(255, 255, 255, 0.85);
        transition: width 0.25s, height 0.25s;
    }

    .sidebar-profile h5 {
        font-size: 1rem;
        font-weight: 600;
        margin: 12px 0 4px;
        color: #fff;
    }

    .sidebar .text-grey {
        color: rgba(255, 255, 255, 0.72);
        font-size: 0.8rem;
        line-height: 1.6;
        margin: 0;
        word-break: break-word;
    }

    /* ---- Section labels ---- */
    .nav-category {
        color: rgba(255, 255, 255, 0.55);
        font-size: 0.72rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        padding: 16px 24px 6px;
    }

    /* ---- Links ---- */
    .sidebar .nav-link {
        color: rgba(255, 255, 255, 0.88);
        display: flex;
        align-items: center;
        gap: 12px;
        margin: 2px 12px;
        padding: 10px 12px;
        border-radius: 8px;
        font-size: 0.95rem;
        transition: background-color 0.2s, color 0.2s, box-shadow 0.2s;
    }

    .sidebar .nav-link i:not(.submenu-toggle) {
        width: 20px;
        text-align: center;
        flex-shrink: 0;
    }

    .sidebar .nav-link:hover,
    .sidebar .nav-link:focus-visible {
        background-color: rgba(255, 255, 255, 0.10);
        color: #fff;
        outline: none;
    }

    .sidebar .nav-link.active {
        background-color: rgba(255, 255, 255, 0.16);
        color: #fff;
        font-weight: 600;
        box-shadow: inset 3px 0 0 var(--highlight-color, #ffa62b);
    }

    .nav-text {
        white-space: nowrap;
    }

    /* ---- Submenus ---- */
    .sidebar .submenu {
        margin: 2px 12px 6px 30px;
        padding-left: 10px;
        border-left: 1px solid rgba(255, 255, 255, 0.18);
    }

    .sidebar .submenu .nav-link {
        margin: 2px 0;
        padding: 8px 10px;
        font-size: 0.9rem;
    }

    .submenu-toggle {
        margin-left: auto;
        font-size: 0.7rem;
        opacity: 0.8;
        transition: transform 0.25s;
    }

    .rotate-toggle {
        transform: rotate(180deg);
    }

    /* ---- Mobile toggle button ---- */
    .mobile-sidebar-toggle {
        display: none;
        position: fixed;
        top: 14px;
        left: 14px;
        z-index: 1100;
        width: 40px;
        height: 40px;
        align-items: center;
        justify-content: center;
        background-color: var(--primary-color, #16697a);
        color: #fff;
        border: none;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
        cursor: pointer;
    }

    /* ---- Collapsed (desktop only) ---- */
    @media (min-width: 769px) {
        body.sidebar-collapsed .sidebar-toggle {
            right: auto;
            left: 50%;
            transform: translateX(-50%);
        }

        body.sidebar-collapsed .sidebar .rounded-circle {
            width: 40px;
            height: 40px;
            border-width: 2px;
        }

        body.sidebar-collapsed .sidebar-profile {
            padding-bottom: 12px;
        }

        body.sidebar-collapsed .sidebar-profile .profile-details,
        body.sidebar-collapsed .nav-text,
        body.sidebar-collapsed .submenu-toggle,
        body.sidebar-collapsed .nav-category {
            display: none;
        }

        body.sidebar-collapsed .sidebar .nav-link {
            justify-content: center;
            padding: 12px 0;
        }

        body.sidebar-collapsed .sidebar .nav-link.active {
            box-shadow: none;
        }

        body.sidebar-collapsed .has-submenu .submenu {
            display: none !important;
        }
    }

    /* ---- Mobile ---- */
    @media (max-width: 768px) {
        .sidebar {
            width: 250px;
            transform: translateX(-100%);
        }

        .sidebar.show {
            transform: translateX(0);
        }

        .sidebar-toggle {
            display: none;
        }

        .mobile-sidebar-toggle {
            display: flex;
        }
    }
</style>

<!-- Sidebar Component -->
<div class="sidebar" id="sidebar">
    <button type="button" class="sidebar-toggle" id="sidebar-toggle" aria-label="Collapse sidebar">
        <i class="fas fa-chevron-left" id="toggle-icon"></i>
    </button>

    <!-- Profile Section -->
    <div class="sidebar-profile">
        <img src="img/manicon.jpg" alt="Profile" class="rounded-circle">
        <div class="profile-details">
            <h5>Suseendran V</h5>
            <p class="text-grey">
                +91 9447037437<br>
                suseendranv1960@gmail.com<br>
                Contractor
            </p>
        </div>
    </div>

    <!-- Main Navigation -->
    <div class="nav-category">Main Navigation</div>
    <nav class="nav flex-column">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="contractor-dashboard.jsp">
            <i class="fas fa-chart-pie"></i>
            <span class="nav-text">Dashboard</span>
        </a>

        <div class="has-submenu">
            <a class="nav-link ${currentPage == 'employees' ? 'active' : ''}" href="#employeeSubmenu"
               data-bs-toggle="collapse" aria-expanded="${currentPage == 'employees'}">
                <i class="fas fa-users"></i>
                <span class="nav-text">Employees</span>
                <i class="fas fa-chevron-down submenu-toggle ${currentPage == 'employees' ? 'rotate-toggle' : ''}"></i>
            </a>
            <div class="submenu collapse ${currentPage == 'employees' ? 'show' : ''}" id="employeeSubmenu">
                <a class="nav-link ${currentSubPage == 'registration' ? 'active' : ''}" href="/employee-registration">
                    <i class="fas fa-user-plus"></i>
                    <span class="nav-text">Registration</span>
                </a>
                <a class="nav-link ${currentSubPage == 'list' ? 'active' : ''}" href="/employee-list">
                    <i class="fas fa-list"></i>
                    <span class="nav-text">Employee List</span>
                </a>
                <a class="nav-link ${currentSubPage == 'attendance' ? 'active' : ''}" href="/attendance-mark-setup">
                    <i class="fas fa-calendar-check"></i>
                    <span class="nav-text">Attendance</span>
                </a>
                <a class="nav-link ${currentSubPage == 'certificate' ? 'active' : ''}" href="/experience-certificate-generate">
                    <i class="fas fa-certificate"></i>
                    <span class="nav-text">Experience Certificate</span>
                </a>
            </div>
        </div>

        <div class="has-submenu">
            <a class="nav-link ${currentPage == 'inventory' ? 'active' : ''}" href="#inventorySubmenu"
               data-bs-toggle="collapse" aria-expanded="${currentPage == 'inventory'}">
                <i class="fas fa-warehouse"></i>
                <span class="nav-text">Inventory</span>
                <i class="fas fa-chevron-down submenu-toggle ${currentPage == 'inventory' ? 'rotate-toggle' : ''}"></i>
            </a>
            <div class="submenu collapse ${currentPage == 'inventory' ? 'show' : ''}" id="inventorySubmenu">
                <a class="nav-link ${currentSubPage == 'add' ? 'active' : ''}" href="/inventory-add">
                    <i class="fas fa-plus-circle"></i>
                    <span class="nav-text">Add Items</span>
                </a>
                <a class="nav-link ${currentSubPage == 'manage' ? 'active' : ''}" href="/inventory-manage">
                    <i class="fas fa-tasks"></i>
                    <span class="nav-text">Manage Items</span>
                </a>
            </div>
        </div>

        <div class="has-submenu">
            <a class="nav-link ${currentPage == 'finance' ? 'active' : ''}" href="#financeSubmenu"
               data-bs-toggle="collapse" aria-expanded="${currentPage == 'finance'}">
                <i class="fas fa-wallet"></i>
                <span class="nav-text">Finance</span>
                <i class="fas fa-chevron-down submenu-toggle ${currentPage == 'finance' ? 'rotate-toggle' : ''}"></i>
            </a>
            <div class="submenu collapse ${currentPage == 'finance' ? 'show' : ''}" id="financeSubmenu">
                <a class="nav-link ${currentSubPage == 'petty-bill' ? 'active' : ''}" href="/petty-bill">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <span class="nav-text">Petty Bill</span>
                </a>
                <a class="nav-link ${currentSubPage == 'expenses' ? 'active' : ''}" href="/expenses">
                    <i class="fas fa-money-bill-wave"></i>
                    <span class="nav-text">Expenses</span>
                </a>
                <a class="nav-link ${currentSubPage == 'income' ? 'active' : ''}" href="/income">
                    <i class="fas fa-coins"></i>
                    <span class="nav-text">Income</span>
                </a>
            </div>
        </div>

        <div class="has-submenu">
            <a class="nav-link ${currentPage == 'reports' ? 'active' : ''}" href="#reportsSubmenu"
               data-bs-toggle="collapse" aria-expanded="${currentPage == 'reports'}">
                <i class="fas fa-chart-line"></i>
                <span class="nav-text">Reports</span>
                <i class="fas fa-chevron-down submenu-toggle ${currentPage == 'reports' ? 'rotate-toggle' : ''}"></i>
            </a>
            <div class="submenu collapse ${currentPage == 'reports' ? 'show' : ''}" id="reportsSubmenu">
                <a class="nav-link ${currentSubPage == 'employee-reports' ? 'active' : ''}" href="/reports/employee">
                    <i class="fas fa-id-card"></i>
                    <span class="nav-text">Employee Reports</span>
                </a>
                <a class="nav-link ${currentSubPage == 'inventory-reports' ? 'active' : ''}" href="/reports/inventory">
                    <i class="fas fa-boxes"></i>
                    <span class="nav-text">Inventory Reports</span>
                </a>
                <a class="nav-link ${currentSubPage == 'financial-reports' ? 'active' : ''}" href="/reports/financial">
                    <i class="fas fa-money-bill-wave"></i>
                    <span class="nav-text">Financial Reports</span>
                </a>
            </div>
        </div>
    </nav>

    <!-- System Navigation -->
    <div class="nav-category">System</div>
    <nav class="nav flex-column">
        <a class="nav-link ${currentPage == 'settings' ? 'active' : ''}" href="/settings">
            <i class="fas fa-cog"></i>
            <span class="nav-text">Settings</span>
        </a>
        <a class="nav-link ${currentPage == 'help' ? 'active' : ''}" href="/help">
            <i class="fas fa-question-circle"></i>
            <span class="nav-text">Help &amp; Support</span>
        </a>
        <a class="nav-link" href="/logout">
            <i class="fas fa-sign-out-alt"></i>
            <span class="nav-text">Logout</span>
        </a>
    </nav>
</div>

<!-- Mobile Sidebar Toggle Button -->
<button type="button" class="mobile-sidebar-toggle" id="mobile-sidebar-toggle" aria-label="Open menu">
    <i class="fas fa-bars"></i>
</button>

<!-- Sidebar JavaScript -->
<script>
(function () {
    var body = document.body;
    var sidebar = document.getElementById('sidebar');
    var sidebarToggle = document.getElementById('sidebar-toggle');
    var mobileToggle = document.getElementById('mobile-sidebar-toggle');
    var toggleIcon = document.getElementById('toggle-icon');

    function setCollapsed(collapsed) {
        body.classList.toggle('sidebar-collapsed', collapsed);
        if (toggleIcon) {
            toggleIcon.classList.toggle('fa-chevron-left', !collapsed);
            toggleIcon.classList.toggle('fa-chevron-right', collapsed);
        }
        try { localStorage.setItem('sidebarCollapsed', collapsed ? '1' : '0'); } catch (e) {}
    }

    // Restore the last state immediately so the page doesn't jump
    try {
        if (localStorage.getItem('sidebarCollapsed') === '1') {
            body.classList.add('sidebar-collapsed');
            if (toggleIcon) {
                toggleIcon.classList.remove('fa-chevron-left');
                toggleIcon.classList.add('fa-chevron-right');
            }
        }
    } catch (e) {}

    // Tooltips for the icon-only (collapsed) mode
    sidebar.querySelectorAll('.nav-link').forEach(function (link) {
        var label = link.querySelector('.nav-text');
        if (label) link.setAttribute('title', label.textContent.trim());
    });

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function () {
            setCollapsed(!body.classList.contains('sidebar-collapsed'));
        });
    }

    if (mobileToggle) {
        mobileToggle.addEventListener('click', function () {
            sidebar.classList.toggle('show');
        });
    }

    // Bootstrap already opens/closes the submenus (data-bs-toggle="collapse").
    // We only keep the chevron in sync with it.
    sidebar.querySelectorAll('.submenu').forEach(function (submenu) {
        var arrow = submenu.parentElement.querySelector('.submenu-toggle');
        submenu.addEventListener('show.bs.collapse', function () {
            if (arrow) arrow.classList.add('rotate-toggle');
        });
        submenu.addEventListener('hide.bs.collapse', function () {
            if (arrow) arrow.classList.remove('rotate-toggle');
        });
    });

    // In icon-only mode, clicking a parent item expands the sidebar first
    sidebar.querySelectorAll('.has-submenu > a').forEach(function (link) {
        link.addEventListener('click', function () {
            if (body.classList.contains('sidebar-collapsed') && window.innerWidth > 768) {
                setCollapsed(false);
            }
        });
    });

    // Close the drawer when tapping outside it on mobile
    document.addEventListener('click', function (event) {
        if (window.innerWidth <= 768 && sidebar && mobileToggle) {
            if (!sidebar.contains(event.target) && !mobileToggle.contains(event.target)) {
                sidebar.classList.remove('show');
            }
        }
    });
})();
</script>
