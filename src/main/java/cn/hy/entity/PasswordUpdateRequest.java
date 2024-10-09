package cn.hy.entity;

public class PasswordUpdateRequest {
    private String username;
    private String password;
    private String newPassword;

    // 添加构造方法、getter和setter方法等

    public PasswordUpdateRequest() {
    }

    public PasswordUpdateRequest(String username, String password, String newPassword) {
        this.username = username;
        this.password = password;
        this.newPassword = newPassword;
    }

    // getter和setter方法
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String oldPassword) {
        this.password = oldPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
