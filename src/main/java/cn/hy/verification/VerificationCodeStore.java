package cn.hy.verification;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class VerificationCodeStore {
    private static final Map<String, VerificationInfo> codeStore = new ConcurrentHashMap<>();

    public static void storeCode(String email, String code) {
        codeStore.put(email, new VerificationInfo(code));
    }

    public static boolean verifyCode(String email, String code) {
        VerificationInfo info = codeStore.get(email);
        if (info != null && info.getCode().equals(code) && info.isValid()) {
            codeStore.remove(email);
            return true;
        }
        return false;
    }

    private static class VerificationInfo {
        private final String code;
        private final LocalDateTime creationTime;
        private static final int EXPIRATION_MINUTES = 5; // 验证码有效期设置为5分钟

        public VerificationInfo(String code) {
            this.code = code;
            this.creationTime = LocalDateTime.now();
        }

        public String getCode() {
            return code;
        }

        public boolean isValid() {
            return LocalDateTime.now().isBefore(creationTime.plusMinutes(EXPIRATION_MINUTES));
        }
    }
}
