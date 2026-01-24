package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.Area;

/**
 * 地区Service接口
 * 
 * @author Leland_Cat
 * @date 2025-09-24
 */
public interface IAreaService 
{
    /**
     * 查询地区
     * 
     * @param id 地区主键
     * @return 地区
     */
    public Area selectAreaById(Long id);

    /**
     * 查询地区列表
     * 
     * @param area 地区
     * @return 地区集合
     */
    public List<Area> selectAreaList(Area area);

    /**
     * 新增地区
     * 
     * @param area 地区
     * @return 结果
     */
    public int insertArea(Area area);

    /**
     * 修改地区
     * 
     * @param area 地区
     * @return 结果
     */
    public int updateArea(Area area);

    /**
     * 批量删除地区
     * 
     * @param ids 需要删除的地区主键集合
     * @return 结果
     */
    public int deleteAreaByIds(Long[] ids);

    /**
     * 删除地区信息
     * 
     * @param id 地区主键
     * @return 结果
     */
    public int deleteAreaById(Long id);
}
