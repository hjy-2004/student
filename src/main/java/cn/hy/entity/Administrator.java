package cn.hy.entity;

import cn.hy.controller.Base64ToByteArrayConverter;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import javax.persistence.*;
import java.util.Arrays;

@Entity
@Table(name = "administrator")
public class Administrator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;



    private String adminNumber;


    private String adminPassword;

    @Column(name = "adminName")
    private String adminName;

    @Column(name = "adminGender")
    private String adminGender;

    @Column(name = "adminEmail")
    private String adminEmail;

    @Column(name = "adminPhone")
    private String adminPhone;

    @Lob
    @Column(name = "admin_avatar")
    @JsonDeserialize(using = Base64ToByteArrayConverter.class)
    private byte[] adminAvatar;

    // Constructors, getters, and setters
    public Administrator() {
    }

    public Administrator(int id, String adminNumber, String adminPassword, String adminName, String adminGender, String adminEmail, String adminPhone, byte[] adminAvatar) {
        this.id = id;
        this.adminNumber = adminNumber;
        this.adminPassword = adminPassword;
        this.adminName = adminName;
        this.adminGender = adminGender;
        this.adminEmail = adminEmail;
        this.adminPhone = adminPhone;
        this.adminAvatar = adminAvatar;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAdminNumber() {
        return adminNumber;
    }

    public void setAdminNumber(String adminNumber) {
        this.adminNumber = adminNumber;
    }

    public String getAdminPassword() {
        return adminPassword;
    }

    public void setAdminPassword(String adminPassword) {
        this.adminPassword = adminPassword;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getAdminGender() {
        return adminGender;
    }

    public void setAdminGender(String adminGender) {
        this.adminGender = adminGender;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public String getAdminPhone() {
        return adminPhone;
    }

    public void setAdminPhone(String adminPhone) {
        this.adminPhone = adminPhone;
    }

    public byte[] getAdminAvatar() {
        return adminAvatar;
    }

    public void setAdminAvatar(byte[] adminAvatar) {
        this.adminAvatar = adminAvatar;
    }

    @Override
    public String toString() {
        return "Administrator{" +
                "id=" + id +
                ", adminNumber='" + adminNumber + '\'' +
                ", adminPassword='" + adminPassword + '\'' +
                ", adminName='" + adminName + '\'' +
                ", adminGender='" + adminGender + '\'' +
                ", adminEmail='" + adminEmail + '\'' +
                ", adminPhone='" + adminPhone + '\'' +
                ", adminAvatar=" + Arrays.toString(adminAvatar) +
                '}';
    }
}

