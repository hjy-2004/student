package cn.hy.controller;

import cn.hy.entity.PasswordUpdateRequest;
import cn.hy.entity.Result;
import cn.hy.entity.User;
import cn.hy.service.UserPwdService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/user")
public class UserPwdController {

    private final UserPwdService userPwdService;

    @Autowired
    public UserPwdController(UserPwdService userPwdService) {
        this.userPwdService = userPwdService;
    }

    @PutMapping("/password")
    public ResponseEntity<String> updatePassword(@RequestBody PasswordUpdateRequest request) {
        // 检查用户是否存在
        if (!userPwdService.existsByUsername(request.getUsername())) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("用户不存在");
        }

        // 检查新密码是否与旧密码相同
        if (request.getPassword().equals(request.getNewPassword())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("新密码不能与旧密码相同");
        }

        try {
            // 执行修改密码操作
            boolean success = userPwdService.updatePassword(request.getUsername(), request.getPassword(), request.getNewPassword());
            if (success) {
                return ResponseEntity.ok("密码修改成功");
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("旧密码不正确");
            }
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

}

