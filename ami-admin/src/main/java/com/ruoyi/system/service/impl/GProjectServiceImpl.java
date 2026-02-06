package com.ruoyi.system.service.impl;

import java.util.List;

import com.ruoyi.system.DTO.Project.AddProjectDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GProjectMapper;
import com.ruoyi.system.domain.GProject;
import com.ruoyi.system.service.IGProjectService;

/**
 * 项目Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@Service
public class GProjectServiceImpl implements IGProjectService 
{
    @Autowired
    private GProjectMapper gProjectMapper;

    /**
     * 查询项目
     * 
     * @param pid 项目主键
     * @return 项目
     */
    @Override
    public GProject selectGProjectByPid(Long pid)
    {
        return gProjectMapper.selectGProjectByPid(pid);
    }

    /**
     * 查询项目列表
     * 
     * @param gProject 项目
     * @return 项目
     */
    @Override
    public List<GProject> selectGProjectList(GProject gProject)
    {
        return gProjectMapper.selectGProjectList(gProject);
    }

    /**
     * 新增项目
     * 
     * @param Data 项目
     * @return 结果
     */
    @Override
    public int insertGProject(AddProjectDTO Data,Long id)
    {
        GProject gProject=new GProject();
        gProject.setAddress(Data.getAddress());
        gProject.setPid(id);
        gProject.setRegionText(Data.getArea().toString());
        List<String> areaList = Data.getArea();
        gProject.setProvince(areaList.get(0));
        gProject.setCity(areaList.get(1));
        gProject.setDistrict(areaList.get(2));
        gProject.setStreet(areaList.get(3));
        gProject.setContactPerson(Data.getAssignedPerson());
        gProject.setProjectCode(Data.getProjectCode());

        return gProjectMapper.insertGProject(gProject);
    }

    /**
     * 修改项目
     * 
     * @param gProject 项目
     * @return 结果
     */
    @Override
    public int updateGProject(GProject gProject)
    {
        return gProjectMapper.updateGProject(gProject);
    }

    /**
     * 批量删除项目
     * 
     * @param pids 需要删除的项目主键
     * @return 结果
     */
    @Override
    public int deleteGProjectByPids(Long[] pids)
    {
        return gProjectMapper.deleteGProjectByPids(pids);
    }

    /**
     * 删除项目信息
     * 
     * @param pid 项目主键
     * @return 结果
     */
    @Override
    public int deleteGProjectByPid(Long pid)
    {
        return gProjectMapper.deleteGProjectByPid(pid);
    }


}
