package cn.hy.service;

import cn.hy.entity.PasswordChangeRequest;
import cn.hy.entity.Teacher;
import cn.hy.repository.TeacherPwdRepository;
import cn.hy.repository.TeacherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeaService {

    @Autowired
    private TeacherPwdRepository teacherPwdRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    public void changePassword(PasswordChangeRequest request) throws Exception {
        Teacher teacher = teacherPwdRepository.findByJobNumber(request.getJobNumber());
        if (teacher == null) {
            throw new Exception("Teacher not found");
        }
        if (!teacher.getPassword().equals(request.getOldPassword())) {
            throw new Exception("Old password is incorrect");
        }
        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new Exception("New passwords do not match");
        }

        teacher.setPassword(request.getNewPassword());
        teacherPwdRepository.save(teacher);
    }


    public List<Teacher> getAllTeachers() {
        return teacherRepository.findAll();
    }

    public Teacher getTeacherById(Long id) {
        return teacherRepository.findById(id).orElse(null);
    }
}
