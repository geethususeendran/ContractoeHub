package com.contractorHub.dao;

import java.util.List;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.contractorHub.pojo.AttendanceMarking;
import com.contractorHub.pojo.MasterContractor;
import com.contractorHub.pojo.MasterDepartment;
import com.contractorHub.pojo.MasterRole;
import com.contractorHub.pojo.UserDetails;

@Repository
public class DashboardDaoImpl implements DashboardDao {
    
    @Autowired 
    private SessionFactory sessionFactory; 

    // Contractor Methods
    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<MasterContractor> getAllContractorList() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from MasterContractor").list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @Override
    public MasterContractor getAllContractorListById(int contractorId) {
        Session session = sessionFactory.openSession();
        try {
            return (MasterContractor) session.createQuery("from MasterContractor where contractorId = :contractorId")
                    .setParameter("contractorId", contractorId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    // Role Methods
    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<MasterRole> getAllRoleList() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from MasterRole").list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @Override
    public MasterRole getAllRoleListById(int roleId) {
        Session session = sessionFactory.openSession();
        try {
            return (MasterRole) session.createQuery("from MasterRole where roleId = :roleId")
                    .setParameter("roleId", roleId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    // Employee Methods
    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<UserDetails> getAllEmployeesList() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from UserDetails").list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("deprecation")
    @Override
    public UserDetails getAllEmployeesListById(int userId) {
        Session session = sessionFactory.openSession();
        try {
            return (UserDetails) session.createQuery("from UserDetails where userId = :userId")
                    .setParameter("userId", userId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @SuppressWarnings("deprecation")
    @Override
    public boolean saveEmployeeDetails(UserDetails user) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            session.saveOrUpdate(user);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @SuppressWarnings("deprecation")
    @Override
    public boolean deleteUserDtls(UserDetails dtls) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            session.createNativeQuery("delete from user_details ud WHERE ud.user_id = :userId")
                    .setParameter("userId", dtls.getUserId())
                    .executeUpdate();
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<UserDetails> getEmployeesListById(int contractorId) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from UserDetails where contractorId.contractorId = :contractorId")
                    .setParameter("contractorId", contractorId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    // Department Methods
    @Override
    public List<MasterDepartment> getAlldepartmentList() {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from MasterDepartment", MasterDepartment.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    @Override
    public MasterDepartment getAlldepartmentListById(int deptId) {
        Session session = sessionFactory.openSession();
        try {
            return (MasterDepartment) session.createQuery("from MasterDepartment where deptId = :deptId")
                    .setParameter("deptId", deptId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    // Attendance Methods
    @Override
    public boolean saveAttendance(AttendanceMarking attendance) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            session.saveOrUpdate(attendance);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    public void updateAttendance(AttendanceMarking attendance) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            session.update(attendance);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<AttendanceMarking> getAttendanceBetween(Date startDate, Date endDate) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from AttendanceMarking where date >= :startDate and date <= :endDate")
                    .setParameter("startDate", startDate)
                    .setParameter("endDate", endDate)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    // IMPLEMENTED MISSING METHODS - MAINTAINING ORDER
    /**
     * Get attendance records for a specific employee on a specific date
     * @param employeeId The ID of the employee
     * @param date The date to check attendance for
     * @return List of attendance records (typically 0 or 1 record)
     */
    @SuppressWarnings({ "deprecation", "unchecked" })
    @Override
    public List<AttendanceMarking> getAttendanceByEmployeeAndDate(int employeeId, Date date) {
        Session session = sessionFactory.openSession();
        try {
            return session.createQuery("from AttendanceMarking where empId.userId = :employeeId and date = :date")
                    .setParameter("employeeId", employeeId)
                    .setParameter("date", date)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    /**
     * Save a single attendance record
     * @param attendance The attendance record to save
     * @return The saved attendance record with generated ID
     */
    @SuppressWarnings("deprecation")
    @Override
    public AttendanceMarking saveAttendanceDetails(AttendanceMarking attendance) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            
            // Validate attendance object
            if (attendance == null) {
                throw new IllegalArgumentException("Attendance object cannot be null");
            }
            
            if (attendance.getEmpId() == null) {
                throw new IllegalArgumentException("Employee ID cannot be null");
            }
            
            if (attendance.getDate() == null) {
                throw new IllegalArgumentException("Date cannot be null");
            }
            
            // Save the attendance record
            session.saveOrUpdate(attendance);
            transaction.commit();
            
            return attendance;
            
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    public boolean saveAllAttendance(List<AttendanceMarking> attendanceList) {
        Session session = null;
        Transaction transaction = null;
        try {
            if (attendanceList == null || attendanceList.isEmpty()) {
                throw new IllegalArgumentException("Attendance list cannot be null or empty");
            }
            
            session = sessionFactory.openSession();
            transaction = session.beginTransaction();
            
            int batchSize = 50; // Adjust batch size as needed
            int i = 0;
            
            for (AttendanceMarking attendance : attendanceList) {
                // Validate each attendance object
                if (attendance == null || attendance.getEmpId() == null || attendance.getDate() == null) {
                    throw new IllegalArgumentException("Invalid attendance object at index " + i);
                }
                
                session.saveOrUpdate(attendance);
                
                // Batch processing
                if (i % batchSize == 0) {
                    session.flush();
                    session.clear();
                }
                
                i++;
            }
            
            session.flush();
            transaction.commit();
            
            return true;
            
        } catch (Exception e) {
            if (transaction != null) {
                try {
                    transaction.rollback();
                } catch (Exception rollbackEx) {
                    System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
                }
            }
            
            System.err.println("Error saving attendance batch: " + e.getMessage());
            e.printStackTrace();
            return false;
            
        } finally {
            if (session != null) {
                try {
                    session.close();
                } catch (Exception closeEx) {
                    System.err.println("Error closing session: " + closeEx.getMessage());
                }
            }
        }
    }

    // Helper Methods
    @Override
    public Map<Integer, UserDetails> getAllEmployeesMap() {
        Session session = sessionFactory.openSession();
        try {
            List<UserDetails> employees = session.createQuery("from UserDetails", UserDetails.class).list();
            Map<Integer, UserDetails> employeeMap = new HashMap<>();
            for (UserDetails employee : employees) {
                employeeMap.put(employee.getUserId(), employee);
            }
            return employeeMap;
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        } finally {
            session.close();
        }
    }
}