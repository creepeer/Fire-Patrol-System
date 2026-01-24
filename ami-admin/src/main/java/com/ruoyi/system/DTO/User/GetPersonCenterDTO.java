package com.ruoyi.system.DTO.User;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("获取个体中心信息 DTO")
public class GetPersonCenterDTO {
    @ApiModelProperty("用户id")
    private Long userId;
    @ApiModelProperty("公司id")
    private Long deptId;
    @ApiModelProperty("姓名")
    private String userName;
    @ApiModelProperty("用户邮箱")
    private String userEmail;
    @ApiModelProperty("公司名称")
    private String deptName;
    @ApiModelProperty("公司类型")
    private String deptType;
    @ApiModelProperty("公司地址")
    private String deptLocation;
    @ApiModelProperty("公司编码")
    private String deptCode;
    @ApiModelProperty("公司传真")
    private String deptFax;
    @ApiModelProperty("公司邮箱")
    private String deptEmail;

}