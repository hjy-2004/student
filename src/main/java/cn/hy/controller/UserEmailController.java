package cn.hy.controller;

import cn.hy.entity.ApiResponse;
import cn.hy.entity.ResetPasswordRequest;
import cn.hy.entity.StuUser;
import cn.hy.entity.UserEmail;
import cn.hy.repository.StuUserOptionalRepository;
import cn.hy.repository.StuUserRepository;
import cn.hy.repository.UserEmailRepository;
import cn.hy.service.UserEmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin("*")
public class UserEmailController {

    @Autowired
    private UserEmailService userEmailService;

    @Autowired
    private UserEmailRepository userEmailRepository;


    @Autowired
    private StuUserOptionalRepository stuUserOptionalRepository; // 注入新的仓库

    @PostMapping("/send-verification-code")
    public void sendVerificationCode(@RequestBody Map<String, String> request) {
        String email = request.get("qqEmail");
        userEmailService.sendVerificationCode(email);
    }

    // 新增发送账号注册验证码的方法
    @PostMapping("/send-registration-verification-code")
    public ResponseEntity<ApiResponse> sendRegistrationVerificationCode(@RequestBody Map<String, String> request) {
        String email = request.get("qqEmail");
        userEmailService.sendRegistrationVerificationCode(email);
        return ResponseEntity.ok(new ApiResponse(true, "注册验证码已发送"));
    }

    @PostMapping("/verify-registration-code")
    public ResponseEntity<ApiResponse> verifyRegistrationCode(@RequestBody Map<String, String> request) {
        String email = request.get("qqEmail");
        String code = request.get("verificationCode");

        boolean isValid = userEmailService.verifyRegistrationCode(email, code);
        if (isValid) {
            return ResponseEntity.ok(new ApiResponse(true, "验证码验证成功"));
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ApiResponse(false, "验证码错误或已过期"));
        }

    }


    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ResetPasswordRequest request) {
        boolean isSuccess = userEmailService.resetPassword(request.getQqEmail(), request.getVerificationCode(), request.getNewPassword());
        if (isSuccess) {
            return ResponseEntity.ok(new ApiResponse(true, "密码重置成功"));
        } else {
            return ResponseEntity.badRequest().body(new ApiResponse(false, "密码重置失败"));
        }
    }

    @PostMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String, String> request) {
        String account = request.get("account");
        String qqEmail = request.get("qqEmail");

        Optional<UserEmail> userEmailOpt = userEmailRepository.findByUsername(account);
        if (userEmailOpt.isPresent()) {
            UserEmail userEmail = userEmailOpt.get();
            if (userEmail.getEmail().equals(qqEmail)) {
                return ResponseEntity.ok(Collections.singletonMap("success", true));
            }
        }
        return ResponseEntity.ok(Collections.singletonMap("success", false));
    }

    @GetMapping("/userEmail")
    public ResponseEntity<UserEmail> getUserEmail(@RequestParam String username) {
        Optional<UserEmail> userEmail = userEmailRepository.findByUsername(username);
        if (userEmail.isPresent()) {
            return ResponseEntity.ok(userEmail.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @PostMapping("/userEmail")
    public ResponseEntity<UserEmail> saveUserEmail(@RequestBody UserEmail userEmail) {
        UserEmail savedUserEmail = userEmailService.saveUserEmail(userEmail);
        return ResponseEntity.ok(savedUserEmail);
    }

    @GetMapping("/check-user")
    public ResponseEntity<Map<String, Boolean>> checkUser(@RequestParam String username, @RequestParam String qqEmail) {
        Optional<UserEmail> userEmailOpt = userEmailRepository.findByUsername(username);
        boolean exists = userEmailOpt.isPresent() && userEmailOpt.get().getEmail().equals(qqEmail);
        return ResponseEntity.ok(Collections.singletonMap("exists", exists));
    }

    @PostMapping("/check-user-email")
    public ResponseEntity<Map<String, Object>> checkUserEmail(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        Optional<UserEmail> userEmailOptional = userEmailRepository.findByUsername(username);

        Map<String, Object> response = new HashMap<>();

        if (userEmailOptional.isPresent()) {
            UserEmail userEmail = userEmailOptional.get();
            boolean hasEmail = userEmail.getEmail() != null && !userEmail.getEmail().isEmpty();

            response.put("hasEmail", hasEmail);
            response.put("email", hasEmail ? userEmail.getEmail() : null);

            return ResponseEntity.ok(response);
        } else {
            response.put("hasEmail", false);
            return ResponseEntity.ok(response);
        }
    }




    @PostMapping("/bind-email")
    public ResponseEntity<String> bindEmail(@RequestBody UserEmail userEmail) {
        if (userEmail == null || userEmail.getUsername() == null || userEmail.getEmail() == null) {
            return new ResponseEntity<>("绑定邮箱失败，缺少必要信息", HttpStatus.BAD_REQUEST);
        }

        System.out.println("Received data: " + userEmail);

        // 1. 先在UserEmail表中查找该用户
        Optional<UserEmail> userOptional = userEmailRepository.findByUsername(userEmail.getUsername());
        if (userOptional.isPresent()) {
            UserEmail existingUser = userOptional.get();
            // 检查用户是否已经绑定了邮箱
            if (existingUser.getEmail() != null && !existingUser.getEmail().isEmpty()) {
                return new ResponseEntity<>("该用户已绑定邮箱", HttpStatus.CONFLICT);
            }

            // 更新已有的UserEmail记录，绑定新的邮箱
            existingUser.setEmail(userEmail.getEmail());
            userEmailRepository.save(existingUser);
            return new ResponseEntity<>("邮箱绑定成功", HttpStatus.OK);
        }

        // 2. 如果UserEmail表中没有找到，则在StuUser表中查找该学号
        Optional<StuUser> stuUserOptional = stuUserOptionalRepository.findByUsername(userEmail.getUsername());
        if (stuUserOptional.isPresent()) {
            // 如果StuUser中存在该学号，则在UserEmail表中创建新记录并绑定邮箱
            UserEmail newUserEmail = new UserEmail();
            newUserEmail.setUsername(userEmail.getUsername());
            newUserEmail.setEmail(userEmail.getEmail());
            userEmailRepository.save(newUserEmail);
            return new ResponseEntity<>("邮箱绑定成功", HttpStatus.OK);
        }

        // 3. 如果StuUser中也没有找到，则返回用户不存在
        return new ResponseEntity<>("用户不存在，请先去注册账号", HttpStatus.NOT_FOUND);
    }



    @PostMapping("/forgot-password")
    public ResponseEntity<String> forgotPassword(@RequestBody UserEmail userEmail) {
        if (userEmail == null || userEmail.getUsername() == null) {
            return ResponseEntity.badRequest().body("请输入学号");
        }

        // Step 1: Check if the username exists in StuUser table
        Optional<StuUser> stuUserOptional = stuUserOptionalRepository.findByUsername(userEmail.getUsername());
        if (!stuUserOptional.isPresent()) {
            return ResponseEntity.badRequest().body("学号不存在，请先注册");
        }

        // Step 2: Check if the username exists in UserEmail table
        Optional<UserEmail> userEmailOptional = userEmailRepository.findByUsername(userEmail.getUsername());
        if (userEmailOptional.isPresent()) {
            return ResponseEntity.ok("该用户已绑定邮箱，请继续重置密码操作");
        } else {
            // Insert a new record into UserEmail and bind the email
            StuUser stuUser = stuUserOptional.get();
            UserEmail newUserEmail = new UserEmail();
            newUserEmail.setUsername(stuUser.getUsername());
            newUserEmail.setEmail(userEmail.getEmail());
            userEmailRepository.save(newUserEmail);
            return ResponseEntity.ok("学号存在，已成功绑定邮箱，请继续操作");
        }
    }


}




