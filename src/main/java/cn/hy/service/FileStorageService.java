package cn.hy.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.stream.Stream;

@Service
public class FileStorageService {

    // 从 application.properties 中获取配置的上传目录
    @Value("${file.upload-dir}")
    private String uploadDir;

    // 初始化存储文件夹
    public void init() {
        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);
            System.out.println("文件上传目录已初始化: " + uploadPath);
        } catch (IOException e) {
            throw new RuntimeException("无法初始化文件上传目录", e);
        }
    }

    // 保存文件
    public String saveFile(MultipartFile file) {
        try {
            // 获取原始文件名
            String originalFileName = file.getOriginalFilename();
            String baseFileName = originalFileName.substring(0, originalFileName.lastIndexOf('.')); // 获取不带后缀的文件名
            String extension = originalFileName.substring(originalFileName.lastIndexOf('.')); // 获取文件后缀

            // 创建目标路径
            Path destination = Paths.get(uploadDir).toAbsolutePath().normalize().resolve(originalFileName);

            // 输出保存文件路径的日志
            System.out.println("Saving file to: " + destination.toString());

            // 确保上传目录存在
            Files.createDirectories(destination.getParent());

            // 检查文件是否已存在，若存在则修改文件名
            int count = 1;
            while (Files.exists(destination)) {
                String newFileName = baseFileName + "（" + count + "）" + extension; // 新文件名
                destination = Paths.get(uploadDir).toAbsolutePath().normalize().resolve(newFileName); // 更新目标路径
                count++; // 增加计数
            }

            // 保存文件
            file.transferTo(destination.toFile());

            return destination.getFileName().toString(); // 返回最终保存的文件名
        } catch (IOException e) {
            // 输出异常日志
            e.printStackTrace();
            throw new RuntimeException("无法保存文件: " + e.getMessage(), e);
        }
    }



    // 获取已上传文件的列表
    public Stream<Path> loadAllFiles() {
        try {
            return Files.walk(Paths.get(uploadDir).toAbsolutePath().normalize(), 1)
                    .filter(path -> !path.equals(Paths.get(uploadDir).toAbsolutePath().normalize()))
                    .map(Paths.get(uploadDir).toAbsolutePath().normalize()::relativize);
        } catch (IOException e) {
            throw new RuntimeException("无法读取文件", e);
        }
    }

    // 加载文件
    public Path load(String filename) {
        return Paths.get(uploadDir).toAbsolutePath().normalize().resolve(filename);
    }

    // 删除文件
    public boolean deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            if (file.exists()) {
                return file.delete();  // 返回删除操作结果
            } else {
                System.out.println("文件不存在: " + filePath);
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
