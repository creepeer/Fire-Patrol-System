package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 检测计划管理对象 d_inspection_plan
 *
 * @author lelandcat
 * @date 2026-01-14
 */
public class DInspectionPlan extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 项目id */
    @Excel(name = "项目id")
    private Long projectId;

    /** 公司id */
    @Excel(name = "公司id")
    private Long deptId;

    /** 计划名称 */
    @Excel(name = "计划名称")
    private String name;

    /** 巡检周期 */
    @Excel(name = "巡检周期")
    private String cycle;

    /** 项目负责人ID */
    @Excel(name = "项目负责人ID")
    private Long inspectorId;

    /** 开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "开始时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date startTime;

    /** 结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "结束时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date endTime;
    @Excel(name = "设备总数")
    private Long totalNum;

    /** 通过设备数 */
    @Excel(name = "通过设备数")
    private Long goodNum;

    /** 不通过设备数 */
    @Excel(name = "不通过设备数")
    private Long badNum;
    /** 账号状态（0正常 1停用） */
    @Excel(name = "检查状态", readConverterExp = "0=未检查,1=通过,2=不通过")
    private Integer status;

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

    // Getters and Setters
    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setCycle(String cycle) {
        this.cycle = cycle;
    }

    public String getCycle() {
        return cycle;
    }

    public void setInspectorId(Long inspectorId) {
        this.inspectorId = inspectorId;
    }

    public Long getInspectorId() {
        return inspectorId;
    }

    public void setTotalNum(Long totalNum) {
        this.totalNum = totalNum;
    }

    public Long getTotalNum() {
        return totalNum;
    }

    public void setGoodNum(Long goodNum) {
        this.goodNum = goodNum;
    }

    public Long getGoodNum() {
        return goodNum;
    }

    public void setBadNum(Long badNum) {
        this.badNum = badNum;
    }

    public Long getBadNum() {
        return badNum;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getStatus() {
        return status;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreatorTime(Date creatorTime) {
        this.creatorTime = creatorTime;
    }

    public Date getCreatorTime() {
        return creatorTime;
    }

    public void setModifier(String modifier) {
        this.modifier = modifier;
    }

    public String getModifier() {
        return modifier;
    }

    public void setModifierTime(Date modifierTime) {
        this.modifierTime = modifierTime;
    }

    public Date getModifierTime() {
        return modifierTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("projectId", getProjectId())
                .append("deptId", getDeptId())
                .append("name", getName())
                .append("cycle", getCycle())
                .append("inspectorId", getInspectorId())
                .append("totalNum", getTotalNum())
                .append("goodNum", getGoodNum())
                .append("badNum", getBadNum())
                .append("startTime", getStartTime())
                .append("endTime", getEndTime())
                .append("status", getStatus())
                .append("creator", getCreator())
                .append("creatorTime", getCreatorTime())
                .append("modifier", getModifier())
                .append("modifierTime", getModifierTime())
                .toString();
    }
}