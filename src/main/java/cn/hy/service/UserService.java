package cn.hy.service;

import cn.hy.entity.Result;
import cn.hy.entity.User;

public interface UserService {
    Result register(User user); // 返回类型为 Result
    Result login(String username, String password);
}
