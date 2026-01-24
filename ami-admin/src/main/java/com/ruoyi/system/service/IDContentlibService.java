package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.DContentlib;

/**
 * 知识库Service接口
 * 
 * @author ruoyi
 * @date 2025-12-30
 */
public interface IDContentlibService 
{
    /**
     * 查询知识库
     * 
     * @param id 知识库主键
     * @return 知识库
     */
    public DContentlib selectDContentlibById(Long id);

    /**
     * 查询知识库列表
     * 
     * @param dContentlib 知识库
     * @return 知识库集合
     */
    public List<DContentlib> selectDContentlibList(DContentlib dContentlib);

    /**
     * 新增知识库
     * 
     * @param dContentlib 知识库
     * @return 结果
     */
    public int insertDContentlib(DContentlib dContentlib);

    /**
     * 修改知识库
     * 
     * @param dContentlib 知识库
     * @return 结果
     */
    public int updateDContentlib(DContentlib dContentlib);

    /**
     * 批量删除知识库
     * 
     * @param ids 需要删除的知识库主键集合
     * @return 结果
     */
    public int deleteDContentlibByIds(Long[] ids);

    /**
     * 删除知识库信息
     * 
     * @param id 知识库主键
     * @return 结果
     */
    public int deleteDContentlibById(Long id);
}
