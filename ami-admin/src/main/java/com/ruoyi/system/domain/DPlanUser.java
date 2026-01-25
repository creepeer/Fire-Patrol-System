package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 计划用户关联对象 d_plan_user
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

    /** 负责区域id */
    @Excel(name = "负责区域id")
    private Long zoneId;

    /** 检测状态 */
    @Excel(name = "检测状态")
    private String status;

    /** 检测备注 */
    @Excel(name = "检测备注")
    private String remark;

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

    public void setZoneId(Long zoneId)
    {
        this.zoneId = zoneId;
    }

    public Long getZoneId()
    {
        return zoneId;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus()
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
                .append("planId", getPlanId())
                .append("userId", getUserId())
                .append("zoneId", getZoneId())
                .append("status", getStatus())
                .append("remark", getRemark())
                .append("creator", getCreator())
                .append("creatorTime", getCreatorTime())
                .append("modifier", getModifier())
                .append("modifierTime", getModifierTime())
                .toString();
    }
}