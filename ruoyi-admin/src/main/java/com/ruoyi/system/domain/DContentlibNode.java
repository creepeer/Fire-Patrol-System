package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.TreeEntity;

/**
 * 知识库节点对象 d_contentlib_node
 * 
 * @author ruoyi
 * @date 2025-12-29
 */
public class DContentlibNode extends TreeEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 父节点 */
    @Excel(name = "父节点")
    private Long pid;

    /** 项目ID */
    @Excel(name = "项目ID")
    private String projectId;

    /** 子节点名称 */
    @Excel(name = "子节点名称")
    private String name;

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

    public void setProjectId(String projectId) 
    {
        this.projectId = projectId;
    }

    public String getProjectId() 
    {
        return projectId;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
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
            .append("projectId", getProjectId())
            .append("name", getName())
            .append("remark", getRemark())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
