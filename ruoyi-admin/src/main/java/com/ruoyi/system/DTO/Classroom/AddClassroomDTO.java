package com.ruoyi.system.DTO.Classroom;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.validation.constraints.Pattern;
import java.math.BigDecimal;

/**
 * 添加教室DTO
 *
 * @author ruoyi
 */
@ApiModel(description = "添加教室数据传输对象")
public class AddClassroomDTO {

    @ApiModelProperty(value = "教室名称", required = true, example = "101教室")
    @NotBlank(message = "教室名称不能为空")
    @Size(min = 2, max = 100, message = "教室名称长度必须在2-100个字符之间")
    private String zname;

    @ApiModelProperty(value = "父级区域ID", required = true, example = "1")
    @NotNull(message = "父级区域ID不能为空")
    private Long pid;

    @ApiModelProperty(value = "所属项目ID", required = true, example = "1")
    @NotNull(message = "所属项目ID不能为空")
    private Long projectId;

    @ApiModelProperty(value = "教室类型", required = true, example = "classroom", allowableValues = "classroom,laboratory,computer_room,multimedia,language_lab,training_room,other")
    @NotBlank(message = "教室类型不能为空")
    private String roomType;

    @ApiModelProperty(value = "管理员", example = "张老师")
    @Size(max = 50, message = "管理员姓名长度不能超过50个字符")
    private String manager;

    @ApiModelProperty(value = "管理员电话", example = "13800138000")
    @Pattern(regexp = "^1[3-9]\\d{9}$|^$", message = "管理员电话格式不正确")
    private String managerPhone;

    @ApiModelProperty(value = "安全责任人", example = "李老师")
    @Size(max = 50, message = "安全责任人姓名长度不能超过50个字符")
    private String safetyOfficer;

    @ApiModelProperty(value = "安全责任人电话", example = "13900139000")
    @Pattern(regexp = "^1[3-9]\\d{9}$|^$", message = "安全责任人电话格式不正确")
    private String safetyOfficerPhone;

    @ApiModelProperty(value = "经度", example = "120.305204")
    private BigDecimal lng;

    @ApiModelProperty(value = "纬度", example = "30.294835")
    private BigDecimal lat;

    @ApiModelProperty(value = "平面图URL", example = "/images/plan101.png")
    @Size(max = 255, message = "平面图URL长度不能超过255个字符")
    private String planMap;

    @ApiModelProperty(value = "疏散图URL", example = "/images/evacuation101.png")
    @Size(max = 255, message = "疏散图URL长度不能超过255个字符")
    private String evacuationMap;

    @ApiModelProperty(value = "教室简介", example = "这是一个多媒体教室，配备投影仪和音响设备")
    @Size(max = 500, message = "教室简介长度不能超过500个字符")
    private String introduction;

    @ApiModelProperty(value = "备注", example = "需要定期检查设备")
    @Size(max = 500, message = "备注长度不能超过500个字符")
    private String remark;

    // 构造方法
    public AddClassroomDTO() {
    }

    public AddClassroomDTO(String zname, Long pid, Long projectId, String roomType) {
        this.zname = zname;
        this.pid = pid;
        this.projectId = projectId;
        this.roomType = roomType;
    }

    // Getter和Setter方法
    public String getZname() {
        return zname;
    }

    public void setZname(String zname) {
        this.zname = zname;
    }

    public Long getPid() {
        return pid;
    }

    public void setPid(Long pid) {
        this.pid = pid;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
    }

    public String getManagerPhone() {
        return managerPhone;
    }

    public void setManagerPhone(String managerPhone) {
        this.managerPhone = managerPhone;
    }

    public String getSafetyOfficer() {
        return safetyOfficer;
    }

    public void setSafetyOfficer(String safetyOfficer) {
        this.safetyOfficer = safetyOfficer;
    }

    public String getSafetyOfficerPhone() {
        return safetyOfficerPhone;
    }

    public void setSafetyOfficerPhone(String safetyOfficerPhone) {
        this.safetyOfficerPhone = safetyOfficerPhone;
    }

    public BigDecimal getLng() {
        return lng;
    }

    public void setLng(BigDecimal lng) {
        this.lng = lng;
    }

    public BigDecimal getLat() {
        return lat;
    }

    public void setLat(BigDecimal lat) {
        this.lat = lat;
    }

    public String getPlanMap() {
        return planMap;
    }

    public void setPlanMap(String planMap) {
        this.planMap = planMap;
    }

    public String getEvacuationMap() {
        return evacuationMap;
    }

    public void setEvacuationMap(String evacuationMap) {
        this.evacuationMap = evacuationMap;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return "AddClassroomDTO{" +
                "zname='" + zname + '\'' +
                ", pid=" + pid +
                ", projectId=" + projectId +
                ", roomType='" + roomType + '\'' +
                ", manager='" + manager + '\'' +
                ", managerPhone='" + managerPhone + '\'' +
                ", safetyOfficer='" + safetyOfficer + '\'' +
                ", safetyOfficerPhone='" + safetyOfficerPhone + '\'' +
                ", lng=" + lng +
                ", lat=" + lat +
                ", planMap='" + planMap + '\'' +
                ", evacuationMap='" + evacuationMap + '\'' +
                ", introduction='" + introduction + '\'' +
                ", remark='" + remark + '\'' +
                '}';
    }
}