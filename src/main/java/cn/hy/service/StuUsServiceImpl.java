package cn.hy.service;

import cn.hy.entity.StuUser;
import cn.hy.repository.StuUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StuUsServiceImpl implements StuUsService{

    private final StuUserRepository stuUserRepository;


    @Autowired
    public StuUsServiceImpl(StuUserRepository stuUserRepository) {
        this.stuUserRepository = stuUserRepository;
    }

    @Override
    public List<StuUser> findByUsername(String username) {
        return stuUserRepository.findByUsername(username);
    }

    @Override
    public StuUser save(StuUser stuUser) {
        return stuUserRepository.save(stuUser);
    }
}
