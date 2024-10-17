package cn.hy.repository;

import cn.hy.entity.StuUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface StuUserRepository extends JpaRepository<StuUser, Integer> {


    List<StuUser> findByUsername(String username);

//    @Query("SELECT s FROM StuUser s WHERE LOWER(s.username) = LOWER(?1)")
//    Optional<StuUser> findByUsernameCustom(String username);


    StuUser findFirstByUsername(String username);


    List<StuUser> findByStuClass(String stuClass);
    boolean existsByUsername(String username);

    void deleteByUsername(String username);






}
