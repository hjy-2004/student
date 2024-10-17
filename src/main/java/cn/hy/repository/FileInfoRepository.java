package cn.hy.repository;
import cn.hy.entity.FileInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FileInfoRepository extends JpaRepository<FileInfo, Long> {

    // 根据学生的学号查询文件
    List<FileInfo> findByUsername(String username);
    // 根据用户名和文件名查询文件

    FileInfo findByUsernameAndFileName(String username, String fileName); // 返回单个对象

}
