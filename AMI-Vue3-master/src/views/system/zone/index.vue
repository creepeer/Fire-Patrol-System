<template>
  <div class="app-container">
    <el-container class="layout-container">
      <!-- 左侧菜单侧边栏 -->
      <el-aside width="350px" class="sidebar">
        <el-card class="sidebar-card">
          <template #header>
            <div class="sidebar-header">
              <span class="header-title">区域管理</span>
              <div class="header-tools">
                <el-tooltip content="可滚动查看所有区域" placement="top">
                  <el-icon class="scroll-hint"><InfoFilled /></el-icon>
                </el-tooltip>
              </div>
            </div>
          </template>
          
          <!-- 顶级区域选择框 -->
          <div class="top-region-selector">
            <el-select
              v-model="selectedTopRegion"
              placeholder="请选择顶级区域"
              style="width: 100%"
              @change="handleTopRegionChange"
            >
              <el-option
                v-for="region in topLevelNodes"
                :key="region.id"
                :label="region.zname"
                :value="region.zname"
              >
                <div class="region-option">
                  <span class="region-name">{{ region.zname }}</span>
                </div>
              </el-option>
            </el-select>
          </div>

          <!-- 搜索输入框 -->
          <div class="tree-search">
            <el-input
              v-model="filterText"
              placeholder="输入关键字进行过滤"
              clearable
              prefix-icon="Search"
            />
          </div>

          <!-- 树形菜单容器 - 添加滚动区域 -->
          <div class="tree-container" ref="treeContainerRef">
            <el-tree
              v-loading="loading"
              :data="filteredTreeData"
              :props="treeProps"
              node-key="id"
              highlight-current
              :expand-on-click-node="false"
              :default-expand-all="isExpandAll"
              :filter-node-method="filterNode"
              @node-click="handleTreeNodeClick"
              class="zone-tree scrollable-tree"
              ref="treeRef"
            >
              <template #default="{ node, data }">
                <span class="custom-tree-node">
                  <span class="node-info">
                    <span class="zone-name">{{ data.zname }}</span>
                    <!-- 只显示项目和一级区域，不显示二级和三级区域 -->
                    <span v-if="data.zonetype === 1 || data.zonetype === 2" class="zone-type-tag">
                      {{ getZoneTypeText(data.zonetype) }}
                    </span>
                  </span>
                  <span class="tree-actions">
                    <el-button link type="primary" size="small" @click.stop="handleAdd(data)" title="添加子区域">
                      <el-icon><Plus /></el-icon>
                    </el-button>
                    <el-button link type="primary" size="small" @click.stop="handleUpdate(data)" title="编辑">
                      <el-icon><Edit /></el-icon>
                    </el-button>
                    <el-button link type="danger" size="small" @click.stop="handleDelete(data)" title="删除">
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </span>
                </span>
              </template>
            </el-tree>
          </div>
          
          <!-- 树形操作工具栏 -->
          <div class="tree-toolbar">
            <el-button-group>
              <el-button 
                size="small" 
                @click="scrollToTop" 
                title="滚动到顶部"
              >
                <el-icon><Top /></el-icon>
              </el-button>
              <el-button 
                size="small" 
                @click="scrollToBottom" 
                title="滚动到底部"
              >
                <el-icon><Bottom /></el-icon>
              </el-button>
              <el-button 
                size="small" 
                @click="toggleExpandAll" 
                :title="isExpandAll ? '折叠所有' : '展开所有'"
              >
                <el-icon><Sort /></el-icon>
                {{ isExpandAll ? '折叠' : '展开' }}
              </el-button>
            </el-button-group>
            
            <div class="tree-info">
              <span class="node-count">共 {{ totalNodeCount }} 个节点</span>
            </div>
          </div>
        </el-card>
      </el-aside>

      <!-- 右侧内容区域 -->
      <el-main class="main-content">
        <!-- 操作按钮和搜索 -->
        <div class="top-actions">
          <div class="left-actions">
            <el-form :model="queryParams" ref="queryRef" :inline="true" class="search-form">

              <el-form-item>
                <el-select
                  v-model="queryParams.zonetype"
                  placeholder="区域类别"
                  clearable
                  style="width: 120px"
                >
                  <el-option label="项目" :value="1" />
                  <el-option label="一级区域" :value="2" />
                  <el-option label="二级区域" :value="3" />
                  <el-option label="三级区域" :value="4" />
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
          
          <div class="right-actions">
            <el-button-group class="add-buttons">
              <el-button
                type="primary"
                icon="Plus"
                @click="handleAddProject"
                v-hasPermi="['system:zone:add']"
              >添加项目</el-button>
              <el-button
                type="success"
                icon="OfficeBuilding"
                @click="handleAddBuilding"
                v-hasPermi="['system:zone:add']"
              >添加楼栋</el-button>
              <el-button
                type="warning"
                icon="House"
                @click="handleAddRoom"
                v-hasPermi="['system:zone:add']"
              >添加房间</el-button>
            </el-button-group>
            <div class="action-tools">
              <el-button
                type="info"
                icon="Sort"
                @click="toggleExpandAll"
              >{{ isExpandAll ? '折叠' : '展开' }}</el-button>
              <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </div>
          </div>
        </div>

        <!-- 详情面板 - 根据节点类型显示不同内容 -->
        <div v-if="currentNode">
          <!-- 项目详情 -->
          <el-card v-if="currentNode.zonetype === 1" header="项目详情" class="detail-card">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="项目名称">{{ currentNode.zname }}</el-descriptions-item>
              <el-descriptions-item label="项目类别">{{ getZoneTypeText(currentNode.zonetype) }}</el-descriptions-item>
              <el-descriptions-item label="所属区域">{{ getParentName(currentNode.pid) }}</el-descriptions-item>
              <el-descriptions-item label="项目管理员">{{ currentNode.manager || '-' }}</el-descriptions-item>
              <el-descriptions-item label="管理员电话">{{ currentNode.managerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="安全责任人">{{ currentNode.safetyOfficer || '-' }}</el-descriptions-item>
              <el-descriptions-item label="责任人电话">{{ currentNode.safetyOfficerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="经纬度">
                {{ (currentNode.lng && currentNode.lat) ? `${currentNode.lng}, ${currentNode.lat}` : '-' }}
              </el-descriptions-item>
              <el-descriptions-item label="创建时间">
                {{ parseTime(currentNode.creatorTime, '{y}-{m}-{d} {h}:{i}') }}
              </el-descriptions-item>
              <el-descriptions-item label="项目简介" :span="2">
                {{ currentNode.introduction || '暂无简介' }}
              </el-descriptions-item>
              <el-descriptions-item label="备注" :span="2">
                {{ currentNode.remark || '暂无备注' }}
              </el-descriptions-item>
            </el-descriptions>

            <!-- 项目关联信息 -->
            <div class="related-info" v-if="projectDetail">
              <el-divider content-position="left">项目详细信息</el-divider>
              <el-descriptions :column="2" border>
                <el-descriptions-item label="项目编码">{{ projectDetail.projectCode || '-' }}</el-descriptions-item>
                <el-descriptions-item label="区域描述">{{ projectDetail.regionText || '-' }}</el-descriptions-item>
                <el-descriptions-item label="省市区">
                  {{ [projectDetail.province, projectDetail.city, projectDetail.district].filter(Boolean).join('/') || '-' }}
                </el-descriptions-item>
                <el-descriptions-item label="街道">{{ projectDetail.street || '-' }}</el-descriptions-item>
                <el-descriptions-item label="详细地址">{{ projectDetail.address || '-' }}</el-descriptions-item>
                <el-descriptions-item label="联系人">{{ projectDetail.contactPerson || '-' }}</el-descriptions-item>
                <el-descriptions-item label="联系电话">{{ projectDetail.contactPhone || '-' }}</el-descriptions-item>
              </el-descriptions>
            </div>

            <!-- 图片预览 -->
            <div class="image-preview" v-if="currentNode.planMap || currentNode.evacuationMap">
              <el-divider content-position="left">项目图纸</el-divider>
              <div class="image-grid">
                <div class="image-item" v-if="currentNode.planMap">
                  <div class="image-label">项目平面图</div>
                  <el-image
                    :src="currentNode.planMap"
                    :preview-src-list="[currentNode.planMap]"
                    fit="cover"
                    class="preview-image"
                  >
                    <template #error>
                      <div class="image-error">
                        <el-icon><Picture /></el-icon>
                        <span>图片加载失败</span>
                      </div>
                    </template>
                  </el-image>
                </div>
                <div class="image-item" v-if="currentNode.evacuationMap">
                  <div class="image-label">项目疏散图</div>
                  <el-image
                    :src="currentNode.evacuationMap"
                    :preview-src-list="[currentNode.evacuationMap]"
                    fit="cover"
                    class="preview-image"
                  >
                    <template #error>
                      <div class="image-error">
                        <el-icon><Picture /></el-icon>
                        <span>图片加载失败</span>
                      </div>
                    </template>
                  </el-image>
                </div>
              </div>
            </div>
          </el-card>

          <!-- 楼栋详情 -->
          <el-card v-else-if="currentNode.zonetype === 2" header="楼栋详情" class="detail-card">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="楼栋名称">{{ currentNode.zname }}</el-descriptions-item>
              <el-descriptions-item label="楼栋类别">{{ getZoneTypeText(currentNode.zonetype) }}</el-descriptions-item>
              <el-descriptions-item label="所属项目">{{ getParentName(currentNode.pid) }}</el-descriptions-item>
              <el-descriptions-item label="楼栋管理员">{{ currentNode.manager || '-' }}</el-descriptions-item>
              <el-descriptions-item label="管理员电话">{{ currentNode.managerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="安全责任人">{{ currentNode.safetyOfficer || '-' }}</el-descriptions-item>
              <el-descriptions-item label="责任人电话">{{ currentNode.safetyOfficerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="经纬度">
                {{ (currentNode.lng && currentNode.lat) ? `${currentNode.lng}, ${currentNode.lat}` : '-' }}
              </el-descriptions-item>
              <el-descriptions-item label="创建时间">
                {{ parseTime(currentNode.creatorTime, '{y}-{m}-{d} {h}:{i}') }}
              </el-descriptions-item>
              <el-descriptions-item label="楼栋简介" :span="2">
                {{ currentNode.introduction || '暂无简介' }}
              </el-descriptions-item>
              <el-descriptions-item label="备注" :span="2">
                {{ currentNode.remark || '暂无备注' }}
              </el-descriptions-item>
            </el-descriptions>

            <!-- 楼栋关联信息 -->
            <div class="related-info" v-if="buildingDetail">
              <el-divider content-position="left">楼栋详细信息</el-divider>
              <el-descriptions :column="2" border>
                <el-descriptions-item label="建筑高度">{{ buildingDetail.height ? buildingDetail.height + '米' : '-' }}</el-descriptions-item>
                <el-descriptions-item label="建筑层数">{{ buildingDetail.floors || '-' }}</el-descriptions-item>
                <el-descriptions-item label="建筑面积">{{ buildingDetail.area ? buildingDetail.area + '平方米' : '-' }}</el-descriptions-item>
                <el-descriptions-item label="建筑类别">{{ getBuildingTypeText(buildingDetail.buildingType) || buildingDetail.buildingType || '-' }}</el-descriptions-item>
                <el-descriptions-item label="使用性质">{{ getUsageTypeText(buildingDetail.usageType) || buildingDetail.usageType || '-' }}</el-descriptions-item>
                <el-descriptions-item label="详细地址">{{ buildingDetail.address || '-' }}</el-descriptions-item>
                <el-descriptions-item label="联系人员">{{ buildingDetail.contactPerson || '-' }}</el-descriptions-item>
                <el-descriptions-item label="联系电话">{{ buildingDetail.contactPhone || '-' }}</el-descriptions-item>
              </el-descriptions>
            </div>

            <!-- 图片预览 -->
            <div class="image-preview" v-if="currentNode.planMap || currentNode.evacuationMap">
              <el-divider content-position="left">楼栋图纸</el-divider>
              <div class="image-grid">
                <div class="image-item" v-if="currentNode.planMap">
                  <div class="image-label">楼栋平面图</div>
                  <el-image
                    :src="currentNode.planMap"
                    :preview-src-list="[currentNode.planMap]"
                    fit="cover"
                    class="preview-image"
                  >
                    <template #error>
                      <div class="image-error">
                        <el-icon><Picture /></el-icon>
                        <span>图片加载失败</span>
                      </div>
                    </template>
                  </el-image>
                </div>
                <div class="image-item" v-if="currentNode.evacuationMap">
                  <div class="image-label">楼栋疏散图</div>
                  <el-image
                    :src="currentNode.evacuationMap"
                    :preview-src-list="[currentNode.evacuationMap]"
                    fit="cover"
                    class="preview-image"
                  >
                    <template #error>
                      <div class="image-error">
                        <el-icon><Picture /></el-icon>
                        <span>图片加载失败</span>
                      </div>
                    </template>
                  </el-image>
                </div>
              </div>
            </div>
          </el-card>

          <!-- 房间详情 -->
          <el-card v-else header="房间详情" class="detail-card">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="房间名称">{{ currentNode.zname }}</el-descriptions-item>
              <el-descriptions-item label="房间类别">{{ getZoneTypeText(currentNode.zonetype) }}</el-descriptions-item>
              <el-descriptions-item label="所属楼栋">{{ getParentName(currentNode.pid) }}</el-descriptions-item>
              <el-descriptions-item label="房间管理员">{{ currentNode.manager || '-' }}</el-descriptions-item>
              <el-descriptions-item label="管理员电话">{{ currentNode.managerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="安全责任人">{{ currentNode.safetyOfficer || '-' }}</el-descriptions-item>
              <el-descriptions-item label="责任人电话">{{ currentNode.safetyOfficerPhone || '-' }}</el-descriptions-item>
              <el-descriptions-item label="创建时间">
                {{ parseTime(currentNode.creatorTime, '{y}-{m}-{d} {h}:{i}') }}
              </el-descriptions-item>
              <el-descriptions-item label="房间简介" :span="2">
                {{ currentNode.introduction || '暂无简介' }}
              </el-descriptions-item>
              <el-descriptions-item label="备注" :span="2">
                {{ currentNode.remark || '暂无备注' }}
              </el-descriptions-item>
            </el-descriptions>

            <!-- 房间关联信息 -->
            <div class="related-info" v-if="roomDetail">
              <el-divider content-position="left">房间详细信息</el-divider>
              <el-descriptions :column="2" border>
                <el-descriptions-item label="区域类别">{{ getRoomZoneTypeText(roomDetail.zoneType) }}</el-descriptions-item>
                <el-descriptions-item label="备注" :span="2">{{ roomDetail.remark || '-' }}</el-descriptions-item>
              </el-descriptions>
            </div>

            <!-- 设备信息 - 只在教室层级显示 -->
            <div class="device-info" v-if="currentNode.zonetype === 4">
              <el-divider content-position="left">设备信息</el-divider>
              
              <!-- 设备统计 -->
              <div class="device-stats" v-if="deviceList.length > 0">
                <div class="stat-card">
                  <div class="stat-value">{{ deviceList.length }}</div>
                  <div class="stat-label">设备总数</div>
                </div>
                <div class="stat-card success">
                  <div class="stat-value">{{ getNormalDeviceCount }}</div>
                  <div class="stat-label">正常设备</div>
                </div>
                <div class="stat-card warning">
                  <div class="stat-value">{{ getAbnormalDeviceCount }}</div>
                  <div class="stat-label">异常设备</div>
                </div>
                <div class="stat-card danger">
                  <div class="stat-value">{{ getRepairDeviceCount }}</div>
                  <div class="stat-label">维修中</div>
                </div>
              </div>

              <el-table
                v-loading="deviceLoading"
                :data="deviceList"
                border
                style="width: 100%"
                empty-text="该教室暂无设备"
              >
                <el-table-column prop="name" label="设备名称" width="180" show-overflow-tooltip />
                <el-table-column prop="brand" label="品牌" width="100" />
                <el-table-column prop="model" label="型号" width="120" />
                <el-table-column prop="location" label="具体位置" width="150" show-overflow-tooltip />
                <el-table-column prop="isHost" label="是否主机" width="90">
                  <template #default="scope">
                    <el-tag :type="scope.row.isHost ? 'primary' : 'info'" size="small">
                      {{ getHostText(scope.row.isHost) }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="isBus" label="是否总线" width="90">
                  <template #default="scope">
                    <el-tag :type="scope.row.isBus ? 'warning' : 'info'" size="small">
                      {{ getBusText(scope.row.isBus) }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="deviceStatus" label="设备状态" width="90">
                  <template #default="scope">
                    <el-tag 
                      :type="getDeviceStatusColor(scope.row.deviceStatus)"
                      size="small"
                    >
                      {{ getDeviceStatusText(scope.row.deviceStatus) }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="bindStatus" label="绑定状态" width="90">
                  <template #default="scope">
                    <el-tag 
                      :type="getBindStatusColor(scope.row.bindStatus)"
                      size="small"
                    >
                      {{ getBindStatusText(scope.row.bindStatus) }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="startDate" label="启用时间" width="110">
                  <template #default="scope">
                    {{ parseTime(scope.row.startDate, '{y}-{m}-{d}') }}
                  </template>
                </el-table-column>
                <el-table-column prop="serviceLife" label="使用期限" width="90">
                  <template #default="scope">
                    {{ scope.row.serviceLife ? scope.row.serviceLife + '年' : '-' }}
                  </template>
                </el-table-column>
                <el-table-column prop="qrCode" label="二维码编号" width="120" />
                <el-table-column prop="remark" label="备注" show-overflow-tooltip />
                <el-table-column label="操作" width="120" fixed="right">
                  <template #default="scope">
                    <el-button link type="primary" size="small" @click="handleViewDevice(scope.row)">查看</el-button>
                    <el-button link type="warning" size="small" @click="handleMaintainDevice(scope.row)">维护</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </div>

            <!-- 图片预览 -->
            <div class="image-preview" v-if="currentNode.planMap">
              <el-divider content-position="left">房间图纸</el-divider>
              <div class="image-grid">
                <div class="image-item" v-if="currentNode.planMap">
                  <div class="image-label">房间平面图</div>
                  <el-image
                    :src="currentNode.planMap"
                    :preview-src-list="[currentNode.planMap]"
                    fit="cover"
                    class="preview-image"
                  >
                    <template #error>
                      <div class="image-error">
                        <el-icon><Picture /></el-icon>
                        <span>图片加载失败</span>
                      </div>
                    </template>
                  </el-image>
                </div>
              </div>
            </div>
          </el-card>
        </div>
        
        <el-card v-else header="区域详情" class="detail-card">
          <div class="empty-state">
            <el-icon size="48" color="#909399"><InfoFilled /></el-icon>
            <p>请选择左侧的区域节点查看详情</p>
          </div>
        </el-card>
      </el-main>
    </el-container>

    <!-- 添加项目对话框 -->
    <el-dialog title="添加项目" v-model="projectOpen" width="700px" append-to-body>
      <el-form ref="projectRef" :model="projectForm" :rules="projectRules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="项目编码" prop="projectCode">
              <el-input v-model="projectForm.projectCode" placeholder="请输入项目编码" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目名称" prop="projectName">
              <el-input v-model="projectForm.projectName" placeholder="请输入项目名称" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="经度" prop="lng">
              <el-input v-model="projectForm.lng" placeholder="请输入经度">
                <template #append>
                  <el-button @click="handleGpsLocation" :icon="Location">GPS定位</el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="纬度" prop="lat">
              <el-input v-model="projectForm.lat" placeholder="请输入纬度" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="省市区" prop="area">
          <el-cascader
            v-model="projectForm.area"
            :options="areaOptions"
            :props="areaProps"
            placeholder="请选择省市区"
            style="width: 100%"
            clearable
          />
        </el-form-item>

        <el-form-item label="详细地址" prop="address">
          <el-input v-model="projectForm.address" type="textarea" :rows="2" placeholder="请输入详细地址" />
        </el-form-item>

        <el-row>
          <el-col :span="12">
            <el-form-item label="委托单位" prop="clientUnit">
              <el-select v-model="projectForm.clientUnit" placeholder="请选择委托单位" style="width: 100%">
                <el-option
                  v-for="unit in clientUnitOptions"
                  :key="unit.value"
                  :label="unit.label"
                  :value="unit.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="分配人员" prop="assignedPerson">
              <el-select v-model="projectForm.assignedPerson" placeholder="请选择分配人员" style="width: 100%">
                <el-option
                  v-for="person in assignedPersonOptions"
                  :key="person.value"
                  :label="person.label"
                  :value="person.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitProjectForm">确 定</el-button>
          <el-button @click="cancelProject">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 添加楼栋对话框 -->
    <el-dialog title="添加楼栋" v-model="buildingOpen" width="700px" append-to-body>
      <el-form ref="buildingRef" :model="buildingForm" :rules="buildingRules" label-width="100px">
        <el-form-item label="楼栋名称" prop="buildingName">
          <el-input v-model="buildingForm.buildingName" placeholder="请输入楼栋名称" />
        </el-form-item>

        <el-row>
          <el-col :span="12">
            <el-form-item label="所属项目" prop="projectId">
              <el-select v-model="buildingForm.projectId" placeholder="请选择所属项目" style="width: 100%">
                <el-option
                  v-for="project in projectOptions"
                  :key="project.id"
                  :label="project.zname"
                  :value="project.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="上级区域" prop="parentZone">
              <el-tree-select
                v-model="buildingForm.parentZone"
                :data="zoneOptions"
                :props="{ value: 'id', label: 'zname', children: 'children' }"
                value-key="id"
                placeholder="请选择上级区域"
                check-strictly
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="省市区" prop="area">
          <el-cascader
            v-model="buildingForm.area"
            :options="areaOptions"
            :props="areaProps"
            placeholder="请选择省市区"
            style="width: 100%"
            clearable
          />
        </el-form-item>

        <!-- 修改：添加建筑面积字段 -->
        <el-row>
          <el-col :span="8">
            <el-form-item label="建筑层数" prop="floorCount">
              <el-input-number 
                v-model="buildingForm.floorCount" 
                :min="1" 
                :max="100" 
                placeholder="请输入建筑层数"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="建筑高度" prop="buildingHeight">
              <el-input v-model="buildingForm.buildingHeight" placeholder="请输入建筑高度">
                <template #append>米</template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="建筑面积" prop="buildingArea">
              <el-input v-model="buildingForm.buildingArea" placeholder="请输入建筑面积">
                <template #append>㎡</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="建筑类别" prop="buildingType">
              <el-select v-model="buildingForm.buildingType" placeholder="请选择建筑类别" style="width: 100%">
                <el-option label="住宅" value="residential" />
                <el-option label="商业" value="commercial" />
                <el-option label="工业" value="industrial" />
                <el-option label="公共建筑" value="public" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="使用性质" prop="usageType">
              <el-select v-model="buildingForm.usageType" placeholder="请选择使用性质" style="width: 100%">
                <el-option label="办公" value="office" />
                <el-option label="住宅" value="residential" />
                <el-option label="商业" value="commercial" />
                <el-option label="工业" value="industrial" />
                <el-option label="仓储" value="warehouse" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="经度" prop="lng">
              <el-input v-model="buildingForm.lng" placeholder="请输入经度">
                <template #append>
                  <el-button @click="handleGpsLocation" :icon="Location">GPS定位</el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="纬度" prop="lat">
              <el-input v-model="buildingForm.lat" placeholder="请输入纬度" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="详细地址" prop="address">
          <el-input v-model="buildingForm.address" type="textarea" :rows="2" placeholder="请输入详细地址" />
        </el-form-item>

        <el-form-item label="备注" prop="remark">
          <el-input v-model="buildingForm.remark" type="textarea" :rows="2" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitBuildingForm">确 定</el-button>
          <el-button @click="cancelBuilding">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 添加房间对话框 -->
<el-dialog title="添加房间" v-model="roomOpen" width="700px" append-to-body>
  <el-form ref="roomRef" :model="roomForm" :rules="roomRules" label-width="100px">
    <el-form-item label="房间名称" prop="roomName">
      <el-input v-model="roomForm.roomName" placeholder="请输入房间名称" />
    </el-form-item>

    <el-row>
      <el-col :span="12">
        <el-form-item label="所属项目" prop="projectId">
          <el-select 
            v-model="roomForm.projectId" 
            placeholder="请选择所属项目" 
            style="width: 100%"
            @change="handleProjectChange"
          >
            <el-option
              v-for="project in projectOptions"
              :key="project.id"
              :label="project.zname"
              :value="project.id"
            />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="房间类型" prop="roomType">
          <el-select v-model="roomForm.roomType" placeholder="请选择房间类型" style="width: 100%">
            <el-option label="办公区" value="office" />
            <el-option label="会议室" value="meeting" />
            <el-option label="休息区" value="rest" />
            <el-option label="设备间" value="equipment" />
            <el-option label="教室" value="classroom" />
            <el-option label="实验室" value="laboratory" />
            <el-option label="其他" value="other" />
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 新增：上级区域树状选择 -->
    <el-form-item label="上级区域" prop="parentZoneId">
      <el-tree-select
        v-model="roomForm.parentZoneId"
        :data="roomZoneOptions"
        :props="{
          value: 'id',
          label: 'zname',
          children: 'children',
          disabled: (data) => data.zonetype === 4 // 禁用房间级别
        }"
        value-key="id"
        placeholder="请选择上级区域"
        check-strictly
        style="width: 100%"
        @change="handleParentZoneChange"
        clearable
      />
    </el-form-item>

    <!-- 显示完整路径 -->
    <el-form-item label="完整路径" v-if="roomForm.parentZonePath">
      <el-input 
        v-model="roomForm.parentZonePath" 
        placeholder="完整路径将自动生成" 
        readonly 
        style="width: 100%"
      >
        <template #append>
          <el-button @click="copyPath" type="primary">复制</el-button>
        </template>
      </el-input>
      <div class="path-tip">完整路径: {{ roomForm.parentZonePath }}</div>
    </el-form-item>

    <!-- 新增：继承信息展示和编辑 -->
    <el-divider content-position="left">继承信息（来自上级区域）</el-divider>
    
    <el-row>
      <el-col :span="12">
        <el-form-item label="经度">
          <el-input v-model="roomForm.lng" placeholder="自动继承或手动输入经度" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="纬度">
          <el-input v-model="roomForm.lat" placeholder="自动继承或手动输入纬度" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-row>
      <el-col :span="12">
        <el-form-item label="管理人">
          <el-input v-model="roomForm.manager" placeholder="自动继承或手动输入管理人" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="管理人电话">
          <el-input v-model="roomForm.managerPhone" placeholder="自动继承或手动输入电话" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-row>
      <el-col :span="12">
        <el-form-item label="安全责任人">
          <el-input v-model="roomForm.safetyOfficer" placeholder="自动继承或手动输入安全责任人" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="责任人电话">
          <el-input v-model="roomForm.safetyOfficerPhone" placeholder="自动继承或手动输入电话" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-row>
      <el-col :span="12">
        <el-form-item label="平面图URL">
          <el-input v-model="roomForm.planMap" placeholder="自动继承或手动输入平面图URL" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="疏散图URL">
          <el-input v-model="roomForm.evacuationMap" placeholder="自动继承或手动输入疏散图URL" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-form-item label="备注" prop="remark">
      <el-input v-model="roomForm.remark" type="textarea" :rows="3" placeholder="请输入备注" />
    </el-form-item>
  </el-form>
  <template #footer>
    <div class="dialog-footer">
      <el-button type="primary" @click="submitRoomForm">确 定</el-button>
      <el-button @click="cancelRoom">取 消</el-button>
    </div>
  </template>
</el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, getCurrentInstance, nextTick, computed, onMounted, watch } from 'vue'
import { Plus, Edit, Delete, InfoFilled, Picture, Location, OfficeBuilding, House, Top, Bottom, Sort, Search } from '@element-plus/icons-vue'
import { listZone, getZone, delZone, addZone, updateZone, addProject, addBuilding, addRoom,
         listProjectByZoneId, listBuildingByProjectId, listRoomByBuildingId  } from "@/api/system/zone"
import { listDeviceByZoneId } from "@/api/system/device"

const { proxy } = getCurrentInstance()

// 响应式数据
const zoneTreeData = ref([])
const zoneOptions = ref([])
const projectOptions = ref([])
const roomZoneOptions = ref([]) // 专门用于房间的上级区域选择
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const currentNode = ref(null) // 当前选中的节点
const selectedTopRegion = ref(null) // 选中的顶级区域（现在存储中文名称）
const filterText = ref('')

// 添加滚动相关的ref
const treeContainerRef = ref(null)
const treeRef = ref(null)

watch(filterText, (val) => {
  treeRef.value.filter(val)
})

const filterNode = (value, data) => {
  if (!value) return true
  return data.zname.indexOf(value) !== -1
}

// 详情数据
const projectDetail = ref(null)
const buildingDetail = ref(null)
const roomDetail = ref(null)

// 设备相关数据
const deviceList = ref([])
const deviceLoading = ref(false)

// 对话框状态
const projectOpen = ref(false)
const buildingOpen = ref(false)
const roomOpen = ref(false)

// 表单引用
const projectRef = ref()
const buildingRef = ref()
const roomRef = ref()

// 省市区选项（示例数据）
const areaOptions = ref([
  {
    value: 'beijing',
    label: '北京市',
    children: [
      { value: 'dongcheng', label: '东城区' },
      { value: 'xicheng', label: '西城区' },
      { value: 'chaoyang', label: '朝阳区' },
      { value: 'haidian', label: '海淀区' }
    ]
  },
  {
    value: 'zhejiang',
    label: '浙江省',
    children: [
      {
        value: 'hangzhou',
        label: '杭州市',
        children: [
          {
            value: 'shangcheng',
            label: '上城区',
            children: [
              { value: 'hubin', label: '湖滨街道' },
              { value: 'qingbo', label: '清波街道' },
              { value: 'xiaoying', label: '小营街道' },
              { value: 'naxiang', label: '南星街道' },
              { value: 'zhanongqiao', label: '闸弄口街道' },
              { value: 'kaixuan', label: '凯旋街道' },
              { value: 'caihe', label: '采荷街道' },
              { value: 'qiantao', label: '钱塘街道' },
              { value: 'dongzhan', label: '东站街道' },
              { value: 'baiyang', label: '白杨街道' },
              { value: 'jiubao', label: '九堡街道' },
              { value: 'dinglan', label: '丁兰街道' },
              { value: 'pengbu', label: '彭埠街道' }
            ]
          },
          // ... 其他区域数据保持不变
        ]
      }
    ]
  }
])

const areaProps = {
  value: 'value',
  label: 'label',
  children: 'children'
}

// 委托单位选项（示例数据）
const clientUnitOptions = ref([
  { value: '特电', label: '特电' },
  { value: '杭电', label: '杭电' },
  { value: '大厂', label: '大厂' }
])

// 分配人员选项（示例数据）
const assignedPersonOptions = ref([
  { value: '张三', label: '张三' },
  { value: '李四', label: '李四' },
  { value: '王五', label: '王五' }
])

// 计算属性：获取顶级节点（pid为0的节点）
const topLevelNodes = computed(() => {
  const findTopNodes = (nodes) => {
    let topNodes = []
    nodes.forEach(node => {
      if (node.pid === 0) {
        topNodes.push(node)
      }
      if (node.children && node.children.length > 0) {
        topNodes = topNodes.concat(findTopNodes(node.children))
      }
    })
    return topNodes
  }
  return findTopNodes(zoneTreeData.value)
})

// 计算属性：根据选择的顶级区域过滤树形数据
const filteredTreeData = computed(() => {
  if (!selectedTopRegion.value) {
    return []
  }
  
  // 根据中文名称找到对应的节点ID
  const findNodeByName = (nodes, name) => {
    for (const node of nodes) {
      if (node.zname === name) {
        return node.children || []
      }
      if (node.children && node.children.length > 0) {
        const found = findNodeByName(node.children, name)
        if (found) return found
      }
    }
    return []
  }
  
  return findNodeByName(zoneTreeData.value, selectedTopRegion.value) || []
})

// 计算属性：总节点数
const totalNodeCount = computed(() => {
  const countNodes = (nodes) => {
    let count = 0
    nodes.forEach(node => {
      count++
      if (node.children && node.children.length > 0) {
        count += countNodes(node.children)
      }
    })
    return count
  }
  return countNodes(filteredTreeData.value)
})

// 树形组件配置
const treeProps = {
  children: 'children',
  label: 'zname'
}

// 表单数据
const data = reactive({
  form: {},
  queryParams: {
    zname: null,
    zonetype: null
  },
  rules: {
    zname: [
      { required: true, message: "区域名称不能为空", trigger: "blur" }
    ],
    zonetype: [
      { required: true, message: "区域类别不能为空", trigger: "change" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

// 项目表单数据
const projectForm = ref({
  projectCode: '',
  projectName: '',
  lng: '',
  lat: '',
  area: [],
  address: '',
  clientUnit: '',
  assignedPerson: ''
})

const projectRules = {
  projectCode: [
    { required: true, message: "项目编码不能为空", trigger: "blur" }
  ],
  projectName: [
    { required: true, message: "项目名称不能为空", trigger: "blur" }
  ],
  lng: [
    { required: true, message: "经度不能为空", trigger: "blur" }
  ],
  lat: [
    { required: true, message: "纬度不能为空", trigger: "blur" }
  ],
  address: [
    { required: true, message: "详细地址不能为空", trigger: "blur" }
  ]
}

// 楼栋表单数据
const buildingForm = ref({
  buildingName: '',
  projectId: '',
  parentZone: '',
  area: [],
  floorCount: 1,
  buildingHeight: '',
  buildingArea: '',
  buildingType: '',
  lng: '',
  lat: '',
  usageType: '',
  address: '',
  remark: ''
})

const buildingRules = {
  buildingName: [
    { required: true, message: "楼栋名称不能为空", trigger: "blur" }
  ],
  projectId: [
    { required: true, message: "所属项目不能为空", trigger: "change" }
  ],
  floorCount: [
    { required: true, message: "建筑层数不能为空", trigger: "blur" }
  ],
  buildingArea: [ 
    { required: true, message: "建筑面积不能为空", trigger: "blur" },
    { pattern: /^\d+(\.\d+)?$/, message: "请输入正确的建筑面积", trigger: "blur" }
  ],
  buildingType: [
    { required: true, message: "建筑类别不能为空", trigger: "change" }
  ],
  usageType: [
    { required: true, message: "使用性质不能为空", trigger: "change" }
  ]
}

// 房间表单数据
const roomForm = ref({
  roomName: '',
  projectId: '',
  roomType: '',
  parentZoneId: null,
  parentZonePath: '',
  lng: '',
  lat: '',
  manager: '',
  managerPhone: '',
  safetyOfficer: '',
  safetyOfficerPhone: '',
  planMap: '',
  evacuationMap: '',
  remark: ''
})

const roomRules = {
  roomName: [
    { required: true, message: "房间名称不能为空", trigger: "blur" }
  ],
  projectId: [
    { required: true, message: "所属项目不能为空", trigger: "change" }
  ],
  roomType: [
    { required: true, message: "房间类型不能为空", trigger: "change" }
  ],
  parentZoneId: [
    { required: true, message: "上级区域不能为空", trigger: "change" }
  ]
}

// 设备相关计算属性
// 计算正常设备数量
const getNormalDeviceCount = computed(() => {
  return deviceList.value.filter(device => device.deviceStatus === 1).length
})

// 计算异常设备数量
const getAbnormalDeviceCount = computed(() => {
  return deviceList.value.filter(device => device.deviceStatus === 2).length
})

// 计算维修中设备数量
const getRepairDeviceCount = computed(() => {
  return deviceList.value.filter(device => device.deviceStatus === 3).length
})

// 滚动相关方法
/** 滚动到顶部 */
function scrollToTop() {
  if (treeContainerRef.value) {
    treeContainerRef.value.scrollTop = 0
  }
}

/** 滚动到底部 */
function scrollToBottom() {
  if (treeContainerRef.value) {
    treeContainerRef.value.scrollTop = treeContainerRef.value.scrollHeight
  }
}

// 在 handleTreeNodeClick 函数中根据节点类型加载对应数据
function handleTreeNodeClick(data) {
  console.log('点击节点:', data) // 添加日志查看点击的节点信息
  currentNode.value = data
  // 清空之前的详情数据
  projectDetail.value = null
  buildingDetail.value = null
  roomDetail.value = null
  deviceList.value = [] // 清空设备列表
  
  // 根据节点类型加载对应的子级数据
  if (data.zonetype === 1) { // 项目层级
    console.log('加载项目数据，ID:', data.id)
    loadProjectsByZoneId(data.id)
  } else if (data.zonetype === 2) { // 楼栋层级  
    console.log('加载楼栋数据，ID:', data.id)
    loadBuildingsByProjectId(data.id)
  } else if (data.zonetype === 3 || data.zonetype === 4) { // 二级区域或教室层级
    console.log('加载房间和设备数据，ID:', data.id, '类型:', data.zonetype)
    loadDevicesByZoneId(data.id) // 加载设备信息
  }
}

// 加载项目数据
function loadProjectsByZoneId(zoneId) {
  listProjectByZoneId(zoneId).then(response => {
    console.log('项目数据:', response.data)
    projectDetail.value = response.data
  }).catch(error => {
    console.error('获取项目数据失败:', error)
    proxy.$modal.msgError("获取项目数据失败")
  })
}

// 加载楼栋数据
function loadBuildingsByProjectId(projectId) {
  listBuildingByProjectId(projectId).then(response => {
    console.log('楼栋数据:', response.data)
    buildingDetail.value = response.data
  }).catch(error => {
    console.error('获取楼栋数据失败:', error)
  })
}

// 加载房间数据
function loadRoomsByBuildingId(buildingId) {
  console.log('开始加载房间数据，楼栋ID:', buildingId)
  if (!buildingId) {
    console.error('楼栋ID为空，无法加载房间数据')
    return
  }
  
  listRoomByBuildingId(buildingId).then(response => {
    console.log('房间数据响应:', response)
    roomDetail.value = response.data
    console.log('加载到的房间数据:', roomDetail.value)
  }).catch(error => {
    console.error('获取房间数据失败:', error)
    proxy.$modal.msgError("获取房间数据失败: " + error.message)
  })
}

// 加载设备数据
function loadDevicesByZoneId(zoneId) {
  console.log('开始加载设备数据，区域ID:', zoneId) // 添加日志
  if (!zoneId) {
    console.error('区域ID为空，无法加载设备')
    return
  }
  
  deviceLoading.value = true
  listDeviceByZoneId(zoneId).then(response => {
    console.log('设备数据响应:', response)
    deviceList.value = response.data || []
    deviceLoading.value = false
    console.log('加载到的设备数量:', deviceList.value.length)
  }).catch(error => {
    console.error('获取设备数据失败:', error)
    deviceList.value = []
    deviceLoading.value = false
    proxy.$modal.msgError("获取设备数据失败: " + error.message)
  })
}

/** 获取区域类别文本 */
function getZoneTypeText(type) {
  const typeMap = {
    1: '项目',
    2: '一级区域', 
    3: '二级区域',
    4: '三级区域'
  }
  return typeMap[type] || '-'
}

/** 获取建筑类别文本 */
function getBuildingTypeText(type) {
  const typeMap = {
    'residential': '住宅',
    'commercial': '商业',
    'industrial': '工业',
    'public': '公共建筑',
    'other': '其他'
  }
  return typeMap[type] || type || '-'
}

/** 获取使用性质文本 */
function getUsageTypeText(type) {
  const typeMap = {
    'office': '办公',
    'residential': '住宅',
    'commercial': '商业',
    'industrial': '工业',
    'warehouse': '仓储',
    'other': '其他'
  }
  return typeMap[type] || type || '-'
}

/** 获取房间区域类别文本 */
function getRoomZoneTypeText(type) {
  const typeMap = {
    'office': '办公区',
    'meeting': '会议室',
    'rest': '休息区',
    'equipment': '设备间',
    'classroom': '教室',
    'laboratory': '实验室',
    'other': '其他'
  }
  return typeMap[type] || type || '-'
}

/** 获取设备状态文本 */
function getDeviceStatusText(status) {
  const statusMap = {
    1: '正常',
    2: '异常',
    3: '修理中',
    4: '待复检'
  }
  return statusMap[status] || '未知'
}

/** 获取设备状态颜色 */
function getDeviceStatusColor(status) {
  const colorMap = {
    1: 'success',
    2: 'danger', 
    3: 'warning',
    4: 'info'
  }
  return colorMap[status] || 'info'
}

/** 获取绑定状态文本 */
function getBindStatusText(status) {
  const statusMap = {
    1: '未绑定',
    2: '已绑定'
  }
  return statusMap[status] || '未知'
}

/** 获取绑定状态颜色 */
function getBindStatusColor(status) {
  return status === 2 ? 'success' : 'info'
}

/** 获取是否主机文本 */
function getHostText(isHost) {
  return isHost ? '是' : '否'
}

/** 获取是否总线文本 */
function getBusText(isBus) {
  return isBus ? '是' : '否'
}

/** 查询区域列表 */
function getList() {
  loading.value = true
  listZone(queryParams.value).then(response => {
    zoneTreeData.value = proxy.handleTree(response.data, "id", "pid")
    loading.value = false
    
    // 默认选择第一个顶级区域（使用中文名称）
    if (topLevelNodes.value.length > 0 && !selectedTopRegion.value) {
      selectedTopRegion.value = topLevelNodes.value[0].zname
    }
  }).catch(() => {
    loading.value = false
  })
}

/** 查询项目列表 */
function getProjectList() {
  // 这里假设项目是zonetype为1的区域
  listZone({ zonetype: 1 }).then(response => {
    projectOptions.value = response.data
  })
}

/** 查询区域下拉树结构 */
function getTreeselect() {
  listZone().then(response => {
    zoneOptions.value = []
    const data = { id: 0, zname: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "id", "pid")
    zoneOptions.value.push(data)
  })
}

/** 查询房间上级区域树结构 */
function getRoomZoneTreeselect() {
  listZone().then(response => {
    roomZoneOptions.value = []
    const data = { id: 0, zname: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "id", "pid")
    roomZoneOptions.value.push(data)
  })
}

/** 获取父级区域名称 */
function getParentName(pid) {
  if (!pid || pid === 0) return '顶级节点'
  // 这里可以优化为从树数据中查找父节点名称
  const findParentName = (nodes, targetId) => {
    for (const node of nodes) {
      if (node.id === targetId) {
        return node.zname
      }
      if (node.children && node.children.length > 0) {
        const found = findParentName(node.children, targetId)
        if (found) return found
      }
    }
    return `ID: ${pid}`
  }
  return findParentName(zoneTreeData.value, pid)
}

/** 获取完整路径 */
function getFullPath(nodeId) {
  const findNodePath = (nodes, targetId, path = []) => {
    for (const node of nodes) {
      const currentPath = [...path, node.zname]
      if (node.id === targetId) {
        return currentPath.join(' - ')
      }
      if (node.children && node.children.length > 0) {
        const found = findNodePath(node.children, targetId, currentPath)
        if (found) return found
      }
    }
    return ''
  }
  
  return findNodePath(zoneTreeData.value, nodeId) || ''
}

/** 顶级区域选择变化 */
function handleTopRegionChange(regionName) {
  selectedTopRegion.value = regionName
  // 清空当前选中的节点
  currentNode.value = null
  projectDetail.value = null
  buildingDetail.value = null
  roomDetail.value = null
  deviceList.value = []
}

/** 添加项目按钮 */
function handleAddProject() {
  // 根据中文名称找到对应的节点ID
  let currentPid = 1 // 默认值
  if (selectedTopRegion.value) {
    const findNodeIdByName = (nodes, name) => {
      for (const node of nodes) {
        if (node.zname === name) {
          return node.id
        }
        if (node.children && node.children.length > 0) {
          const found = findNodeIdByName(node.children, name)
          if (found) return found
        }
      }
      return 1
    }
    currentPid = findNodeIdByName(zoneTreeData.value, selectedTopRegion.value)
  }
  
  projectForm.value = {
    projectCode: '',
    projectName: '',
    lng: '',
    lat: '',
    area: [],
    address: '',
    clientUnit: '',
    assignedPerson: '',
    pid: currentPid 
  }
  projectOpen.value = true
}

/** 添加楼栋按钮 */
function handleAddBuilding() {
  buildingForm.value = {
    buildingName: '',
    projectId: '',
    parentZone: '',
    area: [],
    floorCount: 1,
    buildingHeight: '',
    buildingArea: '', 
    buildingType: '',
    lng: '',
    lat: '',
    usageType: '',
    address: '',
    remark: ''
  }
  buildingOpen.value = true
}

/** 添加房间按钮 */
function handleAddRoom() {
  roomForm.value = {
    roomName: '',
    projectId: '',
    roomType: '',
    parentZoneId: null,
    parentZonePath: '',
    lng: '',
    lat: '',
    manager: '',
    managerPhone: '',
    safetyOfficer: '',
    safetyOfficerPhone: '',
    planMap: '',
    evacuationMap: '',
    remark: ''
  }
  // 加载房间上级区域树
  getRoomZoneTreeselect()
  roomOpen.value = true
}

/** 项目选择变化 */
function handleProjectChange(projectId) {
  // 可以根据选择的项目自动填充一些信息
  console.log('选择的项目ID:', projectId)
}

function handleParentZoneChange(zoneId) {
  if (zoneId) {
    // 获取完整路径
    const fullPath = getFullPath(zoneId)
    roomForm.value.parentZonePath = fullPath
    
    // 查找上级区域的详细信息并继承
    const parentZone = findZoneById(zoneId)
    if (parentZone) {
      // 继承上级区域的信息
      roomForm.value.lng = parentZone.lng || ''
      roomForm.value.lat = parentZone.lat || ''
      roomForm.value.manager = parentZone.manager || ''
      roomForm.value.managerPhone = parentZone.managerPhone || ''
      roomForm.value.safetyOfficer = parentZone.safetyOfficer || ''
      roomForm.value.safetyOfficerPhone = parentZone.safetyOfficerPhone || ''
      roomForm.value.planMap = parentZone.planMap || ''
      roomForm.value.evacuationMap = parentZone.evacuationMap || ''
    }
    
    console.log('选择的上级区域ID:', zoneId, '完整路径:', fullPath)
  } else {
    roomForm.value.parentZonePath = ''
    // 清空继承的字段
    roomForm.value.lng = ''
    roomForm.value.lat = ''
    roomForm.value.manager = ''
    roomForm.value.managerPhone = ''
    roomForm.value.safetyOfficer = ''
    roomForm.value.safetyOfficerPhone = ''
    roomForm.value.planMap = ''
    roomForm.value.evacuationMap = ''
  }
}
/** 根据ID查找区域 */
function findZoneById(zoneId) {
  const findInTree = (nodes, targetId) => {
    for (const node of nodes) {
      if (node.id === targetId) {
        return node
      }
      if (node.children && node.children.length > 0) {
        const found = findInTree(node.children, targetId)
        if (found) return found
      }
    }
    return null
  }
  return findInTree(zoneTreeData.value, zoneId)
}

/** 复制路径 */
function copyPath() {
  if (roomForm.value.parentZonePath) {
    navigator.clipboard.writeText(roomForm.value.parentZonePath).then(() => {
      proxy.$modal.msgSuccess('路径已复制到剪贴板')
    }).catch(() => {
      proxy.$modal.msgError('复制失败')
    })
  }
}

/** GPS定位按钮 */
function handleGpsLocation() {
  proxy.$modal.msgInfo("GPS定位功能暂未实现")
}

/** 提交项目表单 */
function submitProjectForm() {
  projectRef.value.validate(valid => {
    if (valid) {
      addProject(projectForm.value).then(response => {
        proxy.$modal.msgSuccess("添加项目成功")
        projectOpen.value = false
        getList()
      })
    }
  })
}

/** 提交楼栋表单 */
function submitBuildingForm() {
  buildingRef.value.validate(valid => {
    if (valid) {
      addBuilding(buildingForm.value).then(response => {
        proxy.$modal.msgSuccess("添加楼栋成功")
        buildingOpen.value = false
        getList()
      })
    }
  })
}
/** 提交房间表单 */
function submitRoomForm() {
  roomRef.value.validate(valid => {
    if (valid) {
      // 准备提交数据
      const submitData = {
        zname: roomForm.value.roomName,
        pid: roomForm.value.parentZoneId,
        zonetype: 4, 
        projectId: roomForm.value.projectId,
        roomType: roomForm.value.roomType,
        manager: roomForm.value.manager,
        managerPhone: roomForm.value.managerPhone,
        safetyOfficer: roomForm.value.safetyOfficer,
        safetyOfficerPhone: roomForm.value.safetyOfficerPhone,
        lng: roomForm.value.lng,
        lat: roomForm.value.lat,
        planMap: roomForm.value.planMap,
        evacuationMap: roomForm.value.evacuationMap,
        remark: roomForm.value.remark
      }
      
      console.log('提交数据:', submitData)
      
      addRoom(submitData).then(response => {
        proxy.$modal.msgSuccess("添加房间成功")
        roomOpen.value = false
        getList()
      }).catch(error => {
        console.error('添加房间失败:', error)
        proxy.$modal.msgError("添加房间失败: " + error.message)
      })
    }
  })
}

/** 取消项目表单 */
function cancelProject() {
  projectOpen.value = false
  projectRef.value.resetFields()
}

/** 取消楼栋表单 */
function cancelBuilding() {
  buildingOpen.value = false
  buildingRef.value.resetFields()
}

/** 取消房间表单 */
function cancelRoom() {
  roomOpen.value = false
  roomRef.value.resetFields()
}

/** 查看设备详情 */
function handleViewDevice(device) {
  proxy.$modal.alert({
    title: '设备详情 - ' + device.name,
    message: `
      <div style="line-height: 1.8;">
        <p><strong>设备名称：</strong>${device.name}</p>
        <p><strong>品牌型号：</strong>${device.brand || '-'} ${device.model || '-'}</p>
        <p><strong>具体位置：</strong>${device.location || '-'}</p>
        <p><strong>关联区域：</strong>${device.relatedLocation || '-'}</p>
        <p><strong>设备状态：</strong>${getDeviceStatusText(device.deviceStatus)}</p>
        <p><strong>绑定状态：</strong>${getBindStatusText(device.bindStatus)}</p>
        <p><strong>是否主机：</strong>${getHostText(device.isHost)}</p>
        <p><strong>是否总线：</strong>${getBusText(device.isBus)}</p>
        <p><strong>生产日期：</strong>${device.productionDate ? parseTime(device.productionDate, '{y}-{m}-{d}') : '-'}</p>
        <p><strong>启用时间：</strong>${device.startDate ? parseTime(device.startDate, '{y}-{m}-{d}') : '-'}</p>
        <p><strong>使用期限：</strong>${device.serviceLife ? device.serviceLife + '年' : '-'}</p>
        <p><strong>二维码编号：</strong>${device.qrCode || '-'}</p>
        <p><strong>经纬度：</strong>${device.lng && device.lat ? device.lng + ', ' + device.lat : '-'}</p>
        <p><strong>备注：</strong>${device.remark || '-'}</p>
      </div>
    `,
    dangerouslyUseHTMLString: true,
    confirmButtonText: '确定',
    customClass: 'device-detail-modal'
  })
}

/** 设备维护 */
function handleMaintainDevice(device) {
  proxy.$modal.confirm(`确定要对设备"${device.name}"进行维护操作吗？`).then(() => {
    // 调用设备维护API
    proxy.$modal.msgSuccess(`设备"${device.name}"已进入维护状态`)
    // 重新加载设备列表
    loadDevicesByZoneId(currentNode.value.id)
  }).catch(() => {})
}

// 取消按钮
function cancel() {
  open.value = false
  reset()
}

// 表单重置
function reset() {
  form.value = {
    id: null,
    zname: null,
    pid: 0,
    zonetype: null,
    planMap: null,
    introduction: null,
    evacuationMap: null,
    manager: null,
    managerPhone: null,
    safetyOfficer: null,
    safetyOfficerPhone: null,
    lng: null,
    lat: null,
    remark: null
  }
  if (proxy.$refs.zoneRef) {
    proxy.$refs.zoneRef.resetFields()
  }
}

/** 搜索按钮操作 */
function handleQuery() {
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  if (proxy.$refs.queryRef) {
    proxy.$refs.queryRef.resetFields()
  }
  handleQuery()
}

/** 新增按钮操作 */
function handleAdd(row) {
  reset()
  getTreeselect()
  if (row && row.id) {
    form.value.pid = row.id
  } else {
    // 如果没有选择具体节点，就添加到当前选中的顶级区域下
    // 根据中文名称找到对应的节点ID
    let currentPid = 0
    if (selectedTopRegion.value) {
      const findNodeIdByName = (nodes, name) => {
        for (const node of nodes) {
          if (node.zname === name) {
            return node.id
          }
          if (node.children && node.children.length > 0) {
            const found = findNodeIdByName(node.children, name)
            if (found) return found
          }
        }
        return 0
      }
      currentPid = findNodeIdByName(zoneTreeData.value, selectedTopRegion.value)
    }
    form.value.pid = currentPid
  }
  open.value = true
  title.value = "添加区域"
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  isExpandAll.value = !isExpandAll.value
  nextTick(() => {
    // 重新渲染树组件
    const tempData = [...filteredTreeData.value]
    // 树组件会自动响应 filteredTreeData 的变化
  })
}

/** 修改按钮操作 */
async function handleUpdate(row) {
  reset()
  await getTreeselect()
  if (row != null) {
    form.value.pid = row.pid
  }
  getZone(row.id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改区域"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["zoneRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateZone(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
          if (currentNode.value && currentNode.value.id === form.value.id) {
            currentNode.value = form.value
          }
        })
      } else {
        addZone(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  proxy.$modal.confirm('是否确认删除区域 "' + row.zname + '"？').then(function() {
    return delZone(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
    if (currentNode.value && currentNode.value.id === row.id) {
      currentNode.value = null
    }
  }).catch(() => {})
}

// 初始化
onMounted(() => {
  getList()
  getProjectList()
})
</script>

<style scoped>
/* 原有的样式保持不变，只添加新的样式 */

/* 路径提示样式 */
.path-tip {
  font-size: 12px;
  color: #67c23a;
  margin-top: 4px;
  padding: 4px 8px;
  background: #f0f9ff;
  border-radius: 4px;
  border-left: 3px solid #67c23a;
}

/* 树状选择器样式优化 */
:deep(.el-tree-select) {
  width: 100%;
}

:deep(.el-tree-select .el-select) {
  width: 100%;
}

/* 其他样式保持不变 */
.app-container {
  padding: 20px;
  height: calc(100vh - 84px);
}

.layout-container {
  height: 100%;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
}

.sidebar {
  background: #f8f9fa;
  border-right: 1px solid #e4e7ed;
  padding: 16px;
}

.sidebar-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  font-weight: 600;
  color: #303133;
}

.header-tools {
  display: flex;
  align-items: center;
}

.scroll-hint {
  color: #909399;
  cursor: help;
}

.top-region-selector {
  margin-bottom: 8px;
  padding: 0 8px;
}

.tree-search {
  margin-bottom: 8px;
  padding: 0 8px;
}

.region-option {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.region-name {
  font-weight: 500;
}

.sidebar-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 0;
}

/* 树形容器样式 */
.tree-container {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
  max-height: 400px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  background: #fff;
}

/* 可滚动的树形组件 */
.scrollable-tree {
  min-height: 100%;
}

/* 树形操作工具栏 */
.tree-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 8px;
  border-top: 1px solid #e4e7ed;
  background: #f8f9fa;
}

.tree-info {
  font-size: 12px;
  color: #909399;
}

.node-count {
  font-weight: 500;
}

.zone-tree {
  width: 100%;
}

.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding: 8px 4px;
  width: 100%;
}

.node-info {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.zone-name {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.zone-type-tag {
  font-size: 12px;
  color: #909399;
  margin-left: 8px;
  background: #f4f4f5;
  padding: 2px 6px;
  border-radius: 4px;
}

.tree-actions {
  display: flex;
  gap: 2px;
  opacity: 0;
  transition: opacity 0.2s;
  flex-shrink: 0;
}

.custom-tree-node:hover .tree-actions {
  opacity: 1;
}

.tree-actions .el-button {
  padding: 2px;
  height: auto;
}

.main-content {
  padding: 20px;
  background: #fff;
  display: flex;
  flex-direction: column;
}

/* 重新设计顶部操作区域布局 */
.top-actions {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
  gap: 20px;
  flex-wrap: wrap;
}

.left-actions {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.search-form {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.right-actions {
  display: flex;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
}

.add-buttons {
  display: flex;
  gap: 0;
}

.add-buttons .el-button {
  border-radius: 0;
}

.add-buttons .el-button:first-child {
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
}

.add-buttons .el-button:last-child {
  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
}

.action-tools {
  display: flex;
  align-items: center;
  gap: 12px;
}

.detail-card {
  flex: 1;
}

.detail-card :deep(.el-card__header) {
  padding: 12px 20px;
  background: #f5f7fa;
  border-bottom: 1px solid #e4e7ed;
  font-weight: 600;
}

.empty-state {
  text-align: center;
  color: #909399;
  padding: 60px 0;
}

.empty-state p {
  margin-top: 12px;
  font-size: 14px;
}

.image-preview {
  margin-top: 20px;
}

.image-grid {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.image-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.image-label {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

.preview-image {
  width: 200px;
  height: 150px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  overflow: hidden;
}

.image-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #909399;
  gap: 8px;
}

.related-info {
  margin-top: 20px;
}

.related-info :deep(.el-divider__text) {
  background-color: #f8f9fa;
}


.device-info {
  margin-top: 20px;
}

.device-info :deep(.el-divider__text) {
  background-color: #f8f9fa;
}

.device-stats {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.stat-card {
  flex: 1;
  min-width: 120px;
  text-align: center;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 6px;
  border-left: 4px solid #409eff;
}

.stat-card.success {
  border-left-color: #67c23a;
}

.stat-card.warning {
  border-left-color: #e6a23c;
}

.stat-card.danger {
  border-left-color: #f56c6c;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 12px;
  color: #909399;
}

:deep(.el-tree-node__content) {
  height: 40px;
  margin: 2px 0;
}

:deep(.el-tree-node__content:hover) {
  background-color: #f5f7fa;
  border-radius: 4px;
}

:deep(.el-tree-node.is-current > .el-tree-node__content) {
  background-color: #ecf5ff;
  border-radius: 4px;
}

:deep(.el-descriptions) {
  margin-top: 0;
}

:deep(.el-descriptions__header) {
  margin-bottom: 16px;
}

:deep(.el-table) {
  margin-top: 12px;
}

:deep(.el-table .cell) {
  padding: 8px 12px;
}

/* 设备详情模态框样式 */
:deep(.device-detail-modal) {
  width: 500px;
}

:deep(.device-detail-modal .el-message-box__message) {
  max-height: 400px;
  overflow-y: auto;
}

/* 滚动条样式 */
.tree-container::-webkit-scrollbar {
  width: 6px;
}

.tree-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.tree-container::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.tree-container::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 响应式布局 */
@media (max-width: 1200px) {
  .top-actions {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
  }
  
  .left-actions, .right-actions {
    width: 100%;
  }
  
  .right-actions {
    justify-content: space-between;
  }
  
  .tree-container {
    max-height: 300px;
  }
}
/* 继承信息区域样式 */
:deep(.el-divider__text) {
  background-color: #fff;
  padding: 0 10px;
  font-size: 14px;
  color: #606266;
}

.path-tip {
  font-size: 12px;
  color: #67c23a;
  margin-top: 4px;
  padding: 4px 8px;
  background: #f0f9ff;
  border-radius: 4px;
  border-left: 3px solid #67c23a;
}
</style>