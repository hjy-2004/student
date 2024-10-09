package cn.hy.repository;

import cn.hy.entity.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TeacherPwdRepository extends JpaRepository<Teacher, Long> {
    Teacher findByJobNumber(String jobNumber);
}
