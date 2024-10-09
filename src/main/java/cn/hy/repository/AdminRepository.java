package cn.hy.repository;

import cn.hy.entity.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


public interface AdminRepository extends JpaRepository<Administrator, Integer> {
    Administrator findByAdminNumberAndAdminPassword(String adminNumber, String adminPassword);

    Administrator findByAdminNumber(String adminNumber);
}


