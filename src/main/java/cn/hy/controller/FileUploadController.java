package cn.hy.controller;

import cn.hy.entity.FileInfo;
import cn.hy.repository.FileInfoRepository;
import cn.hy.service.FileStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/files")
@CrossOrigin("*")
public class FileUploadController {

    @Autowired
    private FileStorageService fileStorageService;

    @Autowired
    private FileInfoRepository fileInfoRepository;

    // 上传目录
    @Value("${file.upload-dir}") // 从配置文件中读取上传目录
    private String uploadDir;

    // 初始化目录
    @PostConstruct
    public void init() {
        fileStorageService.init();
    }

    // 文件上传接口
    @PostMapping("/upload")
    public ResponseEntity<Map<String, String>> uploadFile(@RequestParam("file") MultipartFile file,
                                                          @RequestParam("username") String username) {
        try {
            String fileName = fileStorageService.saveFile(file); // 保存原始文件名

            FileInfo fileInfo = new FileInfo();
            fileInfo.setFileName(fileName); // 保存原始文件名
            fileInfo.setFilePath(uploadDir + "/" + fileName); // 保存路径
            fileInfo.setUploadTime(LocalDateTime.now());
            fileInfo.setUsername(username); // 保存学号
            fileInfoRepository.save(fileInfo);

            // 创建返回的 JSON 对象
            Map<String, String> responseBody = new HashMap<>();
            responseBody.put("fileName", fileName);
            responseBody.put("filePath", uploadDir + "/" + fileName);

            return ResponseEntity.ok(responseBody); // 返回 JSON 对象
        } catch (Exception e) {
            // 返回错误信息
            Map<String, String> errorBody = new HashMap<>();
            errorBody.put("error", "文件上传失败: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorBody);
        }
    }


    // 获取已上传文件列表接口
    @GetMapping("/list/{username}")
    public ResponseEntity<List<FileInfo>> listUploadedFiles(@PathVariable String username) {
        try {
            List<FileInfo> files = fileInfoRepository.findByUsername(username);

            // 确保返回的文件信息中包含正确的文件名
            if (files.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).body(null); // 如果没有文件，则返回204
            }

            // 返回完整的文件信息
            return ResponseEntity.ok(files);
        } catch (Exception e) {
            e.printStackTrace(); // 输出异常日志
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null); // 返回合适的错误信息
        }
    }


    // 下载文件接口
    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<?> downloadFile(@RequestParam("username") String username,
                                          @PathVariable String filename) {
        try {
            // 从数据库中查找文件信息
            FileInfo fileInfo = fileInfoRepository.findByUsernameAndFileName(username, filename);

            if (fileInfo == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("文件不存在或没有权限");
            }

            // 加载文件
            Path filePath = Paths.get(fileInfo.getFilePath()).normalize();

            Resource resource = new UrlResource(filePath.toUri());

            // 检查文件是否存在和可读
            if (resource.exists() && resource.isReadable()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileInfo.getFileName() + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("文件不存在或无法读取");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("文件下载失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/delete/{filename:.+}")
    public ResponseEntity<String> deleteFile(@RequestParam("username") String username,
                                             @PathVariable String filename) {
        try {
            // 根据用户名和文件名从数据库获取文件信息
            FileInfo fileInfo = fileInfoRepository.findByUsernameAndFileName(username, filename);

            if (fileInfo == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("文件不存在或没有权限");
            }

            // 删除实际文件
            boolean fileDeleted = fileStorageService.deleteFile(fileInfo.getFilePath());
            if (!fileDeleted) {
                // 如果文件删除失败，返回错误响应
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("文件删除失败: 无法从服务器删除文件");
            }

            // 如果文件删除成功，则删除数据库中的文件记录
            fileInfoRepository.delete(fileInfo);

            return ResponseEntity.ok("文件删除成功: " + fileInfo.getFileName());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("文件删除失败: " + e.getMessage());
        }
    }



    // 自定义错误响应体
    class ResourceError {
        private String message;

        public ResourceError(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }
}
