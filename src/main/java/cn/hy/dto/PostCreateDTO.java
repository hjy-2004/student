// PostCreateDTO.java
package cn.hy.dto;

import lombok.Data;
import javax.validation.constraints.NotBlank;

@Data
public class PostCreateDTO {
    @NotBlank(message = "评论内容不能为空")
    private String content;

    private Integer parentId; // 可为空的父评论ID
}