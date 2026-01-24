package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.DPlanContentlib;

/**
 * 计划知识关联Service接口
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
public interface IDPlanContentlibService 
{
    /**
     * 查询计划知识关联
     * 
     * @param id 计划知识关联主键
     * @return 计划知识关联
     */
    public DPlanContentlib selectDPlanContentlibById(Long id);

    /**
     * 查询计划知识关联列表
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 计划知识关联集合
     */
    public List<DPlanContentlib> selectDPlanContentlibList(DPlanContentlib dPlanContentlib);

    /**
     * 新增计划知识关联
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 结果
     */
    public int insertDPlanContentlib(DPlanContentlib dPlanContentlib);

    /**
     * 修改计划知识关联
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 结果
     */
    public int updateDPlanContentlib(DPlanContentlib dPlanContentlib);

    /**
     * 批量删除计划知识关联
     * 
     * @param ids 需要删除的计划知识关联主键集合
     * @return 结果
     */
    public int deleteDPlanContentlibByIds(Long[] ids);

    /**
     * 删除计划知识关联信息
     * 
     * @param id 计划知识关联主键
     * @return 结果
     */
    public int deleteDPlanContentlibById(Long id);
}
