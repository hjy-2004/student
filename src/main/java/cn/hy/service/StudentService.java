package cn.hy.service;

import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import cn.hy.repository.StuUserRepository;
import cn.hy.repository.StudentRepository;
import cn.hy.repository.UserEmailRepository;
import cn.hy.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class StudentService {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private UserEmailRepository userEmailRepository;

    @Autowired
    private StuUserRepository stuUserRepository;

    @Autowired
    private UserRepository userRepository;




    public List<Object[]> getStudentInfoByUsername() {
        return studentRepository.getStudentInfoByUsername();
    }

    @Transactional
    public void deleteStudent(String username) {
        // 先删除依赖表中的记录
        userEmailRepository.deleteByUsername(username);

        // 再删除主表中的记录
        stuUserRepository.deleteByUsername(username);

        // 最后删除User表中的记录
        userRepository.deleteById(username);
    }









}

