package com.ruoyi.system.service.impl;

import java.util.List;

import com.ruoyi.system.DTO.Building.AddBuildingDTO;
import com.ruoyi.system.DTO.Classroom.AddClassroomDTO;
import com.ruoyi.system.DTO.Project.AddProjectDTO;
import com.ruoyi.system.domain.GBuilding;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GZoneMapper;
import com.ruoyi.system.domain.GZone;
import com.ruoyi.system.service.IGZoneService;

/**
 * 区域管理Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@Service
@Slf4j
public class GZoneServiceImpl implements IGZoneService 
{
    @Autowired
    private GZoneMapper gZoneMapper;

    /**
     * 查询区域管理
     * 
     * @param id 区域管理主键
     * @return 区域管理
     */
    @Override
    public GZone selectGZoneById(Long id)
    {
        return gZoneMapper.selectGZoneById(id);
    }

    /**
     * 查询区域管理列表
     * 
     * @param gZone 区域管理
     * @return 区域管理
     */
    @Override
    public List<GZone> selectGZoneList(GZone gZone)
    {
        return gZoneMapper.selectGZoneList(gZone);
    }

    /**
     * 新增区域管理
     * 
     * @param gZone 区域管理
     * @return 结果
     */
    @Override
    public int insertGZone(GZone gZone)
    {
        return gZoneMapper.insertGZone(gZone);
    }

    /**
     * 修改区域管理
     * 
     * @param gZone 区域管理
     * @return 结果
     */
    @Override
    public int updateGZone(GZone gZone)
    {
        return gZoneMapper.updateGZone(gZone);
    }

    /**
     * 批量删除区域管理
     * 
     * @param ids 需要删除的区域管理主键
     * @return 结果
     */
    @Override
    public int deleteGZoneByIds(Long[] ids)
    {
        return gZoneMapper.deleteGZoneByIds(ids);
    }

    /**
     * 删除区域管理信息
     * 
     * @param id 区域管理主键
     * @return 结果
     */
    @Override
    public int deleteGZoneById(Long id)
    {
        return gZoneMapper.deleteGZoneById(id);
    }
    @Override
    public int insertGZoneProject(AddProjectDTO data){
        GZone gZone=new GZone();
        BeanUtils.copyProperties(data,gZone);
        gZone.setZname(data.getProjectName());
        gZone.setZonetype(data.getZoneType());
        gZone.setManager(data.getAssignedPerson());
        return  gZoneMapper.insertGZone(gZone);
    }
    @Override
    public Long insertGZoneBuilding(AddBuildingDTO data){
        GZone gZone=new GZone();
        gZone.setZname(data.getBuildingName());
        gZone.setZonetype(data.getZoneType());
        gZone.setPid(data.getProjectId());
        gZone.setLat(data.getLat());
        gZone.setLng(data.getLng());
        gZone.setRemark(data.getRemark());
        GZone PZone=gZoneMapper.selectGZoneById(data.getProjectId());
        gZone.setManager(PZone.getManager());
        gZone.setManagerPhone(PZone.getManagerPhone());
        gZone.setSafetyOfficer(PZone.getSafetyOfficer());
        gZone.setSafetyOfficerPhone(PZone.getSafetyOfficerPhone());
        gZoneMapper.insertGZone(gZone);
        return gZone.getId();
    }
    @Override
    public Long selectIdByZnameAndPid(String name,Long pid){
        return gZoneMapper.selectIdByZNameAndPid(name,pid);
    }

    @Override
    public  int insertGZOneClassroom(AddClassroomDTO Data){
        System.out.println(Data);
        GZone gZone=new GZone();
        gZone.setZname(Data.getZname());
        gZone.setZonetype(Data.getZonetype());
        gZone.setRemark(Data.getRemark());
        gZone.setPid(Data.getPid());
        gZone.setLat(Data.getLat());
        gZone.setLng(Data.getLng());
        gZone.setSafetyOfficerPhone(Data.getSafetyOfficerPhone());
        gZone.setSafetyOfficer(Data.getSafetyOfficer());
        gZone.setManagerPhone(Data.getManagerPhone());
        gZone.setManager(Data.getManager());
        gZone.setIntroduction(Data.getIntroduction());
        gZone.setPlanMap(Data.getPlanMap());
        gZone.setEvacuationMap(Data.getEvacuationMap());
        return gZoneMapper.insertGZone(gZone);
    }
}
