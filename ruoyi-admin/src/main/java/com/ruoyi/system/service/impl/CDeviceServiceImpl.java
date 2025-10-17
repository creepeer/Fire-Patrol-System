package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CDeviceMapper;
import com.ruoyi.system.domain.CDevice;
import com.ruoyi.system.service.ICDeviceService;

/**
 * 设施设备Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
@Service
public class CDeviceServiceImpl implements ICDeviceService 
{
    @Autowired
    private CDeviceMapper cDeviceMapper;

    /**
     * 查询设施设备
     * 
     * @param id 设施设备主键
     * @return 设施设备
     */
    @Override
    public CDevice selectCDeviceById(Long id)
    {
        return cDeviceMapper.selectCDeviceById(id);
    }


    /**
     * 根据区域ID查询设备列表
     */
    @Override
    public List<CDevice> selectCDeviceByZoneId(Long zoneId) {
        return cDeviceMapper.selectCDeviceByZoneId(zoneId);
    }

    /**
     * 查询设施设备列表
     * 
     * @param cDevice 设施设备
     * @return 设施设备
     */
    @Override
    public List<CDevice> selectCDeviceList(CDevice cDevice)
    {
        return cDeviceMapper.selectCDeviceList(cDevice);
    }

    /**
     * 新增设施设备
     * 
     * @param cDevice 设施设备
     * @return 结果
     */
    @Override
    public int insertCDevice(CDevice cDevice)
    {
        return cDeviceMapper.insertCDevice(cDevice);
    }

    /**
     * 修改设施设备
     * 
     * @param cDevice 设施设备
     * @return 结果
     */
    @Override
    public int updateCDevice(CDevice cDevice)
    {
        return cDeviceMapper.updateCDevice(cDevice);
    }

    /**
     * 批量删除设施设备
     * 
     * @param ids 需要删除的设施设备主键
     * @return 结果
     */
    @Override
    public int deleteCDeviceByIds(Long[] ids)
    {
        return cDeviceMapper.deleteCDeviceByIds(ids);
    }

    /**
     * 删除设施设备信息
     * 
     * @param id 设施设备主键
     * @return 结果
     */
    @Override
    public int deleteCDeviceById(Long id)
    {
        return cDeviceMapper.deleteCDeviceById(id);
    }
}
