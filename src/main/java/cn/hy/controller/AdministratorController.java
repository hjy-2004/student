package cn.hy.controller;

import cn.hy.entity.Administrator;
import cn.hy.entity.ChangePasswordRequest;
import cn.hy.repository.AdminRepository;
import cn.hy.service.AdministratorService;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Base64;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin("*")
public class AdministratorController {

    @Autowired
    private AdministratorService service;

    @Autowired
    private AdminRepository adminRepository;

    @GetMapping("/info")
    public Administrator getAdminInfo() {
        int adminId = 1; // 替换为实际的管理员ID
        return service.getAdminInfo(adminId);
    }

    @PutMapping("/info")
    public Administrator updateAdminInfo(@RequestBody Administrator adminInfo) {
        return service.updateAdminInfo(adminInfo);
    }

    @PostMapping("/upload/avatar")
    public String uploadAvatar(@RequestParam("file") MultipartFile file) {
        // 处理文件上传
        if (file.isEmpty()) {
            return "文件为空";
        }

        try {
            // 存储文件
            byte[] bytes = file.getBytes();

            // 更新管理员的头像
            Administrator admin = service.getAdminInfo(1); // 替换为实际的管理员ID
            admin.setAdminAvatar(bytes);
            service.updateAdminInfo(admin);

            // 返回头像的 Base64 编码数据
            return Base64.getEncoder().encodeToString(bytes);
        } catch (IOException e) {
            e.printStackTrace();
            return "上传失败";
        }
    }

    @PutMapping("/password")
    public ResponseEntity<?> changePassword(@RequestBody ChangePasswordRequest changePasswordRequest,@RequestHeader("Authorization") String userData) throws JSONException {
        // 获取当前管理员ID或号码
        JSONObject jsonObject = new JSONObject(userData);
        String adminNumber = (String) jsonObject.get("username");

        Administrator admin = adminRepository.findByAdminNumber(adminNumber);
        if (admin == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("管理员不存在");
        }

        // 验证当前密码
        if (!changePasswordRequest.getCurrentPassword().equals(admin.getAdminPassword())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("当前密码错误");
        }

        // 验证新密码和确认新密码是否匹配
        if (!changePasswordRequest.getNewPassword().equals(changePasswordRequest.getConfirmPassword())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("新密码与确认新密码不一致");
        }

        // 更新密码
        admin.setAdminPassword(changePasswordRequest.getNewPassword());
        adminRepository.save(admin);


        return ResponseEntity.ok("密码修改成功");
    }


}
