package com.ruoyi.system.service;

import java.util.List;

import com.ruoyi.system.DTO.Inspection.InspectionPlanDTO;
import com.ruoyi.system.domain.DInspectionPlan;

/**
 * 检测计划管理Service接口
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
public interface IDInspectionPlanService 
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
     * @param dto 检测计划管理
     * @return 结果
     */
    public int insertDInspectionPlan(InspectionPlanDTO dto);

    /**
     * 修改检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    public int updateDInspectionPlan(DInspectionPlan dInspectionPlan);

    /**
     * 批量删除检测计划管理
     * 
     * @param ids 需要删除的检测计划管理主键集合
     * @return 结果
     */
    public int deleteDInspectionPlanByIds(Long[] ids);

    /**
     * 删除检测计划管理信息
     * 
     * @param id 检测计划管理主键
     * @return 结果
     */
    public int deleteDInspectionPlanById(Long id);

    /**
     * 列表查询巡检计划（只包含基本信息）
     */
    List<InspectionPlanDTO> selectPlanList(DInspectionPlan dto);

    /**
     * 详情查询巡检计划（包含区域、人员、文档）
     */
    InspectionPlanDTO selectPlanDetail(Long id);
}
