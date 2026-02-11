package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 计划-人员-设备关联对象 d_plan_user
 *
 * @author lelandcat
 * @date 2026-01-14
 */
public class DPlanUser extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private Long id;

    /** 计划id */
    @Excel(name = "计划id")
    private Long planId;

    /** 用户id */
    @Excel(name = "用户id")
    private Long userId;

    /** 设备ID */
    @Excel(name = "设备ID")
    private Long deviceId;

    /** 负责区域id */
    @Excel(name = "负责区域id")
    private Long zoneId;

    /** 检测状态（0-未检查，1-通过，2-不通过） */
    @Excel(name = "检测状态", readConverterExp = "0=-未检查，1=通过，2=不通过")
    private Integer status;

    /** 检测备注 */
    @Excel(name = "检测备注")
    private String remark;

    /** 现场照片 */
    @Excel(name = "现场照片")
    private String photos;

    /** 删除状态 */
    private Integer deleted;

    /** 创建者 */
    private String creator;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date creatorTime;

    /** 修改者（检查人员） */
    @Excel(name = "检查人员")
    private String modifier;

    /** 修改时间（检查时间） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "检查时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date modifierTime;

    // ===== 关联查询字段 =====
    @Excel(name = "设备名称")
    private String deviceName;

    @Excel(name = "设备编码")
    private String deviceCode;

    @Excel(name = "区域名称")
    private String zoneName;

    @Excel(name = "用户姓名")
    private String userName;

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

    public void setPlanId(Long planId)
    {
        this.planId = planId;
    }

    public Long getPlanId()
    {
        return planId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setDeviceId(Long deviceId)
    {
        this.deviceId = deviceId;
    }

    public Long getDeviceId()
    {
        return deviceId;
    }

    public void setZoneId(Long zoneId)
    {
        this.zoneId = zoneId;
    }

    public Long getZoneId()
    {
        return zoneId;
    }

    // 修改：status从String改为Integer
    public void setStatus(Integer status)
    {
        this.status = status;
    }

    public Integer getStatus()
    {
        return status;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public String getRemark()
    {
        return remark;
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

    // ===== 关联字段的Getter和Setter =====
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    // ===== 业务方法 =====
    public String getStatusText() {
        if (status == null) return "未知";
        switch (status) {
            case 0: return "未检查";
            case 1: return "通过";
            case 2: return "不通过";
            default: return "未知";
        }
    }

    public Boolean getChecked() {
        return status != null && status != 0;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("planId", getPlanId())
                .append("userId", getUserId())
                .append("deviceId", getDeviceId())
                .append("zoneId", getZoneId())
                .append("status", getStatus())
                .append("remark", getRemark())
                .append("photos", getPhotos())
                .append("deleted", getDeleted())
                .append("creator", getCreator())
                .append("creatorTime", getCreatorTime())
                .append("modifier", getModifier())
                .append("modifierTime", getModifierTime())
                .append("deviceName", getDeviceName())
                .append("deviceCode", getDeviceCode())
                .append("zoneName", getZoneName())
                .append("userName", getUserName())
                .append("planName", getPlanName())
                .toString();
    }
}