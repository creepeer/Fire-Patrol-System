package com.ruoyi.system.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.ruoyi.system.DTO.Device.AddDeviceDTO;
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
import com.ruoyi.system.domain.CDevice;
import com.ruoyi.system.service.ICDeviceService;
import com.ruoyi.common.utils.poi.ExcelUtil;

/**
 * 设施设备Controller
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
@RestController
@RequestMapping("/system/device")
public class CDeviceController extends BaseController
{
    @Autowired
    private ICDeviceService cDeviceService;


    /**
     * 查询设施设备列表
     */
    @PreAuthorize("@ss.hasPermi('system:device:list')")
    @GetMapping("/list")
    public AjaxResult list(CDevice cDevice)
    {
        List<CDevice> list = cDeviceService.selectCDeviceList(cDevice);
        return success(list);
    }

    /**
     * 导出设施设备列表
     */
    @PreAuthorize("@ss.hasPermi('system:device:export')")
    @Log(title = "设施设备", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CDevice cDevice)
    {
        List<CDevice> list = cDeviceService.selectCDeviceList(cDevice);
        ExcelUtil<CDevice> util = new ExcelUtil<CDevice>(CDevice.class);
        util.exportExcel(response, list, "设施设备数据");
    }

    /**
     * 获取设施设备详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:device:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(cDeviceService.selectCDeviceById(id));
    }

    /**
     * 新增设施设备
     */
    @PreAuthorize("@ss.hasPermi('system:device:add')")
    @Log(title = "设施设备", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AddDeviceDTO Data)
    {
        return toAjax(cDeviceService.insertCDevice(Data));
    }

    /**
     * 修改设施设备
     */
    @PreAuthorize("@ss.hasPermi('system:device:edit')")
    @Log(title = "设施设备", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CDevice cDevice)
    {
        return toAjax(cDeviceService.updateCDevice(cDevice));
    }

    /**
     * 删除设施设备
     */
    @PreAuthorize("@ss.hasPermi('system:device:remove')")
    @Log(title = "设施设备", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(cDeviceService.deleteCDeviceByIds(ids));
    }
    /**
     * 根据区域获取设备（包括子树所有设备）
     */
    @GetMapping("/listByZoneId/{zoneId}")
    public AjaxResult listByZoneId(@PathVariable("zoneId") Long zoneId)
    {
        List<CDevice> list = cDeviceService.selectCDeviceByZoneId(zoneId);
        return success(list);
    }
    /**
     * 根据区域获取设备（仅仅包括叶子节点设备）
     */
    @GetMapping("/planByZoneId/{zoneId}")
    public AjaxResult planByZoneId(@PathVariable("zoneId") Long zoneId)
    {
        List<CDevice> list = cDeviceService.selectCDevicePlanByZoneId(zoneId);
        return success(list);
    }

}
