package cn.hy.vo;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Builder
public class TopicVO {
    private Integer id;
    private String title;
    private Long  creatorId;
    private String content;
    private String author;      // 展示用作者名称
    private String time;        // 格式化后的时间字符串
    private Integer replies;    // 回复数
}