package cn.hy.service;

import cn.hy.entity.Result;
import cn.hy.entity.Teacher;
import cn.hy.repository.TeacherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class TeacherServiceImpl implements TeacherService {

    @Autowired
    private TeacherRepository teacherRepository;



    @Override
    public Result login(String jobNumber, String password) {
        Teacher teacher = teacherRepository.findByJobNumberAndPassword(jobNumber, password);
        if (teacher != null) {
            // 返回登录成功的消息和教师信息
            return new Result(true, "登录成功！", teacher);
        } else {
            // 返回登录失败的消息
            return new Result(false, "工号或密码错误！", null);
        }
    }

    @Override
    public List<Object> getTeacherByJobNumber(String jobNumber) {
        return teacherRepository.findByJobNumber(jobNumber);
    }






}
