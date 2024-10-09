package cn.hy.entity;

public class ResetPasswordRequest {

    private String account;
    private String qqEmail;
    private String code;

    private String verificationCode;
    private String newPassword;

    // Constructors
    public ResetPasswordRequest() {}

    public ResetPasswordRequest(String account, String qqEmail, String code, String verificationCode, String newPassword) {
        this.account = account;
        this.qqEmail = qqEmail;
        this.code = code;
        this.verificationCode = verificationCode;
        this.newPassword = newPassword;
    }

    // Getters and Setters
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getQqEmail() {
        return qqEmail;
    }

    public void setQqEmail(String qqEmail) {
        this.qqEmail = qqEmail;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    @Override
    public String toString() {
        return "ResetPasswordRequest{" +
                "account='" + account + '\'' +
                ", qqEmail='" + qqEmail + '\'' +
                ", code='" + code + '\'' +
                ", verificationCode='" + verificationCode + '\'' +
                ", newPassword='" + newPassword + '\'' +
                '}';
    }
}
