// StuUsersRepository.java
package cn.hy.repository;


import cn.hy.entity.StuUsers;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StuUsersRepository extends JpaRepository<StuUsers, Long> {

    List<StuUsers> findByTeachersId(Long teacherId);



}