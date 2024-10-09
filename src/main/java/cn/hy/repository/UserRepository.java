package cn.hy.repository;


import cn.hy.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, String> {
    User findByUsername(String username);
    User findByUsernameAndPassword(String username, String password);

    // 根据用户名查询用户记录数量
    long countByUsername(String username);

    boolean existsByUsername(String username);


}
