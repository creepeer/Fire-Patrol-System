package com.ruoyi.system.service.impl;

import java.util.List;


import com.ruoyi.system.domain.DInspectionPlan;
import com.ruoyi.system.domain.DeviceScan;
import com.ruoyi.system.mapper.DInspectionPlanMapper;
import com.ruoyi.system.mapper.DeviceScanMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DPlanUserMapper;
import com.ruoyi.system.domain.DPlanUser;
import com.ruoyi.system.service.IDPlanUserService;

/**
 * 计划用户关联Service业务层处理
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@Service
@Slf4j
public class DPlanUserServiceImpl implements IDPlanUserService 
{
    @Autowired
    private DPlanUserMapper dPlanUserMapper;
    @Autowired
    private DeviceScanMapper deviceScanMapper;
    @Autowired
    private DInspectionPlanMapper dInspectionPlanMapper;

    /**
     * 查询计划用户关联
     * 
     * @param id 计划用户关联主键
     * @return 计划用户关联
     */
    @Override
    public DPlanUser selectDPlanUserById(Long id)
    {
        return dPlanUserMapper.selectDPlanUserById(id);
    }

    /**
     * 查询计划用户关联列表
     * 
     * @param dPlanUser 计划用户关联
     * @return 计划用户关联
     */
    @Override
    public List<DPlanUser> selectDPlanUserList(DPlanUser dPlanUser)
    {
        return dPlanUserMapper.selectDPlanUserList(dPlanUser);
    }

    /**
     * 新增计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @Override
    public int insertDPlanUser(DPlanUser dPlanUser)
    {
        return dPlanUserMapper.insertDPlanUser(dPlanUser);
    }

    /**
     * 修改计划用户关联
     * 
     * @param dPlanUser 计划用户关联
     * @return 结果
     */
    @Override
    public int updateDPlanUser(DPlanUser dPlanUser)
    {
        DeviceScan deviceScan = new DeviceScan();
        BeanUtils.copyProperties(dPlanUser,deviceScan);
        log.info("deviceScan{}",deviceScan);
        deviceScan.setScanCode(dPlanUser.getDeviceCode());
        deviceScan.setScanResult(dPlanUser.getStatus());
        deviceScan.setPhotos(dPlanUser.getPhotos());
        deviceScanMapper.insertDeviceScan(deviceScan);
        DInspectionPlan dInspectionPlan = dInspectionPlanMapper.selectDInspectionPlanById(dPlanUser.getPlanId());
        if(dInspectionPlan.getBadNum()+dInspectionPlan.getGoodNum()+1==dInspectionPlan.getTotalNum())dInspectionPlan.setStatus(1);
        if(dPlanUser.getStatus()==1){
            dInspectionPlan.setGoodNum(dInspectionPlan.getGoodNum()+1);
            dInspectionPlanMapper.updateDInspectionPlan(dInspectionPlan);
        }
        else {
            dInspectionPlan.setGoodNum(dInspectionPlan.getBadNum()+1);
            dInspectionPlanMapper.updateDInspectionPlan(dInspectionPlan);
        }
        return dPlanUserMapper.updateDPlanUser(dPlanUser);
    }

    /**
     * 批量删除计划用户关联
     * 
     * @param ids 需要删除的计划用户关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanUserByIds(Long[] ids)
    {
        return dPlanUserMapper.deleteDPlanUserByIds(ids);
    }

    /**
     * 删除计划用户关联信息
     * 
     * @param id 计划用户关联主键
     * @return 结果
     */
    @Override
    public int deleteDPlanUserById(Long id)
    {
        return dPlanUserMapper.deleteDPlanUserById(id);
    }
}
