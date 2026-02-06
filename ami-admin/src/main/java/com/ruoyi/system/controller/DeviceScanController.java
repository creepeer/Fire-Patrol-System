package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.web.controller.common.CommonController;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.DeviceScan;
import com.ruoyi.system.service.IDeviceScanService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 设备扫描记录Controller
 * 
 * @author LelandCat
 * @date 2026-01-30
 */
@RestController
@RequestMapping("/system/scan")
public class DeviceScanController extends BaseController
{
    @Autowired
    private IDeviceScanService deviceScanService;


    /**
     * 查询设备扫描记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:scan:list')")
    @GetMapping("/list")
    public TableDataInfo list(DeviceScan deviceScan)
    {
        startPage();
        List<DeviceScan> list = deviceScanService.selectDeviceScanList(deviceScan);
        return getDataTable(list);
    }

    /**
     * 导出设备扫描记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:scan:export')")
    @Log(title = "设备扫描记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DeviceScan deviceScan)
    {
        List<DeviceScan> list = deviceScanService.selectDeviceScanList(deviceScan);
        ExcelUtil<DeviceScan> util = new ExcelUtil<DeviceScan>(DeviceScan.class);
        util.exportExcel(response, list, "设备扫描记录数据");
    }

    /**
     * 获取设备扫描记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:scan:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(deviceScanService.selectDeviceScanById(id));
    }

    /**
     * 新增设备扫描记录
     */
    @PreAuthorize("@ss.hasPermi('system:scan:add')")
    @Log(title = "设备扫描记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DeviceScan deviceScan)
    {
        return toAjax(deviceScanService.insertDeviceScan(deviceScan));
    }

    /**
     * 修改设备扫描记录
     */
    @PreAuthorize("@ss.hasPermi('system:scan:edit')")
    @Log(title = "设备扫描记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DeviceScan deviceScan)
    {
        return toAjax(deviceScanService.updateDeviceScan(deviceScan));
    }

    /**
     * 删除设备扫描记录
     */
    @PreAuthorize("@ss.hasPermi('system:scan:remove')")
    @Log(title = "设备扫描记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(deviceScanService.deleteDeviceScanByIds(ids));
    }
}
