package cn.hy.vo;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

// PostVO.java
@Getter
@Builder
public class PostVO {
    private Integer id;
    private String content;
    private String author;
    private String time;
    private List<PostVO> replies; // 嵌套回复
    private Integer parentId;
}
