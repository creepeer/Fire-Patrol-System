
# 消防巡检智能管理系统


## 平台简介

消防巡检智能管理系统是一款专为消防安全领域设计的开源（或商业）一体化管理平台。系统旨在帮助物业、企业、消防维保公司实现消防设施的数字化、标准化、智能化巡检与管理，有效预防火灾隐患，落实消防安全主体责任。

系统基于主流的前后端分离架构构建，界面简洁直观，操作流程贴合实际业务场景，支持快速部署与二次开发。

- **前端技术**：采用 Vue.js 全家桶，结合 Element UI 组件库，提供流畅的用户交互体验。
- **后端技术**：基于 Spring Boot 框架，集成 Spring Security 安全框架与 Redis 缓存技术，确保系统的高性能与高安全性。
- **核心特性**：
  - **设备全生命周期管理**：从设备建档、巡检计划、任务执行到维修报废，全程跟踪。
  - **标准化巡检作业**：支持自定义巡检项、巡检计划（日/周/月/季），并生成标准化作业指导。
  - **多端协同**：支持PC端后台管理与移动端（PDA/手机）现场作业，数据实时同步。
  - **数据可视化**：通过大屏驾驶舱直观展示设备完好率、巡检完成率、隐患分布等关键指标。
  - **权限严密控制**：精细化的角色与数据权限，区分超级管理员、公司管理员、普通巡检员等不同角色。
- **高效开发**：内置强大的代码生成工具，可快速针对消防业务表（如设备、点位、巡检记录）生成前后端代码，极大提升开发效率。

## 核心业务功能

本系统围绕消防巡检业务闭环设计，主要包含以下核心模块：

1. **首页驾驶舱**
   - 全局展示设备总数、今日巡检任务、设备故障率、即将过期设备等关键数据。
   - 通过ECharts图表展示各区域设备分布、巡检完成趋势、隐患分类统计。
2. **基础数据中心**
   - **公司/项目管理**：管理使用本系统的物业公司、维保单位或内部项目信息，支持多租户或集团化管理。
   - **设备类别管理**：树形结构管理消防设备分类（如：灭火器、消火栓、喷淋系统、烟感探测器），支持设置该类别的默认巡检周期和检查项。
   - **设备档案管理**：为每一个消防设备建立唯一的“身份档案”，记录设备编号、类型、所在位置（支持地图坐标）、生产日期、有效期、生产厂商等。
3. **巡检任务与执行**
   - **巡检计划制定**：根据设备类别或具体位置，制定周期性的巡检计划（例如：灭火器每月检查一次，消防泵每季度测试一次）。
   - **任务派发**：系统根据计划自动生成巡检任务，并指派给指定的巡检员或班组。
   - **现场巡检（移动端）**：巡检员通过手机扫描设备二维码，按标准检查项逐项确认（拍照、填写数值、勾选正常/异常），如发现异常可直接上报隐患。
   - **任务审核**：管理员对完成的巡检任务进行抽检或审核，确保巡检质量。
4. **隐患与维修管理**
   - **隐患上报**：巡检过程中发现的设备故障、过期、损坏等问题，一键转为隐患记录。
   - **维修处理**：将隐患指派给维修人员，跟踪维修进度，记录维修结果与更换配件。
   - **历史记录**：完整保存设备的所有巡检、隐患、维修历史，形成设备健康档案。
5. **知识库与文档管理**
   - **知识库管理**：集中存储消防相关文档，如《消防设施操作规程》、《应急预案演练方案》、《消防安全培训资料》等。
   - **通知公告**：发布消防安全通知、待办事项提醒，确保信息传达到位。
6. **系统管理**
   - **用户与权限**：管理所有系统用户，分配不同的角色（如：系统管理员、公司主管、巡检员、维修员），控制菜单可见性与数据操作范围。
   - **字典与参数**：维护系统内常用的固定数据，如“巡检结果”、“隐患等级”、“维修状态”等。
   - **日志监控**：记录系统的操作日志、登录日志，监控服务器运行状态，保障系统稳定。

## 在线体验

- 演示地址：[[智巡科防](https://www.zjhzqsh.com/index)](http://fire.your-domain.com/)

//oscimg.oschina.net/oscnet/cd1f90be5f2684f4560c9519c0f2a232ee8.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/1cbcf0e6f257c7d3a063c0e3f2ff989e4b3.jpg"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-8074972883b5ba0622e13246738ebba237a.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-9f88719cdfca9af2e58b352a20e23d43b12.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-39bf2584ec3a529b0d5a3b70d15c9b37646.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-936ec82d1f4872e1bc980927654b6007307.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-b2d62ceb95d2dd9b3fbe157bb70d26001e9.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-d67451d308b7a79ad6819723396f7c3d77a.png"/></td>
    </tr>	 
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/5e8c387724954459291aafd5eb52b456f53.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/644e78da53c2e92a95dfda4f76e6d117c4b.jpg"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-8370a0d02977eebf6dbf854c8450293c937.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-49003ed83f60f633e7153609a53a2b644f7.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-d4fe726319ece268d4746602c39cffc0621.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-c195234bbcd30be6927f037a6755e6ab69c.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/b6115bc8c31de52951982e509930b20684a.jpg"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-5e4daac0bb59612c5038448acbcef235e3a.png"/></td>
    </tr>
</table>