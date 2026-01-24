package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.GBuilding;

/**
 * 一级区域Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-05
 */
public interface GBuildingMapper 
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
    public int insertGBuilding(GBuilding gBuilding);

    /**
     * 修改一级区域
     * 
     * @param gBuilding 一级区域
     * @return 结果
     */
    public int updateGBuilding(GBuilding gBuilding);

    /**
     * 删除一级区域
     * 
     * @param pid 一级区域主键
     * @return 结果
     */
    public int deleteGBuildingByPid(Long pid);

    /**
     * 批量删除一级区域
     * 
     * @param pids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGBuildingByPids(Long[] pids);
}
