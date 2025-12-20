/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : ruoyi

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 20/12/2025 15:37:23
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for c_company
-- ----------------------------
DROP TABLE IF EXISTS `c_company`;
CREATE TABLE `c_company`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `comname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `comtype` tinyint NOT NULL COMMENT '公司类别（1 建设 2 施工 3 监理 4 勘察 5 设计 6检测 7 验收）',
  `credit_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '统一信用编码',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `fax` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传真',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮编',
  `project_leader` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目负责人',
  `technical_leader` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '技术负责人',
  `detection_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '检测内容（检测公司版）文件的oss链接',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_comtype`(`comtype` ASC) USING BTREE,
  INDEX `idx_credit_code`(`credit_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公司表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of c_company
-- ----------------------------

-- ----------------------------
-- Table structure for c_device
-- ----------------------------
DROP TABLE IF EXISTS `c_device`;
CREATE TABLE `c_device`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `category_id` bigint NOT NULL COMMENT '所属类别 c_category表关联',
  `project_id` bigint NULL DEFAULT NULL COMMENT '所属项目',
  `zone_id1` bigint NULL DEFAULT NULL COMMENT '所属区域1',
  `zone_id2` bigint NULL DEFAULT NULL COMMENT '所属区域2',
  `zone_id3` bigint NULL DEFAULT NULL COMMENT '所属区域3',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '具体位置',
  `related_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联区域位置',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '型号',
  `is_host` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否主机（0否，1是）',
  `is_bus` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否总线（0否，1是）',
  `parent_device_id` bigint NULL DEFAULT NULL COMMENT '父设备ID',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `start_date` date NULL DEFAULT NULL COMMENT '启用时间',
  `warranty_start` date NULL DEFAULT NULL COMMENT '质保开始时间',
  `service_life` int NULL DEFAULT NULL COMMENT '使用期限（年）',
  `device_status` tinyint NOT NULL DEFAULT 1 COMMENT '设备状态（1-正常，2-异常，3-修理中，4-待复检）',
  `bind_status` tinyint NOT NULL DEFAULT 1 COMMENT '绑定状态（1-未绑定，2-已绑定）',
  `qr_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '二维码编号',
  `qr_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '二维码url',
  `diagram_2d` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '2d图信息',
  `lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_project_id`(`project_id` ASC) USING BTREE,
  INDEX `idx_device_status`(`device_status` ASC) USING BTREE,
  INDEX `idx_qr_code`(`qr_code` ASC) USING BTREE,
  INDEX `idx_parent_device_id`(`parent_device_id` ASC) USING BTREE,
  CONSTRAINT `fk_device_parent` FOREIGN KEY (`parent_device_id`) REFERENCES `c_device` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '设施设备表（包含父子关系）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of c_device
-- ----------------------------
INSERT INTO `c_device` VALUES (1, '消防报警主机', 10, 2, 3, 4, NULL, '一楼走廊东侧', '杭电辅助教学楼-一号教学楼-一楼', '海湾', 'GST-200', 1, 1, NULL, '2022-03-15', '2022-04-01', '2022-04-01', 10, 1, 2, 'FIRE001', '/qr/fire001', '/diagram/fire001.png', 120.305204, 30.294835, '主报警控制器', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (2, '感烟探测器', 12, 2, 3, 4, 5, '01教室门口', '杭电辅助教学楼-一号教学楼-一楼-01教室', '海湾', 'JTY-GD-G3', 0, 0, 1, '2022-05-10', '2022-05-20', '2022-05-20', 8, 1, 2, 'FIRE002', '/qr/fire002', NULL, 120.305204, 30.294835, '光电感烟探测器', 0, '', '2025-10-10 15:08:12', '', '2025-10-17 15:28:07');
INSERT INTO `c_device` VALUES (3, '手动报警按钮', 15, 2, 3, 4, 6, '02教室走廊', '杭电辅助教学楼-一号教学楼-一楼-02教室', '利达', 'JB-QB-LD128E', 0, 0, 1, '2022-06-05', '2022-06-15', '2022-06-15', 8, 1, 2, 'FIRE003', '/qr/fire003', NULL, 120.305204, 30.294835, '手动火灾报警按钮', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:44:10');
INSERT INTO `c_device` VALUES (4, '消火栓', 17, 2, 3, 4, 7, '卫生间旁', '杭电辅助教学楼-一号教学楼-一楼-卫生间', '沪消', 'SN65', 0, 0, 1, '2021-12-20', '2022-01-10', '2022-01-10', 15, 1, 2, 'FIRE004', '/qr/fire004', NULL, 120.305204, 30.294835, '室内消火栓', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (5, '消防应急照明', 21, 2, 24, 25, 26, '101实验室入口', '杭电辅助教学楼-二号教学楼-一楼-101实验室', '振辉', 'ZH-ZFJC-E6W', 0, 0, 1, '2023-01-15', '2023-02-01', '2023-02-01', 6, 1, 2, 'FIRE005', '/qr/fire005', NULL, 120.305304, 30.294935, '应急疏散照明灯', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (6, '灭火器', 20, 2, 24, 25, 27, '102实验室内部', '杭电辅助教学楼-二号教学楼-一楼-102实验室', '天广', 'MFZ/ABC4', 0, 0, 1, '2023-03-10', '2023-03-20', '2023-03-20', 5, 1, 2, 'FIRE006', '/qr/fire006', NULL, 120.305304, 30.294935, '4kg干粉灭火器', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (7, '感温探测器', 13, 2, 24, 29, 30, '201实验室机房', '杭电辅助教学楼-二号教学楼-二楼-201实验室', '海湾', 'JTW-ZCD-G3N', 0, 0, 1, '2022-11-05', '2022-11-20', '2022-11-20', 8, 1, 2, 'FIRE007', '/qr/fire007', NULL, 120.305304, 30.294935, '感温火灾探测器', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (8, '消防广播', 24, 2, 45, 46, 47, '101教室后墙', '杭电辅助教学楼-三号教学楼-一楼-101教室', '迪士普', 'DSPPA', 0, 1, 1, '2022-08-12', '2022-08-25', '2022-08-25', 10, 1, 2, 'FIRE008', '/qr/fire008', NULL, 120.305404, 30.295035, '消防应急广播', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (9, '喷淋头', 18, 2, 45, 46, 48, '102教室天花板', '杭电辅助教学楼-三号教学楼-一楼-102教室', '威景', 'VK701', 0, 0, 1, '2022-09-18', '2022-10-01', '2022-10-01', 12, 1, 2, 'FIRE009', '/qr/fire009', NULL, 120.305404, 30.295035, '自动喷水灭火喷头', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (10, '防火门监控器', 30, 2, 45, 50, 51, '201实验室入口', '杭电辅助教学楼-三号教学楼-二楼-201实验室', '泛海三江', 'JBF-1', 0, 1, 1, '2023-02-14', '2023-03-01', '2023-03-01', 8, 1, 2, 'FIRE010', '/qr/fire010', NULL, 120.305404, 30.295035, '防火门状态监控器', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (11, '防爆消防设备', 26, 66, NULL, NULL, NULL, '主控室', '特电项目-主控室', '华荣', 'BXD51', 1, 1, NULL, '2023-04-20', '2023-05-10', '2023-05-10', 10, 1, 2, 'FIRE011', '/qr/fire011', '/diagram/fire011.png', 120.306000, 30.295500, '防爆型消防报警主机', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (12, '防爆感烟探测器', 27, 66, NULL, NULL, NULL, '生产线区域', '特电项目-生产线', '华荣', 'BHY-1', 0, 0, 11, '2023-05-15', '2023-05-30', '2023-05-30', 8, 1, 2, 'FIRE012', '/qr/fire012', NULL, 120.306000, 30.295500, '防爆型感烟探测器', 0, '', '2025-10-10 15:08:12', '', '2025-10-17 15:48:07');
INSERT INTO `c_device` VALUES (13, '防爆手动按钮', 26, 66, NULL, NULL, NULL, '仓库入口', '特电项目-仓库', '华荣', 'BHA-1', 0, 0, 11, '2023-06-08', '2023-06-20', '2023-06-20', 8, 1, 2, 'FIRE013', '/qr/fire013', NULL, 120.306000, 30.295500, '防爆手动报警按钮', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:45:20');
INSERT INTO `c_device` VALUES (14, '消防水泵', 28, 2, 3, NULL, NULL, '地下室泵房', '杭电辅助教学楼-一号教学楼-泵房', '凯泉', 'XBD-40', 1, 0, NULL, '2021-10-25', '2021-11-15', '2021-11-15', 15, 1, 2, 'FIRE014', '/qr/fire014', '/diagram/fire014.png', 120.305204, 30.294835, '消防主水泵', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (15, '气体灭火系统', 19, 2, 24, 33, 34, '301实验室', '杭电辅助教学楼-二号教学楼-三楼-301实验室', 'FM200', 'INERGEN', 1, 1, NULL, '2023-07-12', '2023-07-30', '2023-07-30', 12, 1, 2, 'FIRE015', '/qr/fire015', '/diagram/fire015.png', 120.305304, 30.294935, 'IG541气体灭火系统', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (16, '应急电源', 23, 2, 45, 58, 59, '401实验室', '杭电辅助教学楼-三号教学楼-四楼-401实验室', '山特', 'C6KS', 0, 1, 1, '2022-12-05', '2022-12-20', '2022-12-20', 6, 1, 2, 'FIRE016', '/qr/fire016', NULL, 120.305404, 30.295035, '消防设备应急电源', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:45:36');
INSERT INTO `c_device` VALUES (17, '排烟风机', 33, 2, 3, 8, NULL, '二楼走廊', '杭电辅助教学楼-一号教学楼-二楼', '上专', 'PY-400', 0, 0, 1, '2022-04-18', '2022-05-05', '2022-05-05', 10, 1, 2, 'FIRE017', '/qr/fire017', NULL, 120.305204, 30.294835, '消防排烟风机', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (18, '防火卷帘', 34, 2, 24, 37, 38, '401实验室通道', '杭电辅助教学楼-二号教学楼-四楼-401实验室', '博朗', 'FJM-01', 0, 0, 1, '2023-08-22', '2023-09-10', '2023-09-10', 12, 1, 2, 'FIRE018', '/qr/fire018', NULL, 120.305304, 30.294935, '防火分隔卷帘', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (19, '消防电话', 25, 66, NULL, NULL, NULL, '监控中心', '特电项目-监控中心', '海湾', 'TS-Z01A', 0, 1, 11, '2023-09-15', '2023-10-01', '2023-10-01', 8, 1, 2, 'FIRE019', '/qr/fire019', NULL, 120.306000, 30.295500, '消防专用电话', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:26:55');
INSERT INTO `c_device` VALUES (20, '漏电火灾监控', 31, 2, 45, 62, 63, '501实验室', '杭电辅助教学楼-三号教学楼-五楼-501实验室', '安科瑞', 'ARCM200', 0, 1, 1, '2023-10-08', '2023-10-25', '2023-10-25', 8, 1, 2, 'FIRE020', '/qr/fire020', NULL, 120.305404, 30.295035, '电气火灾监控探测器', 0, '', '2025-10-10 15:08:12', '', '2025-10-13 14:45:39');

-- ----------------------------
-- Table structure for c_supplier
-- ----------------------------
DROP TABLE IF EXISTS `c_supplier`;
CREATE TABLE `c_supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `comname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `fax` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传真',
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮编',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of c_supplier
-- ----------------------------

-- ----------------------------
-- Table structure for c_worker
-- ----------------------------
DROP TABLE IF EXISTS `c_worker`;
CREATE TABLE `c_worker`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `category_id` bigint NULL DEFAULT NULL COMMENT '一级分类id',
  `task_id` bigint NULL DEFAULT NULL COMMENT '所属任务',
  `company_id` bigint NULL DEFAULT NULL COMMENT '所属单位id',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公司名称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机',
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信openid',
  `photo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '人员照片oss地址',
  `department` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属部门',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '当前状态（0无效，1有效）',
  `gender` tinyint(1) NULL DEFAULT NULL COMMENT '性别（0未知，1男，2女）',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号',
  `certificates` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '拥有证书（分号分隔）',
  `certificate_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '证书id（分号分隔）',
  `system_type` tinyint NULL DEFAULT NULL COMMENT '所属系统（1-验收，2-巡检 3-维保，4-检测）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid` ASC) USING BTREE,
  INDEX `idx_company_id`(`company_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作人员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of c_worker
-- ----------------------------

-- ----------------------------
-- Table structure for d_contentlib
-- ----------------------------
DROP TABLE IF EXISTS `d_contentlib`;
CREATE TABLE `d_contentlib`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `pid` bigint NOT NULL COMMENT '项目id（项目表id）',
  `status` tinyint NOT NULL COMMENT '模块类型（1-通用，2检测，3-验收）',
  `location` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档地址',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `creator_time` datetime NOT NULL COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '修改者',
  `modifier_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of d_contentlib
-- ----------------------------

-- ----------------------------
-- Table structure for d_contentlib_node
-- ----------------------------
DROP TABLE IF EXISTS `d_contentlib_node`;
CREATE TABLE `d_contentlib_node`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `pid` bigint NOT NULL COMMENT '父节点',
  `Name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '子节点名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `creator_time` datetime NOT NULL COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '修改者',
  `modifier_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of d_contentlib_node
-- ----------------------------

-- ----------------------------
-- Table structure for d_detection_item
-- ----------------------------
DROP TABLE IF EXISTS `d_detection_item`;
CREATE TABLE `d_detection_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `cid` bigint NOT NULL COMMENT '所属结点项（二级或三级）',
  `tech_requirement` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '技术要求',
  `detection_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '检测方法（图文）',
  `sampling_id` bigint NOT NULL COMMENT '抽检要求（抽检要求模板表的id）',
  `is_gb` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否国标（1是，0不是）',
  `version_id` bigint NOT NULL COMMENT '版本id（a_version表的id）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建者',
  `creator_time` datetime NOT NULL COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '修改者',
  `modifier_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检测项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of d_detection_item
-- ----------------------------

-- ----------------------------
-- Table structure for g_building
-- ----------------------------
DROP TABLE IF EXISTS `g_building`;
CREATE TABLE `g_building`  (
  `pid` bigint NOT NULL COMMENT '主键，g_zone表中，区域类别是一级区域的',
  `height` decimal(6, 2) NULL DEFAULT NULL COMMENT '建筑高度（米）',
  `floors` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '建筑层数（地上/地下）',
  `area` decimal(12, 2) NULL DEFAULT NULL COMMENT '建筑面积（平方米）',
  `building_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '建筑类别',
  `usage_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '使用性质',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人员',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`pid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '一级区域表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of g_building
-- ----------------------------
INSERT INTO `g_building` VALUES (3, 25.50, '5', 1500.00, '教育建筑', '教学用途', '杭州市钱塘区白杨街道2号大街1158号', '张三', '13800138001', 0, 'system', '2025-10-05 14:03:18', 'system', '2025-10-05 14:42:49');
INSERT INTO `g_building` VALUES (24, 28.20, '5', 2200.00, '教育建筑', '实验教学', '杭州市钱塘区白杨街道2号大街1158号', '张三', '13800138001', 0, 'system', '2025-10-05 14:03:18', 'system', '2025-10-05 14:42:52');
INSERT INTO `g_building` VALUES (45, 32.80, '5', 3500.00, '教育建筑', '综合教学', '杭州市钱塘区白杨街道2号大街1158号', '张三', '13800138001', 0, 'system', '2025-10-05 14:03:18', 'system', '2025-10-05 18:23:38');
INSERT INTO `g_building` VALUES (74, 123.00, '5', 321.00, 'residential', 'office', '123321', NULL, NULL, 0, '', '2025-10-10 17:25:15', '', '2025-10-10 17:25:15');

-- ----------------------------
-- Table structure for g_category
-- ----------------------------
DROP TABLE IF EXISTS `g_category`;
CREATE TABLE `g_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `cname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类别名称',
  `pid` bigint NOT NULL DEFAULT 0 COMMENT '父节点',
  `ctype` tinyint(1) NOT NULL COMMENT '结点类型（0分支，1结点）',
  `subject_id` bigint NULL DEFAULT NULL COMMENT '所属科目id',
  `cicon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图示',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pid`(`pid` ASC) USING BTREE,
  INDEX `idx_ctype`(`ctype` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of g_category
-- ----------------------------
INSERT INTO `g_category` VALUES (1, '消防报警系统', 0, 0, 1, '/icon/fire-alarm.png', '消防报警控制主机及相关设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (2, '消防探测设备', 0, 0, 1, '/icon/detector.png', '各类火灾探测传感器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (3, '消防报警装置', 0, 0, 1, '/icon/alarm-device.png', '手动报警和声光报警设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (4, '消防灭火设备', 0, 0, 1, '/icon/fire-extinguisher.png', '灭火器材和系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (5, '消防应急设备', 0, 0, 1, '/icon/emergency.png', '应急照明和疏散设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (6, '消防广播通讯', 0, 0, 1, '/icon/broadcast.png', '广播和通讯设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (7, '消防防爆设备', 0, 0, 1, '/icon/explosion-proof.png', '防爆型消防设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (8, '消防供水设备', 0, 0, 1, '/icon/water-supply.png', '消防水泵和供水系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (9, '消防监控设备', 0, 0, 1, '/icon/monitor.png', '状态监控和检测设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (10, '火灾报警控制器', 1, 1, 1, '/icon/controller.png', '集中火灾报警控制主机', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 15:01:41');
INSERT INTO `g_category` VALUES (11, '区域报警控制器', 1, 1, 1, '/icon/area-controller.png', '区域火灾报警控制器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-21 16:49:53');
INSERT INTO `g_category` VALUES (12, '感烟探测器', 2, 1, 1, '/icon/smoke-detector.png', '烟雾探测传感器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-17 15:28:17');
INSERT INTO `g_category` VALUES (13, '感温探测器', 0, 1, 1, '/icon/heat-detector.png', '温度探测传感器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-21 16:49:51');
INSERT INTO `g_category` VALUES (14, '复合探测器', 2, 1, 1, '/icon/combo-detector.png', '多参数复合探测器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (15, '手动报警按钮', 3, 1, 1, '/icon/manual-alarm.png', '手动火灾报警按钮', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (16, '声光报警器', 3, 1, 1, '/icon/sound-light.png', '声光报警装置', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (17, '消火栓系统', 4, 1, 1, '/icon/hydrant.png', '室内外消火栓', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (18, '自动喷淋系统', 4, 1, 1, '/icon/sprinkler.png', '自动喷水灭火系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (19, '气体灭火系统', 4, 1, 1, '/icon/gas-extinguisher.png', '气体自动灭火系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (20, '灭火器材', 4, 1, 1, '/icon/fire-equipment.png', '便携式灭火器', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (21, '应急照明灯', 5, 1, 1, '/icon/emergency-light.png', '消防应急照明设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (22, '疏散指示标志', 5, 1, 1, '/icon/escape-sign.png', '安全疏散指示标志', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (23, '应急电源系统', 5, 1, 1, '/icon/emergency-power.png', '消防应急电源', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (24, '消防广播系统', 6, 1, 1, '/icon/fire-broadcast.png', '应急广播系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (25, '消防电话系统', 6, 1, 1, '/icon/fire-phone.png', '消防专用电话', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (26, '防爆报警设备', 7, 1, 1, '/icon/explosion-alarm.png', '防爆型报警设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (27, '防爆探测设备', 7, 1, 1, '/icon/explosion-detector.png', '防爆型探测设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (28, '消防水泵', 8, 1, 1, '/icon/fire-pump.png', '消防给水泵', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (29, '稳压设备', 8, 1, 1, '/icon/pressure-equipment.png', '消防稳压设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (30, '防火门监控', 9, 1, 1, '/icon/fire-door.png', '防火门状态监控', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (31, '电气火灾监控', 9, 1, 1, '/icon/electrical-monitor.png', '电气火灾监控系统', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (32, '消防设备监控', 9, 1, 1, '/icon/equipment-monitor.png', '消防设备状态监控', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (33, '排烟设备', 32, 1, 1, '/icon/smoke-exhaust.png', '消防排烟风机设备', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');
INSERT INTO `g_category` VALUES (34, '防火卷帘', 32, 1, 1, '/icon/fire-shutter.png', '防火分隔卷帘', 0, 'system', '2025-10-13 14:26:33', 'system', '2025-10-13 14:26:33');

-- ----------------------------
-- Table structure for g_project
-- ----------------------------
DROP TABLE IF EXISTS `g_project`;
CREATE TABLE `g_project`  (
  `pid` bigint NOT NULL COMMENT '主键，g_zone表中，区域类别是项目的',
  `project_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目编码',
  `region_text` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省市区文本',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区',
  `street` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '街道',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人员',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`pid`) USING BTREE,
  INDEX `idx_project_code`(`project_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of g_project
-- ----------------------------
INSERT INTO `g_project` VALUES (2, 'PROJ2025001', '浙江省杭州市钱塘区特种电子技术研发基地', '浙江省', '杭州市', '钱塘区', '白杨街道', '杭州电子科技大学校区内特种电子研发中心', '王五', '13700137001', 0, 'system', '2025-10-02 16:30:00', 'system', '2025-10-02 16:31:09');
INSERT INTO `g_project` VALUES (66, 'PROJ2025002', '浙江省杭州市钱塘区智慧城市建设项目', '浙江省', '杭州市', '钱塘区', '下沙街道', '钱塘区智慧城市指挥中心', '赵六', '13600136001', 0, 'system', '2025-10-02 16:30:00', 'system', '2025-10-02 16:33:46');

-- ----------------------------
-- Table structure for g_zone
-- ----------------------------
DROP TABLE IF EXISTS `g_zone`;
CREATE TABLE `g_zone`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `zname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '区域名称',
  `pid` bigint NOT NULL DEFAULT 0 COMMENT '父级代码',
  `zonetype` bigint NOT NULL COMMENT '区域类别（1.项目 2.一级区域 3.二级区域 4.三级区域）',
  `plan_map` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域平面图',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '区域简介',
  `evacuation_map` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域疏散图',
  `manager` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域管理员',
  `manager_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域管理员电话',
  `safety_officer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域安全责任人',
  `safety_officer_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区域安全责任人电话',
  `lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pid`(`pid` ASC) USING BTREE,
  INDEX `idx_zonetype`(`zonetype` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '区域表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of g_zone
-- ----------------------------
INSERT INTO `g_zone` VALUES (1, '浙江省杭州市钱塘区', 0, 0, NULL, '杭州市重要行政区划，位于杭州东部，是杭州城市发展的重要区域，涵盖多个高校和科技园区。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305004, 30.294635, '省级行政区划，包含多个教育机构', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:42:07');
INSERT INTO `g_zone` VALUES (2, '杭电辅助教学楼', 1, 1, NULL, '杭州电子科技大学重要的辅助教学区域，包含多栋现代化教学楼，为学生提供优质的教学环境和实验设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305104, 30.294735, '教学辅助区域，包含三栋教学楼', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:40:16');
INSERT INTO `g_zone` VALUES (3, '一号教学楼', 2, 2, NULL, '建于2015年的现代化教学楼，配备先进的多媒体设备和实验室，主要承担基础课程教学任务，可同时容纳800名学生。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '主要教学楼，设备齐全', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:40:52');
INSERT INTO `g_zone` VALUES (4, '一楼', 3, 3, NULL, '教学楼一层区域，包含基础教室和公共设施，便于学生日常学习和休息。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '一层公共区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:40:53');
INSERT INTO `g_zone` VALUES (5, '01教室', 4, 4, NULL, '标准多媒体教室，配备投影设备和音响系统，适合各类理论课程教学。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '多媒体教室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (6, '02教室', 4, 4, NULL, '小型讨论教室，适合小组教学和学术讨论，环境安静舒适。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '讨论型教室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (7, '卫生间', 4, 4, NULL, '公共卫生间设施，保持清洁卫生，为学生提供便利。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '公共卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:40:59');
INSERT INTO `g_zone` VALUES (8, '二楼', 3, 3, NULL, '教学楼二层区域，主要包含专业实验室和计算机房，支持实践教学。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '实验室集中区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:00');
INSERT INTO `g_zone` VALUES (9, '201实验室', 8, 4, NULL, '计算机基础实验室，配备60台高性能计算机，支持编程和软件课程教学。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '计算机实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (10, '202实验室', 8, 4, NULL, '电子技术实验室，提供各类电子测量仪器和实验设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '电子技术实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (11, '卫生间', 8, 4, NULL, '二层公共卫生间，定期清洁维护。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (12, '三楼', 3, 3, NULL, '教学楼三层区域，设有专业实验室和科研平台，支持学科深入研究。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '专业实验室区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:04');
INSERT INTO `g_zone` VALUES (13, '301实验室', 12, 4, NULL, '通信工程实验室，配备通信系统测试设备和信号发生器。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '通信专业实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (14, '302实验室', 12, 4, NULL, '自动化控制实验室，支持PLC编程和工业自动化实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '自动化实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (15, '卫生间', 12, 4, NULL, '三层卫生设施，保持良好卫生条件。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (16, '四楼', 3, 3, NULL, '教学楼四层区域，主要承担高级实验课程和科研项目工作。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '高级实验区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:07');
INSERT INTO `g_zone` VALUES (17, '401实验室', 16, 4, NULL, '物理实验室，配备光学、力学和电磁学实验设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '物理实验中心', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (18, '402实验室', 16, 4, NULL, '化学分析实验室，支持基础化学实验和材料分析。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '化学实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (19, '卫生间', 16, 4, NULL, '四层公共卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (20, '五楼', 3, 3, NULL, '教学楼五层区域，设有创新实验室和科研平台，支持学生创新创业。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '创新实践区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:10');
INSERT INTO `g_zone` VALUES (21, '501实验室', 20, 4, NULL, '科研创新实验室，为师生提供科研项目开发和实验平台。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '科研实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (22, '502实验室', 20, 4, NULL, '创新创业实验室，支持学生创业项目和竞赛活动。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '创业孵化基地', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (23, '卫生间', 20, 4, NULL, '五层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (24, '二号教学楼', 2, 2, NULL, '专门用于实验教学的综合楼宇，配备各类专业实验设备，支持电子、通信、计算机等专业的实践教学。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '实验教学专用楼', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:19');
INSERT INTO `g_zone` VALUES (25, '一楼', 24, 3, NULL, '实验楼一层，设有基础实验室和仪器准备室，便于实验课程开展。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '基础实验区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:20');
INSERT INTO `g_zone` VALUES (26, '101实验室', 25, 4, NULL, '电子基础实验室，配备万用表、示波器等基础电子测量设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '电子基础实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (27, '102实验室', 25, 4, NULL, '电路分析实验室，支持电路设计和性能测试实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '电路实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (28, '卫生间', 25, 4, NULL, '一层公共卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (29, '二楼', 24, 3, NULL, '实验楼二层，计算机相关实验室集中区域，支持软件和网络课程。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '计算机实验区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:29');
INSERT INTO `g_zone` VALUES (30, '201实验室', 29, 4, NULL, '软件工程实验室，配备软件开发环境和测试工具。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '软件开发实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (31, '202实验室', 29, 4, NULL, '网络技术实验室，支持网络配置和协议分析实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '网络实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (32, '卫生间', 29, 4, NULL, '二层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (33, '三楼', 24, 3, NULL, '实验楼三层，前沿技术实验室区域，支持人工智能和大数据课程。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '前沿技术实验区', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:30');
INSERT INTO `g_zone` VALUES (34, '301实验室', 33, 4, NULL, '人工智能实验室，配备GPU服务器和AI开发平台。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, 'AI实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (35, '302实验室', 33, 4, NULL, '大数据实验室，支持海量数据处理和分析实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '大数据平台', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (36, '卫生间', 33, 4, NULL, '三层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (37, '四楼', 24, 3, NULL, '实验楼四层，物联网和嵌入式系统专业实验室区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '物联网实验区', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:31');
INSERT INTO `g_zone` VALUES (38, '401实验室', 37, 4, NULL, '物联网实验室，配备传感器网络和物联网开发平台。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '物联网实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (39, '402实验室', 37, 4, NULL, '嵌入式系统实验室，支持嵌入式硬件和软件开发。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '嵌入式实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (40, '卫生间', 37, 4, NULL, '四层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (41, '五楼', 24, 3, NULL, '实验楼五层，研究生和科研项目专用实验室区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '科研专用区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:34');
INSERT INTO `g_zone` VALUES (42, '501实验室', 41, 4, NULL, '研究生实验室，为研究生提供科研工作空间和设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '研究生工作区', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (43, '502实验室', 41, 4, NULL, '科研项目实验室，支持各类纵向和横向科研项目。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '科研项目基地', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (44, '卫生间', 41, 4, NULL, '五层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305304, 30.294935, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (45, '三号教学楼', 2, 2, NULL, '综合性教学实验楼，融合理论教学和实践操作，支持多学科交叉融合的教学需求。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '综合教学实验楼', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:37');
INSERT INTO `g_zone` VALUES (46, '一楼', 45, 3, NULL, '综合楼一层，设有大型教室和公共交流空间。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '公共教学区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:39');
INSERT INTO `g_zone` VALUES (47, '101教室', 46, 4, NULL, '阶梯教室，可容纳120人，适合大型讲座和公开课。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '大型阶梯教室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (48, '102教室', 46, 4, NULL, '研讨型教室，适合小组讨论和互动式教学。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '研讨教室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (49, '卫生间', 46, 4, NULL, '一层公共卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (50, '二楼', 45, 3, NULL, '综合楼二层，工程类专业实验室集中区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '工程实验区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:41');
INSERT INTO `g_zone` VALUES (51, '201实验室', 50, 4, NULL, '机械工程实验室，配备机床和机械测量设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '机械工程实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (52, '202实验室', 50, 4, NULL, '材料实验室，支持材料性能测试和分析实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '材料科学实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (53, '卫生间', 50, 4, NULL, '二层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (54, '三楼', 45, 3, NULL, '综合楼三层，生物医学和环境工程实验室区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '生物环境实验区', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:43');
INSERT INTO `g_zone` VALUES (55, '301实验室', 54, 4, NULL, '生物医学实验室，配备显微镜和生物检测设备。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '生物医学实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (56, '302实验室', 54, 4, NULL, '环境工程实验室，支持环境监测和治理实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '环境工程实验', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (57, '卫生间', 54, 4, NULL, '三层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (58, '四楼', 45, 3, NULL, '综合楼四层，物理声光学专业实验室区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '物理声光实验区', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:48');
INSERT INTO `g_zone` VALUES (59, '401实验室', 58, 4, NULL, '光学实验室，配备激光器和光学测试平台。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '光学实验中心', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (60, '402实验室', 58, 4, NULL, '声学实验室，支持声波测量和音频分析实验。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '声学实验室', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (61, '卫生间', 58, 4, NULL, '四层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (62, '五楼', 45, 3, NULL, '综合楼五层，高级研究和学术交流专用区域。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '高级研究区域', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 16:41:51');
INSERT INTO `g_zone` VALUES (63, '501实验室', 62, 4, NULL, '高级研究实验室，支持前沿科学研究和学术探索。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '前沿科学研究', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (64, '502实验室', 62, 4, NULL, '学术交流室，用于学术讨论和项目汇报活动。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '学术交流空间', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (65, '卫生间', 62, 4, NULL, '五层卫生设施。', NULL, '张三', '13800138001', '李四', '13900139001', 120.305404, 30.295035, '卫生设施', 0, 'system', '2025-10-02 10:24:10', 'system', '2025-10-02 10:24:10');
INSERT INTO `g_zone` VALUES (66, '特电项目', 1, 1, NULL, '浙江省重点特种电子技术研发项目，致力于特种电子设备、军用电子系统和高端电子元器件的研发与产业化，具有重要的战略意义和技术价值。', NULL, '张三', '13800138001', '李四', '13900139001', 120.306000, 30.295500, '省级重点科研项目', 0, 'system', '2025-10-02 00:00:00', 'system', '2025-10-02 14:01:21');
INSERT INTO `g_zone` VALUES (74, '教学楼D楼', 2, 2, NULL, NULL, NULL, '张三', '13800138001', '李四', '13900139001', 123.000000, 321.000000, '123321', 0, '', '2025-10-10 17:25:15', '', '2025-10-10 17:25:15');
INSERT INTO `g_zone` VALUES (76, '213', 29, 4, '133', NULL, '2312', '张三', '13800138001', '13900139001', '13900139001', 120.305304, 30.294935, '12331', 0, '', '2025-10-19 16:18:02', '', '2025-10-19 16:18:02');
INSERT INTO `g_zone` VALUES (78, '213', 8, 4, '123', NULL, '231', '张三', '13800138001', '李四', '13900139001', 120.305204, 30.294835, '12312', 0, '', '2025-10-19 16:36:21', '', '2025-10-19 16:36:21');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (5, 'c_company', '公司表', NULL, NULL, 'CCompany', 'crud', '', 'com.ruoyi.system', 'system', 'company', '公司', 'ruoyi', '0', '/', NULL, 'admin', '2025-09-21 17:23:57', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (6, 'c_device', '设施设备表', '', '', 'CDevice', 'tree', 'element-plus', 'com.ruoyi.system', 'system', 'device', '设施设备', 'ruoyi', '0', '/', '{\"treeCode\":\"id\",\"treeName\":\"name\",\"treeParentCode\":\"parent_device_id\",\"parentMenuId\":0}', 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35', NULL);
INSERT INTO `gen_table` VALUES (8, 'c_supplier', '供应商表', NULL, NULL, 'CSupplier', 'crud', '', 'com.ruoyi.system', 'system', 'supplier', '供应商', 'ruoyi', '0', '/', NULL, 'admin', '2025-09-21 17:23:57', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (9, 'c_worker', '工作人员表', NULL, NULL, 'CWorker', 'crud', '', 'com.ruoyi.system', 'system', 'worker', '工作人员', 'ruoyi', '0', '/', NULL, 'admin', '2025-09-21 17:23:57', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (10, 'g_building', '一级区域表', NULL, NULL, 'GBuilding', 'crud', 'element-plus', 'com.ruoyi.system', 'system', 'building', '一级区域', 'ruoyi', '0', '/', '{\"parentMenuId\":0}', 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53', NULL);
INSERT INTO `gen_table` VALUES (11, 'g_project', '项目表', NULL, NULL, 'GProject', 'crud', 'element-plus', 'com.ruoyi.system', 'system', 'project', '项目', 'ruoyi', '0', '/', '{}', 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27', NULL);
INSERT INTO `gen_table` VALUES (12, 'g_zone', '区域表', '', '', 'GZone', 'tree', 'element-plus', 'com.ruoyi.system', 'system', 'zone', '区域管理', 'ruoyi', '0', '/', '{\"treeCode\":\"id\",\"treeName\":\"zname\",\"treeParentCode\":\"pid\",\"parentMenuId\":2027}', 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10', NULL);
INSERT INTO `gen_table` VALUES (13, 'g_category', '类别表', '', '', 'GCategory', 'tree', 'element-plus', 'com.ruoyi.system', 'system', 'category', '类别', 'ruoyi', '0', '/', '{\"treeCode\":\"id\",\"treeName\":\"cname\",\"treeParentCode\":\"pid\"}', 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04', NULL);
INSERT INTO `gen_table` VALUES (14, 'sys_area', '地区表', '', '', 'Area', 'tree', 'element-plus', 'com.ruoyi.system', 'system', 'area', '地区', 'Leland_Cat', '0', '/', '{\"treeCode\":\"area_code\",\"treeName\":\"area_name\",\"treeParentCode\":\"parent_code\",\"parentMenuId\":2027}', 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 204 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (31, 5, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (32, 5, 'comname', '名称', 'varchar(100)', 'String', 'comname', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (33, 5, 'comtype', '公司类别（1 建设 2 施工 3 监理 4 勘察 5 设计 6检测 7 验收）', 'tinyint', 'Long', 'comtype', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 3, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (34, 5, 'credit_code', '统一信用编码', 'varchar(50)', 'String', 'creditCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (35, 5, 'address', '地址', 'varchar(255)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (36, 5, 'phone', '电话', 'varchar(20)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (37, 5, 'fax', '传真', 'varchar(20)', 'String', 'fax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (38, 5, 'zip_code', '邮编', 'varchar(10)', 'String', 'zipCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (39, 5, 'project_leader', '项目负责人', 'varchar(50)', 'String', 'projectLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (40, 5, 'technical_leader', '技术负责人', 'varchar(50)', 'String', 'technicalLeader', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (41, 5, 'detection_content', '检测内容（检测公司版）文件的oss链接', 'varchar(500)', 'String', 'detectionContent', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', 11, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (42, 5, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (43, 5, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (44, 5, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (45, 5, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (46, 5, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (47, 5, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (48, 6, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (49, 6, 'name', '名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (50, 6, 'category_id', '所属类别 c_category表关联', 'bigint', 'Long', 'categoryId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (51, 6, 'project_id', '所属项目', 'bigint', 'Long', 'projectId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (52, 6, 'zone_id1', '所属区域1', 'bigint', 'Long', 'zoneId1', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (53, 6, 'zone_id2', '所属区域2', 'bigint', 'Long', 'zoneId2', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (54, 6, 'location', '具体位置', 'varchar(255)', 'String', 'location', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (55, 6, 'related_location', '关联区域位置', 'varchar(255)', 'String', 'relatedLocation', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (56, 6, 'brand', '品牌', 'varchar(50)', 'String', 'brand', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (57, 6, 'model', '型号', 'varchar(50)', 'String', 'model', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (58, 6, 'is_host', '是否主机（0否，1是）', 'tinyint(1)', 'Integer', 'isHost', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (59, 6, 'is_bus', '是否总线（0否，1是）', 'tinyint(1)', 'Integer', 'isBus', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (60, 6, 'production_date', '生产日期', 'date', 'Date', 'productionDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (61, 6, 'start_date', '启用时间', 'date', 'Date', 'startDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 16, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (62, 6, 'warranty_start', '质保开始时间', 'date', 'Date', 'warrantyStart', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (63, 6, 'service_life', '使用期限（年）', 'int', 'Long', 'serviceLife', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (64, 6, 'device_status', '设备状态（1-正常，2-异常，3-修理中，4-待复检）', 'tinyint', 'Long', 'deviceStatus', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 19, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (65, 6, 'bind_status', '绑定状态（1-未绑定，2-已绑定）', 'tinyint', 'Long', 'bindStatus', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 20, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (66, 6, 'qr_code', '二维码编号', 'varchar(50)', 'String', 'qrCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (67, 6, 'qr_url', '二维码url', 'varchar(255)', 'String', 'qrUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 22, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (68, 6, 'diagram_2d', '2d图信息', 'varchar(255)', 'String', 'diagram2d', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 23, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (69, 6, 'lng', '经度', 'decimal(10,6)', 'BigDecimal', 'lng', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 24, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (70, 6, 'lat', '纬度', 'decimal(10,6)', 'BigDecimal', 'lat', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 25, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (71, 6, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 26, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (72, 6, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 27, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (73, 6, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 28, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (74, 6, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 29, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (75, 6, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 30, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (76, 6, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 31, 'admin', '2025-09-21 17:23:57', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (88, 8, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (89, 8, 'comname', '名称', 'varchar(100)', 'String', 'comname', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (90, 8, 'address', '地址', 'varchar(255)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (91, 8, 'phone', '电话', 'varchar(20)', 'String', 'phone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (92, 8, 'fax', '传真', 'varchar(20)', 'String', 'fax', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (93, 8, 'zip_code', '邮编', 'varchar(10)', 'String', 'zipCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (94, 8, 'contact_person', '联系人', 'varchar(50)', 'String', 'contactPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (95, 8, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (96, 8, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (97, 8, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (98, 8, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 11, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (99, 8, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (100, 8, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 13, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (101, 9, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (102, 9, 'name', '姓名', 'varchar(50)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (103, 9, 'category_id', '一级分类id', 'bigint', 'Long', 'categoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (104, 9, 'task_id', '所属任务', 'bigint', 'Long', 'taskId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (105, 9, 'company_id', '所属单位id', 'bigint', 'Long', 'companyId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (106, 9, 'company_name', '公司名称', 'varchar(100)', 'String', 'companyName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 6, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (107, 9, 'phone', '手机', 'varchar(20)', 'String', 'phone', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (108, 9, 'openid', '微信openid', 'varchar(100)', 'String', 'openid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (109, 9, 'photo_url', '人员照片oss地址', 'varchar(255)', 'String', 'photoUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (110, 9, 'department', '所属部门', 'varchar(50)', 'String', 'department', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (111, 9, 'status', '当前状态（0无效，1有效）', 'tinyint(1)', 'Integer', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 11, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (112, 9, 'gender', '性别（0未知，1男，2女）', 'tinyint(1)', 'Integer', 'gender', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (113, 9, 'id_card', '身份证号', 'varchar(18)', 'String', 'idCard', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (114, 9, 'certificates', '拥有证书（分号分隔）', 'varchar(500)', 'String', 'certificates', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 14, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (115, 9, 'certificate_ids', '证书id（分号分隔）', 'varchar(500)', 'String', 'certificateIds', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 15, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (116, 9, 'system_type', '所属系统（1-验收，2-巡检 3-维保，4-检测）', 'tinyint', 'Long', 'systemType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 16, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (117, 9, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 17, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (118, 9, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (119, 9, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 19, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (120, 9, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 20, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (121, 9, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 21, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (122, 9, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 22, 'admin', '2025-09-21 17:23:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (123, 10, 'pid', '主键，g_zone表中，区域类别是一级区域的', 'bigint', 'Long', 'pid', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (124, 10, 'height', '建筑高度（米）', 'decimal(6,2)', 'BigDecimal', 'height', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (125, 10, 'floors', '建筑层数（地上/地下）', 'varchar(20)', 'String', 'floors', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (126, 10, 'area', '建筑面积（平方米）', 'decimal(12,2)', 'BigDecimal', 'area', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (127, 10, 'building_type', '建筑类别', 'varchar(50)', 'String', 'buildingType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 5, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (128, 10, 'usage_type', '使用性质', 'varchar(50)', 'String', 'usageType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', 6, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (129, 10, 'address', '详细地址', 'varchar(255)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (130, 10, 'contact_person', '联系人员', 'varchar(50)', 'String', 'contactPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (131, 10, 'contact_phone', '联系电话', 'varchar(20)', 'String', 'contactPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (132, 10, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (133, 10, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (134, 10, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 12, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (135, 10, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (136, 10, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 14, 'admin', '2025-09-21 17:23:57', '', '2025-10-05 14:04:53');
INSERT INTO `gen_table_column` VALUES (137, 11, 'pid', '主键，g_zone表中，区域类别是项目的', 'bigint', 'Long', 'pid', '1', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (138, 11, 'project_code', '项目编码', 'varchar(50)', 'String', 'projectCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (139, 11, 'region_text', '省市区文本', 'varchar(100)', 'String', 'regionText', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (140, 11, 'province', '省', 'varchar(50)', 'String', 'province', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (141, 11, 'city', '市', 'varchar(50)', 'String', 'city', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (142, 11, 'district', '区', 'varchar(50)', 'String', 'district', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (143, 11, 'street', '街道', 'varchar(100)', 'String', 'street', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (144, 11, 'address', '详细地址', 'varchar(255)', 'String', 'address', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (145, 11, 'contact_person', '联系人员', 'varchar(50)', 'String', 'contactPerson', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (146, 11, 'contact_phone', '联系电话', 'varchar(20)', 'String', 'contactPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (147, 11, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (148, 11, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (149, 11, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 13, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (150, 11, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (151, 11, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', 15, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 15:17:27');
INSERT INTO `gen_table_column` VALUES (152, 12, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (153, 12, 'zname', '区域名称', 'varchar(50)', 'String', 'zname', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (154, 12, 'pid', '父级代码', 'bigint', 'Long', 'pid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (155, 12, 'zonetype', '区域类别（1.项目 2.一级区域 3.二级区域 4.三级区域）', 'bigint', 'Long', 'zonetype', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (156, 12, 'plan_map', '区域平面图', 'varchar(255)', 'String', 'planMap', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (157, 12, 'introduction', '区域简介', 'text', 'String', 'introduction', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 6, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:10');
INSERT INTO `gen_table_column` VALUES (158, 12, 'evacuation_map', '区域疏散图', 'varchar(255)', 'String', 'evacuationMap', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (159, 12, 'manager', '区域管理员', 'varchar(50)', 'String', 'manager', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (160, 12, 'manager_phone', '区域管理员电话', 'varchar(20)', 'String', 'managerPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (161, 12, 'safety_officer', '区域安全责任人', 'varchar(50)', 'String', 'safetyOfficer', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (162, 12, 'safety_officer_phone', '区域安全责任人电话', 'varchar(20)', 'String', 'safetyOfficerPhone', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (163, 12, 'lng', '经度', 'decimal(10,6)', 'BigDecimal', 'lng', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (164, 12, 'lat', '纬度', 'decimal(10,6)', 'BigDecimal', 'lat', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (165, 12, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 14, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (166, 12, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (167, 12, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (168, 12, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (169, 12, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (170, 12, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 19, 'admin', '2025-09-21 17:23:57', '', '2025-10-02 10:22:11');
INSERT INTO `gen_table_column` VALUES (171, 13, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (172, 13, 'cname', '类别名称', 'varchar(50)', 'String', 'cname', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (173, 13, 'pid', '父节点', 'bigint', 'Long', 'pid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (174, 13, 'ctype', '结点类型（0分支，1结点）', 'tinyint(1)', 'Integer', 'ctype', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', 4, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (175, 13, 'subject_id', '所属科目id', 'bigint', 'Long', 'subjectId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (176, 13, 'cicon', '图示', 'varchar(255)', 'String', 'cicon', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (177, 13, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 7, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (178, 13, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (179, 13, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (180, 13, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 10, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (181, 13, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (182, 13, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 12, 'admin', '2025-09-21 17:24:15', '', '2025-10-13 14:06:04');
INSERT INTO `gen_table_column` VALUES (183, 14, 'id', '主键，自增', 'bigint', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (184, 14, 'level', '层级', 'tinyint(1)', 'Integer', 'level', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (185, 14, 'parent_code', '父级行政代码', 'bigint', 'Long', 'parentCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (186, 14, 'area_code', '行政代码', 'bigint', 'Long', 'areaCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (187, 14, 'zip_code', '邮政编码', 'mediumint', 'Long', 'zipCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (188, 14, 'city_code', '区号', 'char(6)', 'String', 'cityCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (189, 14, 'area_name', '地区名称', 'varchar(50)', 'String', 'areaName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 7, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (190, 14, 'short_name', '简称', 'varchar(50)', 'String', 'shortName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (191, 14, 'merger_name', '组合名', 'varchar(50)', 'String', 'mergerName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 9, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (192, 14, 'pinyin', '拼音', 'varchar(30)', 'String', 'pinyin', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (193, 14, 'abbr', '缩写', 'bigint', 'Long', 'abbr', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 11, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (194, 14, 'lng', '经度', 'bigint', 'Long', 'lng', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 12, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (195, 14, 'lat', '纬度', 'int', 'Long', 'lat', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 13, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (196, 14, 'remark', '备注', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 14, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (197, 14, 'deleted', '删除状态（0正常 1删除）', 'tinyint(1)', 'Integer', 'deleted', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 15, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (198, 14, 'creator', '创建者', 'varchar(32)', 'String', 'creator', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 16, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (199, 14, 'creator_time', '创建时间', 'datetime', 'Date', 'creatorTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 17, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (200, 14, 'modifier', '修改者', 'varchar(32)', 'String', 'modifier', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 18, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (201, 14, 'modifier_time', '修改时间', 'datetime', 'Date', 'modifierTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', 19, 'admin', '2025-09-21 17:24:49', '', '2025-09-24 16:59:38');
INSERT INTO `gen_table_column` VALUES (202, 6, 'zone_id3', '所属区域3', 'bigint', 'Long', 'zoneId3', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 7, '', '2025-10-08 18:28:51', '', '2025-10-13 13:36:35');
INSERT INTO `gen_table_column` VALUES (203, 6, 'parent_device_id', '父设备ID', 'bigint', 'Long', 'parentDeviceId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 14, '', '2025-10-13 13:35:46', '', '2025-10-13 13:36:35');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键，自增',
  `level` tinyint(1) NOT NULL COMMENT '层级',
  `parent_code` bigint NOT NULL DEFAULT 0 COMMENT '父级行政代码',
  `area_code` bigint NOT NULL COMMENT '行政代码',
  `zip_code` mediumint NOT NULL DEFAULT 0 COMMENT '邮政编码',
  `city_code` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '区号',
  `area_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地区名称',
  `short_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '简称',
  `merger_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '组合名',
  `pinyin` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '拼音',
  `abbr` bigint NOT NULL DEFAULT 0 COMMENT '缩写',
  `lng` bigint NOT NULL DEFAULT 0 COMMENT '经度',
  `lat` int NOT NULL DEFAULT 0 COMMENT '纬度',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态（0正常 1删除）',
  `creator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '创建者',
  `creator_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `modifier` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '修改者',
  `modifier_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_area_code`(`area_code` ASC) USING BTREE,
  INDEX `idx_parent_code`(`parent_code` ASC) USING BTREE,
  INDEX `idx_area_name`(`area_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '地区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_area
-- ----------------------------
INSERT INTO `sys_area` VALUES (2, 1, 0, 110000, 100000, '010', '北京市', '北京', '中国,北京,北京市', 'beijing', 110000, 116405285, 39904989, '直辖市', 0, 'admin', '2025-09-24 00:00:00', 'admin', '2025-09-24 00:00:00');
INSERT INTO `sys_area` VALUES (3, 1, 0, 120000, 300000, '022', '天津市', '天津', '中国,天津,天津市', 'tianjin', 120000, 117190182, 39125393, '直辖市', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (4, 2, 110000, 110100, 100000, '010', '北京市辖区', '市辖区', '中国,北京,北京市,市辖区', 'shixiaqu', 110100, 116405285, 39904989, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (5, 2, 110000, 110200, 101500, '010', '北京市辖县', '市辖县', '中国,北京,北京市,市辖县', 'shixiaxian', 110200, 116405285, 39904989, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (6, 2, 120000, 120100, 300000, '022', '天津市辖区', '市辖区', '中国,天津,天津市,市辖区', 'shixiaqu', 120100, 117190182, 39125393, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (7, 3, 110100, 110101, 100000, '010', '东城区', '东城', '中国,北京,北京市,市辖区,东城区', 'dongcheng', 110101, 116416357, 39928449, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (8, 3, 110100, 110102, 100000, '010', '西城区', '西城', '中国,北京,北京市,市辖区,西城区', 'xicheng', 110102, 116365743, 39912411, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (9, 3, 110200, 110221, 101500, '010', '昌平区', '昌平', '中国,北京,北京市,市辖县,昌平区', 'changping', 110221, 116231285, 40220989, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (10, 3, 110200, 110222, 101500, '010', '顺义区', '顺义', '中国,北京,北京市,市辖县,顺义区', 'shunyi', 110222, 116654525, 40130456, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (11, 3, 120100, 120101, 300000, '022', '和平区', '和平', '中国,天津,天津市,市辖区,和平区', 'heping', 120101, 117214563, 39117896, '', 0, 'admin', '2025-09-24 19:11:48', 'admin', '2025-09-24 19:11:48');
INSERT INTO `sys_area` VALUES (12, 4, 110101, 110101001, 100010, '010', '东华门街道', '东华门', '中国,北京,北京市,市辖区,东城区,东华门街道', 'donghuamen', 110101001, 116417000, 39928500, '', 0, 'admin', '2025-09-25 18:31:36', 'admin', '2025-09-25 18:31:36');
INSERT INTO `sys_area` VALUES (13, 4, 110101, 110101002, 100010, '010', '景山街道', '景山', '中国,北京,北京市,市辖区,东城区,景山街道', 'jingshan', 110101002, 116418000, 39928600, '', 0, 'admin', '2025-09-25 18:31:36', 'admin', '2025-09-25 18:31:36');
INSERT INTO `sys_area` VALUES (14, 4, 110101, 110101003, 100010, '010', '交道口街道', '交道口', '中国,北京,北京市,市辖区,东城区,交道口街道', 'jiaodaokou', 110101003, 116419000, 39928700, '', 0, 'admin', '2025-09-25 18:31:36', 'admin', '2025-09-25 18:31:36');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-09-17 10:41:43', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-09-17 10:41:43', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-09-17 10:41:43', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-09-17 10:41:43', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-09-17 10:41:43', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 153 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-17 10:42:37');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-17 11:42:10');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-17 13:49:20');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-21 16:01:45');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-22 13:15:03');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-22 13:15:08');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-22 15:06:22');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-23 11:22:51');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-23 14:36:53');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-23 16:26:07');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-23 17:39:37');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-24 14:25:23');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 14:25:27');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-24 14:56:07');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 14:56:13');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 18:16:46');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 19:31:35');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-09-24 19:51:38');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-24 19:51:41');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-24 19:51:42');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 19:51:50');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-25 17:52:51');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-25 18:25:04');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-25 19:21:20');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-26 15:52:16');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-30 11:46:57');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-30 15:51:24');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 09:30:34');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 10:06:13');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 11:00:22');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 11:47:16');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 13:45:53');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 14:10:19');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-02 17:30:09');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-05 13:02:57');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-05 13:43:44');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-05 17:49:53');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-08 16:11:21');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-08 18:03:20');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-09 10:33:40');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-10 14:51:29');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-10 16:21:39');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-13 13:11:55');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 14:33:28');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 18:12:47');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-10-19 15:49:18');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-10-19 15:49:21');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 15:49:24');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 17:23:28');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 18:18:24');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 16:25:21');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 14:36:51');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 17:03:38');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2059 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-09-17 10:41:42', 'admin', '2025-09-17 12:06:36', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-09-17 10:41:42', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-09-17 10:41:42', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-09-17 10:41:42', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-09-17 10:41:42', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-09-17 10:41:42', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-09-17 10:41:42', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-09-17 10:41:42', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-09-17 10:41:42', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-09-17 10:41:42', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-09-17 10:41:42', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-09-17 10:41:42', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-09-17 10:41:42', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-09-17 10:41:42', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-09-17 10:41:42', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-09-17 10:41:42', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-09-17 10:41:42', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-09-17 10:41:42', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-09-17 10:41:42', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-09-17 10:41:42', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-09-17 10:41:42', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-09-17 10:41:42', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-09-17 10:41:42', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '区域管理', 0, 4, 'LOC', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'star', 'admin', '2025-09-24 16:55:21', 'admin', '2025-10-08 16:29:43', '');
INSERT INTO `sys_menu` VALUES (2029, '地区管理', 2027, 1, 'area', 'system/area/index', NULL, '', 1, 0, 'C', '0', '0', 'system:area:list', 'slider', 'admin', '2025-09-24 17:03:10', 'admin', '2025-09-24 18:25:38', '地区菜单');
INSERT INTO `sys_menu` VALUES (2030, '地区查询', 2029, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:area:query', '#', 'admin', '2025-09-24 17:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '地区新增', 2029, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:area:add', '#', 'admin', '2025-09-24 17:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '地区修改', 2029, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:area:edit', '#', 'admin', '2025-09-24 17:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '地区删除', 2029, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:area:remove', '#', 'admin', '2025-09-24 17:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '地区导出', 2029, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:area:export', '#', 'admin', '2025-09-24 17:03:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '区域管理', 2027, 1, 'zone', 'system/zone/index', NULL, '', 1, 0, 'C', '0', '0', 'system:zone:list', 'tree', 'admin', '2025-10-02 10:27:55', 'admin', '2025-10-08 16:28:56', '区域管理菜单');
INSERT INTO `sys_menu` VALUES (2036, '区域管理查询', 2035, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:zone:query', '#', 'admin', '2025-10-02 10:27:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '区域管理新增', 2035, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:zone:add', '#', 'admin', '2025-10-02 10:27:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '区域管理修改', 2035, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:zone:edit', '#', 'admin', '2025-10-02 10:27:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '区域管理删除', 2035, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:zone:remove', '#', 'admin', '2025-10-02 10:27:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '区域管理导出', 2035, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:zone:export', '#', 'admin', '2025-10-02 10:27:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '设备管理', 0, 5, 'EQM', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'eye-open', 'admin', '2025-10-08 16:27:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '设备管理', 2041, 1, 'equipment', 'system/device/index', NULL, '', 1, 0, 'C', '0', '0', 'system:device:list', 'example', 'admin', '2025-10-08 16:28:26', 'admin', '2025-10-13 14:01:42', '');
INSERT INTO `sys_menu` VALUES (2057, '类别管理', 0, 6, 'CGY', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'build', 'admin', '2025-10-13 14:00:24', 'admin', '2025-10-13 14:00:38', '');
INSERT INTO `sys_menu` VALUES (2058, '类别管理', 2057, 1, 'category', 'system/category/index', NULL, '', 1, 0, 'C', '0', '0', '', 'cascader', 'admin', '2025-10-13 14:01:34', 'admin', '2025-10-13 14:02:36', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-09-17 10:41:43', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-09-17 10:41:43', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 308 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"消防巡检\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/index\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 11:43:55', 49);
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 11:43:54\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"消防巡检\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 11:44:09', 20);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"项目\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index/example\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 11:45:38', 17);
INSERT INTO `sys_oper_log` VALUES (103, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"笃行楼\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2001,\"path\":\"/index/example/building\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 11:47:28', 16);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"一楼\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2002,\"path\":\"/index/example/building/floor\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 11:49:08', 10);
INSERT INTO `sys_oper_log` VALUES (105, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 10:41:42\",\"icon\":\"system\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:06:36', 40);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"101\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2003,\"path\":\"/index/example/building/floor/room\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:10:51', 20);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"102\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":2003,\"path\":\"/\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:11:12', 16);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 12:10:51\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"101\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2003,\"path\":\"/index/example/building/floor/room\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:11:16', 16);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 12:11:12\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"102\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":2003,\"path\":\"/index/example/building/floor/room\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:11:21', 17);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 12:10:51\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"101\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2003,\"path\":\"/index/example/building/floor/room\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:11:32', 17);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 12:11:12\",\"icon\":\"checkbox\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"102\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2003,\"path\":\"/index/example/building/floor/room\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 12:11:37', 15);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"二楼\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":2002,\"path\":\"/index/example/building/floor\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:03:18', 16);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"三楼\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":2002,\"path\":\"/index/example/building/floor\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:03:39', 7);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2000', '127.0.0.1', '内网IP', '2000', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-09-21 16:22:17', 4);
INSERT INTO `sys_oper_log` VALUES (115, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2003', '127.0.0.1', '内网IP', '2003', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-09-21 16:22:23', 1);
INSERT INTO `sys_oper_log` VALUES (116, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2003', '127.0.0.1', '内网IP', '2003', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-09-21 16:22:25', 2);
INSERT INTO `sys_oper_log` VALUES (117, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2004', '127.0.0.1', '内网IP', '2004', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:29', 17);
INSERT INTO `sys_oper_log` VALUES (118, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2005', '127.0.0.1', '内网IP', '2005', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:31', 7);
INSERT INTO `sys_oper_log` VALUES (119, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2003', '127.0.0.1', '内网IP', '2003', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:32', 5);
INSERT INTO `sys_oper_log` VALUES (120, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2006', '127.0.0.1', '内网IP', '2006', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:34', 7);
INSERT INTO `sys_oper_log` VALUES (121, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2007', '127.0.0.1', '内网IP', '2007', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:36', 6);
INSERT INTO `sys_oper_log` VALUES (122, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:38', 7);
INSERT INTO `sys_oper_log` VALUES (123, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2001', '127.0.0.1', '内网IP', '2001', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:22:39', 7);
INSERT INTO `sys_oper_log` VALUES (124, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 11:43:54\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"区域管理\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/areamanage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:23:07', 5);
INSERT INTO `sys_oper_log` VALUES (125, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"online\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/area/manage\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:24:22', 7);
INSERT INTO `sys_oper_log` VALUES (126, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-17 11:43:54\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"区域管理\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/area\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:24:31', 6);
INSERT INTO `sys_oper_log` VALUES (127, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/area\",\"createTime\":\"2025-09-21 16:24:22\",\"icon\":\"online\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/area/manage\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 16:29:25', 5);
INSERT INTO `sys_oper_log` VALUES (128, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"-- 类别表（g_category）\\nCREATE TABLE g_category (\\n    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT \'主键，自增\',\\n    Cname VARCHAR(50) NOT NULL COMMENT \'类别名称\',\\n    Pid BIGINT(20) NOT NULL DEFAULT 0 COMMENT \'父节点\',\\n    Ctype TINYINT(1) NOT NULL COMMENT \'结点类型（0分支，1结点）\',\\n    subject_id BIGINT(20) DEFAULT NULL COMMENT \'所属科目id\',\\n    Cicon VARCHAR(255) DEFAULT NULL COMMENT \'图示\',\\n    remark VARCHAR(255) DEFAULT NULL COMMENT \'备注\',\\n    deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT \'删除状态（0正常 1删除）\',\\n    creator VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'创建者\',\\n    creator_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n    modifier VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'修改者\',\\n    modifier_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'修改时间\',\\n    PRIMARY KEY (id),\\n    KEY idx_pid (Pid),\\n    KEY idx_ctype (Ctype)\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:00:13', 11);
INSERT INTO `sys_oper_log` VALUES (129, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"\\nCREATE TABLE g_category (\\n    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT \'主键，自增\',\\n    Cname VARCHAR(50) NOT NULL COMMENT \'类别名称\',\\n    Pid BIGINT(20) NOT NULL DEFAULT 0 COMMENT \'父节点\',\\n    Ctype TINYINT(1) NOT NULL COMMENT \'结点类型（0分支，1结点）\',\\n    subject_id BIGINT(20) DEFAULT NULL COMMENT \'所属科目id\',\\n    Cicon VARCHAR(255) DEFAULT NULL COMMENT \'图示\',\\n    remark VARCHAR(255) DEFAULT NULL COMMENT \'备注\',\\n    deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT \'删除状态（0正常 1删除）\',\\n    creator VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'创建者\',\\n    creator_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n    modifier VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'修改者\',\\n    modifier_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'修改时间\',\\n    PRIMARY KEY (id),\\n    KEY idx_pid (Pid),\\n    KEY idx_ctype (Ctype)\\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:00:17', 1);
INSERT INTO `sys_oper_log` VALUES (130, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"\\nCREATE TABLE g_category (\\n    id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT \'主键，自增\',\\n    Cname VARCHAR(50) NOT NULL COMMENT \'类别名称\',\\n    Pid BIGINT(20) NOT NULL DEFAULT 0 COMMENT \'父节点\',\\n    Ctype TINYINT(1) NOT NULL COMMENT \'结点类型（0分支，1结点）\',\\n    subject_id BIGINT(20) DEFAULT NULL COMMENT \'所属科目id\',\\n    Cicon VARCHAR(255) DEFAULT NULL COMMENT \'图示\',\\n    remark VARCHAR(255) DEFAULT NULL COMMENT \'备注\',\\n    deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT \'删除状态（0正常 1删除）\',\\n    creator VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'创建者\',\\n    creator_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n    modifier VARCHAR(32) NOT NULL DEFAULT \'\' COMMENT \'修改者\',\\n    modifier_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'修改时间\',\\n    PRIMARY KEY (id),\\n    KEY idx_pid (Pid),\\n    KEY idx_ctype (Ctype)\\n)COMMENT=\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:00:27', 3);
INSERT INTO `sys_oper_log` VALUES (131, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table qcl_user\\n(\\n    id        int(11) auto_increment comment \'编号\',\\n    name      varchar(20) null comment \'姓名\',\\n    education varchar(20) null comment \'学历\',\\n    age       int         null comment \'年龄\',\\n    primary key (id)\\n) comment \'用户表\';\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:00:34', 110);
INSERT INTO `sys_oper_log` VALUES (132, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:00:38', 9);
INSERT INTO `sys_oper_log` VALUES (133, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category (\\n    id bigint(20) not null auto_increment comment \'主键，自增\',\\n    cname varchar(50) not null comment \'类别名称\',\\n    pid bigint(20) not null default 0 comment \'父节点\',\\n    ctype tinyint(1) not null comment \'结点类型（0分支，1结点）\',\\n    subject_id bigint(20) default null comment \'所属科目id\',\\n    cicon varchar(255) default null comment \'图示\',\\n    remark varchar(255) default null comment \'备注\',\\n    deleted tinyint(1) not null default 0 comment \'删除状态（0正常 1删除）\',\\n    creator varchar(32) not null default \'\' comment \'创建者\',\\n    creator_time datetime not null default current_timestamp comment \'创建时间\',\\n    modifier varchar(32) not null default \'\' comment \'修改者\',\\n    modifier_time datetime not null default current_timestamp on update current_timestamp comment \'修改时间\',\\n    primary key (id),\\n    key idx_pid (pid),\\n    key idx_ctype (ctype)\\n) engine=innodb default charset=utf8mb4 comment=\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:03:46', 1);
INSERT INTO `sys_oper_log` VALUES (134, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category (\\n    id bigint(20) not null auto_increment comment \'主键，自增\',\\n    cname varchar(50) not null comment \'类别名称\',\\n    pid bigint(20) not null default 0 comment \'父节点\',\\n    ctype tinyint(1) not null comment \'结点类型（0分支，1结点）\',\\n    subject_id bigint(20) default null comment \'所属科目id\',\\n    cicon varchar(255) default null comment \'图示\',\\n    remark varchar(255) default null comment \'备注\',\\n    deleted tinyint(1) not null default 0 comment \'删除状态（0正常 1删除）\',\\n    creator varchar(32) not null default \'\' comment \'创建者\',\\n    creator_time datetime not null default current_timestamp comment \'创建时间\',\\n    modifier varchar(32) not null default \'\' comment \'修改者\',\\n    modifier_time datetime not null default current_timestamp on update current_timestamp comment \'修改时间\',\\n    primary key (id),\\n    key idx_pid (pid),\\n    key idx_ctype (ctype)\\n)comment=\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:03:54', 1);
INSERT INTO `sys_oper_log` VALUES (135, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category (\\n    id bigint(20) not null auto_increment comment \'主键，自增\',\\n    cname varchar(50) not null comment \'类别名称\',\\n    pid bigint(20) not null default 0 comment \'父节点\',\\n    ctype tinyint(1) not null comment \'结点类型（0分支，1结点）\',\\n    subject_id bigint(20) default null comment \'所属科目id\',\\n    cicon varchar(255) default null comment \'图示\',\\n    remark varchar(255) default null comment \'备注\',\\n    deleted tinyint(1) not null default 0 comment \'删除状态（0正常 1删除）\',\\n    creator varchar(32) not null default \'\' comment \'创建者\',\\n    creator_time datetime not null default current_timestamp comment \'创建时间\',\\n    modifier varchar(32) not null default \'\' comment \'修改者\',\\n    modifier_time datetime not null default current_timestamp on update current_timestamp comment \'修改时间\',\\n    primary key (id),\\n)comment\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:05:19', 2);
INSERT INTO `sys_oper_log` VALUES (136, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category \\n(\\n    id bigint(20) not null auto_increment comment \'主键，自增\',\\n    cname varchar(50) not null comment \'类别名称\',\\n    pid bigint(20) not null default 0 comment \'父节点\',\\n    ctype tinyint(1) not null comment \'结点类型（0分支，1结点）\',\\n    subject_id bigint(20) default null comment \'所属科目id\',\\n    cicon varchar(255) default null comment \'图示\',\\n    remark varchar(255) default null comment \'备注\',\\n    deleted tinyint(1) not null default 0 comment \'删除状态（0正常 1删除）\',\\n    creator varchar(32) not null default \'\' comment \'创建者\',\\n    creator_time datetime not null default current_timestamp comment \'创建时间\',\\n    modifier varchar(32) not null default \'\' comment \'修改者\',\\n    modifier_time datetime not null default current_timestamp on update current_timestamp comment \'修改时间\',\\n    primary key (id),\\n) comment\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:06:02', 2);
INSERT INTO `sys_oper_log` VALUES (137, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category \\n(\\n    id bigint(20) not null auto_increment comment \'主键，自增\',\\n    cname varchar(50) not null comment \'类别名称\',\\n    pid bigint(20) not null default 0 comment \'父节点\',\\n    ctype tinyint(1) not null comment \'结点类型（0分支，1结点）\',\\n    subject_id bigint(20) default null comment \'所属科目id\',\\n    cicon varchar(255) default null comment \'图示\',\\n    remark varchar(255) default null comment \'备注\',\\n    deleted tinyint(1) not null default 0 comment \'删除状态（0正常 1删除）\',\\n    creator varchar(32) not null default \'\' comment \'创建者\',\\n    creator_time datetime not null default current_timestamp comment \'创建时间\',\\n    modifier varchar(32) not null default \'\' comment \'修改者\',\\n    primary key (id),\\n) comment\'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:07:36', 1);
INSERT INTO `sys_oper_log` VALUES (138, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_config\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:09:30', 23);
INSERT INTO `sys_oper_log` VALUES (139, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:09:46', 5);
INSERT INTO `sys_oper_log` VALUES (140, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            bigint(20) auto_increment comment \'主键，自增\',\\n    cname         varchar(50) comment \'类别名称\',\\n    pid           bigint(20) comment \'父节点\',\\n    ctype         tinyint(1) comment \'结点类型（0分支，1结点）\',\\n    subject_id    bigint(20) comment \'所属科目id\',\\n    cicon         varchar(255) comment \'图示\',\\n    remark        varchar(255) comment \'备注\',\\n    deleted       tinyint(1) comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) comment \'创建者\',\\n    creator_time  datetime comment \'创建时间\',\\n    modifier      varchar(32) comment \'修改者\',\\n    modifier_time datetime comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:12:37', 3);
INSERT INTO `sys_oper_log` VALUES (141, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            int(20) auto_increment comment \'主键，自增\',\\n    cname         varchar(50) comment \'类别名称\',\\n    pid           int(20) comment \'父节点\',\\n    ctype         int(1) comment \'结点类型（0分支，1结点）\',\\n    subject_id    int(20) comment \'所属科目id\',\\n    cicon         varchar(255) comment \'图示\',\\n    remark        varchar(255) comment \'备注\',\\n    deleted       int(1) comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) comment \'创建者\',\\n    creator_time  datetime comment \'创建时间\',\\n    modifier      varchar(32) comment \'修改者\',\\n    modifier_time datetime comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:13:09', 1);
INSERT INTO `sys_oper_log` VALUES (142, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            int(20) auto_increment comment \'主键，自增\',\\n    cname         varchar(50) comment \'类别名称\',\\n    pid           int(20) comment \'父节点\',\\n    ctype         int(1) comment \'结点类型（0分支，1结点）\',\\n    subject_id    int(20) comment \'所属科目id\',\\n    cicon         varchar(255) comment \'图示\',\\n    remark        varchar(255) comment \'备注\',\\n    deleted       int(1) comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) comment \'创建者\',\\n    creator_time  varchar(32) comment \'创建时间\',\\n    modifier      varchar(32) comment \'修改者\',\\n    modifier_time  varchar(32) comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:13:30', 1);
INSERT INTO `sys_oper_log` VALUES (143, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table qcl_user\\n(\\n    id        int(11) auto_increment comment \'编号\',\\n    name      varchar(20) null comment \'姓名\',\\n    education varchar(20) null comment \'学历\',\\n    age       int         null comment \'年龄\',\\n    primary key (id)\\n) comment \'用户表\';\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:14:05', 28);
INSERT INTO `sys_oper_log` VALUES (144, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:14:34', 5);
INSERT INTO `sys_oper_log` VALUES (145, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            bigint(20) auto_increment comment \'主键，自增\',\\n    cname         varchar(50) null comment \'类别名称\',\\n    pid           bigint(20) null comment \'父节点\',\\n    ctype         tinyint(1) null comment \'结点类型（0分支，1结点）\',\\n    subject_id    bigint(20) null comment \'所属科目id\',\\n    cicon         varchar(255) null comment \'图示\',\\n    remark        varchar(255) null comment \'备注\',\\n    deleted       tinyint(1) null comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) null comment \'创建者\',\\n    creator_time  datetime null comment \'创建时间\',\\n    modifier      varchar(32) null comment \'修改者\',\\n    modifier_time datetime null comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:16:13', 1);
INSERT INTO `sys_oper_log` VALUES (146, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            bigint(20) auto_increment comment \'主键，自增\',\\n   id        int(11) auto_increment comment \'编号\',\\n    cname         varchar(50) null comment \'类别名称\',\\n    pid           bigint(20) null comment \'父节点\',\\n    ctype         tinyint(1) null comment \'结点类型（0分支，1结点）\',\\n    subject_id    bigint(20) null comment \'所属科目id\',\\n    cicon         varchar(255) null comment \'图示\',\\n    remark        varchar(255) null comment \'备注\',\\n    deleted       tinyint(1) null comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) null comment \'创建者\',\\n    creator_time  datetime null comment \'创建时间\',\\n    modifier      varchar(32) null comment \'修改者\',\\n    modifier_time datetime null comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:16:48', 1);
INSERT INTO `sys_oper_log` VALUES (147, '创建表', 0, 'com.ruoyi.generator.controller.GenController.createTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/createTable', '127.0.0.1', '内网IP', '{\"sql\":\"create table g_category\\n(\\n    id            int(20) auto_increment comment \'主键，自增\',\\n    cname         varchar(50) null comment \'类别名称\',\\n    pid           int(20) null comment \'父节点\',\\n    ctype         int(1) null comment \'结点类型（0分支，1结点）\',\\n    subject_id    int(20) null comment \'所属科目id\',\\n    cicon         varchar(255) null comment \'图示\',\\n    remark        varchar(255) null comment \'备注\',\\n    deleted       int(1) null comment \'删除状态（0正常 1删除）\',\\n    creator       varchar(32) null comment \'创建者\',\\n    creator_time  varchar(32) null comment \'创建时间\',\\n    modifier      varchar(32) null comment \'修改者\',\\n    modifier_time varchar(32) null comment \'修改时间\',\\n    primary key (id)\\n) comment \'类别表\';\"}', '{\"msg\":\"创建表结构异常\",\"code\":500}', 0, NULL, '2025-09-21 17:20:07', 1);
INSERT INTO `sys_oper_log` VALUES (148, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"g_category\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:22:53', 28);
INSERT INTO `sys_oper_log` VALUES (149, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"c_company,c_device,c_rsdevice,c_supplier,c_worker,g_building,g_project,g_zone\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:23:57', 186);
INSERT INTO `sys_oper_log` VALUES (150, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/4', '127.0.0.1', '内网IP', '[4]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:24:11', 8);
INSERT INTO `sys_oper_log` VALUES (151, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"g_category\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:24:15', 30);
INSERT INTO `sys_oper_log` VALUES (152, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-21 17:24:49', 26);
INSERT INTO `sys_oper_log` VALUES (153, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-21 17:25:23', 46);
INSERT INTO `sys_oper_log` VALUES (154, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-21 17:27:02', 55);
INSERT INTO `sys_oper_log` VALUES (155, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-21 17:37:57', 23);
INSERT INTO `sys_oper_log` VALUES (156, '地区', 1, 'com.ruoyi.system.controller.SysAreaController.add()', 'POST', 1, 'admin', '研发部门', '/system/area', '127.0.0.1', '内网IP', '{\"abbr\":1000,\"areaCode\":100001,\"areaName\":\"格致楼\",\"cityCode\":\"1\",\"creator\":\"admin\",\"creatorTime\":\"2025-09-24\",\"deleted\":0,\"id\":1,\"lat\":100,\"level\":1,\"lng\":100,\"mergerName\":\"1000\",\"modifier\":\"admin\",\"modifierTime\":\"2025-09-24\",\"params\":{},\"parentCode\":0,\"pinyin\":\"gezhilou\",\"remark\":\"1000\",\"shortName\":\"格致\",\"zipCode\":1001}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 14:29:33', 15);
INSERT INTO `sys_oper_log` VALUES (157, '地区', 2, 'com.ruoyi.system.controller.SysAreaController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/area', '127.0.0.1', '内网IP', '{\"abbr\":1000,\"areaCode\":100001,\"areaName\":\"格致楼\",\"cityCode\":\"1\",\"creator\":\"admin\",\"creatorTime\":\"2025-09-24\",\"deleted\":0,\"id\":1,\"lat\":100,\"level\":1,\"lng\":100,\"mergerName\":\"10001\",\"modifier\":\"admin\",\"modifierTime\":\"2025-09-24\",\"params\":{},\"parentCode\":0,\"pinyin\":\"gezhilou\",\"remark\":\"1000\",\"shortName\":\"格致\",\"zipCode\":1001}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 15:01:24', 14);
INSERT INTO `sys_oper_log` VALUES (158, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-24 15:44:54', 46);
INSERT INTO `sys_oper_log` VALUES (159, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-24 16:43:52', 141);
INSERT INTO `sys_oper_log` VALUES (160, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"消防巡检系统\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"AMI\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 16:55:21', 12);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/AMI/area\",\"createBy\":\"admin\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2027,\"path\":\"/AMI/area\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 16:57:19', 9);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/AMI/area\",\"createTime\":\"2025-09-24 16:57:19\",\"icon\":\"rate\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2028,\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2027,\"path\":\"area\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 16:57:33', 8);
INSERT INTO `sys_oper_log` VALUES (163, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"area\",\"className\":\"Area\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":183,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:49\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Level\",\"columnComment\":\"层级\",\"columnId\":184,\"columnName\":\"level\",\"columnType\":\"tinyint(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"level\",\"javaType\":\"Integer\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ParentCode\",\"columnComment\":\"父级行政代码\",\"columnId\":185,\"columnName\":\"parent_code\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"parentCode\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":14,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AreaCode\",\"columnComment\":\"行政代码\",\"columnId\":186,\"columnName\":\"area_code\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:49\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"areaCode\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 16:59:38', 60);
INSERT INTO `sys_oper_log` VALUES (164, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"sys_area\"}', NULL, 0, NULL, '2025-09-24 16:59:56', 37);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/area/index\",\"createTime\":\"2025-09-24 17:03:10\",\"icon\":\"slider\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2029,\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2027,\"path\":\"area\",\"perms\":\"system:area:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 18:25:38', 15);
INSERT INTO `sys_oper_log` VALUES (166, '地区', 2, 'com.ruoyi.system.controller.AreaController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/area', '127.0.0.1', '内网IP', '{\"abbr\":1000,\"areaCode\":100001,\"areaName\":\"格致楼\",\"children\":[],\"cityCode\":\"1\",\"creator\":\"admin\",\"creatorTime\":\"2025-09-24\",\"deleted\":0,\"id\":1,\"lat\":100,\"level\":1,\"lng\":100,\"mergerName\":\"10001\",\"modifier\":\"admin\",\"modifierTime\":\"2025-09-24\",\"params\":{},\"parentCode\":0,\"pinyin\":\"gezhilou\",\"remark\":\"1000\",\"shortName\":\"格致\",\"zipCode\":1001}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 19:55:23', 21);
INSERT INTO `sys_oper_log` VALUES (167, '地区', 2, 'com.ruoyi.system.controller.AreaController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/area', '127.0.0.1', '内网IP', '{\"abbr\":110000,\"areaCode\":110000,\"areaName\":\"北京市\",\"children\":[],\"cityCode\":\"010\",\"creator\":\"admin\",\"creatorTime\":\"2025-09-24\",\"deleted\":0,\"id\":2,\"lat\":39904989,\"level\":1,\"lng\":116405285,\"mergerName\":\"中国,北京,北京市\",\"modifier\":\"admin\",\"modifierTime\":\"2025-09-24\",\"params\":{},\"parentCode\":0,\"pinyin\":\"beijing\",\"remark\":\"直辖市\",\"shortName\":\"北京\",\"zipCode\":100000}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 19:55:32', 5);
INSERT INTO `sys_oper_log` VALUES (168, '地区', 3, 'com.ruoyi.system.controller.AreaController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/area/15', '127.0.0.1', '内网IP', '[15]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-30 16:54:05', 58);
INSERT INTO `sys_oper_log` VALUES (169, '地区', 3, 'com.ruoyi.system.controller.AreaController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/area/16', '127.0.0.1', '内网IP', '[16]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-30 16:54:14', 5);
INSERT INTO `sys_oper_log` VALUES (170, '地区', 3, 'com.ruoyi.system.controller.AreaController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/area/17', '127.0.0.1', '内网IP', '[17]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-30 16:55:37', 5);
INSERT INTO `sys_oper_log` VALUES (171, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_zone\"}', NULL, 0, NULL, '2025-10-02 10:17:58', 72);
INSERT INTO `sys_oper_log` VALUES (172, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"area\",\"className\":\"GZone\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":152,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Zname\",\"columnComment\":\"区域名称\",\"columnId\":153,\"columnName\":\"zname\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"zname\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Pid\",\"columnComment\":\"父级代码\",\"columnId\":154,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Zonetype\",\"columnComment\":\"区域类别（1.项目 2.一级区域 3.二级区域 4.三级区域）\",\"columnId\":155,\"columnName\":\"zonetype\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"zon', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-02 10:20:13', 95);
INSERT INTO `sys_oper_log` VALUES (173, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"zone\",\"className\":\"GZone\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":152,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 10:20:13\",\"usableColumn\":false},{\"capJavaField\":\"Zname\",\"columnComment\":\"区域名称\",\"columnId\":153,\"columnName\":\"zname\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"zname\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 10:20:13\",\"usableColumn\":false},{\"capJavaField\":\"Pid\",\"columnComment\":\"父级代码\",\"columnId\":154,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":12,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 10:20:13\",\"usableColumn\":false},{\"capJavaField\":\"Zonetype\",\"columnComment\":\"区域类别（1.项目 2.一级区域 3.二级区域 4.三级区域）\",\"columnId\":155,\"columnName\":\"zonetype\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-02 10:22:11', 36);
INSERT INTO `sys_oper_log` VALUES (174, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_zone\"}', NULL, 0, NULL, '2025-10-02 10:26:07', 29);
INSERT INTO `sys_oper_log` VALUES (175, '区域管理', 2, 'com.ruoyi.system.controller.GZoneController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/zone', '127.0.0.1', '内网IP', '{\"children\":[],\"creator\":\"system\",\"creatorTime\":\"2025-10-02\",\"deleted\":0,\"id\":66,\"introduction\":\"浙江省重点特种电子技术研发项目，致力于特种电子设备、军用电子系统和高端电子元器件的研发与产业化，具有重要的战略意义和技术价值。\",\"lat\":30.2955,\"lng\":120.306,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"modifier\":\"system\",\"modifierTime\":\"2025-10-02\",\"params\":{},\"pid\":0,\"remark\":\"省级重点科研项目\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"特电项目\",\"zonetype\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-02 13:49:29', 27);
INSERT INTO `sys_oper_log` VALUES (176, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"project\",\"className\":\"GProject\",\"columns\":[{\"capJavaField\":\"Pid\",\"columnComment\":\"主键，g_zone表中，区域类别是项目的\",\"columnId\":137,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":11,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ProjectCode\",\"columnComment\":\"项目编码\",\"columnId\":138,\"columnName\":\"project_code\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"projectCode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":11,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"RegionText\",\"columnComment\":\"省市区文本\",\"columnId\":139,\"columnName\":\"region_text\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"regionText\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":11,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Province\",\"columnComment\":\"省\",\"columnId\":140,\"columnName\":\"province\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-02 15:17:27', 92);
INSERT INTO `sys_oper_log` VALUES (177, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_project\"}', NULL, 0, NULL, '2025-10-02 15:17:44', 167);
INSERT INTO `sys_oper_log` VALUES (178, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"projectCode\":\"123\"}', NULL, 1, 'Cannot invoke \"com.ruoyi.system.service.IGProjectService.insertGProject(com.ruoyi.system.domain.GProject)\" because \"this.gProjectService\" is null', '2025-10-02 15:51:56', 7);
INSERT INTO `sys_oper_log` VALUES (179, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"GBuilding\",\"columns\":[{\"capJavaField\":\"Pid\",\"columnComment\":\"主键，g_zone表中，区域类别是一级区域的\",\"columnId\":123,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Height\",\"columnComment\":\"建筑高度（米）\",\"columnId\":124,\"columnName\":\"height\",\"columnType\":\"decimal(6,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"height\",\"javaType\":\"BigDecimal\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Floors\",\"columnComment\":\"建筑层数（地上/地下）\",\"columnId\":125,\"columnName\":\"floors\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"floors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Area\",\"columnComment\":\"建筑面积（平方米）\",\"columnId\":126,\"columnName\":\"area\",\"columnType\":\"decimal(12,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-02 15:54:30', 47);
INSERT INTO `sys_oper_log` VALUES (180, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_building\"}', NULL, 0, NULL, '2025-10-02 15:54:35', 114);
INSERT INTO `sys_oper_log` VALUES (181, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"building\",\"className\":\"GBuilding\",\"columns\":[{\"capJavaField\":\"Pid\",\"columnComment\":\"主键，g_zone表中，区域类别是一级区域的\",\"columnId\":123,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 15:54:30\",\"usableColumn\":false},{\"capJavaField\":\"Height\",\"columnComment\":\"建筑高度（米）\",\"columnId\":124,\"columnName\":\"height\",\"columnType\":\"decimal(6,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"height\",\"javaType\":\"BigDecimal\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 15:54:30\",\"usableColumn\":false},{\"capJavaField\":\"Floors\",\"columnComment\":\"建筑层数（地上/地下）\",\"columnId\":125,\"columnName\":\"floors\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"floors\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":10,\"updateBy\":\"\",\"updateTime\":\"2025-10-02 15:54:30\",\"usableColumn\":false},{\"capJavaField\":\"Area\",\"columnComment\":\"建筑面积（平方米）\",\"columnId\":126,\"columnName\":\"area\",\"columnType\":\"decimal(12,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"incr', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 14:04:53', 56);
INSERT INTO `sys_oper_log` VALUES (182, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_building\"}', NULL, 0, NULL, '2025-10-05 14:04:57', 111);
INSERT INTO `sys_oper_log` VALUES (183, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"projectCode\":\"123\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GProjectMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GProjectMapper.insertGProject-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_project          ( project_code,                                                                              address )           values ( ?,                                                                              ? )\r\n### Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\n; Field \'pid\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'pid\' doesn\'t have a default value', '2025-10-05 14:52:16', 143);
INSERT INTO `sys_oper_log` VALUES (184, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"projectCode\":\"123\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GProjectMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GProjectMapper.insertGProject-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_project          ( project_code,                                                                              address )           values ( ?,                                                                              ? )\r\n### Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\n; Field \'pid\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'pid\' doesn\'t have a default value', '2025-10-05 14:52:22', 3);
INSERT INTO `sys_oper_log` VALUES (185, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"projectCode\":\"111\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GProjectMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GProjectMapper.insertGProject-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_project          ( project_code,                                                                              address )           values ( ?,                                                                              ? )\r\n### Cause: java.sql.SQLException: Field \'pid\' doesn\'t have a default value\n; Field \'pid\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'pid\' doesn\'t have a default value', '2025-10-05 14:52:37', 5);
INSERT INTO `sys_oper_log` VALUES (186, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"pid\":1,\"projectCode\":\"123\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 15:06:37', 13);
INSERT INTO `sys_oper_log` VALUES (187, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"params\":{},\"pid\":1,\"projectCode\":\"123\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 15:10:46', 106);
INSERT INTO `sys_oper_log` VALUES (188, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"beijing\",\"dongcheng\"],\"assignedPerson\":\"person1\",\"clientUnit\":\"unit1\",\"lat\":\"123\",\"lng\":\"123\",\"pid\":1,\"projectCode\":\"123\",\"projectName\":\"123\",\"zoneType\":1}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GProjectMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GProjectMapper.insertGProject-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_project\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'\' at line 1', '2025-10-05 15:21:51', 52);
INSERT INTO `sys_oper_log` VALUES (189, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"beijing\",\"dongcheng\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"123\",\"lng\":\"123\",\"pid\":1,\"projectCode\":\"21321\",\"projectName\":\"1231\",\"zoneType\":1}', NULL, 1, 'Index 2 out of bounds for length 2', '2025-10-05 17:50:16', 19);
INSERT INTO `sys_oper_log` VALUES (190, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/67', '127.0.0.1', '内网IP', '[67]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 17:52:20', 8);
INSERT INTO `sys_oper_log` VALUES (191, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"hangzhou\",\"shangcheng\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"12\",\"lng\":\"12\",\"pid\":1,\"projectCode\":\"123\",\"projectName\":\"1231\",\"zoneType\":1}', NULL, 1, 'Index 2 out of bounds for length 2', '2025-10-05 17:52:54', 5);
INSERT INTO `sys_oper_log` VALUES (192, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"mishixiang\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"123\",\"lng\":\"12341\",\"pid\":1,\"projectCode\":\"123123\",\"projectName\":\"123123\",\"zoneType\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 17:58:27', 11);
INSERT INTO `sys_oper_log` VALUES (193, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/68', '127.0.0.1', '内网IP', '[68]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 17:59:24', 5);
INSERT INTO `sys_oper_log` VALUES (194, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/69', '127.0.0.1', '内网IP', '[69]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 18:16:11', 13);
INSERT INTO `sys_oper_log` VALUES (195, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"xiahe\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"123\",\"lng\":\"123\",\"pid\":1,\"projectCode\":\"12334\",\"projectName\":\"123\",\"zoneType\":1}', NULL, 1, 'Invalid bound statement (not found): com.ruoyi.system.mapper.GZoneMapper.selectIdByZNameAndPid', '2025-10-05 18:16:26', 11);
INSERT INTO `sys_oper_log` VALUES (196, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"xiahe\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"123\",\"lng\":\"123\",\"pid\":1,\"projectCode\":\"12334\",\"projectName\":\"123\",\"zoneType\":1}', NULL, 1, 'nested exception is org.apache.ibatis.binding.BindingException: Parameter \'name\' not found. Available parameters are [arg1, arg0, param1, param2]', '2025-10-05 18:19:29', 68);
INSERT INTO `sys_oper_log` VALUES (197, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"zhejiang\",\"hangzhou\",\"shangcheng\",\"hubin\"],\"assignedPerson\":\"李四\",\"clientUnit\":\"特电\",\"lat\":\"123\",\"lng\":\"1241\",\"pid\":1,\"projectCode\":\"12315412\",\"projectName\":\"124142\",\"zoneType\":1}', NULL, 1, 'nested exception is org.apache.ibatis.binding.BindingException: Parameter \'name\' not found. Available parameters are [arg1, arg0, param1, param2]', '2025-10-05 18:19:47', 8);
INSERT INTO `sys_oper_log` VALUES (198, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/70', '127.0.0.1', '内网IP', '[70]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 18:21:10', 15);
INSERT INTO `sys_oper_log` VALUES (199, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/71', '127.0.0.1', '内网IP', '[71]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 18:21:13', 4);
INSERT INTO `sys_oper_log` VALUES (200, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/72', '127.0.0.1', '内网IP', '[72]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 18:21:16', 6);
INSERT INTO `sys_oper_log` VALUES (201, '项目', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/project', '127.0.0.1', '内网IP', '{\"address\":\"杭电路1号杭州电子科技大学信息工程学院\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"hushu\"],\"assignedPerson\":\"张三\",\"clientUnit\":\"特电\",\"lat\":\"1323\",\"lng\":\"1234\",\"pid\":1,\"projectCode\":\"123124\",\"projectName\":\"3123\",\"zoneType\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-05 18:22:19', 76);
INSERT INTO `sys_oper_log` VALUES (202, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-24 16:55:21\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2027,\"menuName\":\"区域管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"AMI\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 16:25:36', 33);
INSERT INTO `sys_oper_log` VALUES (203, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"eye-open\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"设备管理\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"AMI\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 16:27:20', 15);
INSERT INTO `sys_oper_log` VALUES (204, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"设备管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2041,\"path\":\"AMI/equipment\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 16:28:26', 11);
INSERT INTO `sys_oper_log` VALUES (205, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/zone/index\",\"createTime\":\"2025-10-02 10:27:55\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2035,\"menuName\":\"区域管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2027,\"path\":\"zone\",\"perms\":\"system:zone:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 16:28:56', 11);
INSERT INTO `sys_oper_log` VALUES (206, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-09-24 16:55:21\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2027,\"menuName\":\"区域管理\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 16:29:43', 11);
INSERT INTO `sys_oper_log` VALUES (207, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/c_device', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 18:28:27', 116);
INSERT INTO `sys_oper_log` VALUES (208, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/c_device', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 18:28:51', 60);
INSERT INTO `sys_oper_log` VALUES (209, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"device\",\"className\":\"CDevice\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":48,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-08 18:28:51\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名称\",\"columnId\":49,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-08 18:28:51\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"所属类别 c_category表关联\",\"columnId\":50,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-08 18:28:51\",\"usableColumn\":false},{\"capJavaField\":\"ProjectId\",\"columnComment\":\"所属项目\",\"columnId\":51,\"columnName\":\"project_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 18:29:30', 48);
INSERT INTO `sys_oper_log` VALUES (210, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"c_device\"}', NULL, 0, NULL, '2025-10-08 18:29:34', 135);
INSERT INTO `sys_oper_log` VALUES (211, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/device/index\",\"createTime\":\"2025-10-08 16:28:26\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"设备管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2041,\"path\":\"equipment\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 18:39:19', 36);
INSERT INTO `sys_oper_log` VALUES (212, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/device/index\",\"createTime\":\"2025-10-08 16:28:26\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"设备管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2041,\"path\":\"equipment\",\"perms\":\"system:device:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-08 18:39:38', 5);
INSERT INTO `sys_oper_log` VALUES (213, '建筑', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/building', '127.0.0.1', '内网IP', '{\"address\":\"1251231\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"hushu\"],\"buildingArea\":320,\"buildingHeight\":12,\"buildingName\":\"12314\",\"buildingType\":\"commercial\",\"floorCount\":5,\"lat\":312,\"lng\":12,\"parentZone\":\"\",\"projectId\":2,\"remark\":\"1254123\",\"usageType\":\"office\",\"zoneType\":2}', NULL, 1, 'Cannot invoke \"com.ruoyi.system.domain.GZone.getManager()\" because \"PZone\" is null', '2025-10-10 17:19:52', 9);
INSERT INTO `sys_oper_log` VALUES (214, '建筑', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/building', '127.0.0.1', '内网IP', '{\"address\":\"12314\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"hushu\"],\"buildingArea\":123,\"buildingHeight\":123,\"buildingName\":\"1234\",\"buildingType\":\"residential\",\"floorCount\":5,\"lat\":312,\"lng\":124,\"parentZone\":\"\",\"projectId\":2,\"remark\":\"1231241\",\"usageType\":\"office\",\"zoneType\":2}', NULL, 1, 'Cannot invoke \"com.ruoyi.system.domain.GZone.getManager()\" because \"PZone\" is null', '2025-10-10 17:20:47', 4);
INSERT INTO `sys_oper_log` VALUES (215, '建筑', 1, 'com.ruoyi.system.controller.GZoneController.add()', 'POST', 1, 'admin', '研发部门', '/system/zone/building', '127.0.0.1', '内网IP', '{\"address\":\"123321\",\"area\":[\"zhejiang\",\"hangzhou\",\"gongshu\",\"hushu\"],\"buildingArea\":321,\"buildingHeight\":123,\"buildingName\":\"教学楼D楼\",\"buildingType\":\"residential\",\"floorCount\":5,\"lat\":321,\"lng\":123,\"parentZone\":\"\",\"projectId\":2,\"remark\":\"123321\",\"usageType\":\"office\",\"zoneType\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-10 17:25:15', 72);
INSERT INTO `sys_oper_log` VALUES (216, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"类别管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"Category\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:12:55', 14);
INSERT INTO `sys_oper_log` VALUES (217, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2049,\"path\":\"/category\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:13:33', 13);
INSERT INTO `sys_oper_log` VALUES (218, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/category\",\"createTime\":\"2025-10-13 13:13:33\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2050,\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2049,\"path\":\"category\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:13:59', 10);
INSERT INTO `sys_oper_log` VALUES (219, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/category\",\"createTime\":\"2025-10-13 13:13:33\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2050,\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2049,\"path\":\"category\",\"perms\":\"system:category:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:14:11', 12);
INSERT INTO `sys_oper_log` VALUES (220, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/c_device', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:35:46', 108);
INSERT INTO `sys_oper_log` VALUES (221, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/c_rsdevice', '127.0.0.1', '内网IP', '{}', NULL, 1, '同步数据失败，原表结构不存在', '2025-10-13 13:35:49', 16);
INSERT INTO `sys_oper_log` VALUES (222, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/7', '127.0.0.1', '内网IP', '[7]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:35:54', 14);
INSERT INTO `sys_oper_log` VALUES (223, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"device\",\"className\":\"CDevice\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":48,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-13 13:35:46\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名称\",\"columnId\":49,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-13 13:35:46\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"所属类别 c_category表关联\",\"columnId\":50,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2025-10-13 13:35:46\",\"usableColumn\":false},{\"capJavaField\":\"ProjectId\",\"columnComment\":\"所属项目\",\"columnId\":51,\"columnName\":\"project_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:23:57\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:36:35', 65);
INSERT INTO `sys_oper_log` VALUES (224, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"c_device\"}', NULL, 0, NULL, '2025-10-13 13:36:41', 75);
INSERT INTO `sys_oper_log` VALUES (225, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2051', '127.0.0.1', '内网IP', '2051', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-10-13 13:56:51', 7);
INSERT INTO `sys_oper_log` VALUES (226, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2052', '127.0.0.1', '内网IP', '2052', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:56:59', 22);
INSERT INTO `sys_oper_log` VALUES (227, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2053', '127.0.0.1', '内网IP', '2053', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:57:00', 8);
INSERT INTO `sys_oper_log` VALUES (228, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2054', '127.0.0.1', '内网IP', '2054', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:57:02', 10);
INSERT INTO `sys_oper_log` VALUES (229, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2055', '127.0.0.1', '内网IP', '2055', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:57:04', 8);
INSERT INTO `sys_oper_log` VALUES (230, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2056', '127.0.0.1', '内网IP', '2056', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:57:06', 11);
INSERT INTO `sys_oper_log` VALUES (231, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2051', '127.0.0.1', '内网IP', '2051', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:57:07', 9);
INSERT INTO `sys_oper_log` VALUES (232, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2043', '127.0.0.1', '内网IP', '2043', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-10-13 13:59:22', 3);
INSERT INTO `sys_oper_log` VALUES (233, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2044', '127.0.0.1', '内网IP', '2044', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:27', 12);
INSERT INTO `sys_oper_log` VALUES (234, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2043', '127.0.0.1', '内网IP', '2043', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2025-10-13 13:59:29', 3);
INSERT INTO `sys_oper_log` VALUES (235, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2045', '127.0.0.1', '内网IP', '2045', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:31', 10);
INSERT INTO `sys_oper_log` VALUES (236, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2046', '127.0.0.1', '内网IP', '2046', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:33', 9);
INSERT INTO `sys_oper_log` VALUES (237, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2047', '127.0.0.1', '内网IP', '2047', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:35', 10);
INSERT INTO `sys_oper_log` VALUES (238, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2048', '127.0.0.1', '内网IP', '2048', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:37', 9);
INSERT INTO `sys_oper_log` VALUES (239, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2043', '127.0.0.1', '内网IP', '2043', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 13:59:39', 8);
INSERT INTO `sys_oper_log` VALUES (240, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"类别管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"Category\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:00:24', 14);
INSERT INTO `sys_oper_log` VALUES (241, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-10-13 14:00:24\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2057,\"menuName\":\"类别管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"CGY\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:00:38', 10);
INSERT INTO `sys_oper_log` VALUES (242, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2057,\"path\":\"category\",\"routeName\":\"category\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:01:34', 8);
INSERT INTO `sys_oper_log` VALUES (243, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/device/index\",\"createTime\":\"2025-10-08 16:28:26\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"设备管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2041,\"path\":\"equipment\",\"perms\":\"system:device:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:01:42', 6);
INSERT INTO `sys_oper_log` VALUES (244, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-10-13 14:01:34\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2058,\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2057,\"path\":\"category\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:02:21', 7);
INSERT INTO `sys_oper_log` VALUES (245, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/category/index\",\"createTime\":\"2025-10-13 14:01:34\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2058,\"menuName\":\"类别管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2057,\"path\":\"category\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:02:36', 9);
INSERT INTO `sys_oper_log` VALUES (246, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"category\",\"className\":\"GCategory\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"主键，自增\",\"columnId\":171,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:15\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Cname\",\"columnComment\":\"类别名称\",\"columnId\":172,\"columnName\":\"cname\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"cname\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Pid\",\"columnComment\":\"父节点\",\"columnId\":173,\"columnName\":\"pid\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"pid\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":13,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Ctype\",\"columnComment\":\"结点类型（0分支，1结点）\",\"columnId\":174,\"columnName\":\"ctype\",\"columnType\":\"tinyint(1)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-21 17:24:15\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"ctype\",\"javaType', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:06:05', 32);
INSERT INTO `sys_oper_log` VALUES (247, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"g_category\"}', NULL, 0, NULL, '2025-10-13 14:06:09', 24);
INSERT INTO `sys_oper_log` VALUES (248, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{},\"parentDeviceId\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:43:47', 13);
INSERT INTO `sys_oper_log` VALUES (249, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{},\"parentDeviceId\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:43:50', 5);
INSERT INTO `sys_oper_log` VALUES (250, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":3,\"params\":{},\"parentDeviceId\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:43:53', 8);
INSERT INTO `sys_oper_log` VALUES (251, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":3,\"params\":{},\"parentDeviceId\":6}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:44:00', 6);
INSERT INTO `sys_oper_log` VALUES (252, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":3,\"params\":{},\"parentDeviceId\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:44:07', 4);
INSERT INTO `sys_oper_log` VALUES (253, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":3,\"params\":{},\"parentDeviceId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:44:10', 7);
INSERT INTO `sys_oper_log` VALUES (254, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":3,\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 3\' at line 3\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.updateCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update c_device                    where id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 3\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 3\' at line 3', '2025-10-13 14:44:14', 32);
INSERT INTO `sys_oper_log` VALUES (255, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 2\' at line 3\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.updateCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update c_device                    where id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 2\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 2\' at line 3', '2025-10-13 14:44:16', 2);
INSERT INTO `sys_oper_log` VALUES (256, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"parentDeviceId\":12}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:18', 7);
INSERT INTO `sys_oper_log` VALUES (257, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"parentDeviceId\":11}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:20', 6);
INSERT INTO `sys_oper_log` VALUES (258, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"parentDeviceId\":11}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:22', 2);
INSERT INTO `sys_oper_log` VALUES (259, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"parentDeviceId\":11}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:23', 1);
INSERT INTO `sys_oper_log` VALUES (260, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{},\"parentDeviceId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:30', 6);
INSERT INTO `sys_oper_log` VALUES (261, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":16,\"params\":{},\"parentDeviceId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:36', 4);
INSERT INTO `sys_oper_log` VALUES (262, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":20,\"params\":{},\"parentDeviceId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:45:39', 8);
INSERT INTO `sys_oper_log` VALUES (263, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{},\"pid\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:52:47', 9);
INSERT INTO `sys_oper_log` VALUES (264, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":11,\"params\":{},\"pid\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:52:52', 9);
INSERT INTO `sys_oper_log` VALUES (265, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":10,\"params\":{},\"pid\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 14:53:27', 2);
INSERT INTO `sys_oper_log` VALUES (266, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":10,\"params\":{},\"pid\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 15:01:40', 7);
INSERT INTO `sys_oper_log` VALUES (267, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":10,\"params\":{},\"pid\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-13 15:01:41', 5);
INSERT INTO `sys_oper_log` VALUES (268, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{},\"parentDeviceId\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:28:04', 27);
INSERT INTO `sys_oper_log` VALUES (269, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":2,\"params\":{},\"parentDeviceId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:28:07', 7);
INSERT INTO `sys_oper_log` VALUES (270, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"pid\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:28:15', 10);
INSERT INTO `sys_oper_log` VALUES (271, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{},\"pid\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:28:17', 8);
INSERT INTO `sys_oper_log` VALUES (272, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{},\"parentDeviceId\":13}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:47:56', 9);
INSERT INTO `sys_oper_log` VALUES (273, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.updateCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update c_device                    where id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3', '2025-10-17 15:48:02', 49);
INSERT INTO `sys_oper_log` VALUES (274, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{}}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.updateCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update c_device                    where id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'where id = 12\' at line 3', '2025-10-17 15:48:04', 2);
INSERT INTO `sys_oper_log` VALUES (275, '设施设备', 2, 'com.ruoyi.system.controller.CDeviceController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":12,\"params\":{},\"parentDeviceId\":11}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 15:48:07', 8);
INSERT INTO `sys_oper_log` VALUES (276, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"124\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"1231\",\"projectId\":2,\"remark\":\"12341\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:05:02', 161);
INSERT INTO `sys_oper_log` VALUES (277, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"3123\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:10:31', 88);
INSERT INTO `sys_oper_log` VALUES (278, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"3123\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:10:36', 2);
INSERT INTO `sys_oper_log` VALUES (279, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"123\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"office\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:10:56', 3);
INSERT INTO `sys_oper_log` VALUES (280, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"123\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"office\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:11:54', 90);
INSERT INTO `sys_oper_log` VALUES (281, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"123\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":33,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"124123\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\",\"zoneType\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2025-10-19 16:14:32', 21);
INSERT INTO `sys_oper_log` VALUES (282, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/75', '127.0.0.1', '内网IP', '[75]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 16:15:56', 8);
INSERT INTO `sys_oper_log` VALUES (283, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"2312\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"133\",\"projectId\":2,\"remark\":\"12331\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\",\"zoneType\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2025-10-19 16:18:02', 4);
INSERT INTO `sys_oper_log` VALUES (284, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"321\",\"lat\":30.294935,\"lng\":120.305304,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":29,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:24:51', 83);
INSERT INTO `sys_oper_log` VALUES (285, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"123\",\"lat\":30.294835,\"lng\":120.305204,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":8,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"office\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\"}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\GZoneMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GZoneMapper.insertGZone-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into g_zone          ( zname,             pid,                          plan_map,                          evacuation_map,             manager,             manager_phone,             safety_officer,             safety_officer_phone,             lng,             lat,             remark )           values ( ?,             ?,                          ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value\n; Field \'zonetype\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'zonetype\' doesn\'t have a default value', '2025-10-19 16:26:52', 11);
INSERT INTO `sys_oper_log` VALUES (286, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"321\",\"lat\":30.294835,\"lng\":120.305204,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":8,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"123\",\"roomType\":\"office\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\",\"zonetype\":4}', '{\"msg\":\"操作失败\",\"code\":500}', 0, NULL, '2025-10-19 16:32:24', 155);
INSERT INTO `sys_oper_log` VALUES (287, '区域管理', 3, 'com.ruoyi.system.controller.GZoneController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/zone/77', '127.0.0.1', '内网IP', '[77]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 16:36:06', 15);
INSERT INTO `sys_oper_log` VALUES (288, '区域管理', 1, 'com.ruoyi.system.controller.GZoneController.addClassroom()', 'POST', 1, 'admin', '研发部门', '/system/zone/room', '127.0.0.1', '内网IP', '{\"evacuationMap\":\"231\",\"lat\":30.294835,\"lng\":120.305204,\"manager\":\"张三\",\"managerPhone\":\"13800138001\",\"pid\":8,\"planMap\":\"123\",\"projectId\":2,\"remark\":\"12312\",\"roomType\":\"meeting\",\"safetyOfficer\":\"李四\",\"safetyOfficerPhone\":\"13900139001\",\"zname\":\"213\",\"zonetype\":4}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 16:36:21', 18);
INSERT INTO `sys_oper_log` VALUES (289, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":13,\"params\":{},\"pid\":0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:49:51', 24);
INSERT INTO `sys_oper_log` VALUES (290, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":11,\"params\":{},\"pid\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:49:53', 9);
INSERT INTO `sys_oper_log` VALUES (291, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":23,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:04', 4);
INSERT INTO `sys_oper_log` VALUES (292, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":21,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:05', 3);
INSERT INTO `sys_oper_log` VALUES (293, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":23,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:06', 2);
INSERT INTO `sys_oper_log` VALUES (294, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":23,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:07', 4);
INSERT INTO `sys_oper_log` VALUES (295, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":23,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:08', 3);
INSERT INTO `sys_oper_log` VALUES (296, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":22,\"params\":{},\"pid\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:16', 3);
INSERT INTO `sys_oper_log` VALUES (297, '类别', 2, 'com.ruoyi.system.controller.GCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"children\":[],\"id\":27,\"params\":{},\"pid\":7}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 16:52:19', 4);
INSERT INTO `sys_oper_log` VALUES (298, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/10/21/bdf9bc08e05642b9bba88e8441b01769.png\",\"code\":200}', 0, NULL, '2025-10-21 17:00:09', 68);
INSERT INTO `sys_oper_log` VALUES (299, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/10/21/2dbeb0a6728844c5b0358d48b208927d.png\",\"code\":200}', 0, NULL, '2025-10-21 17:00:17', 28);
INSERT INTO `sys_oper_log` VALUES (300, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"ry@163.com\",\"nickName\":\"兰得\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 17:00:38', 20);
INSERT INTO `sys_oper_log` VALUES (301, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"123\",\"categoryId\":3,\"children\":[],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":123,\"lng\":123,\"location\":\"一楼厕所边\",\"model\":\"123\",\"name\":\"123\",\"params\":{},\"parentDeviceId\":14,\"productionDate\":\"2025-10-14\",\"projectId\":2,\"remark\":\"123\",\"startDate\":\"2025-10-30\",\"warrantyStart\":\"2025-10-29\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,             parent_device_id,             production_date,             start_date,             warranty_start,                          device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 15:47:08', 79);
INSERT INTO `sys_oper_log` VALUES (302, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"123\",\"categoryId\":2,\"children\":[],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":312,\"lng\":123,\"location\":\"123\",\"model\":\"123\",\"name\":\"123\",\"params\":{},\"parentDeviceId\":1,\"productionDate\":\"2025-10-09\",\"projectId\":2,\"remark\":\"123\",\"serviceLife\":123,\"startDate\":\"2025-10-31\",\"warrantyStart\":\"2025-10-08\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,             parent_device_id,             production_date,             start_date,             warranty_start,             service_life,             device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 15:48:02', 4);
INSERT INTO `sys_oper_log` VALUES (303, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"123\",\"categoryId\":2,\"childDeviceIds\":[2,8],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":312,\"lng\":123,\"location\":\"123\",\"model\":\"123\",\"name\":\"123\",\"parentDeviceId\":1,\"productionDate\":\"2025-10-09\",\"projectId\":2,\"remark\":\"123\",\"serviceLife\":123,\"startDate\":\"2025-10-31\",\"warrantyStart\":\"2025-10-08\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-24 16:00:38', 11);
INSERT INTO `sys_oper_log` VALUES (304, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"海澜\",\"categoryId\":1,\"childDeviceIds\":[2,8],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":312,\"lng\":123,\"location\":\"门把手旁\",\"model\":\"T1000\",\"name\":\"消防总具\",\"productionDate\":\"2025-10-22\",\"projectId\":2,\"remark\":\"123\",\"startDate\":\"2025-10-29\",\"warrantyStart\":\"2025-10-22\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,                          production_date,             start_date,             warranty_start,                          device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,                          ?,             ?,             ?,                          ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 16:22:11', 116);
INSERT INTO `sys_oper_log` VALUES (305, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"蔚蓝\",\"categoryId\":1,\"childDeviceIds\":[2,8],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":321,\"lng\":123,\"location\":\"门把手旁\",\"model\":\"T001\",\"name\":\"消防总系\",\"productionDate\":\"2025-10-30\",\"projectId\":2,\"remark\":\"123\",\"startDate\":\"2025-10-31\",\"warrantyStart\":\"2025-10-30\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,                          production_date,             start_date,             warranty_start,                          device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,                          ?,             ?,             ?,                          ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 17:04:38', 57);
INSERT INTO `sys_oper_log` VALUES (306, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"蔚蓝\",\"categoryId\":1,\"childDeviceIds\":[2,8],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":312,\"lng\":123,\"location\":\"门把手\",\"model\":\"T001\",\"name\":\"消防\",\"productionDate\":\"2025-10-27\",\"projectId\":2,\"remark\":\"123\",\"startDate\":\"2025-10-31\",\"warrantyStart\":\"2025-10-27\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,                          production_date,             start_date,             warranty_start,                          device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,                          ?,             ?,             ?,                          ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 17:05:54', 5);
INSERT INTO `sys_oper_log` VALUES (307, '设施设备', 1, 'com.ruoyi.system.controller.CDeviceController.add()', 'POST', 1, 'admin', '研发部门', '/system/device', '127.0.0.1', '内网IP', '{\"bindStatus\":0,\"brand\":\"蔚蓝\",\"categoryId\":1,\"childDeviceIds\":[2,8],\"deviceStatus\":1,\"isBus\":0,\"isHost\":1,\"lat\":312,\"lng\":123,\"location\":\"门把手\",\"model\":\"T001\",\"name\":\"消防\",\"productionDate\":\"2025-10-29\",\"projectId\":2,\"remark\":\"123\",\"serviceLife\":123,\"startDate\":\"2025-10-31\",\"warrantyStart\":\"2025-10-29\",\"zoneId1\":1,\"zoneId2\":2,\"zoneId3\":3}', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\r\n### The error may exist in file [A:\\desktopA\\若以\\RuoYi-Vue\\ruoyi-admin\\target\\classes\\mapper\\system\\CDeviceMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.CDeviceMapper.insertCDevice-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into c_device          ( name,             category_id,             project_id,             zone_id1,             zone_id2,             zone_id3,             location,                          brand,             model,             is_host,             is_bus,                          production_date,             start_date,             warranty_start,             service_life,             device_status,             bind_status,                                                    lng,             lat,             remark )           values ( ?,             ?,             ?,             ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,                          ?,             ?,             ?,             ?,             ?,             ?,                                                    ?,             ?,             ? )\r\n### Cause: java.sql.SQLException: Field \'related_location\' doesn\'t have a default value\n; Field \'related_location\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'related_location\' doesn\'t have a default value', '2025-10-24 17:07:16', 4);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-09-17 10:41:42', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-09-17 10:41:42', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-09-17 10:41:42', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '兰得', '00', 'ry@163.com', '15888888888', '1', '/profile/avatar/2025/10/21/2dbeb0a6728844c5b0358d48b208927d.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-24 17:03:38', '2025-09-17 10:41:42', 'admin', '2025-09-17 10:41:42', '', '2025-10-21 17:00:38', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-09-17 10:41:42', '2025-09-17 10:41:42', 'admin', '2025-09-17 10:41:42', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;
