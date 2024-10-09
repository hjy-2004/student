package cn.hy.controller;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.tomcat.util.codec.binary.Base64;
import java.io.IOException;

public class Base64ToByteArrayConverter extends JsonDeserializer<byte[]> {
    @Override
    public byte[] deserialize(JsonParser jsonParser, DeserializationContext deserializationContext)
            throws IOException, JsonProcessingException {
        String base64String = jsonParser.getText();
        return Base64.decodeBase64(base64String);
    }
}
