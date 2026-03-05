package com.ruoyi.common.Rabbitmq.consumer;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class MessageReceiver {

//    @RabbitListener(queues = "basic.queue") // 监听 "basic.queue" 队列 👂
    public void receiveMessage(String message) {
        System.out.println(" [Consumer] Received: " + message + " from " + "basic.queue" + " 📥");
        try {
            Thread.sleep(1000); // 模拟处理时间 ⏳
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println(" [Consumer] Done processing: " + message + " 👍");
    }
}