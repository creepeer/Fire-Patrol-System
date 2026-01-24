package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.GCategory;

/**
 * 类别Service接口
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
public interface IGCategoryService 
{
    /**
     * 查询类别
     * 
     * @param id 类别主键
     * @return 类别
     */
    public GCategory selectGCategoryById(Long id);

    /**
     * 查询类别列表
     * 
     * @param gCategory 类别
     * @return 类别集合
     */
    public List<GCategory> selectGCategoryList(GCategory gCategory);

    /**
     * 新增类别
     * 
     * @param gCategory 类别
     * @return 结果
     */
    public int insertGCategory(GCategory gCategory);

    /**
     * 修改类别
     * 
     * @param gCategory 类别
     * @return 结果
     */
    public int updateGCategory(GCategory gCategory);

    /**
     * 批量删除类别
     * 
     * @param ids 需要删除的类别主键集合
     * @return 结果
     */
    public int deleteGCategoryByIds(Long[] ids);

    /**
     * 删除类别信息
     * 
     * @param id 类别主键
     * @return 结果
     */
    public int deleteGCategoryById(Long id);
}
