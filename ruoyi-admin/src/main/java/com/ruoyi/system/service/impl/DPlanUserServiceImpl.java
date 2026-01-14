package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DPlanUserMapper;
import com.ruoyi.system.domain.DPlanUser;
import com.ruoyi.system.service.IDPlanUserService;

/**
 * 计划用户关联Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
public class DPlanUserServiceImpl implements IDPlanUserService 
{
    @Autowired
    private DPlanUserMapper dPlanUserMapper;

    /**
     * 查询计划用户关联
     * 
     * @param id 计划用户关联主键
     * @return 计划用户关联
     */
    @Override
    public DPlanUser selectDPlanUserById(Long id)
    {
        return dPlanUserMapper.selectDPlanUserById(id);
    }

    /**
     * 查询计划用户关联列表
     * 
     * @param dPlanUser 计划用户关联
     * @return 计划用户关联
     */
    @Override
    public List<DPlanUser> selectDPlanUserList(DPlanUser dPlanUser)
    {
        return dPlanUserMapper.selectDPlanUserList(dPlanUser);
    }

    /**
     * 新增计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @Override
    public int insertDPlanUser(DPlanUser dPlanUser)
    {
        return dPlanUserMapper.insertDPlanUser(dPlanUser);
    }

    /**
     * 修改计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @Override
    public int updateDPlanUser(DPlanUser dPlanUser)
    {
        return dPlanUserMapper.updateDPlanUser(dPlanUser);
    }

    /**
     * 批量删除计划用户关联
     * 
     * @param ids 需要删除的计划用户关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanUserByIds(Long[] ids)
    {
        return dPlanUserMapper.deleteDPlanUserByIds(ids);
    }

    /**
     * 删除计划用户关联信息
     * 
     * @param id 计划用户关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanUserById(Long id)
    {
        return dPlanUserMapper.deleteDPlanUserById(id);
    }
}
