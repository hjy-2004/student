package cn.hy.repository;

import cn.hy.entity.Teacher;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface TeacherRepository extends JpaRepository<Teacher, Long> {


    Teacher findByJobNumberAndPassword(String jobNumber, String password);

    @Query(value = "SELECT * FROM teacher", nativeQuery = true)
    List<Object> findByJobNumber(@Param("jobNumber") String jobNumber);


}
