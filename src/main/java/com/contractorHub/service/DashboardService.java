package com.contractorHub.service;

import java.util.List;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.contractorHub.pojo.AttendanceMarking;
import com.contractorHub.pojo.MasterContractor;
import com.contractorHub.pojo.MasterDepartment;
import com.contractorHub.pojo.MasterRole;
import com.contractorHub.pojo.UserDetails;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public interface DashboardService {
    
    // Contractor Methods
    List<MasterContractor> getAllContractorList();
    
    // Role Methods
    List<MasterRole> getAllRoleList();
    
    // Employee Methods
    List<UserDetails> getAllEmployeesList();
    UserDetails getAllEmployeesListById(int userId);
    boolean deleteUserDtls(UserDetails dtls);
    List<UserDetails> getEmployeesListById(int contractorId);
    
    // Department Methods
    List<MasterDepartment> getAlldepartmentList();
    
    // Attendance Methods
    List<AttendanceMarking> getAttendanceBetween(Date startDate, Date endDate);
    List<AttendanceMarking> getAttendanceByEmployeeAndDate(int employeeId, Date date);
    AttendanceMarking saveAttendanceDetails(AttendanceMarking attendance);
    
    // File Upload Methods
    String saveEmpdetails(HttpServletRequest req, HttpSession session, MultipartFile file, 
                         String applicationPath, String uploadFilePath);
    
    // Attendance Save Methods
    String saveEmpAttendanceDtls(HttpServletRequest req, HttpSession session, Date monthStart, Date monthEnd);
}