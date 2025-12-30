package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DContentlibNodeMapper;
import com.ruoyi.system.domain.DContentlibNode;
import com.ruoyi.system.service.IDContentlibNodeService;

/**
 * 知识库节点Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-12-29
 */
@Service
public class DContentlibNodeServiceImpl implements IDContentlibNodeService 
{
    @Autowired
    private DContentlibNodeMapper dContentlibNodeMapper;

    /**
     * 查询知识库节点
     * 
     * @param id 知识库节点主键
     * @return 知识库节点
     */
    @Override
    public DContentlibNode selectDContentlibNodeById(Long id)
    {
        return dContentlibNodeMapper.selectDContentlibNodeById(id);
    }

    /**
     * 查询知识库节点列表
     * 
     * @param dContentlibNode 知识库节点
     * @return 知识库节点
     */
    @Override
    public List<DContentlibNode> selectDContentlibNodeList(DContentlibNode dContentlibNode)
    {
        return dContentlibNodeMapper.selectDContentlibNodeList(dContentlibNode);
    }

    /**
     * 新增知识库节点
     * 
     * @param dContentlibNode 知识库节点
     * @return 结果
     */
    @Override
    public int insertDContentlibNode(DContentlibNode dContentlibNode)
    {
        return dContentlibNodeMapper.insertDContentlibNode(dContentlibNode);
    }

    /**
     * 修改知识库节点
     * 
     * @param dContentlibNode 知识库节点
     * @return 结果
     */
    @Override
    public int updateDContentlibNode(DContentlibNode dContentlibNode)
    {
        return dContentlibNodeMapper.updateDContentlibNode(dContentlibNode);
    }

    /**
     * 批量删除知识库节点
     * 
     * @param ids 需要删除的知识库节点主键
     * @return 结果
     */
    @Override
    public int deleteDContentlibNodeByIds(Long[] ids)
    {
        return dContentlibNodeMapper.deleteDContentlibNodeByIds(ids);
    }

    /**
     * 删除知识库节点信息
     * 
     * @param id 知识库节点主键
     * @return 结果
     */
    @Override
    public int deleteDContentlibNodeById(Long id)
    {
        return dContentlibNodeMapper.deleteDContentlibNodeById(id);
    }
}
