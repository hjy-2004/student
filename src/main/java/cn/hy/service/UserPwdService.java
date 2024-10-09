package cn.hy.service;

import cn.hy.entity.User;
import cn.hy.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserPwdService {

    @Autowired
    private UserRepository userRepository;

    public boolean updatePassword(String username, String oldPassword, String newPassword) {
        // 查找用户
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 验证旧密码
        if (!user.getPassword().equals(oldPassword)) {
            throw new RuntimeException("旧密码不正确");
        }

        // 更新密码
        user.setPassword(newPassword);
        userRepository.save(user);

        return true;
    }
    // 检查指定用户名的用户是否存在
    public boolean existsByUsername(String username) {
        // 查询用户记录数量
        long count = userRepository.countByUsername(username);
        // 如果数量大于零，则用户存在
        return count > 0;
    }
}
