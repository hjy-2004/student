package cn.hy.service;

import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import cn.hy.entity.UserEmail;
import cn.hy.repository.UserEmailRepository;
import cn.hy.repository.UserRepository;
import cn.hy.verification.VerificationCodeStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class UserEmailService {

    @Autowired
    private UserEmailRepository userEmailRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender mailSender;

    private final Random random = new Random();

    // 记录每个邮箱最新的验证码和发送时间
    private final ConcurrentHashMap<String, VerificationInfo> verificationInfoMap = new ConcurrentHashMap<>();

    /**
     * 发送账号注册验证码
     * @param email 用户邮箱
     */
    public void sendRegistrationVerificationCode(String email) {
        // 检查是否已经发送过验证码
        if (verificationInfoMap.containsKey(email)) {
            VerificationInfo info = verificationInfoMap.get(email);
            // 判断时间间隔
            if (info != null && LocalDateTime.now().isBefore(info.getExpirationTime())) {
                // 提示用户稍后再试或直接返回
                System.out.println("请勿频繁发送验证码，请稍后再试。");
                return;
            }
        }

        String code = generateVerificationCode();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("3484077367@qq.com");
        message.setTo(email);
        message.setSubject("账号注册验证码");
        message.setText("【航院学生成绩管理系统】提醒您：您正在注册账号，请确认是否是本人操作，如果不是请忽略此信息，您的验证码为： " + code);

        mailSender.send(message);

        // 更新验证码和发送时间
        verificationInfoMap.put(email, new VerificationInfo(code));

        // 将验证码存储在数据库或缓存中
        VerificationCodeStore.storeCode(email, code);
    }

    /**
     * 发送重置密码验证码
     * @param email 用户邮箱
     */
    public void sendVerificationCode(String email) {
        // 检查是否已经发送过验证码
        if (verificationInfoMap.containsKey(email)) {
            VerificationInfo info = verificationInfoMap.get(email);
            // 判断时间间隔
            if (info != null && LocalDateTime.now().isBefore(info.getExpirationTime())) {
                // 提示用户稍后再试或直接返回
                System.out.println("请勿频繁发送验证码，请稍后再试。");
                return;
            }
        }

        String code = generateVerificationCode();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("3484077367@qq.com");
        message.setTo(email);
        message.setSubject("密码重置验证码");
        message.setText("【航院学生成绩管理系统】提醒您：您正在重置密码，请确认是否是本人操作，如果不是请忽略此信息，您的验证码为： " + code);

        mailSender.send(message);

        // 更新验证码和发送时间
        verificationInfoMap.put(email, new VerificationInfo(code));

        // 将验证码存储在数据库或缓存中
        VerificationCodeStore.storeCode(email, code);
    }

    /**
     * 重置用户密码
     * @param email 用户邮箱
     * @param code 验证码
     * @param newPassword 新密码
     * @return 是否成功重置密码
     */
    @Transactional // 事务管理，保证操作的原子性
    public boolean resetPassword(String email, String code, String newPassword) {
        if (!VerificationCodeStore.verifyCode(email, code)) {
            return false;
        }

        Optional<UserEmail> userEmailOptional = userEmailRepository.findByEmail(email);
        if (userEmailOptional.isPresent()) {
            UserEmail userEmail = userEmailOptional.get();
            userEmail.setPassword(newPassword);
            userEmailRepository.save(userEmail); // 更新 UserEmail 表中的密码

            Optional<User> userOptional = userRepository.findById(userEmail.getUsername());
            userOptional.ifPresent(user -> {
                user.setPassword(newPassword);
                userRepository.save(user); // 更新 User 表中的密码
            });

            // 重置成功后移除验证码信息
            verificationInfoMap.remove(email);

            return true;
        }

        return false;
    }

    /**
     * 验证注册验证码是否正确
     * @param email 用户邮箱
     * @param code 验证码
     * @return 验证是否通过
     */
    public boolean verifyRegistrationCode(String email, String code) {
        VerificationInfo verificationInfo = verificationInfoMap.get(email);
        if (verificationInfo == null) {
            return false; // 没有发送过验证码
        }

        if (LocalDateTime.now().isAfter(verificationInfo.getExpirationTime())) {
            return false; // 验证码已过期
        }

        return verificationInfo.getCode().equals(code); // 返回验证码是否匹配
    }

    /**
     * 生成六位随机数字验证码
     * @return 验证码
     */
    private String generateVerificationCode() {
        return String.valueOf(100000 + random.nextInt(900000));
    }

    /**
     * 验证信息类，用于存储验证码和过期时间
     */
    private static class VerificationInfo {
        private final String code;
        private final LocalDateTime expirationTime;

        public VerificationInfo(String code) {
            this.code = code;
            this.expirationTime = LocalDateTime.now().plusMinutes(5); // 设置验证码有效期为5分钟
        }

        public String getCode() {
            return code;
        }

        public LocalDateTime getExpirationTime() {
            return expirationTime;
        }
    }

    public Optional<UserEmail> getUserEmailByUsername(String username) {
        return userEmailRepository.findByUsername(username);
    }

    public UserEmail saveUserEmail(UserEmail userEmail) {
        return userEmailRepository.save(userEmail);
    }
}
