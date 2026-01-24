package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DPlanContentlibMapper;
import com.ruoyi.system.domain.DPlanContentlib;
import com.ruoyi.system.service.IDPlanContentlibService;

/**
 * 计划知识关联Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
public class DPlanContentlibServiceImpl implements IDPlanContentlibService 
{
    @Autowired
    private DPlanContentlibMapper dPlanContentlibMapper;

    /**
     * 查询计划知识关联
     * 
     * @param id 计划知识关联主键
     * @return 计划知识关联
     */
    @Override
    public DPlanContentlib selectDPlanContentlibById(Long id)
    {
        return dPlanContentlibMapper.selectDPlanContentlibById(id);
    }

    /**
     * 查询计划知识关联列表
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 计划知识关联
     */
    @Override
    public List<DPlanContentlib> selectDPlanContentlibList(DPlanContentlib dPlanContentlib)
    {
        return dPlanContentlibMapper.selectDPlanContentlibList(dPlanContentlib);
    }

    /**
     * 新增计划知识关联
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 结果
     */
    @Override
    public int insertDPlanContentlib(DPlanContentlib dPlanContentlib)
    {
        return dPlanContentlibMapper.insertDPlanContentlib(dPlanContentlib);
    }

    /**
     * 修改计划知识关联
     * 
     * @param dPlanContentlib 计划知识关联
     * @return 结果
     */
    @Override
    public int updateDPlanContentlib(DPlanContentlib dPlanContentlib)
    {
        return dPlanContentlibMapper.updateDPlanContentlib(dPlanContentlib);
    }

    /**
     * 批量删除计划知识关联
     * 
     * @param ids 需要删除的计划知识关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanContentlibByIds(Long[] ids)
    {
        return dPlanContentlibMapper.deleteDPlanContentlibByIds(ids);
    }

    /**
     * 删除计划知识关联信息
     * 
     * @param id 计划知识关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanContentlibById(Long id)
    {
        return dPlanContentlibMapper.deleteDPlanContentlibById(id);
    }
}
