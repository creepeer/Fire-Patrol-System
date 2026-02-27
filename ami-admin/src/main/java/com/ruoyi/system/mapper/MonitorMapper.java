package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.MonitorPosition;

/**
 * 监控 Mapper 接口
 * 
 * @author ruoyi
 */
public interface MonitorMapper 
{
    /**
     * 查询实时位置
     * 
     * @return 监控位置
     */
    public MonitorPosition selectMonitorPosition();
}
