package com.ruoyi.system.DTO.Device;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

/**
 * 设备新增DTO
 */
@Data
@Schema(description = "设备新增DTO")
public class AddDeviceDTO {

    @NotBlank(message = "设备名称不能为空")
    @Size(max = 100, message = "设备名称长度不能超过100个字符")
    @Schema(description = "设备名称", required = true, example = "中央空调主机")
    private String name;

    @NotNull(message = "设备类别不能为空")
    @Schema(description = "设备类别ID", required = true, example = "10")
    private Long categoryId;

    @NotNull(message = "所属项目不能为空")
    @Schema(description = "所属项目ID", required = true, example = "2")
    private Long projectId;

    @Schema(description = "一级区域ID", example = "3")
    private Long zoneId1;

    @Schema(description = "二级区域ID", example = "4")
    private Long zoneId2;

    @Schema(description = "三级区域ID", example = "5")
    private Long zoneId3;

    @Size(max = 255, message = "具体位置长度不能超过255个字符")
    @Schema(description = "具体位置", example = "一楼走廊东侧")
    private String location;

    @NotBlank(message = "关联区域位置不能为空")
    @Size(max = 255, message = "关联区域位置长度不能超过255个字符")
    @Schema(description = "关联区域位置", required = true, example = "杭电辅助教学楼-一号教学楼-一楼")
    private String relatedLocation;

    @Size(max = 50, message = "品牌长度不能超过50个字符")
    @Schema(description = "品牌", example = "海湾")
    private String brand;

    @Size(max = 50, message = "型号长度不能超过50个字符")
    @Schema(description = "型号", example = "GST-200")
    private String model;

    @NotNull(message = "是否主机不能为空")
    @Schema(description = "是否主机（0否，1是）", required = true, example = "1")
    private Integer isHost;

    @NotNull(message = "是否总线不能为空")
    @Schema(description = "是否总线（0否，1是）", required = true, example = "1")
    private Integer isBus;

    @Schema(description = "父设备ID", example = "1")
    private Long parentDeviceId;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "生产日期", example = "2022-03-15")
    private Date productionDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "启用时间", example = "2022-04-01")
    private Date startDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "质保开始时间", example = "2022-04-01")
    private Date warrantyStart;

    @Min(value = 1, message = "使用期限必须大于0")
    @Max(value = 50, message = "使用期限不能超过50年")
    @Schema(description = "使用期限（年）", example = "10")
    private Long serviceLife;

    @NotNull(message = "设备状态不能为空")
    @Schema(description = "设备状态（1-正常，2-异常，3-修理中，4-待复检）", required = true, example = "1")
    private Long deviceStatus;

    @NotNull(message = "绑定状态不能为空")
    @Schema(description = "绑定状态（1-未绑定，2-已绑定）", required = true, example = "1")
    private Long bindStatus;

    @Size(max = 50, message = "二维码编号长度不能超过50个字符")
    @Schema(description = "二维码编号", example = "FIRE001")
    private String qrCode;

    @Size(max = 255, message = "二维码URL长度不能超过255个字符")
    @Schema(description = "二维码URL", example = "/qr/fire001")
    private String qrUrl;

    @Size(max = 255, message = "2D图信息长度不能超过255个字符")
    @Schema(description = "2D图信息", example = "/diagram/fire001.png")
    private String diagram2d;

    @DecimalMin(value = "-180.0", message = "经度范围无效")
    @DecimalMax(value = "180.0", message = "经度范围无效")
    @Schema(description = "经度", example = "120.305204")
    private BigDecimal lng;

    @DecimalMin(value = "-90.0", message = "纬度范围无效")
    @DecimalMax(value = "90.0", message = "纬度范围无效")
    @Schema(description = "纬度", example = "30.294835")
    private BigDecimal lat;

    @Size(max = 255, message = "备注长度不能超过255个字符")
    @Schema(description = "备注", example = "主报警控制器")
    private String remark;

    @Schema(description = "子设备ID列表")
    private List<Long> childDeviceIds;

    // 业务逻辑验证方法
    public void validateBusinessLogic() {
        // 验证主机设备逻辑
        if (isHost == 1 && isBus == 1) {
            throw new IllegalArgumentException("设备不能同时为主机和总线");
        }

        // 验证日期逻辑 - 使用java.sql.Date的compareTo方法
        if (productionDate != null && startDate != null) {
            if (productionDate.compareTo(startDate) > 0) {
                throw new IllegalArgumentException("生产日期不能晚于启用时间");
            }
        }

        if (startDate != null && warrantyStart != null) {
            if (startDate.compareTo(warrantyStart) > 0) {
                throw new IllegalArgumentException("启用时间不能晚于质保开始时间");
            }
        }

        // 验证父子设备关系
        if (parentDeviceId != null && parentDeviceId.equals(this.getTemporaryId())) {
            throw new IllegalArgumentException("设备不能设置自己为父设备");
        }
    }

    // 临时ID用于业务逻辑验证（实际新增时ID为null）
    private Long getTemporaryId() {
        return null;
    }
}