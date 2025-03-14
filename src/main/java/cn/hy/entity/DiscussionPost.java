package cn.hy.entity;

import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "discussion_post")
@Data
public class DiscussionPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private DiscussionTopic topic;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private DiscussionPost parent;

    @Lob
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "poster_id", nullable = false)
    private Long posterId;

    @Enumerated(EnumType.STRING)
    @Column(name = "poster_type", nullable = false)
    private UserType posterType;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer childCount;

    // 子评论列表（反向关联）
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
    private List<DiscussionPost> replies = new ArrayList<>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public DiscussionTopic getTopic() {
        return topic;
    }

    public void setTopic(DiscussionTopic topic) {
        this.topic = topic;
    }

    public DiscussionPost getParentId() {
        return parent;
    }

    public void setParentId(Integer parentId) {
        if (parentId != null) {
            this.parent = new DiscussionPost();
            this.parent.setId(parentId);
        } else {
            this.parent = null;
        }
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getPosterId() {
        return posterId;
    }

    public void setPosterId(Long posterId) {
        this.posterId = posterId;
    }

    public UserType getPosterType() {
        return posterType;
    }

    public void setPosterType(UserType posterType) {
        this.posterType = posterType;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getChildCount() {
        return childCount;
    }

    public void setChildCount(Integer childCount) {
        this.childCount = childCount;
    }

    public DiscussionPost getParent() {
        return parent;
    }

    public void setParent(DiscussionPost parent) {
        this.parent = parent;
    }

    public List<DiscussionPost> getReplies() {
        return replies;
    }

    public void setReplies(List<DiscussionPost> replies) {
        this.replies = replies;
    }
}