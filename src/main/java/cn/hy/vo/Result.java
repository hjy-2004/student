// Result.java
package cn.hy.vo;

import lombok.Data;

@Data
public class Result<T> {
    private Integer code;
    private String message;
    private T data;

    // 手动实现构建器
    public static <T> ResultBuilder<T> builder() {
        return new ResultBuilder<>();
    }

    public static class ResultBuilder<T> {
        private Integer code;
        private String message;
        private T data;

        public ResultBuilder<T> code(Integer code) {
            this.code = code;
            return this;
        }

        public ResultBuilder<T> message(String message) {
            this.message = message;
            return this;
        }

        public ResultBuilder<T> data(T data) {
            this.data = data;
            return this;
        }

        public Result<T> build() {
            Result<T> result = new Result<>();
            result.setCode(code);
            result.setMessage(message);
            result.setData(data);
            return result;
        }
    }

    // 无参成功方法
    public static <T> Result<T> success() {
        return Result.<T>builder()
                .code(200)
                .message("success")
                .data(null)
                .build();
    }

    // 带数据成功方法
    public static <T> Result<T> success(T data) {
        return Result.<T>builder()
                .code(200)
                .message("success")
                .data(data)
                .build();
    }

    // 错误方法
    public static <T> Result<T> error(Integer code, String message) {
        return Result.<T>builder()
                .code(code)
                .message(message)
                .build();
    }
}