package cn.hy.service;

import cn.hy.entity.StuUser;

import java.util.List;

public interface StuUsService {

    List<StuUser> findByUsername(String username);
    StuUser save(StuUser stuUser);
}
