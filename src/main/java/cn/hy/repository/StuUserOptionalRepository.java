package cn.hy.repository;

import cn.hy.entity.StuUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 管理email
 * */

@Repository
public interface StuUserOptionalRepository extends JpaRepository<StuUser, Integer> {
    Optional<StuUser> findByUsername(String username); // 使用 Optional
}
