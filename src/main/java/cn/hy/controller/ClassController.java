package cn.hy.controller;

import cn.hy.entity.Teachers;
import cn.hy.repository.StuUsersRepository;
import cn.hy.repository.TeachersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin("*")
public class ClassController {

    @Autowired
    private TeachersRepository teachersRepository;

    @GetMapping("/GetTeachers")
    public List<Teachers> getTeachers() {
        List<Teachers> teachers = teachersRepository.findAll();
        for (Teachers teacher : teachers) {
            // 通过调用 getter 方法触发懒加载
            teacher.getStudents().size();
        }
        return teachers;
    }

    @GetMapping("/GetTeachers/{id}")
    public Teachers getTeacher(@PathVariable Long id) {
        Teachers teacher = teachersRepository.findById(id).orElse(null);
        if (teacher != null) {
            // 通过调用 getter 方法触发懒加载
            teacher.getStudents().size();
        }
        return teacher;
    }

}
