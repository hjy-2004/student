package cn.hy.service;

import cn.hy.entity.User;
import cn.hy.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class UseService {

    @Autowired
    private UserRepository userRepository;



    public User getUserByUsername(String username) {
        return userRepository.findById(username).orElse(null);
    }

    public boolean checkUserExists(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean usernameExists(String username) {
        return userRepository.existsByUsername(username); // 直接使用 repository 方法检查是否存在
    }

    public void saveUser(User user) {
        userRepository.save(user);
    }


    public User addUser(User user) {
        return userRepository.save(user);
    }

}
