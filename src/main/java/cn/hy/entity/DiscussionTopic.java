package cn.hy.entity;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import javax.persistence.*;
import java.time.LocalDateTime;

// DiscussionTopic.java
@Entity
@Table(name = "discussion_topic")
public class DiscussionTopic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "class_id")
    private String classId;

    @Column(name = "creator_id")
    private Long  creatorId;

    @Enumerated(EnumType.STRING)
    @Column(name = "creator_type")
    private UserType creatorType;

    private String title;
    private String content;

    @Column(name = "is_closed")
    private Boolean isClosed = false;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(columnDefinition = "INT DEFAULT 0")
    private Integer replyCount;

    // Getters & Setters


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getClassId() {
        return classId;
    }

    public void setClassId(String classId) {
        this.classId = classId;
    }

    public Long  getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Long  creatorId) {
        this.creatorId = creatorId;
    }

    public UserType getCreatorType() {
        return creatorType;
    }

    public void setCreatorType(UserType creatorType) {
        this.creatorType = creatorType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getClosed() {
        return isClosed;
    }

    public void setClosed(Boolean closed) {
        isClosed = closed;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(Integer replyCount) {
        this.replyCount = replyCount;
    }
}

