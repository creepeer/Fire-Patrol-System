package com.ruoyi.system.service.impl;

import java.util.List;

import com.ruoyi.system.DTO.Device.AddDeviceDTO;
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
     * 根据区域ID查询检测设备列表
     */
    @Override
    public List<CDevice> selectCDevicePlanByZoneId(Long zoneId) {
        return cDeviceMapper.selectCDevicePlanByZoneId(zoneId);
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
     * @param Data 设施设备
     * @return 结果
     */
    @Override
    public int insertCDevice(AddDeviceDTO Data)
    {
        System.out.println(Data);
        CDevice device=new CDevice();
        device.setName(Data.getName());
        device.setCategoryId(Data.getCategoryId());
        device.setProjectId(Data.getProjectId());
        device.setZoneId1(Data.getZoneId1());
        device.setZoneId2(Data.getZoneId2());
        device.setZoneId3(Data.getZoneId3());
        device.setLocation(Data.getLocation());
        device.setRelatedLocation(Data.getRelatedLocation());
        device.setBrand(Data.getBrand());
        device.setModel(Data.getModel());
        device.setIsHost(Data.getIsHost());
        device.setIsBus(Data.getIsBus());
        device.setParentDeviceId(Data.getParentDeviceId());
        device.setStartDate(Data.getStartDate());
        device.setProductionDate(Data.getProductionDate());
        device.setWarrantyStart(Data.getWarrantyStart());
        device.setServiceLife(Data.getServiceLife());
        device.setDeviceStatus(Data.getDeviceStatus());
        device.setBindStatus(Data.getBindStatus());
        device.setQrCode(Data.getQrCode());
        device.setQrUrl(Data.getQrUrl());
        device.setDiagram2d(Data.getDiagram2d());
        device.setLat(Data.getLat());
        device.setLng(Data.getLng());
        device.setRemark(Data.getRemark());

        int result = cDeviceMapper.insertCDevice(device);

        // 3. 如果插入成功且是主机设备且有子设备，更新子设备的父设备ID
        if (result > 0 && Data.getIsHost() == 1 &&
                Data.getChildDeviceIds() != null && !Data.getChildDeviceIds().isEmpty()) {
            associateChildDevices(device.getId(), Data.getChildDeviceIds());
        }
       return result;
    }
    private void associateChildDevices(Long hostId, List<Long> childIds) {
        for (Long childId : childIds) {
            CDevice child = cDeviceMapper.selectCDeviceById(childId);
            if (child != null && child.getIsHost() != 1) {
                child.setParentDeviceId(hostId);
                cDeviceMapper.updateCDevice(child);
            }
        }
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
