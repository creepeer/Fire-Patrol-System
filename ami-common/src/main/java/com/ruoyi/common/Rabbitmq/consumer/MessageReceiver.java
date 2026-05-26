package com.ruoyi.common.Rabbitmq.consumer;

import com.ruoyi.common.utils.MailUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
@Slf4j
public class MessageReceiver {
    @Autowired
    private MailUtils mailUtils;

    @RabbitListener(queues = "basic.queue") // 监听 "basic.queue" 队列 👂
    public void receiveMessage(String message) {
        System.out.println(" [Consumer] Received: " + message + " from " + "basic.queue" + " 📥");
        try {
            Thread.sleep(1000); // 模拟处理时间 ⏳
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println(" [Consumer] Done processing: " + message + " 👍");
    }
    @RabbitListener(queues = "mail.queue")  // 监听邮件队列
    public void receiveMailMessage(String message) {
        log.info(" [邮件消费者] 接收到邮件任务: {}", message);

        try {
            // 解析消息
            String[] parts = message.split(",", 3);
            if (parts.length == 3) {
                String email = parts[0];
                String subject = parts[1];
                String content = parts[2];
                Set<String>setEmail=new HashSet<>();
                setEmail.add(email);
                log.info(" [邮件消费者] 准备发送邮件到: {}, 主题: {}", email, subject);

                // 真正发送邮件
                mailUtils.sendEmail(setEmail, subject, content);

                log.info(" [邮件消费者] 邮件发送成功! ✅");
            } else {
                log.error(" [邮件消费者] 消息格式错误: {}", message);
            }
        } catch (Exception e) {
            log.error(" [邮件消费者] 邮件发送失败: {}", e.getMessage());
            // 可以抛出异常让消息重新入队
            throw new RuntimeException("邮件发送失败", e);
        }
    }
}