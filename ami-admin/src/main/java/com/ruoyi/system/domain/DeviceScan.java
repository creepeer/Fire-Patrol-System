package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 设备扫描记录对象 d_device_scan
 * 
 * @author LelandCat
 * @date 2026-01-30
 */
public class DeviceScan extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 设备ID，关联c_device表 */
    @Excel(name = "设备ID，关联c_device表")
    private Long deviceId;

    /** 计划ID，关联d_inspection_plan表 */
    @Excel(name = "计划ID，关联d_inspection_plan表")
    private Long planId;

    /** 区域ID（可选），关联g_zone表 */
    @Excel(name = "区域ID", readConverterExp = "可=选")
    private Long zoneId;

    /** 扫描结果（1-通过，2-不通过） */
    @Excel(name = "扫描结果", readConverterExp = "1=-通过，2-不通过")
    private Long scanResult;

    /** 扫描备注 */
    @Excel(name = "扫描备注")
    private String scanRemark;

    /** 现场照片（多个用逗号分隔） */
    @Excel(name = "现场照片", readConverterExp = "多=个用逗号分隔")
    private String photos;

    /** 删除状态 */
    @Excel(name = "删除状态")
    private Integer deleted;

    /** 创建者 */
    @Excel(name = "创建者")
    private String creator;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date creatorTime;

    /** 修改者 */
    @Excel(name = "修改者")
    private String modifier;

    /** 修改时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "修改时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date modifierTime;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setDeviceId(Long deviceId) 
    {
        this.deviceId = deviceId;
    }

    public Long getDeviceId() 
    {
        return deviceId;
    }

    public void setPlanId(Long planId) 
    {
        this.planId = planId;
    }

    public Long getPlanId() 
    {
        return planId;
    }

    public void setZoneId(Long zoneId) 
    {
        this.zoneId = zoneId;
    }

    public Long getZoneId() 
    {
        return zoneId;
    }

    public void setScanResult(Long scanResult) 
    {
        this.scanResult = scanResult;
    }

    public Long getScanResult() 
    {
        return scanResult;
    }

    public void setScanRemark(String scanRemark) 
    {
        this.scanRemark = scanRemark;
    }

    public String getScanRemark() 
    {
        return scanRemark;
    }

    public void setPhotos(String photos) 
    {
        this.photos = photos;
    }

    public String getPhotos() 
    {
        return photos;
    }

    public void setDeleted(Integer deleted) 
    {
        this.deleted = deleted;
    }

    public Integer getDeleted() 
    {
        return deleted;
    }

    public void setCreator(String creator) 
    {
        this.creator = creator;
    }

    public String getCreator() 
    {
        return creator;
    }

    public void setCreatorTime(Date creatorTime) 
    {
        this.creatorTime = creatorTime;
    }

    public Date getCreatorTime() 
    {
        return creatorTime;
    }

    public void setModifier(String modifier) 
    {
        this.modifier = modifier;
    }

    public String getModifier() 
    {
        return modifier;
    }

    public void setModifierTime(Date modifierTime) 
    {
        this.modifierTime = modifierTime;
    }

    public Date getModifierTime() 
    {
        return modifierTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("deviceId", getDeviceId())
            .append("planId", getPlanId())
            .append("zoneId", getZoneId())
            .append("scanResult", getScanResult())
            .append("scanRemark", getScanRemark())
            .append("photos", getPhotos())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
