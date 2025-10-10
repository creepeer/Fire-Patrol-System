package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.DTO.Building.AddBuildingDTO;
import com.ruoyi.system.DTO.Project.AddProjectDTO;
import com.ruoyi.system.domain.GZone;

/**
 * 区域管理Service接口
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
public interface IGZoneService 
{
    /**
     * 查询区域管理
     * 
     * @param id 区域管理主键
     * @return 区域管理
     */
    public GZone selectGZoneById(Long id);

    /**
     * 查询区域管理列表
     * 
     * @param gZone 区域管理
     * @return 区域管理集合
     */
    public List<GZone> selectGZoneList(GZone gZone);

    /**
     * 新增区域管理
     * 
     * @param gZone 区域管理
     * @return 结果
     */
    public int insertGZone(GZone gZone);

    /**
     * 修改区域管理
     * 
     * @param gZone 区域管理
     * @return 结果
     */
    public int updateGZone(GZone gZone);

    /**
     * 批量删除区域管理
     * 
     * @param ids 需要删除的区域管理主键集合
     * @return 结果
     */
    public int deleteGZoneByIds(Long[] ids);

    /**
     * 删除区域管理信息
     * 
     * @param id 区域管理主键
     * @return 结果
     */
    public int deleteGZoneById(Long id);

    public int insertGZoneProject(AddProjectDTO data);
    public Long insertGZoneBuilding(AddBuildingDTO data);

    Long selectIdByZnameAndPid(String projectName, Long pid);

}
