package cn.hy.repository;

import cn.hy.entity.StuUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StuUserEmailRepository extends JpaRepository<StuUser, Integer> {

    StuUser findByUsername(String username);
}
