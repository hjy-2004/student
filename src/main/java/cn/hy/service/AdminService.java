package cn.hy.service;

import cn.hy.entity.Result;



public interface AdminService {

    Result login(String adminNumber, String adminPassword);
}
