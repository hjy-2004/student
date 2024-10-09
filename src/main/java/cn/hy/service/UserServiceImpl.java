package cn.hy.service;

import cn.hy.entity.Result;
import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import cn.hy.repository.StuUserRepository;
import cn.hy.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userRepository;



    @Override
    public Result register(User user) {
        // 验证用户名是否已存在
        if (userRepository.findByUsername(user.getUsername()) != null) {
            return new Result(false, "用户名已存在！", null);
        }
        // 验证其他字段是否为空，例如框里面是否有值
        if (user.getUsername() == null || user.getPassword().isEmpty()) {
            return new Result(false, "学号和密码不能为空！", null);
        }



        // 保存用户到数据库
        userRepository.save(user);

        // 返回注册成功的信息
        return new Result(true, "注册成功,请点击登录！", user);
    }

    @Override
    public Result login(String username, String password) {
        // 检查用户名和密码是否为空
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            return new Result(false, "学号和密码不能为空！", null);
        }
        User user = userRepository.findByUsernameAndPassword(username, password);

        if (user != null) {
            // 用户名和密码匹配成功，返回成功的消息和用户信息
            return new Result(true, "登录成功！", user);
        } else {
            // 用户名或密码错误，返回失败的消息
            return new Result(false, "用户名或密码错误！", null);
        }
    }


}
