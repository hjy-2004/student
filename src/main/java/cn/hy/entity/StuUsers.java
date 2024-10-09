package cn.hy.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import javax.persistence.*;

@Entity
@Table(name = "stu_user")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "uid")
public class StuUsers {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int uid;

    private String stu_class;
    private String stu_name;
    private String total_credits;
    private String username;

    @ManyToOne
    @JoinColumn(name = "teacher_id")
    private Teachers teachers;

    public StuUsers() {}

    public StuUsers(int uid, String stu_class, String stu_name, String total_credits, String username, Teachers teachers) {
        this.uid = uid;
        this.stu_class = stu_class;
        this.stu_name = stu_name;
        this.total_credits = total_credits;
        this.username = username;
        this.teachers = teachers;
    }

    // Getters and Setters

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getStu_class() {
        return stu_class;
    }

    public void setStu_class(String stu_class) {
        this.stu_class = stu_class;
    }

    public String getStu_name() {
        return stu_name;
    }

    public void setStu_name(String stu_name) {
        this.stu_name = stu_name;
    }

    public String getTotal_credits() {
        return total_credits;
    }

    public void setTotal_credits(String total_credits) {
        this.total_credits = total_credits;
    }

    public Teachers getTeachers() {
        return teachers;
    }

    public void setTeachers(Teachers teachers) {
        this.teachers = teachers;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String toString() {
        return "StuUsers{" +
                "uid=" + uid +
                ", stu_class='" + stu_class + '\'' +
                ", stu_name='" + stu_name + '\'' +
                ", total_credits='" + total_credits + '\'' +
                ", username='" + username + '\'' +
                ", teachers=" + teachers +
                '}';
    }
}