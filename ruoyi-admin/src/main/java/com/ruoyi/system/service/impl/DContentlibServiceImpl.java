package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DContentlibMapper;
import com.ruoyi.system.domain.DContentlib;
import com.ruoyi.system.service.IDContentlibService;

/**
 * 知识库Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-30
 */
@Service
public class DContentlibServiceImpl implements IDContentlibService 
{
    @Autowired
    private DContentlibMapper dContentlibMapper;

    /**
     * 查询知识库
     * 
     * @param id 知识库主键
     * @return 知识库
     */
    @Override
    public DContentlib selectDContentlibById(Long id)
    {
        return dContentlibMapper.selectDContentlibById(id);
    }

    /**
     * 查询知识库列表
     * 
     * @param dContentlib 知识库
     * @return 知识库
     */
    @Override
    public List<DContentlib> selectDContentlibList(DContentlib dContentlib)
    {
        return dContentlibMapper.selectDContentlibList(dContentlib);
    }

    /**
     * 新增知识库
     * 
     * @param dContentlib 知识库
     * @return 结果
     */
    @Override
    public int insertDContentlib(DContentlib dContentlib)
    {
        return dContentlibMapper.insertDContentlib(dContentlib);
    }

    /**
     * 修改知识库
     * 
     * @param dContentlib 知识库
     * @return 结果
     */
    @Override
    public int updateDContentlib(DContentlib dContentlib)
    {
        return dContentlibMapper.updateDContentlib(dContentlib);
    }

    /**
     * 批量删除知识库
     * 
     * @param ids 需要删除的知识库主键
     * @return 结果
     */
    @Override
    public int deleteDContentlibByIds(Long[] ids)
    {
        return dContentlibMapper.deleteDContentlibByIds(ids);
    }

    /**
     * 删除知识库信息
     * 
     * @param id 知识库主键
     * @return 结果
     */
    @Override
    public int deleteDContentlibById(Long id)
    {
        return dContentlibMapper.deleteDContentlibById(id);
    }
}
