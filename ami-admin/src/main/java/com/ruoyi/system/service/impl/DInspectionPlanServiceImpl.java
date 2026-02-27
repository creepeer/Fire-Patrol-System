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
import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.service.IDInspectionPlanService;

/**
 * 检测计划管理Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
@Slf4j
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
    @Autowired
    private DeviceScanMapper deviceScanMapper;
    @Autowired
    private CDeviceMapper cDeviceMapper;


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
        Long projectId=dto.getProject().getId();
        dInspectionPlan.setProjectId(projectId);
        dInspectionPlan.setDeptId(dto.getCompany().getId());
        dInspectionPlan.setName(dto.getName());
        dInspectionPlan.setStartTime(dto.getSchedule().getStartTime());
        dInspectionPlan.setEndTime(dto.getSchedule().getEndTime());
        dInspectionPlan.setCycle(dto.getSchedule().getCycle());
        dInspectionPlan.setStatus(0);
        Long num=0L;
        dInspectionPlanMapper.insertDInspectionPlan(dInspectionPlan);
        //计划区域关联表
        for (InspectionPlanDTO.PersonnelInfo personnel : dto.getPersonnel()) {
            for (InspectionPlanDTO.PersonnelInfo.AssignedArea assignedArea : personnel.getAssignedAreas()) {
                Long zoneId= assignedArea.getId();
                List<CDevice> cDevices=cDeviceMapper.selectCDevicePlanByZoneId(zoneId);
                log.info("cDevices:{}",cDevices.size());
                for(CDevice device:cDevices){
                    num++;
                    DPlanUser planUser= new DPlanUser();
                    planUser.setDeviceId(device.getId());
                    planUser.setZoneId(zoneId);
                    planUser.setPlanId(dInspectionPlan.getId());
                    planUser.setStatus(0);
                    planUser.setUserId(personnel.getId());
                    log.info("deviceScan{}",planUser);
                    dPlanUserMapper.insertDPlanUser(planUser);
                }
            }
        }
        dInspectionPlan.setTotalNum(num);
        dInspectionPlan.setGoodNum(0L);
        dInspectionPlan.setBadNum(0L);
        dInspectionPlanMapper.updateDInspectionPlan(dInspectionPlan);
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
        List<DInspectionPlan> planList = dInspectionPlanMapper.selectDInspectionPlanList(query);

        List<InspectionPlanDTO> result = new ArrayList<>();
        for (DInspectionPlan plan : planList) {
            InspectionPlanDTO dto = new InspectionPlanDTO();
            dto.setId(plan.getId());
            dto.setName(plan.getName());
            dto.setStatus(plan.getStatus());
            dto.setTotalNum(plan.getTotalNum());
            dto.setGoodNum(plan.getGoodNum());
            dto.setBadNum(plan.getBadNum());
            InspectionPlanDTO.ScheduleInfo schedule = new InspectionPlanDTO.ScheduleInfo();
            schedule.setStartTime(plan.getStartTime());
            schedule.setEndTime(plan.getEndTime());
            dto.setSchedule(schedule);
            if (plan.getProjectId() != null) {
                GZone project = gZoneMapper.selectGZoneById(plan.getProjectId());
                if (project != null) {
                    InspectionPlanDTO.ProjectInfo projectDto = new InspectionPlanDTO.ProjectInfo();
                    projectDto.setId(project.getId());
                    projectDto.setZname(project.getZname());
                    dto.setProject(projectDto);
                }
            }
            if (plan.getDeptId() != null) {
                SysDept dept = sysDeptMapper.selectDeptById(plan.getDeptId());
                if (dept != null) {
                    InspectionPlanDTO.CompanyInfo companyDto = new InspectionPlanDTO.CompanyInfo();
                    companyDto.setId(dept.getDeptId());
                    companyDto.setName(dept.getDeptName());
                    dto.setCompany(companyDto);
                }
            }
            result.add(dto);
        }
        return result;
    }

    @Override
    public InspectionPlanDTO selectPlanDetail(Long id) {
        DInspectionPlan plan = dInspectionPlanMapper.selectDInspectionPlanById(id);
        if (plan == null) {
            return null;
        }

        InspectionPlanDTO dto = new InspectionPlanDTO();
        dto.setId(plan.getId());
        dto.setName(plan.getName());
        dto.setStatus(plan.getStatus());
        dto.setCreatedAt(plan.getCreatorTime());

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

        if (plan.getDeptId() != null) {
            SysDept dept = sysDeptMapper.selectDeptById(plan.getDeptId());
            if (dept != null) {
                InspectionPlanDTO.CompanyInfo companyDto = new InspectionPlanDTO.CompanyInfo();
                companyDto.setId(dept.getDeptId());
                companyDto.setName(dept.getDeptName());
                dto.setCompany(companyDto);
            }
        }

        InspectionPlanDTO.ScheduleInfo schedule = new InspectionPlanDTO.ScheduleInfo();
        schedule.setCycle(plan.getCycle());
        schedule.setStartTime(plan.getStartTime());
        schedule.setEndTime(plan.getEndTime());
        dto.setSchedule(schedule);

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

        return dto;
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
