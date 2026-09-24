package com.contractorHub.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.contractorHub.pojo.AttendanceMarking;
import com.contractorHub.pojo.UserDetails;
import com.contractorHub.service.DashboardService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {

    @Autowired
    private DashboardService dashService;

    private static final String UPLOAD_DIR = "other-docs";

    @GetMapping("/")
    public String getDashboard() {
        return "contractor-dashboard";
    }

    @GetMapping("/employee-registration")
    public String getEmpRegistration(Model model, HttpServletRequest req, HttpSession session) {
        model.addAttribute("contractorList", dashService.getAllContractorList());
        model.addAttribute("roleList", dashService.getAllRoleList());
        model.addAttribute("empList", dashService.getAllEmployeesList());
        return "employee_registration";
    }

    @GetMapping("/employee-list")
    public String getEmployeeList(Model model) {
        model.addAttribute("contractorList", dashService.getAllContractorList());
        model.addAttribute("roleList", dashService.getAllRoleList());
        model.addAttribute("empList", dashService.getAllEmployeesList());
        return "employees_list";
    }

    @PostMapping("submit-employee-details")
    public String SaveEmpDetails(HttpServletRequest req, HttpSession session,
                                 @RequestParam("customFile") MultipartFile file) {
        String applicationPath = req.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        return dashService.saveEmpdetails(req, session, file, applicationPath, uploadFilePath);
    }

    // FIX: public; session key "userId" used consistently (was "userId" here, "userID" in delete)
    @GetMapping("edit-employee-details")
    public String editEmpRegistrationDetails(Model model, HttpServletRequest req, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:employee-list";
        }
        model.addAttribute("contractorList", dashService.getAllContractorList());
        model.addAttribute("roleList", dashService.getAllRoleList());
        model.addAttribute("editEmpList", dashService.getAllEmployeesListById(userId));
        return "employee_registration";
    }

    @GetMapping("delete-employee-registration")
    public String deleteEmpRegistrationDetails(Model model, HttpServletRequest req, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:employee-list";
        }
        UserDetails dtls = dashService.getAllEmployeesListById(userId);
        dashService.deleteUserDtls(dtls);
        return "redirect:employee-list";
    }

    @GetMapping("/attendance-mark-setup")
    public String getAttendance(Model model,
                                @RequestParam(required = false) String date,
                                @RequestParam(required = false) String month,
                                HttpServletRequest req,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        YearMonth selectedMonth = YearMonth.now();

        try {
            LocalDate selectedDate = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
            selectedMonth = (month == null || month.isBlank())
                    ? YearMonth.from(selectedDate)
                    : YearMonth.parse(month);   // expects yyyy-MM

            Date monthStart = Date.from(selectedMonth.atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date monthEnd = Date.from(selectedMonth.plusMonths(1).atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant());

            List<UserDetails> empList = dashService.getAllEmployeesList();
            List<AttendanceMarking> monthlyAttendance = dashService.getAttendanceBetween(monthStart, monthEnd);

            // employeeId -> day -> attendance
            Map<Integer, Map<Integer, AttendanceMarking>> monthAttendance = new HashMap<>();
            for (UserDetails emp : empList) {
                monthAttendance.put(emp.getUserId(), new HashMap<>());
            }

            if (monthlyAttendance != null) {
                for (AttendanceMarking attendance : monthlyAttendance) {
                    if (attendance.getEmpId() == null || attendance.getDate() == null) continue;

                    int employeeId = attendance.getEmpId().getUserId();
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(attendance.getDate());
                    int day = cal.get(Calendar.DAY_OF_MONTH);

                    monthAttendance.computeIfAbsent(employeeId, k -> new HashMap<>()).put(day, attendance);
                }
            }

            int presentCount = 0, absentCount = 0, halfdayCount = 0, leaveCount = 0;
            double totalHours = 0;
            for (Map<Integer, AttendanceMarking> employeeAttendance : monthAttendance.values()) {
                for (AttendanceMarking attendance : employeeAttendance.values()) {
                    switch (attendance.getStatusId()) {
                        case 1: presentCount++; break;
                        case 2: absentCount++; break;
                        case 3: halfdayCount++; break;
                        case 4: leaveCount++; break;
                        default: break;
                    }
                    if ((attendance.getStatusId() == 1 || attendance.getStatusId() == 3)
                            && attendance.getHoursWorked() != null) {
                        totalHours += attendance.getHoursWorked();
                    }
                }
            }

            List<Integer> daysInMonth = IntStream.rangeClosed(1, selectedMonth.lengthOfMonth())
                    .boxed()
                    .collect(Collectors.toList());

            model.addAttribute("empList", empList);
            model.addAttribute("daysInMonth", daysInMonth);
            model.addAttribute("selectedMonth", selectedMonth.toString());          // e.g. 2026-09
            model.addAttribute("selectedYear", selectedMonth.getYear());
            model.addAttribute("selectedMonthNumber", selectedMonth.getMonthValue());
            model.addAttribute("monthAttendance", monthAttendance);
            model.addAttribute("presentCount", presentCount);
            model.addAttribute("absentCount", absentCount);
            model.addAttribute("halfdayCount", halfdayCount);
            model.addAttribute("leaveCount", leaveCount);
            model.addAttribute("totalHours", totalHours);

            return "attendance-marking";

        } catch (DateTimeParseException e) {
            // Redirect to the default (current) month - no params, so no redirect loop
            redirectAttributes.addFlashAttribute("req_status", false);
            redirectAttributes.addFlashAttribute("message", "Invalid date format provided");
            return "redirect:/attendance-mark-setup";

        } catch (Exception e) {
            // FIX: render the page with an empty model instead of redirecting to itself forever
            e.printStackTrace();
            model.addAttribute("empList", new ArrayList<UserDetails>());
            model.addAttribute("daysInMonth", IntStream.rangeClosed(1, selectedMonth.lengthOfMonth())
                    .boxed().collect(Collectors.toList()));
            model.addAttribute("selectedMonth", selectedMonth.toString());
            model.addAttribute("selectedYear", selectedMonth.getYear());
            model.addAttribute("selectedMonthNumber", selectedMonth.getMonthValue());
            model.addAttribute("monthAttendance", new HashMap<Integer, Map<Integer, AttendanceMarking>>());
            model.addAttribute("presentCount", 0);
            model.addAttribute("absentCount", 0);
            model.addAttribute("halfdayCount", 0);
            model.addAttribute("leaveCount", 0);
            model.addAttribute("totalHours", 0);
            model.addAttribute("req_status", false);
            model.addAttribute("message", "Error loading attendance: " + e.getMessage());
            return "attendance-marking";
        }
    }

    @GetMapping("/petty-bill")
    public String getPettyBill(Model model, HttpServletRequest req, HttpSession session) {
        model.addAttribute("contractorList", dashService.getAllContractorList());
        return "petty-bill-setup";
    }

    @GetMapping("/experience-certificate-generate")
    public String getEmployeeCertificate(Model model) {
        return "experience-certificate-generate";
    }

    @RequestMapping(value = "/get-employee-list", method = RequestMethod.GET)
    @ResponseBody
    public String getEmployeeListBy(@RequestParam("contractorId") int contractorId) {
        try {
            List<UserDetails> list = dashService.getEmployeesListById(contractorId);
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString(list);
        } catch (Exception e) {
            e.printStackTrace();
            return "[]";
        }
    }

    @PostMapping("/save-attendance-month")
    public String saveAttendanceDtls(HttpServletRequest req, HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        String monthParam = req.getParameter("month");   // expects yyyy-MM, e.g. 2026-09

        try {
            if (monthParam == null || monthParam.isBlank()) {
                throw new IllegalArgumentException("Month is required");
            }
            YearMonth ym = YearMonth.parse(monthParam);

            // Cache employees so we don't query once per cell
            Map<Integer, UserDetails> employeeCache = new HashMap<>();
            for (UserDetails emp : dashService.getAllEmployeesList()) {
                employeeCache.put(emp.getUserId(), emp);
            }

            // Load the month's existing records once: key = employeeId_day
            Date monthStart = Date.from(ym.atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
            Date monthEnd = Date.from(ym.plusMonths(1).atDay(1).atStartOfDay(ZoneId.systemDefault()).toInstant());
            Map<String, AttendanceMarking> existingMap = new HashMap<>();
            List<AttendanceMarking> existingList = dashService.getAttendanceBetween(monthStart, monthEnd);
            if (existingList != null) {
                Calendar cal = Calendar.getInstance();
                for (AttendanceMarking a : existingList) {
                    if (a.getEmpId() == null || a.getDate() == null) continue;
                    cal.setTime(a.getDate());
                    existingMap.put(a.getEmpId().getUserId() + "_" + cal.get(Calendar.DAY_OF_MONTH), a);
                }
            }

            int saved = 0;

            for (String paramName : req.getParameterMap().keySet()) {
                if (!paramName.startsWith("attendance_")) continue;

                // Format: attendance_{employeeId}_{day}
                String[] parts = paramName.split("_");
                if (parts.length != 3) continue;

                int employeeId = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);
                if (day < 1 || day > ym.lengthOfMonth()) continue;

                int statusId = Integer.parseInt(req.getParameter(paramName));

                String hoursStr = req.getParameter("hours_" + employeeId + "_" + day);
                double hoursWorked = 0.0;
                if (hoursStr != null && !hoursStr.isBlank()) {
                    hoursWorked = Double.parseDouble(hoursStr);
                }
                // Hours only make sense for Present (1) / Half Day (3)
                if (statusId != 1 && statusId != 3) {
                    hoursWorked = 0.0;
                }

                AttendanceMarking existing = existingMap.get(employeeId + "_" + day);

                if (statusId == 0) {
                    // "Not marked": if a record exists, reset it so it doesn't reappear as marked
                    if (existing != null && existing.getStatusId() != 0) {
                        existing.setStatusId(0);
                        existing.setHoursWorked(0.0);
                        dashService.saveAttendanceDetails(existing);
                        saved++;
                    }
                    continue;
                }

                if (existing != null) {
                    // Update only if something changed
                    double oldHours = existing.getHoursWorked() == null ? 0.0 : existing.getHoursWorked();
                    if (existing.getStatusId() != statusId || oldHours != hoursWorked) {
                        existing.setStatusId(statusId);
                        existing.setHoursWorked(hoursWorked);
                        existing.setUpdatedAt(new Date());
                        dashService.saveAttendanceDetails(existing);
                        saved++;
                    }
                } else {
                    UserDetails employee = employeeCache.get(employeeId);
                    if (employee == null) {
                        throw new IllegalArgumentException("Employee with ID " + employeeId + " not found");
                    }

                    Date attendanceDate = Date.from(ym.atDay(day).atStartOfDay(ZoneId.systemDefault()).toInstant());

                    AttendanceMarking attendance = new AttendanceMarking();
                    attendance.setEmpId(employee);
                    attendance.setDate(attendanceDate);
                    attendance.setStatusId(statusId);
                    attendance.setHoursWorked(hoursWorked);
                    attendance.setCreatedAt(new Date());
                    attendance.setUpdatedAt(new Date());

                    dashService.saveAttendanceDetails(attendance);
                    saved++;
                }
            }

            redirectAttributes.addFlashAttribute("req_status", true);
            redirectAttributes.addFlashAttribute("message", "Attendance saved successfully (" + saved + " changes)");
            return "redirect:/attendance-mark-setup?month=" + ym;

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("req_status", false);
            redirectAttributes.addFlashAttribute("message", "Error saving attendance: " + e.getMessage());
            return (monthParam == null || monthParam.isBlank())
                    ? "redirect:/attendance-mark-setup"
                    : "redirect:/attendance-mark-setup?month=" + monthParam;
        }
    }
}