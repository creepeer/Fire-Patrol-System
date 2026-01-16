package com.ruoyi.system.mapper;

import java.util.List;

import com.ruoyi.common.annotation.AutoFill;
import com.ruoyi.common.enums.OperationType;
import com.ruoyi.system.domain.DPlanUser;

/**
 * 计划用户关联Mapper接口
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
public interface DPlanUserMapper 
{
    /**
     * 查询计划用户关联
     * 
     * @param id 计划用户关联主键
     * @return 计划用户关联
     */
    public DPlanUser selectDPlanUserById(Long id);

    /**
     * 查询计划用户关联列表
     * 
     * @param dPlanUser 计划用户关联
     * @return 计划用户关联集合
     */
    public List<DPlanUser> selectDPlanUserList(DPlanUser dPlanUser);

    /**
     * 新增计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @AutoFill(value = OperationType.INSERT)
    public int insertDPlanUser(DPlanUser dPlanUser);

    /**
     * 修改计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @AutoFill(value = OperationType.UPDATE)
    public int updateDPlanUser(DPlanUser dPlanUser);

    /**
     * 删除计划用户关联
     * 
     * @param id 计划用户关联主键
     * @return 结果
     */
    public int deleteDPlanUserById(Long id);

    /**
     * 批量删除计划用户关联
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDPlanUserByIds(Long[] ids);
}
