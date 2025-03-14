package cn.hy.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import java.util.Arrays;

public enum UserType {
    TEACHER("TEACHER"),  // 统一使用大写
    STUDENT("STUDENT");


    private final String value;

    UserType(String value) {
        this.value = value;
    }

    // 序列化使用该值（必须添加）
    @JsonValue
    public String getValue() {
        return value;
    }

    // 反序列化方法增强
    @JsonCreator
    public static UserType fromString(String value) {
        System.out.println("Received userType: " + value); // 打印实际接收值
        return valueOf(value.toUpperCase());
    }
}