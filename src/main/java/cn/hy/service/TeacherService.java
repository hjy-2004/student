package cn.hy.service;

import cn.hy.entity.Result;

import java.util.List;

public interface TeacherService {
    Result login(String jobNumber, String password); // 返回类型为 Result
    List<Object> getTeacherByJobNumber(String jobNumber);




}
