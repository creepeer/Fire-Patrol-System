package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 知识库对象 d_contentlib
 * 
 * @author ruoyi
 * @date 2025-12-30
 */
public class DContentlib extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 项目id（项目表id） */
    @Excel(name = "项目id", readConverterExp = "项目表id")
    private Long pid;

    /** 项目id（项目表id） */
    @Excel(name = "文档名称", readConverterExp = "文档名称")
    private String name;

    /** 模块类型（1-通用，2检测，3-验收） */
    @Excel(name = "模块类型", readConverterExp = "1=-通用，2检测，3-验收")
    private Long status;

    /** 文档地址 */
    @Excel(name = "文档地址")
    private String location;

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

    public void setPid(Long pid) 
    {
        this.pid = pid;
    }

    public Long getPid() 
    {
        return pid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setStatus(Long status)
    {
        this.status = status;
    }

    public Long getStatus() 
    {
        return status;
    }

    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
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
            .append("pid", getPid())
            .append("status", getStatus())
            .append("location", getLocation())
            .append("remark", getRemark())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
