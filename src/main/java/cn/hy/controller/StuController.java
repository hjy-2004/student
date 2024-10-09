package cn.hy.controller;

import cn.hy.entity.StuUser;
import cn.hy.repository.StudentRepository;
import cn.hy.service.StuUsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/students")
public class StuController {

    @Autowired
    private StudentRepository studentRepository;

    private final StuUsService stuUsService;


    @Autowired
    public StuController(StuUsService stuUserService) {
        this.stuUsService = stuUserService;
    }

    @GetMapping("/getStudent")
    public List<StuUser> getStudentByUsername(@RequestParam String username) {
        System.out.println("Received request with username: " + username);
        return stuUsService.findByUsername(username);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addStudent(@RequestBody StuUser stuUser) {
        try {
            // 这里需要确保能够正确接收并保存班主任信息
            stuUsService.save(stuUser);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error saving student: " + e.getMessage());
        }
    }
}


