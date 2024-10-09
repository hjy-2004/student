package cn.hy.controller;

import cn.hy.entity.StuUser;
import cn.hy.entity.User;
import cn.hy.repository.StuUserRepository;
import cn.hy.service.StuUserService;
import cn.hy.service.StudentService;
import cn.hy.service.UseService;
import cn.hy.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/students")
@CrossOrigin("*")
public class StuUserController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private StuUserService stuUserService;

    @Autowired
    private StuUserRepository stuUserRepository;

    @Autowired
    private UseService useService;

    @GetMapping
    public List<StuUser> getAllStudents() {
        return stuUserService.getAllStudents();
    }

    @GetMapping("/{uid}")
    public ResponseEntity<StuUser> getStudentById(@PathVariable int uid) {
        StuUser student = stuUserService.getStudentById(uid);
        if (student == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(student);
    }

    @PutMapping("/{uid}")
    public ResponseEntity<?> updateStudent(@PathVariable int uid, @RequestBody StuUser studentDetails) {
        try {
            StuUser updatedStudent = stuUserService.updateStudent(uid, studentDetails);
            if (updatedStudent == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(updatedStudent);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating student: " + e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<?> addStudent(@RequestBody StuUser student) {
        System.out.println("Received student: " + student);
        try {
            StuUser newStudent = stuUserService.addStudent(student);
            return ResponseEntity.ok(newStudent);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error saving student: " + e.getMessage());
        }
    }

    @PostMapping("/addOrUpdate")
    public ResponseEntity<?> addOrUpdateStudent(@RequestBody StuUser studentDetails) {
        try {
            StuUser savedStudent = stuUserService.saveOrUpdateStudent(studentDetails);
            return ResponseEntity.ok(savedStudent);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error saving student: " + e.getMessage());
        }
    }


    @DeleteMapping("/{uid}")
    public ResponseEntity<?> deleteStudent(@PathVariable int uid) {
        try {
            stuUserService.deleteStudent(uid);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting student: " + e.getMessage());
        }
    }

    @GetMapping("/class/{stuClass}")
    public List<StuUser> getStudentsByClass(@PathVariable String stuClass) {
        return stuUserService.getStudentsByClass(stuClass);
    }

    @GetMapping("/classes")
    public List<String> getAllClasses() {
        return stuUserService.getAllClasses();
    }


    @GetMapping("/admin")
    public List<StuUser> getAllStuUsers() {
        return stuUserRepository.findAll();
    }

    @PostMapping("/admin")
    public StuUser createStuUser(@RequestBody StuUser stuUser) {
        return stuUserRepository.save(stuUser);
    }

    @PutMapping("/admin/{uid}")
    public StuUser updateStuUser(@PathVariable int uid, @RequestBody StuUser stuUser) {
        stuUser.setUid(uid);
        return stuUserRepository.save(stuUser);
    }

//    @DeleteMapping("/admin/{uid}")
//    public void deleteStuUser(@PathVariable int uid) {
//        stuUserRepository.deleteById(uid);
//    }

    @DeleteMapping("/by-username/{username}")
    public ResponseEntity<Void> deleteStudent(@PathVariable String username) {
        studentService.deleteStudent(username);
        return ResponseEntity.noContent().build();
    }

//    @PutMapping("/update-by-username/{username}")
//    public ResponseEntity<?> updateStudentByUsername(@PathVariable String username, @RequestBody StuUser studentDetails) {
//        // 确保你正确获取了现有学生
//        StuUser existingStudent = stuUserService.getStudentByUsername(username);
//        if (existingStudent == null) {
//            return ResponseEntity.notFound().build(); // 学生未找到
//        }
//
//        // 更新学生信息
//        existingStudent.setStuName(studentDetails.getStuName());
//        existingStudent.setStuClass(studentDetails.getStuClass());
//        existingStudent.setEmail(studentDetails.getEmail());
//        existingStudent.setTeacher(studentDetails.getTeacher());
//
//        // 保存更新
//        StuUser updatedStudent = stuUserRepository.save(existingStudent);
//        return ResponseEntity.ok(updatedStudent); // 返回更新后的学生信息
//    }

    @PutMapping("/update-by-uid/{uid}")
    public ResponseEntity<?> updateStudentByUid(@PathVariable int uid, @RequestBody StuUser studentDetails) {
        try {
            StuUser existingStudent = stuUserService.updateStudent(uid, studentDetails);
            if (existingStudent == null) {
                return ResponseEntity.notFound().build();
            }
            // 更新学生信息
            existingStudent.setStuName(studentDetails.getStuName());
            existingStudent.setStuClass(studentDetails.getStuClass());
            existingStudent.setEmail(studentDetails.getEmail());
            existingStudent.setTeacher(studentDetails.getTeacher());

            // 保存更新
            StuUser updatedStudent = stuUserRepository.save(existingStudent);
            return ResponseEntity.ok(updatedStudent);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating student: " + e.getMessage());
        }
    }

    @GetMapping("/check-username")
    public ResponseEntity<Boolean> checkUsername(@RequestParam String username) {
        boolean exists = stuUserService.usernameExists(username);
        return ResponseEntity.ok(exists);
    }





}
