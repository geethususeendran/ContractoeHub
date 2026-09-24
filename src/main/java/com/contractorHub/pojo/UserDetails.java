package com.contractorHub.pojo;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "user_details")
public class UserDetails {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private int userId;

    @Column(name = "user_name")
    private String userName;
    
    @Column(name = "date_of_birth")
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;
    
    @Column(name = "mobile_no")
    private String mobileNo;

    @Column(name = "email_id")
    private String emailId;

    @Column(name = "adhaar_no")
    private String adhaarNo;

    @ManyToOne
    @JoinColumn(name = "contractor_id")
    private MasterContractor contractorId;
    
    @ManyToOne
    @JoinColumn(name = "role_id")
    private MasterRole roleId;

    @ManyToOne
    @JoinColumn(name = "dept_id")
    private MasterDepartment deptId;

    @Column(name = "code_no")
    private String codeNo;

    @Column(name = "esi_no")
    private String esiNo;

    @Column(name = "uan_no")
    private String uanNo;
    
    @Column(name = "pf_no")
    private String pfNo;
    
    @Column(name = "pcc_no")
    private String pccNo;

    @Column(name = "prof_img")
    private String profImg;
    
    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "profile_pic")
    private String profilePic;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    // Constructors
    public UserDetails() {
    }

    public UserDetails(String userName, String emailId, String mobileNo, String address) {
        this.userName = userName;
        this.emailId = emailId;
        this.mobileNo = mobileNo;
        this.address = address;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
        this.updatedAt = new Date();
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
        this.updatedAt = new Date();
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
        this.updatedAt = new Date();
    }

    public String getEmailId() {
        return emailId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
        this.updatedAt = new Date();
    }

    public String getAdhaarNo() {
        return adhaarNo;
    }

    public void setAdhaarNo(String adhaarNo) {
        this.adhaarNo = adhaarNo;
        this.updatedAt = new Date();
    }

    public MasterContractor getContractorId() {
        return contractorId;
    }

    public void setContractorId(MasterContractor contractorId) {
        this.contractorId = contractorId;
        this.updatedAt = new Date();
    }

    public MasterRole getRoleId() {
        return roleId;
    }

    public void setRoleId(MasterRole roleId) {
        this.roleId = roleId;
        this.updatedAt = new Date();
    }

    public MasterDepartment getDeptId() {
        return deptId;
    }

    public void setDeptId(MasterDepartment deptId) {
        this.deptId = deptId;
        this.updatedAt = new Date();
    }

    public String getCodeNo() {
        return codeNo;
    }

    public void setCodeNo(String codeNo) {
        this.codeNo = codeNo;
        this.updatedAt = new Date();
    }

    public String getEsiNo() {
        return esiNo;
    }

    public void setEsiNo(String esiNo) {
        this.esiNo = esiNo;
        this.updatedAt = new Date();
    }

    public String getUanNo() {
        return uanNo;
    }

    public void setUanNo(String uanNo) {
        this.uanNo = uanNo;
        this.updatedAt = new Date();
    }

    public String getPfNo() {
        return pfNo;
    }

    public void setPfNo(String pfNo) {
        this.pfNo = pfNo;
        this.updatedAt = new Date();
    }

    public String getPccNo() {
        return pccNo;
    }

    public void setPccNo(String pccNo) {
        this.pccNo = pccNo;
        this.updatedAt = new Date();
    }

    public String getProfImg() {
        return profImg;
    }

    public void setProfImg(String profImg) {
        this.profImg = profImg;
        this.updatedAt = new Date();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
        this.updatedAt = new Date();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
        this.updatedAt = new Date();
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
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

    @Override
    public String toString() {
        return "UserDetails{" +
                "userId=" + userId +
                ", userName='" + userName + '\'' +
                ", emailId='" + emailId + '\'' +
                ", address='" + address + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}