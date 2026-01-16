package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.DTO.Inspection.InspectionPlanDTO;
import com.ruoyi.system.domain.DContentlib;
import com.ruoyi.system.domain.DPlanContentlib;
import com.ruoyi.system.domain.DPlanUser;
import com.ruoyi.system.domain.GZone;
import com.ruoyi.system.mapper.DContentlibMapper;
import com.ruoyi.system.mapper.DInspectionPlanMapper;
import com.ruoyi.system.mapper.DPlanContentlibMapper;
import com.ruoyi.system.mapper.DPlanUserMapper;
import com.ruoyi.system.mapper.GZoneMapper;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.DInspectionPlan;
import com.ruoyi.system.service.IDInspectionPlanService;

/**
 * 检测计划管理Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
public class DInspectionPlanServiceImpl implements IDInspectionPlanService 
{
    @Autowired
    private DInspectionPlanMapper dInspectionPlanMapper;
    @Autowired
    private DPlanContentlibMapper dPlanContentlibMapper;
    @Autowired
    private DPlanUserMapper dPlanUserMapper;
    @Autowired
    private GZoneMapper gZoneMapper;
    @Autowired
    private SysDeptMapper sysDeptMapper;
    @Autowired
    private SysUserMapper sysUserMapper;
    @Autowired
    private DContentlibMapper dContentlibMapper;


    /**
     * 查询检测计划管理
     * 
     * @param id 检测计划管理主键
     * @return 检测计划管理
     */
    @Override
    public DInspectionPlan selectDInspectionPlanById(Long id)
    {
        return dInspectionPlanMapper.selectDInspectionPlanById(id);
    }

    /**
     * 查询检测计划管理列表
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 检测计划管理
     */
    @Override
    public List<DInspectionPlan> selectDInspectionPlanList(DInspectionPlan dInspectionPlan)
    {
        return dInspectionPlanMapper.selectDInspectionPlanList(dInspectionPlan);
    }

    /**
     * 新增检测计划管理
     * 
     * @param dto 检测计划管理
     * @return 结果
     */
    @Override
    public int insertDInspectionPlan(InspectionPlanDTO dto)
    {
        //计划表
        DInspectionPlan dInspectionPlan=new DInspectionPlan();
        dInspectionPlan.setProjectId(dto.getProject().getId());
        dInspectionPlan.setDeptId(dto.getCompany().getId());
        dInspectionPlan.setName(dto.getName());
        dInspectionPlan.setStartTime(dto.getSchedule().getStartTime());
        dInspectionPlan.setEndTime(dto.getSchedule().getEndTime());
        dInspectionPlan.setCycle(dto.getSchedule().getCycle());
        dInspectionPlan.setStatus(dto.getStatus());
        dInspectionPlanMapper.insertDInspectionPlan(dInspectionPlan);
        //计划区域关联表
        for (InspectionPlanDTO.PersonnelInfo personnel : dto.getPersonnel()) {
            for (InspectionPlanDTO.PersonnelInfo.AssignedArea assignedArea : personnel.getAssignedAreas()) {
                DPlanUser dPlanUser = new DPlanUser();
                dPlanUser.setPlanId(dInspectionPlan.getId());
                dPlanUser.setUserId(personnel.getId());
                dPlanUser.setZoneId(assignedArea.getId());
                // 插入关联记录
                dPlanUserMapper.insertDPlanUser(dPlanUser);
            }
        }
        //计划知识库关联表
        for(InspectionPlanDTO.DocumentInfo documentInfo:dto.getDocuments()){
            DPlanContentlib dPlanContentlib=new DPlanContentlib();
            dPlanContentlib.setContentlibId(documentInfo.getId());
            dPlanContentlib.setPlanId(dInspectionPlan.getId());
            dPlanContentlibMapper.insertDPlanContentlib(dPlanContentlib);
        }


        return 1 ;
    }

    /**
     * 修改检测计划管理
     * 
     * @param dInspectionPlan 检测计划管理
     * @return 结果
     */
    @Override
    public int updateDInspectionPlan(DInspectionPlan dInspectionPlan)
    {
        return dInspectionPlanMapper.updateDInspectionPlan(dInspectionPlan);
    }

    /**
     * 批量删除检测计划管理
     * 
     * @param ids 需要删除的检测计划管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionPlanByIds(Long[] ids)
    {
        if (ids != null)
        {
            for (Long id : ids)
            {
                if (id != null)
                {
                    deletePlanRelationsByPlanId(id);
                }
            }
        }
        return dInspectionPlanMapper.deleteDInspectionPlanByIds(ids);
    }

    /**
     * 删除检测计划管理信息
     * 
     * @param id 检测计划管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionPlanById(Long id)
    {
        if (id != null)
        {
            deletePlanRelationsByPlanId(id);
        }
        return dInspectionPlanMapper.deleteDInspectionPlanById(id);
    }
    @Override
    public List<InspectionPlanDTO> selectPlanList(DInspectionPlan query) {
        // 1. 查询计划主表数据
        List<DInspectionPlan> planList = dInspectionPlanMapper.selectDInspectionPlanList(query);

        // 2. 遍历每个计划，填充完整信息
        List<InspectionPlanDTO> result = new ArrayList<>();
        for (DInspectionPlan plan : planList) {
            InspectionPlanDTO dto = new InspectionPlanDTO();

            dto.setId(plan.getId());
            dto.setName(plan.getName());
            dto.setStatus(plan.getStatus());
            dto.setCreatedAt(plan.getCreatorTime());

            // 项目信息
            if (plan.getProjectId() != null) {
                GZone project = gZoneMapper.selectGZoneById(plan.getProjectId());
                if (project != null) {
                    InspectionPlanDTO.ProjectInfo projectDto = new InspectionPlanDTO.ProjectInfo();
                    projectDto.setId(project.getId());
                    projectDto.setZname(project.getZname());
                    projectDto.setPid(project.getPid());
                    projectDto.setZonetype(project.getZonetype());
                    dto.setProject(projectDto);
                }
            }

            // 公司信息
            if (plan.getDeptId() != null) {
                SysDept dept = sysDeptMapper.selectDeptById(plan.getDeptId());
                if (dept != null) {
                    InspectionPlanDTO.CompanyInfo companyDto = new InspectionPlanDTO.CompanyInfo();
                    companyDto.setId(dept.getDeptId());
                    companyDto.setName(dept.getDeptName());
                    dto.setCompany(companyDto);
                }
            }

            // 巡检安排
            InspectionPlanDTO.ScheduleInfo schedule = new InspectionPlanDTO.ScheduleInfo();
            schedule.setCycle(plan.getCycle());
            schedule.setStartTime(plan.getStartTime());
            schedule.setEndTime(plan.getEndTime());
            dto.setSchedule(schedule);

            // 巡检负责人
            if (plan.getInspectorId() != null) {
                SysUser inspector = sysUserMapper.selectUserById(plan.getInspectorId());
                if (inspector != null) {
                    dto.setInspector(inspector.getUserName());
                }
            }

            DPlanUser planUserQuery = new DPlanUser();
            planUserQuery.setPlanId(plan.getId());
            List<DPlanUser> planUsers = dPlanUserMapper.selectDPlanUserList(planUserQuery);
            if (planUsers != null && !planUsers.isEmpty()) {
                Set<Long> zoneIds = new HashSet<>();
                for (DPlanUser planUser : planUsers) {
                    if (planUser.getZoneId() != null) {
                        zoneIds.add(planUser.getZoneId());
                    }
                }

                List<InspectionPlanDTO.InspectionArea> areas = new ArrayList<>();
                for (Long zoneId : zoneIds) {
                    GZone zone = gZoneMapper.selectGZoneById(zoneId);
                    if (zone != null) {
                        InspectionPlanDTO.InspectionArea area = new InspectionPlanDTO.InspectionArea();
                        area.setId(zone.getId());
                        area.setName(zone.getZname());
                        area.setLevel(zone.getZonetype());
                        areas.add(area);
                    }
                }
                dto.setAreas(areas);
            }

            if (planUsers != null && !planUsers.isEmpty()) {
                Map<Long, List<DPlanUser>> userGroups = new HashMap<>();
                for (DPlanUser planUser : planUsers) {
                    userGroups.computeIfAbsent(planUser.getUserId(), k -> new ArrayList<>()).add(planUser);
                }

                List<InspectionPlanDTO.PersonnelInfo> personnelList = new ArrayList<>();
                for (Map.Entry<Long, List<DPlanUser>> entry : userGroups.entrySet()) {
                    SysUser user = sysUserMapper.selectUserById(entry.getKey());
                    if (user != null) {
                        InspectionPlanDTO.PersonnelInfo personnel = new InspectionPlanDTO.PersonnelInfo();
                        personnel.setId(user.getUserId());
                        personnel.setName(user.getUserName());

                        // 分配的区域
                        List<InspectionPlanDTO.PersonnelInfo.AssignedArea> assignedAreas = new ArrayList<>();
                        for (DPlanUser planUser : entry.getValue()) {
                            if (planUser.getZoneId() != null) {
                                GZone zone = gZoneMapper.selectGZoneById(planUser.getZoneId());
                                if (zone != null) {
                                    InspectionPlanDTO.PersonnelInfo.AssignedArea area =
                                            new InspectionPlanDTO.PersonnelInfo.AssignedArea();
                                    area.setId(zone.getId());
                                    area.setName(zone.getZname());
                                    area.setLevel(zone.getZonetype());
                                    assignedAreas.add(area);
                                }
                            }
                        }
                        personnel.setAssignedAreas(assignedAreas);

                        personnelList.add(personnel);
                    }
                }
                dto.setPersonnel(personnelList);
            }

            DPlanContentlib planDocQuery = new DPlanContentlib();
            planDocQuery.setPlanId(plan.getId());
            List<DPlanContentlib> planDocs = dPlanContentlibMapper.selectDPlanContentlibList(planDocQuery);
            if (planDocs != null && !planDocs.isEmpty()) {
                List<InspectionPlanDTO.DocumentInfo> documents = new ArrayList<>();
                for (DPlanContentlib planDoc : planDocs) {
                    InspectionPlanDTO.DocumentInfo doc = new InspectionPlanDTO.DocumentInfo();
                    Long contentlibId = planDoc.getContentlibId();
                    doc.setId(contentlibId);
                    if (contentlibId != null) {
                        DContentlib contentlib = dContentlibMapper.selectDContentlibById(contentlibId);
                        if (contentlib != null) {
                            doc.setTitle(contentlib.getName());
                            doc.setLocation(contentlib.getLocation());
                        }
                    }
                    if (doc.getTitle() == null) {
                        doc.setTitle("资料" + contentlibId);
                    }
                    documents.add(doc);
                }
                dto.setDocuments(documents);
            }

            result.add(dto);
        }

        return result;
    }

    private void deletePlanRelationsByPlanId(Long planId)
    {
        DPlanUser planUserQuery = new DPlanUser();
        planUserQuery.setPlanId(planId);
        List<DPlanUser> planUsers = dPlanUserMapper.selectDPlanUserList(planUserQuery);
        if (planUsers != null && !planUsers.isEmpty())
        {
            Long[] ids = new Long[planUsers.size()];
            for (int i = 0; i < planUsers.size(); i++)
            {
                ids[i] = planUsers.get(i).getId();
            }
            dPlanUserMapper.deleteDPlanUserByIds(ids);
        }

        DPlanContentlib planDocQuery = new DPlanContentlib();
        planDocQuery.setPlanId(planId);
        List<DPlanContentlib> planDocs = dPlanContentlibMapper.selectDPlanContentlibList(planDocQuery);
        if (planDocs != null && !planDocs.isEmpty())
        {
            Long[] ids = new Long[planDocs.size()];
            for (int i = 0; i < planDocs.size(); i++)
            {
                ids[i] = planDocs.get(i).getId();
            }
            dPlanContentlibMapper.deleteDPlanContentlibByIds(ids);
        }
    }
}
