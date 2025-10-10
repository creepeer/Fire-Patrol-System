package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 设施设备对象 c_device
 * 
 * @author ruoyi
 * @date 2025-10-08
 */
public class CDevice extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 名称 */
    @Excel(name = "名称")
    private String name;

    /** 所属类别 c_category表关联 */
    @Excel(name = "所属类别 c_category表关联")
    private Long categoryId;

    /** 所属项目 */
    @Excel(name = "所属项目")
    private Long projectId;

    /** 所属区域1 */
    @Excel(name = "所属区域1")
    private Long zoneId1;

    /** 所属区域2 */
    @Excel(name = "所属区域2")
    private Long zoneId2;

    /** 所属区域3 */
    @Excel(name = "所属区域3")
    private Long zoneId3;

    /** 具体位置 */
    @Excel(name = "具体位置")
    private String location;

    /** 关联区域位置 */
    @Excel(name = "关联区域位置")
    private String relatedLocation;

    /** 品牌 */
    @Excel(name = "品牌")
    private String brand;

    /** 型号 */
    @Excel(name = "型号")
    private String model;

    /** 是否主机（0否，1是） */
    @Excel(name = "是否主机", readConverterExp = "0=否，1是")
    private Integer isHost;

    /** 是否总线（0否，1是） */
    @Excel(name = "是否总线", readConverterExp = "0=否，1是")
    private Integer isBus;

    /** 生产日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "生产日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date productionDate;

    /** 启用时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "启用时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date startDate;

    /** 质保开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "质保开始时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date warrantyStart;

    /** 使用期限（年） */
    @Excel(name = "使用期限", readConverterExp = "年=")
    private Long serviceLife;

    /** 设备状态（1-正常，2-异常，3-修理中，4-待复检） */
    @Excel(name = "设备状态", readConverterExp = "1=-正常，2-异常，3-修理中，4-待复检")
    private Long deviceStatus;

    /** 绑定状态（1-未绑定，2-已绑定） */
    @Excel(name = "绑定状态", readConverterExp = "1=-未绑定，2-已绑定")
    private Long bindStatus;

    /** 二维码编号 */
    @Excel(name = "二维码编号")
    private String qrCode;

    /** 二维码url */
    @Excel(name = "二维码url")
    private String qrUrl;

    /** 2d图信息 */
    @Excel(name = "2d图信息")
    private String diagram2d;

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

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }

    public void setCategoryId(Long categoryId) 
    {
        this.categoryId = categoryId;
    }

    public Long getCategoryId() 
    {
        return categoryId;
    }

    public void setProjectId(Long projectId) 
    {
        this.projectId = projectId;
    }

    public Long getProjectId() 
    {
        return projectId;
    }

    public void setZoneId1(Long zoneId1) 
    {
        this.zoneId1 = zoneId1;
    }

    public Long getZoneId1() 
    {
        return zoneId1;
    }

    public void setZoneId2(Long zoneId2) 
    {
        this.zoneId2 = zoneId2;
    }

    public Long getZoneId2() 
    {
        return zoneId2;
    }

    public void setZoneId3(Long zoneId3) 
    {
        this.zoneId3 = zoneId3;
    }

    public Long getZoneId3() 
    {
        return zoneId3;
    }

    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }

    public void setRelatedLocation(String relatedLocation) 
    {
        this.relatedLocation = relatedLocation;
    }

    public String getRelatedLocation() 
    {
        return relatedLocation;
    }

    public void setBrand(String brand) 
    {
        this.brand = brand;
    }

    public String getBrand() 
    {
        return brand;
    }

    public void setModel(String model) 
    {
        this.model = model;
    }

    public String getModel() 
    {
        return model;
    }

    public void setIsHost(Integer isHost) 
    {
        this.isHost = isHost;
    }

    public Integer getIsHost() 
    {
        return isHost;
    }

    public void setIsBus(Integer isBus) 
    {
        this.isBus = isBus;
    }

    public Integer getIsBus() 
    {
        return isBus;
    }

    public void setProductionDate(Date productionDate) 
    {
        this.productionDate = productionDate;
    }

    public Date getProductionDate() 
    {
        return productionDate;
    }

    public void setStartDate(Date startDate) 
    {
        this.startDate = startDate;
    }

    public Date getStartDate() 
    {
        return startDate;
    }

    public void setWarrantyStart(Date warrantyStart) 
    {
        this.warrantyStart = warrantyStart;
    }

    public Date getWarrantyStart() 
    {
        return warrantyStart;
    }

    public void setServiceLife(Long serviceLife) 
    {
        this.serviceLife = serviceLife;
    }

    public Long getServiceLife() 
    {
        return serviceLife;
    }

    public void setDeviceStatus(Long deviceStatus) 
    {
        this.deviceStatus = deviceStatus;
    }

    public Long getDeviceStatus() 
    {
        return deviceStatus;
    }

    public void setBindStatus(Long bindStatus) 
    {
        this.bindStatus = bindStatus;
    }

    public Long getBindStatus() 
    {
        return bindStatus;
    }

    public void setQrCode(String qrCode) 
    {
        this.qrCode = qrCode;
    }

    public String getQrCode() 
    {
        return qrCode;
    }

    public void setQrUrl(String qrUrl) 
    {
        this.qrUrl = qrUrl;
    }

    public String getQrUrl() 
    {
        return qrUrl;
    }

    public void setDiagram2d(String diagram2d) 
    {
        this.diagram2d = diagram2d;
    }

    public String getDiagram2d() 
    {
        return diagram2d;
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
            .append("name", getName())
            .append("categoryId", getCategoryId())
            .append("projectId", getProjectId())
            .append("zoneId1", getZoneId1())
            .append("zoneId2", getZoneId2())
            .append("zoneId3", getZoneId3())
            .append("location", getLocation())
            .append("relatedLocation", getRelatedLocation())
            .append("brand", getBrand())
            .append("model", getModel())
            .append("isHost", getIsHost())
            .append("isBus", getIsBus())
            .append("productionDate", getProductionDate())
            .append("startDate", getStartDate())
            .append("warrantyStart", getWarrantyStart())
            .append("serviceLife", getServiceLife())
            .append("deviceStatus", getDeviceStatus())
            .append("bindStatus", getBindStatus())
            .append("qrCode", getQrCode())
            .append("qrUrl", getQrUrl())
            .append("diagram2d", getDiagram2d())
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
