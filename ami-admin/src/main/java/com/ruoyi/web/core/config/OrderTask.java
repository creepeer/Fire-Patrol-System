package com.ruoyi.web.core.config;

import com.ruoyi.system.mapper.DPlanUserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class OrderTask {
    @Autowired
    private DPlanUserMapper dPlanUserMapper;

    @Scheduled(cron = "1 * * * * ?")
    public void planRemind(){
        log.info("开始计划信息短信发布");

    }
}
