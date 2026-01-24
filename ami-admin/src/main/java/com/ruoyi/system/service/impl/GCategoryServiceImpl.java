package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GCategoryMapper;
import com.ruoyi.system.domain.GCategory;
import com.ruoyi.system.service.IGCategoryService;

/**
 * 类别Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
@Service
public class GCategoryServiceImpl implements IGCategoryService 
{
    @Autowired
    private GCategoryMapper gCategoryMapper;

    /**
     * 查询类别
     * 
     * @param id 类别主键
     * @return 类别
     */
    @Override
    public GCategory selectGCategoryById(Long id)
    {
        return gCategoryMapper.selectGCategoryById(id);
    }

    /**
     * 查询类别列表
     * 
     * @param gCategory 类别
     * @return 类别
     */
    @Override
    public List<GCategory> selectGCategoryList(GCategory gCategory)
    {
        return gCategoryMapper.selectGCategoryList(gCategory);
    }

    /**
     * 新增类别
     * 
     * @param gCategory 类别
     * @return 结果
     */
    @Override
    public int insertGCategory(GCategory gCategory)
    {
        return gCategoryMapper.insertGCategory(gCategory);
    }

    /**
     * 修改类别
     * 
     * @param gCategory 类别
     * @return 结果
     */
    @Override
    public int updateGCategory(GCategory gCategory)
    {
        return gCategoryMapper.updateGCategory(gCategory);
    }

    /**
     * 批量删除类别
     * 
     * @param ids 需要删除的类别主键
     * @return 结果
     */
    @Override
    public int deleteGCategoryByIds(Long[] ids)
    {
        return gCategoryMapper.deleteGCategoryByIds(ids);
    }

    /**
     * 删除类别信息
     * 
     * @param id 类别主键
     * @return 结果
     */
    @Override
    public int deleteGCategoryById(Long id)
    {
        return gCategoryMapper.deleteGCategoryById(id);
    }
}
