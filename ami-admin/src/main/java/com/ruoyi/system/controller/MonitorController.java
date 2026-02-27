package com.ruoyi.system.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MonitorPosition;
import com.ruoyi.system.service.IMonitorService;

/**
 * 监控定位 Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/monitor")
public class MonitorController extends BaseController
{
    @Autowired
    private IMonitorService monitorService;

    /**
     * 获取实时位置
     */
    @GetMapping("/position")
    public AjaxResult getRealTimePosition()
    {
        MonitorPosition position = monitorService.selectRealTimePosition();
        return success(position);
    }
}
