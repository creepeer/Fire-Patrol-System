package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 设备检查记录对象 d_device_scan
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
    @Excel(name = "设备ID")
    private Long deviceId;

    /** 计划ID，关联d_inspection_plan表 */
    @Excel(name = "计划ID")
    private Long planId;

    /** 区域ID，关联g_zone表 */
    @Excel(name = "区域ID")
    private Long zoneId;

    /** 扫描二维码的图片地址 */
    @Excel(name = "二维码地址")
    private String scanCode;

    /** 检查状态（0-未检测，1-通过，2-不通过） */
    @Excel(name = "检查状态", readConverterExp = "0=-未检测，1=通过，2=不通过")
    private Integer scanResult;

    /** 检查备注（不通过时填写理由） */
    @Excel(name = "检查备注")
    private String scanRemark;

    /** 现场照片（多个用逗号分隔） */
    @Excel(name = "现场照片")
    private String photos;

    /** 删除状态 */
    private Integer deleted;

    /** 创建者 */
    private String creator;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date creatorTime;

    /** 检查人员 */
    @Excel(name = "检查人员")
    private String modifier;

    /** 检查时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "检查时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date modifierTime;

    // ===== 以下是新增的关联查询字段（非数据库字段） =====
    /** 设备名称 */
    @Excel(name = "设备名称")
    private String deviceName;

    /** 设备编码 */
    @Excel(name = "设备编码")
    private String deviceCode;

    /** 区域名称 */
    @Excel(name = "区域名称")
    private String zoneName;

    /** 计划名称 */
    @Excel(name = "计划名称")
    private String planName;

    // ===== Getter和Setter =====
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

    public void setScanCode(String scanCode)
    {
        this.scanCode = scanCode;
    }

    public String getScanCode()
    {
        return scanCode;
    }


    public void setScanResult(Integer scanResult)
    {
        this.scanResult = scanResult;
    }

    public Integer getScanResult()
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

    // ===== 新增关联字段的Getter和Setter =====
    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("deviceId", getDeviceId())
                .append("planId", getPlanId())
                .append("zoneId", getZoneId())
                .append("scanCode", getScanCode())
                .append("scanResult", getScanResult())
                .append("scanRemark", getScanRemark())
                .append("photos", getPhotos())
                .append("deleted", getDeleted())
                .append("creator", getCreator())
                .append("creatorTime", getCreatorTime())
                .append("modifier", getModifier())
                .append("modifierTime", getModifierTime())
                .append("deviceName", getDeviceName())
                .append("deviceCode", getDeviceCode())
                .append("zoneName", getZoneName())
                .append("planName", getPlanName())
                .toString();
    }
}