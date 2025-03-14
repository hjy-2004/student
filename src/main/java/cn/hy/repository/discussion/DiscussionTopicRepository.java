package cn.hy.repository.discussion;

import cn.hy.entity.DiscussionTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DiscussionTopicRepository extends JpaRepository<DiscussionTopic, Integer> {
    List<DiscussionTopic> findByClassIdOrderByCreatedAtDesc(String classId);

    @Modifying
    @Query("UPDATE DiscussionTopic t SET t.replyCount = t.replyCount + 1 WHERE t.id = :topicId")
    void incrementReplyCount(@Param("topicId") Integer topicId);
}
