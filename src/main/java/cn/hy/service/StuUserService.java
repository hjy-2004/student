package cn.hy.service;

import cn.hy.entity.StuUser;
import cn.hy.repository.StuUserRepository;
import cn.hy.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class StuUserService {

    @Autowired
    private StuUserRepository stuUserRepository;

    @Autowired
    private UserRepository userRepository;

    public List<StuUser> getAllStudents() {
        return stuUserRepository.findAll();
    }

    public StuUser getStudentById(int uid) {
        return stuUserRepository.findById(uid).orElse(null);
    }


    public StuUser getStudentByUsername(String username) {
        return stuUserRepository.findFirstByUsername(username); // 使用新添加的方法
    }

    public boolean usernameExists(String username) {
        return userRepository.existsByUsername(username); // 直接使用 repository 方法检查是否存在
    }

    public StuUser  updateStudent(int uid, StuUser student) {
        StuUser existingStudent = stuUserRepository.findById(uid).orElse(null);
        if (existingStudent != null) {
            existingStudent.setStuName(student.getStuName());
            existingStudent.setStuClass(student.getStuClass());
            existingStudent.setTotalCredits(student.getTotalCredits());
            existingStudent.setTeacher(student.getTeacher());
            return stuUserRepository.save(existingStudent);
        } else {
            return null; // 或者抛出异常
        }
    }

    public StuUser addStudent(StuUser stuUser) {
        return stuUserRepository.save(stuUser);
    }

    public void deleteStudent(int uid) {
        stuUserRepository.deleteById(uid);
    }


    public List<StuUser> getStudentsByClass(String stuClass) {
        return stuUserRepository.findByStuClass(stuClass);
    }

    public List<String> getAllClasses() {
        return stuUserRepository.findAll().stream()
                .map(StuUser::getStuClass)
                .distinct()
                .collect(Collectors.toList());
    }

    public StuUser saveOrUpdateStudent(StuUser stuUser) {
        if (stuUserRepository.existsByUsername(stuUser.getUsername())) {
            // 如果学生存在，则进行更新
            return updateStudent(stuUser.getUid(), stuUser); // 这里 uid 应该是学生的唯一标识符
        } else {
            // 如果学生不存在，则进行插入
            return addStudent(stuUser);
        }
    }


//    public boolean isStep2Completed(String username) {
//        Optional<StuUser> studentOpt = stuUserRepository.findByUsernameCustom(username);
//
//        if (studentOpt.isPresent()) {
//            StuUser student = studentOpt.get();
//            System.out.println("stuClass: " + student.getStuClass());
//            System.out.println("teacher: " + student.getTeacher());
//            System.out.println("email: " + student.getEmail());
//
//            return student.getStuClass() != null &&
//                    student.getTeacher() != null &&
//                    student.getEmail() != null;
//        }
//
//        return false;
//    }





}
