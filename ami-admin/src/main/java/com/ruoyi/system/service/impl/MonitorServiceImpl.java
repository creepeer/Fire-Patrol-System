package com.ruoyi.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.MonitorPosition;
import com.ruoyi.system.mapper.MonitorMapper;
import com.ruoyi.system.service.IMonitorService;

/**
 * 监控服务实现
 * 
 * @author ruoyi
 */
@Service
public class MonitorServiceImpl implements IMonitorService 
{
    @Autowired
    private MonitorMapper monitorMapper;

    /**
     * 获取实时位置
     * 
     * @return 监控位置
     */
    @Override
    public MonitorPosition selectRealTimePosition()
    {

        MonitorPosition position = new MonitorPosition();

        double baseLat = 27.56407;
        double baseLng = 120.56809;
        
        // 随机偏移
        double offsetLat = (Math.random() - 0.5) * 0.001;
        double offsetLng = (Math.random() - 0.5) * 0.001;
        
        position.setX(baseLat + offsetLat);
        position.setX(baseLng + offsetLng);
        position.setY(baseLat + offsetLat);
        
        return position;
    }
}
