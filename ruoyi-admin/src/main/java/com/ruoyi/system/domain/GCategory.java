package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.TreeEntity;

/**
 * 类别对象 g_category
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
public class GCategory extends TreeEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键，自增 */
    private Long id;

    /** 类别名称 */
    @Excel(name = "类别名称")
    private String cname;

    /** 父节点 */
    @Excel(name = "父节点")
    private Long pid;

    /** 结点类型（0分支，1结点） */
    @Excel(name = "结点类型", readConverterExp = "0=分支，1结点")
    private Integer ctype;

    /** 所属科目id */
    @Excel(name = "所属科目id")
    private Long subjectId;

    /** 图示 */
    @Excel(name = "图示")
    private String cicon;

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

    public void setCname(String cname) 
    {
        this.cname = cname;
    }

    public String getCname() 
    {
        return cname;
    }

    public void setPid(Long pid) 
    {
        this.pid = pid;
    }

    public Long getPid() 
    {
        return pid;
    }

    public void setCtype(Integer ctype) 
    {
        this.ctype = ctype;
    }

    public Integer getCtype() 
    {
        return ctype;
    }

    public void setSubjectId(Long subjectId) 
    {
        this.subjectId = subjectId;
    }

    public Long getSubjectId() 
    {
        return subjectId;
    }

    public void setCicon(String cicon) 
    {
        this.cicon = cicon;
    }

    public String getCicon() 
    {
        return cicon;
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
            .append("cname", getCname())
            .append("pid", getPid())
            .append("ctype", getCtype())
            .append("subjectId", getSubjectId())
            .append("cicon", getCicon())
            .append("remark", getRemark())
            .append("deleted", getDeleted())
            .append("creator", getCreator())
            .append("creatorTime", getCreatorTime())
            .append("modifier", getModifier())
            .append("modifierTime", getModifierTime())
            .toString();
    }
}
