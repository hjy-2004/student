// TeachersRepository.java
package cn.hy.repository;

import cn.hy.entity.Teachers;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TeachersRepository extends JpaRepository<Teachers, Long> {
}