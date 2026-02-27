package com.ruoyi.system.DTO.Inspection;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;
import java.util.List;

/**
 * 消防巡检计划DTO（内部类版本）
 */
@Data
public class InspectionPlanDTO {

    private Long id;

    private String name;

    /**
     * 项目信息
     */
    private ProjectInfo project;

    /**
     * 公司信息
     */
    private CompanyInfo company;
    /**
     * 设备数量信息
     */
    private Long totalNum;
    private Long goodNum;
    private Long badNum;

    /**
     * 巡检负责人
     */
    private String inspector;

    /**
     * 巡检安排
     */
    private ScheduleInfo schedule;

    /**
     * 巡检区域列表
     */
    private List<InspectionArea> areas;

    /**
     * 参与人员列表
     */
    private List<PersonnelInfo> personnel;

    /**
     * 相关文档列表
     */
    private List<DocumentInfo> documents;

    /**
     * 状态：active/inactive
     */
    private Integer status;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private Date createdAt;

    /**
     * 项目信息内部类
     */
    @Data
    public static class ProjectInfo {
        /**
         * 项目ID
         */
        private Long id;

        /**
         * 项目名称
         */
        private String zname;

        /**
         * 父项目ID
         */
        private Long pid;

        /**
         * 区域类型
         */
        private Long zonetype;
    }

    /**
     * 公司信息内部类
     */
    @Data
    public static class CompanyInfo {
        /**
         * 公司ID
         */
        private Long id;

        /**
         * 公司名称
         */
        private String name;

        /**
         * 联系人
         */
        private String contact;

        /**
         * 联系电话
         */
        private String phone;
    }

    /**
     * 巡检安排内部类
     */
    @Data
    public static class ScheduleInfo {
        /**
         * 开始时间
         */
        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        private Date startTime;

        /**
         * 结束时间
         */
        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        private Date endTime;

        /**
         * 巡检周期：daily/weekly/monthly/quarterly/yearly
         */
        private String cycle;
    }

    /**
     * 巡检区域内部类
     */
    @Data
    public static class InspectionArea {
        /**
         * 区域ID
         */
        private Long id;

        /**
         * 区域名称
         */
        private String name;

        /**
         * 区域等级
         */
        private Long level;
    }

    /**
     * 人员信息内部类
     */
    @Data
    public static class PersonnelInfo {
        /**
         * 人员ID
         */
        private Long id;

        /**
         * 姓名
         */
        private String name;

        /**
         * 角色
         */
        private String role;

        /**
         * 分配的区域列表
         */
        private List<AssignedArea> assignedAreas;

        /**
         * 分配区域内部类
         */
        @Data
        public static class AssignedArea {
            /**
             * 区域ID
             */
            private Long id;

            /**
             * 区域名称
             */
            private String name;

            /**
             * 区域等级
             */
            private Long level;
        }
    }

    /**
     * 文档信息内部类
     */
    @Data
    public static class DocumentInfo {
        /**
         * 文档ID
         */
        private Long id;

        /**
         * 文档标题
         */
        private String title;

        /**
         * 文档存储位置
         */
        private String location;
    }
}
