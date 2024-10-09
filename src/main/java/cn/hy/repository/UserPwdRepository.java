package cn.hy.repository;

import cn.hy.entity.PasswordUpdateRequest;
import cn.hy.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserPwdRepository extends JpaRepository<User,String> {

}
