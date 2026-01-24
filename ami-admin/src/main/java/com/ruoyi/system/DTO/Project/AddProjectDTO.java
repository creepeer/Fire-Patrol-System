package com.ruoyi.system.DTO.Project;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@Data
@ApiModel("项目添加DTO")
public class AddProjectDTO {
    @ApiModelProperty("父级id")
    private Long pid;
    @ApiModelProperty("名称")
    private String projectName;
    @ApiModelProperty("区域等级")
    private Long zoneType;
    @ApiModelProperty("项目编码")
    private String projectCode;

    @ApiModelProperty("区域")
    private List<String> area;

    @ApiModelProperty("详细地址")
    private String address;

    @ApiModelProperty("联系人")
    private String assignedPerson;

    @ApiModelProperty("联系单位")
    private String clientUnit;

    @ApiModelProperty("经度")
    private String lat;

    @ApiModelProperty("纬度")
    private String lng;
}