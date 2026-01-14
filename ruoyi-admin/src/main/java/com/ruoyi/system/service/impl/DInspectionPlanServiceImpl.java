package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DInspectionPlanMapper;
import com.ruoyi.system.domain.DInspectionPlan;
import com.ruoyi.system.service.IDInspectionPlanService;

/**
 * 检测计划管理Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
public class DInspectionPlanServiceImpl implements IDInspectionPlanService 
{
    @Autowired
    private DInspectionPlanMapper dInspectionPlanMapper;

    /**
     * 查询检测计划管理
     * 
     * @param id 检测计划管理主键
     * @return 检测计划管理
     */
    @Override
    public DInspectionPlan selectDInspectionPlanById(Long id)
    {
        return dInspectionPlanMapper.selectDInspectionPlanById(id);
    }

    /**
     * 查询检测计划管理列表
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 检测计划管理
     */
    @Override
    public List<DInspectionPlan> selectDInspectionPlanList(DInspectionPlan dInspectionPlan)
    {
        return dInspectionPlanMapper.selectDInspectionPlanList(dInspectionPlan);
    }

    /**
     * 新增检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    @Override
    public int insertDInspectionPlan(DInspectionPlan dInspectionPlan)
    {
        return dInspectionPlanMapper.insertDInspectionPlan(dInspectionPlan);
    }

    /**
     * 修改检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    @Override
    public int updateDInspectionPlan(DInspectionPlan dInspectionPlan)
    {
        return dInspectionPlanMapper.updateDInspectionPlan(dInspectionPlan);
    }

    /**
     * 批量删除检测计划管理
     * 
     * @param ids 需要删除的检测计划管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionPlanByIds(Long[] ids)
    {
        return dInspectionPlanMapper.deleteDInspectionPlanByIds(ids);
    }

    /**
     * 删除检测计划管理信息
     * 
     * @param id 检测计划管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionPlanById(Long id)
    {
        return dInspectionPlanMapper.deleteDInspectionPlanById(id);
    }
}
