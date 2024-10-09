package cn.hy.controller;

import cn.hy.entity.Result;
import cn.hy.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


@RestController
@RequestMapping("/admin")
@CrossOrigin("*")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @PostMapping("/login")
    public Result login(@RequestParam("admin_number") String adminNumber,
                        @RequestParam("admin_password") String adminPassword,
                        HttpServletRequest request) {
        Result result = adminService.login(adminNumber, adminPassword);
        if (result.isSuccess()) {
            // 登录成功，将管理员号码存储在 HttpSession 中
            HttpSession session = request.getSession();
            session.setAttribute("adminNumber", adminNumber);
        }
        return result;
    }
}
