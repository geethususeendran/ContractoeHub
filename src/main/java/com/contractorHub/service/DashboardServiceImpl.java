package com.contractorHub.service;

import java.io.File;
import java.text.SimpleDateFormat;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.contractorHub.dao.DashboardDao;
import com.contractorHub.pojo.AttendanceMarking;
import com.contractorHub.pojo.MasterContractor;
import com.contractorHub.pojo.MasterDepartment;
import com.contractorHub.pojo.MasterRole;
import com.contractorHub.pojo.UserDetails;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class DashboardServiceImpl implements DashboardService {
    
    @Autowired
    private DashboardDao dashDao;
    
    // Contractor Methods
    @Override
    public List<MasterContractor> getAllContractorList() {
        return dashDao.getAllContractorList();
    }
    
    // Role Methods
    @Override
    public List<MasterRole> getAllRoleList() {
        return dashDao.getAllRoleList();
    }
    
    // Employee Methods
    @Override
    public List<UserDetails> getAllEmployeesList() {
        return dashDao.getAllEmployeesList();
    }
    
    @Override
    public UserDetails getAllEmployeesListById(int userId) {
        return dashDao.getAllEmployeesListById(userId);
    }
    
    @Override
    public boolean deleteUserDtls(UserDetails dtls) {
        return dashDao.deleteUserDtls(dtls);
    }
    
    @Override
    public List<UserDetails> getEmployeesListById(int contractorId) {
        return dashDao.getEmployeesListById(contractorId);
    }
    
    // Department Methods
    @Override
    public List<MasterDepartment> getAlldepartmentList() {
        return dashDao.getAlldepartmentList();
    }
    
    // Attendance Methods
    @Override
    public List<AttendanceMarking> getAttendanceBetween(Date startDate, Date endDate) {
        return dashDao.getAttendanceBetween(startDate, endDate);
    }
    
    // Attendance Save Methods
    @Override
    @Transactional
    public String saveEmpAttendanceDtls(HttpServletRequest req, HttpSession session, Date monthStart, Date monthEnd) {
        try {
            // Fetch existing attendance records for the entire month
            Map<Integer, Map<Integer, AttendanceMarking>> existingAttendance = new HashMap<>();
            List<AttendanceMarking> attendanceList = dashDao.getAttendanceBetween(monthStart, monthEnd);

            if (attendanceList != null) {
                for (AttendanceMarking item : attendanceList) {
                    if (item.getEmpId() != null && item.getDate() != null) {
                        int employeeId = item.getEmpId().getUserId();
                        int day = item.getDate().getDate();
                        
                        // Initialize inner map if not exists
                        if (!existingAttendance.containsKey(employeeId)) {
                            existingAttendance.put(employeeId, new HashMap<>());
                        }
                        
                        // Store the attendance record
                        existingAttendance.get(employeeId).put(day, item);
                    }
                }
            }

            // Process attendance parameters for the entire month
            int processedCount = 0;
            int skippedCount = 0;
            List<AttendanceMarking> attendanceToSave = new ArrayList<>();
            
            // First, collect all the attendance data from the form
            for (String parameter : req.getParameterMap().keySet()) {
                if (!parameter.startsWith("attendance_")) continue;
                
                try {
                    String[] parts = parameter.split("_");
                    if (parts.length != 3) continue; // Should be attendance_employeeId_day
                    
                    int employeeId = Integer.parseInt(parts[1]);
                    int day = Integer.parseInt(parts[2]);
                    int statusId = Integer.parseInt(req.getParameter(parameter));
                    
                    // Skip if status is "Not Marked" (0)
                    if (statusId == 0) continue;
                    
                    // Create date for this day
                    Calendar dayCal = Calendar.getInstance();
                    dayCal.setTime(monthStart);
                    dayCal.set(Calendar.DAY_OF_MONTH, day);
                    Date attendanceDate = dayCal.getTime();
                    
                    // Get or create attendance record
                    AttendanceMarking attendance;
                    String key = employeeId + "_" + day;
                    
                    if (existingAttendance.containsKey(employeeId) && 
                        existingAttendance.get(employeeId).containsKey(day)) {
                        attendance = existingAttendance.get(employeeId).get(day);
                        // Update existing record
                        attendance.setStatusId(statusId);
                        attendance.setUpdatedAt(new Date());
                        
                        // Update hours if provided
                        String hoursParam = "hours_" + employeeId + "_" + day;
                        String hoursStr = req.getParameter(hoursParam);
                        if (hoursStr != null && !hoursStr.isEmpty()) {
                            try {
                                double hours = Double.parseDouble(hoursStr);
                                attendance.setHoursWorked(hours);
                            } catch (NumberFormatException e) {
                                // Keep existing hours
                            }
                        }
                    } else {
                        // Create new record
                        UserDetails employee = dashDao.getAllEmployeesListById(employeeId);
                        if (employee == null) {
                            skippedCount++;
                            continue; // Skip if employee not found
                        }
                        
                        attendance = new AttendanceMarking();
                        attendance.setEmpId(employee);
                        attendance.setDate(attendanceDate);
                        attendance.setStatusId(statusId);
                        attendance.setCreatedAt(new Date());
                        attendance.setUpdatedAt(new Date());
                        
                        // Set initial hours
                        String hoursParam = "hours_" + employeeId + "_" + day;
                        String hoursStr = req.getParameter(hoursParam);
                        if (hoursStr != null && !hoursStr.isEmpty()) {
                            try {
                                double hours = Double.parseDouble(hoursStr);
                                attendance.setHoursWorked(hours);
                            } catch (NumberFormatException e) {
                                attendance.setHoursWorked(0.0);
                            }
                        } else {
                            attendance.setHoursWorked(0.0);
                        }
                    }
                    
                    attendanceToSave.add(attendance);
                    processedCount++;
                    
                } catch (NumberFormatException e) {
                    System.err.println("Invalid parameter format: " + parameter);
                    skippedCount++;
                    continue; // Skip invalid entries
                }
            }
            
            if (processedCount == 0) {
                throw new IllegalArgumentException("No valid attendance data found to save. Skipped " + skippedCount + " invalid entries.");
            }
            
            // Save all attendance records
            boolean saveSuccess = dashDao.saveAllAttendance(attendanceToSave);
            
            if (!saveSuccess) {
                throw new RuntimeException("Failed to save attendance records");
            }
            
            // Set success message with details
            String message = "Attendance for " + processedCount + " records saved successfully";
            if (skippedCount > 0) {
                message += ". Skipped " + skippedCount + " invalid entries.";
            }
            session.setAttribute("req_status", true);
            session.setAttribute("message", message);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("req_status", false);
            session.setAttribute("message", "Attendance save failed due to error: " + e.getMessage());
        }

        // Redirect back to the setup page
        SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy-MM");
        String monthParam = monthFormat.format(monthStart);
        return "redirect:attendance-mark-setup?month=" + monthParam;
    }
    
    // File Upload Methods
    @Override
    public String saveEmpdetails(HttpServletRequest req, HttpSession session, MultipartFile file, 
                              String applicationPath, String uploadFilePath) {
        try {
            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Get file details
            String originalFilename = file.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = System.currentTimeMillis() + fileExtension;
            
            // Save file
            File destFile = new File(uploadFilePath + File.separator + newFilename);
            file.transferTo(destFile);
            
            // Get form parameters
            String empName = req.getParameter("emp_name");
            String empEmail = req.getParameter("emp_email");
            String empPhone = req.getParameter("emp_phone");
            String empAddress = req.getParameter("emp_address");
            int contractorId = Integer.parseInt(req.getParameter("contractor_id"));
            int roleId = Integer.parseInt(req.getParameter("role_id"));
            int deptId = Integer.parseInt(req.getParameter("dept_id"));
            
            // Create employee object
            UserDetails employee = new UserDetails();
            employee.setUserName(empName);
            employee.setEmailId(empEmail);
            employee.setPhone(empPhone);
            employee.setAddress(empAddress);
            employee.setContractorId(dashDao.getAllContractorListById(contractorId));
            employee.setRoleId(dashDao.getAllRoleListById(roleId));
            employee.setDeptId(dashDao.getAlldepartmentListById(deptId));
            employee.setProfilePic(newFilename);
            employee.setCreatedAt(new Date());
            
            // Save employee
            boolean saved = dashDao.saveEmployeeDetails(employee);
            
            if (saved) {
                session.setAttribute("req_status", true);
                session.setAttribute("message", "Employee registered successfully");
                return "redirect:/employee-list";
            } else {
                session.setAttribute("req_status", false);
                session.setAttribute("message", "Failed to register employee");
                return "redirect:/employee-registration";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("req_status", false);
            session.setAttribute("message", "Error: " + e.getMessage());
            return "redirect:/employee-registration";
        }
    }

    // IMPLEMENTED MISSING METHODS - MAINTAINING ORDER
    @Override
    public List<AttendanceMarking> getAttendanceByEmployeeAndDate(int employeeId, Date date) {
        return dashDao.getAttendanceByEmployeeAndDate(employeeId, date);
    }

    @Override
    public AttendanceMarking saveAttendanceDetails(AttendanceMarking attendance) {
        return dashDao.saveAttendanceDetails(attendance);
    }
}