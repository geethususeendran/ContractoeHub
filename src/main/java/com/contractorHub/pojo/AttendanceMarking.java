package com.contractorHub.pojo;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
    name = "attendance_marking",
    schema = "ams",
    uniqueConstraints = @UniqueConstraint(
        name = "uq_emp_date",
        columnNames = {"emp_id", "date"}
    )
)
public class AttendanceMarking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "attendance_id")
    private int attendanceId;

    // FIX: removed insertable=false, updatable=false so Hibernate writes emp_id.
    // If you hit LazyInitializationException in the JSP/controller, remove fetch = LAZY.
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emp_id", nullable = false)
    private UserDetails empId;

    @Column(name = "date")
    @Temporal(TemporalType.DATE)
    private Date date;

    @Column(name = "status_id")
    private int statusId;

    @Column(name = "hours_worked")
    private Double hoursWorked;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    public AttendanceMarking() {
    }

    public AttendanceMarking(UserDetails empId, Date date, int statusId) {
        this.empId = empId;
        this.date = date;
        this.statusId = statusId;
        this.hoursWorked = 0.0;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    public int getAttendanceId() {
        return attendanceId;
    }

    public void setAttendanceId(int attendanceId) {
        this.attendanceId = attendanceId;
    }

    public UserDetails getEmpId() {
        return empId;
    }

    public void setEmpId(UserDetails empId) {
        this.empId = empId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
        this.updatedAt = new Date();
    }

    public Double getHoursWorked() {
        return hoursWorked;
    }

    public void setHoursWorked(Double hoursWorked) {
        this.hoursWorked = hoursWorked;
        this.updatedAt = new Date();
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // FIX: don't print the whole empId (avoids lazy-load / recursion problems)
    @Override
    public String toString() {
        return "AttendanceMarking{" +
                "attendanceId=" + attendanceId +
                ", date=" + date +
                ", statusId=" + statusId +
                ", hoursWorked=" + hoursWorked +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}