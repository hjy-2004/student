package cn.hy.service;

import cn.hy.entity.Administrator;
import cn.hy.entity.Result;
import cn.hy.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService{

    @Autowired
    private AdminRepository adminRepository;
    @Override
    public Result login(String adminNumber, String adminPassword) {
        Administrator administrator=adminRepository.findByAdminNumberAndAdminPassword(adminNumber,adminPassword);
        if(administrator != null){
            // 返回登陆成功的消息
            return new Result(true, "登录成功！", administrator);
        }else {
            // 返回登录失败的消息
            return new Result(false, "管理员账号或密码错误！", null);
        }

    }
}
