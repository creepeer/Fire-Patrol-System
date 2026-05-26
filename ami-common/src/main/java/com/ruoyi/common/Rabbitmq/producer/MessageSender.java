package com.ruoyi.common.Rabbitmq.producer;

import com.ruoyi.common.utils.MailUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;
@Slf4j
@Service
public class MessageSender {
    @Autowired
    private MailUtils mailUtils;
    @Autowired
    private RabbitTemplate rabbitTemplate;

    private static final String QUEUE_NAME = "basic.queue"; // 定义队列名称 🏷️
    private static final String MAIL_QUEUE_NAME = "mail.queue"; // 新增邮件队列
    public void sendMessage(String message) {
        System.out.println(" [Producer] Sending: " + message + " to " + QUEUE_NAME + " ➡️📦");
        rabbitTemplate.convertAndSend(QUEUE_NAME, message);
        System.out.println(" [Producer] Message sent! ✅");
    }
    public void sendMailMessage(String message) {
        log.info(" [邮件生产者] 发送邮件任务: {} 到队列 {}", message, MAIL_QUEUE_NAME);
        rabbitTemplate.convertAndSend(MAIL_QUEUE_NAME, message);
        log.info(" [邮件生产者] 邮件任务发送成功! ✅");
    }
}
