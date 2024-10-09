package cn.hy.entity;

import javax.persistence.*;

@Entity
@Table(name = "user")
public class User {
    @Id
    private String username; // 学号

    private String password; // 密码

    private String newPassword; // 新密码

    public User() {}

    public User(String username, String password, String newPassword) {
        this.username = username;
        this.password = password;
        this.newPassword = newPassword;
    }

    // Getters and Setters

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
