package com.ruoyi.common.Rabbitmq.config;
import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitAdmin;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;



@Configuration
public class RabbitMQConfig {

    @Bean
    public Queue basicQueue() {
        // durable=true 表示队列持久化
        return new Queue("basic.queue", true);
    }
    @Bean
    public Queue mailQueue() {
        // durable=true 表示队列持久化
        return new Queue("mail.queue", true);
    }

    @Bean
    public RabbitAdmin rabbitAdmin(ConnectionFactory connectionFactory) {
        RabbitAdmin admin = new RabbitAdmin(connectionFactory);
        admin.setAutoStartup(true);
        return admin;
    }
}