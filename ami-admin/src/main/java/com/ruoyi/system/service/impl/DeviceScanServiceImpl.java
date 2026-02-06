package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DeviceScanMapper;
import com.ruoyi.system.domain.DeviceScan;
import com.ruoyi.system.service.IDeviceScanService;

/**
 * 设备扫描记录Service业务层处理
 * 
 * @author LelandCat
 * @date 2026-01-30
 */
@Service
public class DeviceScanServiceImpl implements IDeviceScanService 
{
    @Autowired
    private DeviceScanMapper deviceScanMapper;

    /**
     * 查询设备扫描记录
     * 
     * @param id 设备扫描记录主键
     * @return 设备扫描记录
     */
    @Override
    public DeviceScan selectDeviceScanById(Long id)
    {
        return deviceScanMapper.selectDeviceScanById(id);
    }

    /**
     * 查询设备扫描记录列表
     * 
     * @param deviceScan 设备扫描记录
     * @return 设备扫描记录
     */
    @Override
    public List<DeviceScan> selectDeviceScanList(DeviceScan deviceScan)
    {
        return deviceScanMapper.selectDeviceScanList(deviceScan);
    }

    /**
     * 新增设备扫描记录
     * 
     * @param deviceScan 设备扫描记录
     * @return 结果
     */
    @Override
    public int insertDeviceScan(DeviceScan deviceScan)
    {
        return deviceScanMapper.insertDeviceScan(deviceScan);
    }

    /**
     * 修改设备扫描记录
     * 
     * @param deviceScan 设备扫描记录
     * @return 结果
     */
    @Override
    public int updateDeviceScan(DeviceScan deviceScan)
    {
        return deviceScanMapper.updateDeviceScan(deviceScan);
    }

    /**
     * 批量删除设备扫描记录
     * 
     * @param ids 需要删除的设备扫描记录主键
     * @return 结果
     */
    @Override
    public int deleteDeviceScanByIds(Long[] ids)
    {
        return deviceScanMapper.deleteDeviceScanByIds(ids);
    }

    /**
     * 删除设备扫描记录信息
     * 
     * @param id 设备扫描记录主键
     * @return 结果
     */
    @Override
    public int deleteDeviceScanById(Long id)
    {
        return deviceScanMapper.deleteDeviceScanById(id);
    }
}
