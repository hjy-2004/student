package cn.hy.repository.discussion;

import cn.hy.entity.DiscussionPost;
import cn.hy.entity.DiscussionTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DiscussionPostRepository extends JpaRepository<DiscussionPost, Integer> {
    // 查询主题下的顶级评论（parent为null）
    List<DiscussionPost> findByTopicAndParentIsNull(DiscussionTopic topic);

    // 通过父评论ID查询子评论（自定义查询）
    @Query("SELECT p FROM DiscussionPost p WHERE p.parent.id = :parentId")
    List<DiscussionPost> findChildrenByParentId(@Param("parentId") Integer parentId);

    // 统计主题回复数
    @Query("SELECT COUNT(p) FROM DiscussionPost p WHERE p.topic.id = :topicId")
    Integer countByTopicId(@Param("topicId") Integer topicId);

    // 提供删除操作，Spring Data JPA 会自动生成 SQL 查询
    void deleteById(Integer id);
    boolean existsById(Integer id);  // 检查是否存在
}