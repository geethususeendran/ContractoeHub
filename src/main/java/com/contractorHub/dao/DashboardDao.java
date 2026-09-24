package com.contractorHub.dao;

import java.util.List;
import java.util.Date;
import java.util.Map;

import com.contractorHub.pojo.AttendanceMarking;
import com.contractorHub.pojo.MasterContractor;
import com.contractorHub.pojo.MasterDepartment;
import com.contractorHub.pojo.MasterRole;
import com.contractorHub.pojo.UserDetails;

public interface DashboardDao {

    // Contractor Methods
    List<MasterContractor> getAllContractorList();
    MasterContractor getAllContractorListById(int contractorId);

    // Role Methods
    List<MasterRole> getAllRoleList();
    MasterRole getAllRoleListById(int roleId);

    // Employee Methods
    List<UserDetails> getAllEmployeesList();
    UserDetails getAllEmployeesListById(int userId);
    boolean saveEmployeeDetails(UserDetails user);
    boolean deleteUserDtls(UserDetails dtls);
    List<UserDetails> getEmployeesListById(int contractorId);

    // Department Methods
    List<MasterDepartment> getAlldepartmentList();
    MasterDepartment getAlldepartmentListById(int deptId);

    // Attendance Methods
    List<AttendanceMarking> getAttendanceBetween(Date startDate, Date endDate);
    boolean saveAttendance(AttendanceMarking attendance);
    void updateAttendance(AttendanceMarking attendance);
    boolean saveAllAttendance(List<AttendanceMarking> attendanceList);
    
    // Helper Methods
    Map<Integer, UserDetails> getAllEmployeesMap();
	List<AttendanceMarking> getAttendanceByEmployeeAndDate(int employeeId, Date date);
	AttendanceMarking saveAttendanceDetails(AttendanceMarking attendance);
}