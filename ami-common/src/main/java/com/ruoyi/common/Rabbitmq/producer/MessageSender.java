package com.ruoyi.common.Rabbitmq.producer;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageSender {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    private static final String QUEUE_NAME = "basic.queue"; // 定义队列名称 🏷️

    public void sendMessage(String message) {
        System.out.println(" [Producer] Sending: " + message + " to " + QUEUE_NAME + " ➡️📦");
        rabbitTemplate.convertAndSend(QUEUE_NAME, message);
        System.out.println(" [Producer] Message sent! ✅");
    }
}
