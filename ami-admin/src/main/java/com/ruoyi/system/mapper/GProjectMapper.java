package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.GProject;

/**
 * 项目Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
public interface GProjectMapper 
{
    /**
     * 查询项目
     * 
     * @param pid 项目主键
     * @return 项目
     */
    public GProject selectGProjectByPid(Long pid);

    /**
     * 查询项目列表
     * 
     * @param gProject 项目
     * @return 项目集合
     */
    public List<GProject> selectGProjectList(GProject gProject);

    /**
     * 新增项目
     * 
     * @param gProject 项目
     * @return 结果
     */
    public int insertGProject(GProject gProject);

    /**
     * 修改项目
     * 
     * @param gProject 项目
     * @return 结果
     */
    public int updateGProject(GProject gProject);

    /**
     * 删除项目
     * 
     * @param pid 项目主键
     * @return 结果
     */
    public int deleteGProjectByPid(Long pid);

    /**
     * 批量删除项目
     * 
     * @param pids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGProjectByPids(Long[] pids);

}
