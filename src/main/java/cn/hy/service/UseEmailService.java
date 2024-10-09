package cn.hy.service;

import cn.hy.entity.UserEmail;
import org.springframework.stereotype.Service;

import java.util.List;



public interface UseEmailService {

    List<UserEmail> findByUsername(String username);
}
