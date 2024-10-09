package cn.hy.controller;

import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import cn.hy.repository.StuUserRepository;
import cn.hy.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/students")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private StuUserRepository stuUserRepository;


    // 根据学号获取学生信息
    @GetMapping("/getAllStudents")
    public List<Object[]> getStudentByUsername() {
        return  studentService.getStudentInfoByUsername();
    }


    @GetMapping("/exists")
    public ResponseEntity<Map<String, Boolean>> checkStuUserExists(@RequestParam String username) {
        boolean exists = stuUserRepository.existsByUsername(username);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

}
