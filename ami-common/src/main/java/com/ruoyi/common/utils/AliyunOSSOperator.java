package com.ruoyi.common.utils;

import com.aliyun.oss.*;
import com.aliyun.oss.common.auth.DefaultCredentialProvider;
import com.aliyun.oss.common.comm.SignVersion;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.ByteArrayInputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Component
@Slf4j
public class AliyunOSSOperator {

    @Value("${aliyun.oss.endpoint}")
    private String endpoint;

    @Value("${aliyun.oss.bucketName}")
    private String bucketName;

    @Value("${aliyun.oss.region}")
    private String region;
    @Value("${aliyun.oss.access-key-id}")
    private String accessKeyId;
    @Value("${aliyun.oss.access-key-secret}")
    private String accessKeySecret;


    /**
     * 创建OSS客户端（复用代码）
     */
    private OSS createOssClient() {
        DefaultCredentialProvider credentialProvider =
                new DefaultCredentialProvider(accessKeyId, accessKeySecret);

        if (accessKeyId == null || accessKeySecret == null) {
            throw new IllegalStateException(
                    "未找到阿里云AccessKey环境变量。\n" +
                            "当前设置的变量: \n" +
                            "ALIYUN_ACCESS_KEY_ID = " + (accessKeyId != null ? "已设置" : "未设置") + "\n" +
                            "ALIYUN_ACCESS_KEY_SECRET = " + (accessKeySecret != null ? "已设置" : "未设置")
            );
        }

        ClientBuilderConfiguration clientBuilderConfiguration = new ClientBuilderConfiguration();
        clientBuilderConfiguration.setSignatureVersion(SignVersion.V4);

        return OSSClientBuilder.create()
                .endpoint(endpoint)
                .credentialsProvider(credentialProvider)
                .clientConfiguration(clientBuilderConfiguration)
                .region(region)
                .build();
    }

    public String upload(byte[] content, String originalFilename) throws Exception {
        // 填写Object完整路径，例如202406/1.png。Object完整路径中不能包含Bucket名称。
        //获取当前系统日期的字符串,格式为 yyyy/MM
        String dir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM"));
        //生成一个新的不重复的文件名
        String newFileName = UUID.randomUUID() + originalFilename.substring(originalFilename.lastIndexOf("."));
        String objectName = dir + "/" + newFileName;

        OSS ossClient = createOssClient();
        try {
            ossClient.putObject(bucketName, objectName, new ByteArrayInputStream(content));
        } finally {
            ossClient.shutdown();
        }

        return endpoint.split("//")[0] + "//" + bucketName + "." + endpoint.split("//")[1] + "/" + objectName;
    }

    /**
     * 从完整URL中提取objectName
     * @param fileUrl 完整文件URL
     * @return objectName
     */
    private String extractObjectNameFromUrl(String fileUrl) {
        try {
            // 格式：https://bucket-name.endpoint/objectName
            // 例如：https://my-bucket.oss-cn-hangzhou.aliyuncs.com/2024/06/uuid.jpg

            // 获取bucket前缀URL
            String bucketPrefix = endpoint.split("//")[0] + "//" + bucketName + "." + endpoint.split("//")[1] + "/";

            // 如果URL以bucket前缀开头，直接截取后面的部分
            if (fileUrl.startsWith(bucketPrefix)) {
                return fileUrl.substring(bucketPrefix.length());
            }

            // 另一种可能的格式：直接使用endpoint的URL
            String endpointPrefix = endpoint + "/" + bucketName + "/";
            if (fileUrl.startsWith(endpointPrefix)) {
                return fileUrl.substring(endpointPrefix.length());
            }

            // 如果都不匹配，尝试从URL中提取路径部分
            // 移除协议头
            String path = fileUrl;
            if (fileUrl.contains("://")) {
                path = fileUrl.substring(fileUrl.indexOf("://") + 3);
            }

            // 移除域名部分
            int slashIndex = path.indexOf("/");
            if (slashIndex > 0) {
                path = path.substring(slashIndex + 1);
            }

            // 如果路径以bucketName开头，移除它
            if (path.startsWith(bucketName + "/")) {
                path = path.substring(bucketName.length() + 1);
            }

            log.debug("从URL {} 提取的objectName: {}", fileUrl, path);
            return path;
        } catch (Exception e) {
            log.error("从URL提取objectName失败: {}", fileUrl, e);
            return fileUrl; // 如果解析失败，返回原值
        }
    }

    /**
     * 删除单个文件
     * @param objectName 文件在OSS中的完整路径，例如 "2024/06/abc123.jpg"
     * @return 是否删除成功
     */
    public boolean delete(String objectName) {
        log.info("objectName:{}",objectName);
        if (objectName == null || objectName.trim().isEmpty()) {
            log.error("删除文件失败：objectName为空");
            return false;
        }

        OSS ossClient = null;

        try {
            ossClient = createOssClient();
            ossClient.deleteObject(bucketName, objectName);
        } catch (OSSException oe) {
            System.out.println("Caught an OSSException, which means your request made it to OSS, "
                    + "but was rejected with an error response for some reason.");
            System.out.println("Error Message:" + oe.getErrorMessage());
            System.out.println("Error Code:" + oe.getErrorCode());
            System.out.println("Request ID:" + oe.getRequestId());
            System.out.println("Host ID:" + oe.getHostId());
        } catch (ClientException ce) {
            System.out.println("Caught an ClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with OSS, "
                    + "such as not being able to access the network.");
            System.out.println("Error Message:" + ce.getMessage());
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
        return true;
    }
}