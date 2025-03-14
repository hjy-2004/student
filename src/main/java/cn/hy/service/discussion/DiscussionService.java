package cn.hy.service.discussion;

import cn.hy.abnormal.ResourceNotFoundException;
import cn.hy.dto.TopicCreateDTO;
import cn.hy.entity.*;
import cn.hy.repository.StudentRepository;
import cn.hy.repository.TeacherRepository;
import cn.hy.repository.discussion.DiscussionPostRepository;
import cn.hy.repository.discussion.DiscussionTopicRepository;
import cn.hy.vo.PostVO;
import cn.hy.vo.TopicVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DiscussionService {
    private final DiscussionTopicRepository topicRepository;
    private final DiscussionPostRepository postRepository;
    // 需要先注入用户Repository
    private final TeacherRepository teacherRepository;
    private final StudentRepository studentRepository;

    private String getAuthorName(Long creatorId, UserType creatorType) {
        return switch (creatorType) {
            case TEACHER -> teacherRepository.findById(Long.valueOf(creatorId))
                    .map(Teacher::getName)
                    .orElse("未知教师");
            case STUDENT -> studentRepository.findByUsername(String.valueOf(creatorId)) // 改为用学号查询
                    .map(StuUser::getStuName)
                    .orElse("未知学生");
        };
    }

    private String formatDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter
                .ofPattern("yyyy-MM-dd HH:mm")
                .withZone(ZoneId.systemDefault());
        return dateTime.format(formatter);
    }

    private Integer getReplyCount(Integer topicId) {
        return postRepository.countByTopicId(topicId);
    }

    // 获取主题列表
    public List<TopicVO> getTopics(String classId) {
        return topicRepository.findByClassIdOrderByCreatedAtDesc(classId)
                .stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
    }

    // 创建新主题
    public TopicVO createTopic(TopicCreateDTO dto) {
        DiscussionTopic topic = new DiscussionTopic();
        topic.setClassId(dto.getClassId());
        topic.setCreatorId(dto.getCreatorId());
        topic.setCreatorType(dto.getCreatorType());
        topic.setTitle(dto.getTitle());
        topic.setContent(dto.getContent());
        return convertToVO(topicRepository.save(topic));
    }

    // 实体转VO
    private TopicVO convertToVO(DiscussionTopic topic) {
        return TopicVO.builder()
                .id(topic.getId())
                .title(topic.getTitle())
                .creatorId(topic.getCreatorId())
                .content(topic.getContent() != null ? topic.getContent() : "暂无主题")
                .author(getAuthorName(topic.getCreatorId(), topic.getCreatorType()))
                .time(formatDateTime(topic.getCreatedAt()))
                .replies(getReplyCount(topic.getId()))
                .build();
    }

    public TopicVO getTopicById(Integer topicId) {
        return topicRepository.findById(topicId)
                .map(this::convertToVO)
                .orElseThrow(() -> new ResourceNotFoundException("主题不存在"));
    }



    @Transactional
    public void createPost(Integer topicId, String content, Long posterId,
                           UserType posterType, Integer parentId) {
        DiscussionTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("主题不存在"));

        DiscussionPost post = new DiscussionPost();
        post.setContent(content);
        post.setPosterId(posterId);
        post.setPosterType(posterType);
        post.setTopic(topic);

        // 关键修复：正确建立父评论关联
        if (parentId != null) {
            DiscussionPost parent = postRepository.findById(parentId)
                    .orElseThrow(() -> new ResourceNotFoundException("父评论不存在"));
            post.setParent(parent);
            parent.getReplies().add(post); // 双向关联
        }

        postRepository.save(post); // 级联保存
    }

    // 新增方法：获取评论列表
    public List<PostVO> getPosts(Integer topicId) {
        DiscussionTopic topic = topicRepository.findById(topicId)
                .orElseThrow(() -> new ResourceNotFoundException("主题不存在"));

        List<DiscussionPost> rootPosts = postRepository.findByTopicAndParentIsNull(topic);
        return rootPosts.stream()
                .map(this::convertToPostVO)
                .collect(Collectors.toList());
    }

    // 新增方法：评论实体转VO
    private PostVO convertToPostVO(DiscussionPost post) {
        return PostVO.builder()
                .id(post.getId())
                .content(post.getContent())
                .author(getAuthorName(post.getPosterId(), post.getPosterType()))
                .time(formatDateTime(post.getCreatedAt()))
                .parentId(post.getParent() != null ? post.getParent().getId() : null)
                .replies(getReplies(post.getId())) // 递归获取子回复
                .build();
    }

    // 递归获取子回复（修正版）
    private List<PostVO> getReplies(Integer postId) {
        return postRepository.findChildrenByParentId(postId)
                .stream()
                .map(this::convertToPostVO)
                .collect(Collectors.toList());
    }

    // 删除主题及其帖子
    public void deleteTopic(Integer topicId, Long userId, UserType userType) {
        // 检查主题是否存在
        if (!topicRepository.existsById(topicId)) {
            throw new RuntimeException("主题不存在");
        }

        // 可选：可以根据用户角色进行权限验证（例如，只有教师可以删除）
        // if (!userHasPermission(userId, topicId)) {
        //    throw new RuntimeException("权限不足");
        // }

        // 删除主题（此操作会通过外键约束级联删除相关帖子）
        topicRepository.deleteById(topicId);

        // 删除相关的帖子（可以根据需要在这里添加额外的删除逻辑）
        // postRepository.deleteByTopicId(topicId);
    }
}
