package cn.hy.repository;


import cn.hy.entity.UserEmail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserEmailRepository extends JpaRepository<UserEmail, Long> {

    Optional<UserEmail> findByEmail(String email);

    Optional<UserEmail> findByUsername(String username);

    void deleteByUsername(String username);

}



