package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.CDevice;

/**
 * 设施设备Service接口
 * 
 * @author ruoyi
 * @date 2025-10-08
 */
public interface ICDeviceService 
{
    /**
     * 查询设施设备
     * 
     * @param id 设施设备主键
     * @return 设施设备
     */
    public CDevice selectCDeviceById(Long id);

    /**
     * 查询设施设备列表
     * 
     * @param cDevice 设施设备
     * @return 设施设备集合
     */
    public List<CDevice> selectCDeviceList(CDevice cDevice);

    /**
     * 新增设施设备
     * 
     * @param cDevice 设施设备
     * @return 结果
     */
    public int insertCDevice(CDevice cDevice);

    /**
     * 修改设施设备
     * 
     * @param cDevice 设施设备
     * @return 结果
     */
    public int updateCDevice(CDevice cDevice);

    /**
     * 批量删除设施设备
     * 
     * @param ids 需要删除的设施设备主键集合
     * @return 结果
     */
    public int deleteCDeviceByIds(Long[] ids);

    /**
     * 删除设施设备信息
     * 
     * @param id 设施设备主键
     * @return 结果
     */
    public int deleteCDeviceById(Long id);
}
