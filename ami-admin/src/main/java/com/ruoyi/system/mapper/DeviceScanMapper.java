package com.ruoyi.system.mapper;

import java.util.List;

import com.ruoyi.common.annotation.AutoFill;
import com.ruoyi.common.enums.OperationType;
import com.ruoyi.system.domain.DeviceScan;

/**
 * 设备扫描记录Mapper接口
 * 
 * @author LelandCat
 * @date 2026-01-30
 */
public interface DeviceScanMapper 
{
    /**
     * 查询设备扫描记录
     * 
     * @param id 设备扫描记录主键
     * @return 设备扫描记录
     */
    public DeviceScan selectDeviceScanById(Long id);

    /**
     * 查询设备扫描记录列表
     * 
     * @param deviceScan 设备扫描记录
     * @return 设备扫描记录集合
     */
    public List<DeviceScan> selectDeviceScanList(DeviceScan deviceScan);

    /**
     * 新增设备扫描记录
     * 
     * @param deviceScan 设备扫描记录
     * @return 结果
     */
    @AutoFill(value = OperationType.INSERT)
    public int insertDeviceScan(DeviceScan deviceScan);

    /**
     * 修改设备扫描记录
     * 
     * @param deviceScan 设备扫描记录
     * @return 结果
     */
    @AutoFill(value = OperationType.UPDATE)
    public int updateDeviceScan(DeviceScan deviceScan);

    /**
     * 删除设备扫描记录
     * 
     * @param id 设备扫描记录主键
     * @return 结果
     */
    public int deleteDeviceScanById(Long id);

    /**
     * 批量删除设备扫描记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDeviceScanByIds(Long[] ids);
}
