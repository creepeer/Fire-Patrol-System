package com.ruoyi.common.Rabbitmq.service;

import com.ruoyi.common.Rabbitmq.producer.MessageSender;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MailMQService {

    @Autowired
    private MessageSender messageSender;


    // 专门用于邮件发送的队列
    private static final String MAIL_QUEUE = "mail.queue";

    /**
     * 异步发送邮件（通过MQ）
     * @param email 收件人邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     */
    public void sendMailAsync(String email, String subject, String content) {
        // 将邮件信息拼接成字符串，格式: email,subject,content
        // 注意：如果内容中包含逗号，需要进行转义或使用其他分隔符
        String message = email + "," + subject + "," + content;
        messageSender.sendMailMessage(message);
        log.info("邮件任务已加入MQ队列: {}", email);
    }
}
