package com.ruoyi.system.service;

import com.ruoyi.system.domain.MonitorPosition;

/**
 * 监控服务接口
 * 
 * @author ruoyi
 */
public interface IMonitorService 
{
    /**
     * 获取实时位置
     * 
     * @return 监控位置
     */
    public MonitorPosition selectRealTimePosition();
}
