package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 一级区域对象 g_building
 * 
 * @author ruoyi
 * @date 2025-10-05
 */
public class GBuilding extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，g_zone表中，区域类别是一级区域的 */
    private Long pid;

    /** 建筑高度（米） */
    @Excel(name = "建筑高度", readConverterExp = "米=")
    private BigDecimal height;

    /** 建筑层数（地上/地下） */
    @Excel(name = "建筑层数", readConverterExp = "地=上/地下")
    private String floors;

    /** 建筑面积（平方米） */
    @Excel(name = "建筑面积", readConverterExp = "平=方米")
    private BigDecimal area;

    /** 建筑类别 */
    @Excel(name = "建筑类别")
    private String buildingType;

    /** 使用性质 */
    @Excel(name = "使用性质")
    private String usageType;

    /** 详细地址 */
    @Excel(name = "详细地址")
    private String address;

    /** 联系人员 */
    @Excel(name = "联系人员")
    private String contactPerson;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String contactPhone;

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

    public void setPid(Long pid) 
    {
        this.pid = pid;
    }

    public Long getPid() 
    {
        return pid;
    }

    public void setHeight(BigDecimal height) 
    {
        this.height = height;
    }

    public BigDecimal getHeight() 
    {
        return height;
    }

    public void setFloors(String floors) 
    {
        this.floors = floors;
    }

    public String getFloors() 
    {
        return floors;
    }

    public void setArea(BigDecimal area) 
    {
        this.area = area;
    }

    public BigDecimal getArea() 
    {
        return area;
    }

    public void setBuildingType(String buildingType) 
    {
        this.buildingType = buildingType;
    }

    public String getBuildingType() 
    {
        return buildingType;
    }

    public void setUsageType(String usageType) 
    {
        this.usageType = usageType;
    }

    public String getUsageType() 
    {
        return usageType;
    }

    public void setAddress(String address) 
    {
        this.address = address;
    }

    public String getAddress() 
    {
        return address;
    }

    public void setContactPerson(String contactPerson) 
    {
        this.contactPerson = contactPerson;
    }

    public String getContactPerson() 
    {
        return contactPerson;
    }

    public void setContactPhone(String contactPhone) 
    {
        this.contactPhone = contactPhone;
    }

    public String getContactPhone() 
    {
        return contactPhone;
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
            .append("pid", getPid())
            .append("height", getHeight())
            .append("floors", getFloors())
            .append("area", getArea())
            .append("buildingType", getBuildingType())
            .append("usageType", getUsageType())
            .append("address", getAddress())
            .append("contactPerson", getContactPerson())
            .append("contactPhone", getContactPhone())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
