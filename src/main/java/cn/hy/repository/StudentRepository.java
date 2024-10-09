package cn.hy.repository;
import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<StuUser, Long> {

    // 使用 JPQL 进行连表查询，获取学生的学号、姓名、班级以及成绩信息
    @Query(value = "SELECT u.username, s.stu_class, s.stu_name, s.total_credits, s.email " +
            "FROM User u JOIN stu_user s ON u.username = s.username "
            , nativeQuery = true)
    List<Object[]> getStudentInfoByUsername();


}


