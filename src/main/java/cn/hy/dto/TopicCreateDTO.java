package cn.hy.dto;

import cn.hy.entity.UserType;
import lombok.Data;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Data
public class TopicCreateDTO {
    @NotBlank(message = "班级ID不能为空")
    private String classId;

    @NotBlank(message = "标题不能为空")
    @Size(max = 100, message = "标题长度不能超过100字符")
    private String title;

    @NotBlank(message = "内容不能为空")
    @Size(max = 2000, message = "内容长度不能超过2000字符")
    private String content;

    // 以下字段通常从用户上下文中获取，不需要前端传递
    private Long creatorId;
    private UserType creatorType;
}