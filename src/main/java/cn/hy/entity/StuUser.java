package cn.hy.entity;

import javax.persistence.*;

@Entity
@Table(name = "stu_user")
public class StuUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int uid; // 编号

    @Column(name = "stu_class")
    private String stuClass; // 学生所属班级

    @Column(name = "stu_name")
    private String stuName; // 学生姓名

    @Column(name = "total_credits")
    private String totalCredits; // 学生当前总学分


    private String username;//学生学号

    private String email;//学生邮箱

    private String password;
    @ManyToOne
    @JoinColumn(name = "teacher_id")
    private Teacher teacher;

    public StuUser() {}

    public StuUser(int uid, String stuClass, String stuName, String totalCredits, String username, String email, String password, Teacher teacher) {
        this.uid = uid;
        this.stuClass = stuClass;
        this.stuName = stuName;
        this.totalCredits = totalCredits;
        this.username = username;
        this.email = email;
        this.password = password;
        this.teacher = teacher;
    }

    // Getters and Setters

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getStuClass() {
        return stuClass;
    }

    public void setStuClass(String stuClass) {
        this.stuClass = stuClass;
    }

    public String getStuName() {
        return stuName;
    }

    public void setStuName(String stuName) {
        this.stuName = stuName;
    }

    public String getTotalCredits() {
        return totalCredits;
    }

    public void setTotalCredits(String totalCredits) {
        this.totalCredits = totalCredits;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "StuUser{" +
                "uid=" + uid +
                ", stuClass='" + stuClass + '\'' +
                ", stuName='" + stuName + '\'' +
                ", totalCredits='" + totalCredits + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", password='" + password + '\'' +
                ", teacher=" + teacher +
                '}';
    }
}
