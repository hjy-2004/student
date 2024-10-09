package cn.hy.controller;

import cn.hy.abnormal.ResourceNotFoundException;
import cn.hy.entity.PasswordChangeRequest;
import cn.hy.entity.Result;
import cn.hy.entity.Teacher;
import cn.hy.repository.TeacherRepository;
import cn.hy.service.TeaService;
import cn.hy.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/teachers")
@CrossOrigin("*")
public class TeacherController {

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private TeaService teaService;

    @Autowired
    private TeacherRepository teacherRepository;

    @PostMapping("/login")
    public Result login(@RequestParam("teacher_number") String jobNumber, @RequestParam("teacher_password") String password) {
        return teacherService.login(jobNumber, password);


    }

    @GetMapping("/getTeacher")
    public List<Object> getTeacher(@RequestParam String jobNumber) {
        return teacherService.getTeacherByJobNumber(jobNumber);
    }


    @GetMapping
    public List<Teacher> getAllTeachers() {
        return teaService.getAllTeachers();
    }

    @GetMapping("/{id}")
    public Teacher getTeacherById(@PathVariable Long id) {
        return teaService.getTeacherById(id);
    }


    @PutMapping("/{id}")
    public ResponseEntity<Teacher> updateTeacher(@PathVariable Long id, @RequestBody Teacher teacherDetails) {
        Teacher teacher = teacherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with id " + id));

        teacher.setJobNumber(teacherDetails.getJobNumber());
        teacher.setName(teacherDetails.getName());
        teacher.setGender(teacherDetails.getGender());
        teacher.setEmail(teacherDetails.getEmail());
        teacher.setPhoneNumber(teacherDetails.getPhoneNumber());
        teacher.setClassId(teacherDetails.getClassId());
        teacher.setPassword(teacherDetails.getPassword());

        Teacher updatedTeacher = teacherRepository.save(teacher);
        return ResponseEntity.ok(updatedTeacher);
    }

    @PostMapping
    public Teacher createTeacher(@RequestBody Teacher teacher) {
        return teacherRepository.save(teacher);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTeacher(@PathVariable Long id) {
        Teacher teacher = teacherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Teacher not found with id " + id));

        teacherRepository.delete(teacher);
        return ResponseEntity.noContent().build();
    }


}
