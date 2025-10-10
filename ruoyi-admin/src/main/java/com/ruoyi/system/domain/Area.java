package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.TreeEntity;

/**
 * 地区对象 sys_area
 * 
 * @author Leland_Cat
 * @date 2025-09-24
 */
public class Area extends TreeEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 层级 */
    @Excel(name = "层级")
    private Integer level;

    /** 父级行政代码 */
    @Excel(name = "父级行政代码")
    private Long parentCode;

    /** 行政代码 */
    @Excel(name = "行政代码")
    private Long areaCode;

    /** 邮政编码 */
    @Excel(name = "邮政编码")
    private Long zipCode;

    /** 区号 */
    @Excel(name = "区号")
    private String cityCode;

    /** 地区名称 */
    @Excel(name = "地区名称")
    private String areaName;

    /** 简称 */
    @Excel(name = "简称")
    private String shortName;

    /** 组合名 */
    @Excel(name = "组合名")
    private String mergerName;

    /** 拼音 */
    @Excel(name = "拼音")
    private String pinyin;

    /** 缩写 */
    @Excel(name = "缩写")
    private Long abbr;

    /** 经度 */
    @Excel(name = "经度")
    private Long lng;

    /** 纬度 */
    @Excel(name = "纬度")
    private Long lat;

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

    public void setLevel(Integer level) 
    {
        this.level = level;
    }

    public Integer getLevel() 
    {
        return level;
    }

    public void setParentCode(Long parentCode) 
    {
        this.parentCode = parentCode;
    }

    public Long getParentCode() 
    {
        return parentCode;
    }

    public void setAreaCode(Long areaCode) 
    {
        this.areaCode = areaCode;
    }

    public Long getAreaCode() 
    {
        return areaCode;
    }

    public void setZipCode(Long zipCode) 
    {
        this.zipCode = zipCode;
    }

    public Long getZipCode() 
    {
        return zipCode;
    }

    public void setCityCode(String cityCode) 
    {
        this.cityCode = cityCode;
    }

    public String getCityCode() 
    {
        return cityCode;
    }

    public void setAreaName(String areaName) 
    {
        this.areaName = areaName;
    }

    public String getAreaName() 
    {
        return areaName;
    }

    public void setShortName(String shortName) 
    {
        this.shortName = shortName;
    }

    public String getShortName() 
    {
        return shortName;
    }

    public void setMergerName(String mergerName) 
    {
        this.mergerName = mergerName;
    }

    public String getMergerName() 
    {
        return mergerName;
    }

    public void setPinyin(String pinyin) 
    {
        this.pinyin = pinyin;
    }

    public String getPinyin() 
    {
        return pinyin;
    }

    public void setAbbr(Long abbr) 
    {
        this.abbr = abbr;
    }

    public Long getAbbr() 
    {
        return abbr;
    }

    public void setLng(Long lng) 
    {
        this.lng = lng;
    }

    public Long getLng() 
    {
        return lng;
    }

    public void setLat(Long lat) 
    {
        this.lat = lat;
    }

    public Long getLat() 
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
            .append("level", getLevel())
            .append("parentCode", getParentCode())
            .append("areaCode", getAreaCode())
            .append("zipCode", getZipCode())
            .append("cityCode", getCityCode())
            .append("areaName", getAreaName())
            .append("shortName", getShortName())
            .append("mergerName", getMergerName())
            .append("pinyin", getPinyin())
            .append("abbr", getAbbr())
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
