package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.TreeEntity;

/**
 * 区域管理对象 g_zone
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
public class GZone extends TreeEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 区域名称 */
    @Excel(name = "区域名称")
    private String zname;

    /** 父级代码 */
    @Excel(name = "父级代码")
    private Long pid;

    /** 区域类别（1.项目 2.一级区域 3.二级区域 4.三级区域） */
    @Excel(name = "区域类别", readConverterExp = "1=.项目,2=.一级区域,3=.二级区域,4=.三级区域")
    private Long zonetype;

    /** 区域平面图 */
    @Excel(name = "区域平面图")
    private String planMap;

    /** 区域简介 */
    @Excel(name = "区域简介")
    private String introduction;

    /** 区域疏散图 */
    @Excel(name = "区域疏散图")
    private String evacuationMap;

    /** 区域管理员 */
    @Excel(name = "区域管理员")
    private String manager;

    /** 区域管理员电话 */
    @Excel(name = "区域管理员电话")
    private String managerPhone;

    /** 区域安全责任人 */
    @Excel(name = "区域安全责任人")
    private String safetyOfficer;

    /** 区域安全责任人电话 */
    @Excel(name = "区域安全责任人电话")
    private String safetyOfficerPhone;

    /** 经度 */
    @Excel(name = "经度")
    private BigDecimal lng;

    /** 纬度 */
    @Excel(name = "纬度")
    private BigDecimal lat;

    /** 删除状态（0正常 1删除） */
    @Excel(name = "删除状态", readConverterExp = "0=正常,1=删除")
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

    public void setZname(String zname) 
    {
        this.zname = zname;
    }

    public String getZname() 
    {
        return zname;
    }

    public void setPid(Long pid) 
    {
        this.pid = pid;
    }

    public Long getPid() 
    {
        return pid;
    }

    public Long getZonetype() {
        return zonetype;
    }

    public void setZonetype(Long zonetype) {
        this.zonetype = zonetype;
    }

    public void setPlanMap(String planMap)
    {
        this.planMap = planMap;
    }

    public String getPlanMap() 
    {
        return planMap;
    }

    public void setIntroduction(String introduction) 
    {
        this.introduction = introduction;
    }

    public String getIntroduction() 
    {
        return introduction;
    }

    public void setEvacuationMap(String evacuationMap) 
    {
        this.evacuationMap = evacuationMap;
    }

    public String getEvacuationMap() 
    {
        return evacuationMap;
    }

    public void setManager(String manager) 
    {
        this.manager = manager;
    }

    public String getManager() 
    {
        return manager;
    }

    public void setManagerPhone(String managerPhone) 
    {
        this.managerPhone = managerPhone;
    }

    public String getManagerPhone() 
    {
        return managerPhone;
    }

    public void setSafetyOfficer(String safetyOfficer) 
    {
        this.safetyOfficer = safetyOfficer;
    }

    public String getSafetyOfficer() 
    {
        return safetyOfficer;
    }

    public void setSafetyOfficerPhone(String safetyOfficerPhone) 
    {
        this.safetyOfficerPhone = safetyOfficerPhone;
    }

    public String getSafetyOfficerPhone() 
    {
        return safetyOfficerPhone;
    }

    public void setLng(BigDecimal lng) 
    {
        this.lng = lng;
    }

    public BigDecimal getLng() 
    {
        return lng;
    }

    public void setLat(BigDecimal lat) 
    {
        this.lat = lat;
    }

    public BigDecimal getLat() 
    {
        return lat;
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
            .append("zname", getZname())
            .append("pid", getPid())
            .append("zonetype", getZonetype())
            .append("planMap", getPlanMap())
            .append("introduction", getIntroduction())
            .append("evacuationMap", getEvacuationMap())
            .append("manager", getManager())
            .append("managerPhone", getManagerPhone())
            .append("safetyOfficer", getSafetyOfficer())
            .append("safetyOfficerPhone", getSafetyOfficerPhone())
            .append("lng", getLng())
            .append("lat", getLat())
            .append("remark", getRemark())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
