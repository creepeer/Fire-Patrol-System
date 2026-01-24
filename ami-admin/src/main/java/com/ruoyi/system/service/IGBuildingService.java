package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.DTO.Building.AddBuildingDTO;
import com.ruoyi.system.domain.GBuilding;

/**
 * 一级区域Service接口
 * 
 * @author ruoyi
 * @date 2025-10-05
 */
public interface IGBuildingService 
{
    /**
     * 查询一级区域
     * 
     * @param pid 一级区域主键
     * @return 一级区域
     */
    public GBuilding selectGBuildingByPid(Long pid);

    /**
     * 查询一级区域列表
     * 
     * @param gBuilding 一级区域
     * @return 一级区域集合
     */
    public List<GBuilding> selectGBuildingList(GBuilding gBuilding);

    /**
     * 新增一级区域
     * 
     * @param gBuilding 一级区域
     * @return 结果
     */
    public int insertGBuilding(AddBuildingDTO Date, Long id);

    /**
     * 修改一级区域
     * 
     * @param gBuilding 一级区域
     * @return 结果
     */
    public int updateGBuilding(GBuilding gBuilding);

    /**
     * 批量删除一级区域
     * 
     * @param pids 需要删除的一级区域主键集合
     * @return 结果
     */
    public int deleteGBuildingByPids(Long[] pids);

    /**
     * 删除一级区域信息
     * 
     * @param pid 一级区域主键
     * @return 结果
     */
    public int deleteGBuildingByPid(Long pid);
}
