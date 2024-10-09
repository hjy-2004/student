package cn.hy.controller;

import cn.hy.entity.Result;
import cn.hy.entity.User;
import cn.hy.repository.StuUserRepository;
import cn.hy.repository.UserEmailRepository;
import cn.hy.repository.UserRepository;
import cn.hy.service.UseService;
import cn.hy.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
@CrossOrigin("*")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private UseService useService;

    @Autowired
    private UserRepository userRepository;


    @Autowired
    private StuUserRepository stuUserRepository;

    @Autowired
    private UserEmailRepository userEmailRepository;

    @PostMapping("/register")
    public Result register(@RequestBody User user) {
        return userService.register(user);
    }

    @PostMapping("/login")
    public Result login(@RequestParam("user_name") String username, @RequestParam("user_password") String password) {
        return userService.login(username, password);
    }

    @GetMapping("/{username}")
    public User getUserByUsername(@PathVariable String username) {
        return useService.getUserByUsername(username);
    }

    @GetMapping("/exists")
    public ResponseEntity<Map<String, Boolean>> checkUsernameExists(@RequestParam String username) {
        boolean exists = userRepository.existsByUsername(username);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/admin/register")
    public ResponseEntity<String> registerUser(@RequestBody User user) {
        boolean userExists = useService.checkUserExists(user.getUsername());
        if (userExists) {
            return ResponseEntity.status(409).body("学号已存在");
        }
        useService.saveUser(user);
        return ResponseEntity.status(201).body("学号添加成功");
    }

    @GetMapping("/admin/password")
    public List<User> fetchPasswords() {
        return userRepository.findAll();
    }

    @GetMapping("/admin/passwords")
    public ResponseEntity<?> getAllUsers() {
        try {
            return new ResponseEntity<>(userRepository.findAll(), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to fetch users: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}
