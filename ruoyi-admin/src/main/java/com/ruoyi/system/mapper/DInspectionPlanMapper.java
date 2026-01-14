package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.DInspectionPlan;

/**
 * 检测计划管理Mapper接口
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
public interface DInspectionPlanMapper 
{
    /**
     * 查询检测计划管理
     * 
     * @param id 检测计划管理主键
     * @return 检测计划管理
     */
    public DInspectionPlan selectDInspectionPlanById(Long id);

    /**
     * 查询检测计划管理列表
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 检测计划管理集合
     */
    public List<DInspectionPlan> selectDInspectionPlanList(DInspectionPlan dInspectionPlan);

    /**
     * 新增检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    public int insertDInspectionPlan(DInspectionPlan dInspectionPlan);

    /**
     * 修改检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    public int updateDInspectionPlan(DInspectionPlan dInspectionPlan);

    /**
     * 删除检测计划管理
     * 
     * @param id 检测计划管理主键
     * @return 结果
     */
    public int deleteDInspectionPlanById(Long id);

    /**
     * 批量删除检测计划管理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDInspectionPlanByIds(Long[] ids);
}
