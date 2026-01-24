package com.ruoyi.system.DTO.Building;

import lombok.Data;
import org.apache.poi.hpsf.Decimal;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

/**
 * 建筑信息DTO
 */
@Data
public class AddBuildingDTO {

    /**
     * 建筑名称
     */
    @NotBlank(message = "建筑名称不能为空")
    private String buildingName;

    /**
     * 项目ID
     */
    @NotNull(message = "项目ID不能为空")
    private Long projectId;

    private Long parentId;

    private Long zoneType;
    /**
     * 父级区域
     */
    private String parentZone;

    /**
     * 详细地址
     */
    private String address;

    /**
     * 区域面积
     */
    private BigDecimal buildingArea;
    /**
     * 区域路径（省市区街道）
     */
    private List<String> area;
    /**
     * 建筑高度（米）
     */
    private BigDecimal buildingHeight;

    /**
     * 建筑类型
     */
    @NotBlank(message = "建筑类型不能为空")
    private String buildingType;

    /**
     * 楼层数量
     */
    @NotNull(message = "楼层数量不能为空")
    private Long floorCount;

    /**
     * 纬度
     */
    private BigDecimal lat;

    /**
     * 经度
     */
    private BigDecimal lng;

    /**
     * 备注
     */
    private String remark;

    /**
     * 使用类型
     */
    @NotBlank(message = "使用类型不能为空")
    private String usageType;
}