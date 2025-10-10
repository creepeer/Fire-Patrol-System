package com.ruoyi.system.service.impl;

import java.util.List;

import com.ruoyi.system.DTO.Building.AddBuildingDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GBuildingMapper;
import com.ruoyi.system.domain.GBuilding;
import com.ruoyi.system.service.IGBuildingService;

/**
 * 一级区域Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-05
 */
@Service
public class GBuildingServiceImpl implements IGBuildingService 
{
    @Autowired
    private GBuildingMapper gBuildingMapper;

    /**
     * 查询一级区域
     * 
     * @param pid 一级区域主键
     * @return 一级区域
     */
    @Override
    public GBuilding selectGBuildingByPid(Long pid)
    {
        return gBuildingMapper.selectGBuildingByPid(pid);
    }

    /**
     * 查询一级区域列表
     * 
     * @param gBuilding 一级区域
     * @return 一级区域
     */
    @Override
    public List<GBuilding> selectGBuildingList(GBuilding gBuilding)
    {
        return gBuildingMapper.selectGBuildingList(gBuilding);
    }

    /**
     * 新增一级区域
     * 
     * @param Data 一级区域
     * @return 结果
     */
    @Override
    public int insertGBuilding(AddBuildingDTO Data,Long pid)
    {
        GBuilding gBuilding=new GBuilding();
        gBuilding.setPid(pid);
        gBuilding.setBuildingType(Data.getBuildingType());
        gBuilding.setAddress(Data.getAddress());
        gBuilding.setArea(Data.getBuildingArea());
        gBuilding.setFloors(Data.getFloorCount().toString());
        gBuilding.setHeight(Data.getBuildingHeight());
        gBuilding.setUsageType(Data.getUsageType());
        return gBuildingMapper.insertGBuilding(gBuilding);
    }

    /**
     * 修改一级区域
     * 
     * @param gBuilding 一级区域
     * @return 结果
     */
    @Override
    public int updateGBuilding(GBuilding gBuilding)
    {
        return gBuildingMapper.updateGBuilding(gBuilding);
    }

    /**
     * 批量删除一级区域
     * 
     * @param pids 需要删除的一级区域主键
     * @return 结果
     */
    @Override
    public int deleteGBuildingByPids(Long[] pids)
    {
        return gBuildingMapper.deleteGBuildingByPids(pids);
    }

    /**
     * 删除一级区域信息
     * 
     * @param pid 一级区域主键
     * @return 结果
     */
    @Override
    public int deleteGBuildingByPid(Long pid)
    {
        return gBuildingMapper.deleteGBuildingByPid(pid);
    }
}
