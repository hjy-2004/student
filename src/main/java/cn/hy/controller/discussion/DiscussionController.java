package cn.hy.controller.discussion;

import cn.hy.dto.PostCreateDTO;
import cn.hy.dto.TopicCreateDTO;
import cn.hy.service.discussion.DiscussionService;
import cn.hy.vo.PostVO;
import cn.hy.vo.Result;
import cn.hy.vo.TopicVO;
import cn.hy.entity.UserType;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/discussions")
@CrossOrigin("*")
@RequiredArgsConstructor
public class DiscussionController {
    private final DiscussionService discussionService;

    // 获取主题列表
    @GetMapping
    public Result<List<TopicVO>> getTopics(
            @RequestParam String classId,
            @RequestHeader("X-User-Id") String userId,
            @RequestHeader("X-User-Type") UserType userType
    ) {
        return Result.success(discussionService.getTopics(classId));
    }

    // 创建新主题
    @PostMapping
    public Result<TopicVO> createTopic(
            @RequestBody @Valid TopicCreateDTO dto,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Type") UserType userType
    ) {
        dto.setCreatorId(userId);
        dto.setCreatorType(userType);
        return Result.success(discussionService.createTopic(dto));
    }

    @GetMapping("/{topicId}")
    public Result<TopicVO> getTopicById(
            @PathVariable Integer topicId,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Type") UserType userType) {
        return Result.success(discussionService.getTopicById(topicId));
    }

    /**
     * 发表评论接口
     * POST /api/discussions/{topicId}/posts
     */
    @PostMapping("/{topicId}/posts")
    public Result<Void> createPost(
            @PathVariable Integer topicId,
            @RequestBody @Valid PostCreateDTO dto,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Type") UserType userType) {

//        log.info("收到评论请求 parentId={}", dto.getParentId()); // 添加日志

        discussionService.createPost(
                topicId,
                dto.getContent(),
                userId,
                userType,
                dto.getParentId()
        );
        return Result.success();
    }

    // 获取评论列表接口
    @GetMapping("/{topicId}/posts")
    public Result<List<PostVO>> getPosts(
            @PathVariable Integer topicId,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Type") UserType userType) {

        return Result.success(discussionService.getPosts(topicId));
    }

    // 删除讨论主题接口
    @DeleteMapping("/{topicId}")
    public Result<Void> deleteTopic(
            @PathVariable Integer topicId,
            @RequestHeader("X-User-Id") Long userId,
            @RequestHeader("X-User-Type") UserType userType) {

        try {
            // 调用 service 层方法删除主题
            discussionService.deleteTopic(topicId, userId, userType);
            return Result.success();  // 成功返回成功的结果
        } catch (RuntimeException e) {
            // 捕获可能的错误，例如主题不存在或权限问题，使用 Result.error 返回错误信息
            return Result.error(400, e.getMessage());  // 400 可以是通用错误代码，也可以根据需求修改
        }
    }

}
