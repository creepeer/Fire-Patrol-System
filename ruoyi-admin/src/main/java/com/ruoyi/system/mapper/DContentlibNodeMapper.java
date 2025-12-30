package com.ruoyi.system.mapper;

import java.util.List;

import com.ruoyi.common.annotation.AutoFill;
import com.ruoyi.common.enums.OperationType;
import com.ruoyi.common.enums.OperatorType;
import com.ruoyi.system.domain.DContentlibNode;

/**
 * 知识库节点Mapper接口
 * 
 * @author ruoyi
 * @date 2025-12-29
 */
public interface DContentlibNodeMapper 
{
    /**
     * 查询知识库节点
     * 
     * @param id 知识库节点主键
     * @return 知识库节点
     */
    public DContentlibNode selectDContentlibNodeById(Long id);

    /**
     * 查询知识库节点列表
     * 
     * @param dContentlibNode 知识库节点
     * @return 知识库节点集合
     */
    public List<DContentlibNode> selectDContentlibNodeList(DContentlibNode dContentlibNode);

    /**
     * 新增知识库节点
     * 
     * @param dContentlibNode 知识库节点
     * @return 结果
     */
    @AutoFill(value = OperationType.INSERT)
    public int insertDContentlibNode(DContentlibNode dContentlibNode);

    /**
     * 修改知识库节点
     * 
     * @param dContentlibNode 知识库节点
     * @return 结果
     */
    @AutoFill(value = OperationType.UPDATE)
    public int updateDContentlibNode(DContentlibNode dContentlibNode);

    /**
     * 删除知识库节点
     * 
     * @param id 知识库节点主键
     * @return 结果
     */
    public int deleteDContentlibNodeById(Long id);

    /**
     * 批量删除知识库节点
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDContentlibNodeByIds(Long[] ids);
}
