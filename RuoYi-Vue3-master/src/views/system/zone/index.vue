<template>
  <div class="app-container">
    <el-container class="layout-container">
      <!-- 左侧菜单侧边栏 -->
      <el-aside width="350px" class="sidebar">
        <el-card class="sidebar-card">
          <template #header>
            <div class="sidebar-header">
              <span class="header-title">区域管理</span>
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
                :value="region.id"
              >
                <div class="region-option">
                  <span class="region-name">{{ region.zname }}</span>
                </div>
              </el-option>
            </el-select>
          </div>

          <!-- 树形菜单 -->
          <el-tree
            v-loading="loading"
            :data="filteredTreeData"
            :props="treeProps"
            node-key="id"
            highlight-current
            :expand-on-click-node="false"
            :default-expand-all="isExpandAll"
            @node-click="handleTreeNodeClick"
            class="zone-tree"
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
        </el-card>
      </el-aside>

      <!-- 右侧内容区域 -->
      <el-main class="main-content">
        <!-- 操作按钮和搜索 -->
        <div class="top-actions">
          <div class="left-actions">
            <el-form :model="queryParams" ref="queryRef" :inline="true" class="search-form">
              <el-form-item>
                <el-input
                  v-model="queryParams.zname"
                  placeholder="请输入区域名称"
                  clearable
                  style="width: 200px"
                />
              </el-form-item>
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
    <el-dialog title="添加房间" v-model="roomOpen" width="600px" append-to-body>
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
            <el-form-item label="区域类别" prop="zoneType">
              <el-select v-model="roomForm.zoneType" placeholder="请选择区域类别" style="width: 100%">
                <el-option label="办公区" value="office" />
                <el-option label="会议室" value="meeting" />
                <el-option label="休息区" value="rest" />
                <el-option label="设备间" value="equipment" />
                <el-option label="其他" value="other" />
              </el-select>
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
import { ref, reactive, getCurrentInstance, nextTick, computed, onMounted } from 'vue'
import { Plus, Edit, Delete, InfoFilled, Picture, Location, OfficeBuilding, House } from '@element-plus/icons-vue'
import { listZone, getZone, delZone, addZone, updateZone, addProject, addBuilding, addRoom,
         listProjectByZoneId, listBuildingByProjectId, listRoomByBuildingId  } from "@/api/system/zone"

const { proxy } = getCurrentInstance()

// 响应式数据
const zoneTreeData = ref([])
const zoneOptions = ref([])
const projectOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const currentNode = ref(null) // 当前选中的节点
const selectedTopRegion = ref(null) // 选中的顶级区域

// 详情数据
const projectDetail = ref(null)
const buildingDetail = ref(null)
const roomDetail = ref(null)

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
          {
            value: 'gongshu',
            label: '拱墅区',
            children: [
              { value: 'mishixiang', label: '米市巷街道' },
              { value: 'hushu', label: '湖墅街道' },
              { value: 'xiahe', label: '小河街道' },
              { value: 'hefang', label: '和睦街道' },
              { value: 'daguan', label: '大关街道' },
              { value: 'beishan', label: '北山街道' },
              { value: 'xihu', label: '西溪街道' },
              { value: 'lingyin', label: '灵隐街道' },
              { value: 'cuibai', label: '翠苑街道' },
              { value: 'wensan', label: '文三街道' },
              { value: 'gongchenqiao', label: '拱宸桥街道' },
              { value: 'shiqiao', label: '石桥街道' },
              { value: 'dongxin', label: '东新街道' },
              { value: 'banian', label: '半山街道' },
              { value: 'xiangfu', label: '祥符街道' },
              { value: 'kangqiao', label: '康桥街道' }
            ]
          },
          {
            value: 'xihu',
            label: '西湖区',
            children: [
              { value: 'beishan', label: '北山街道' },
              { value: 'xiling', label: '西泠街道' },
              { value: 'lingyin', label: '灵隐街道' },
              { value: 'cuibai', label: '翠苑街道' },
              { value: 'wensan', label: '文三街道' },
              { value: 'gushan', label: '古荡街道' },
              { value: 'zhuantang', label: '转塘街道' },
              { value: 'liuxia', label: '留下街道' },
              { value: 'shuangpu', label: '双浦街道' },
              { value: 'sanjiangkou', label: '三墩街道' },
              { value: 'jiangcun', label: '蒋村街道' }
            ]
          },
          {
            value: 'binjiang',
            label: '滨江区',
            children: [
              { value: 'xixing', label: '西兴街道' },
              { value: 'changhe', label: '长河街道' },
              { value: 'puyan', label: '浦沿街道' },
              { value: 'baiyang', label: '白杨街道' },
              { value: 'xiasha', label: '下沙街道' }
            ]
          },
          {
            value: 'xiaoshan',
            label: '萧山区',
            children: [
              { value: 'chengxiang', label: '城厢街道' },
              { value: 'beigan', label: '北干街道' },
              { value: 'shushan', label: '蜀山街道' },
              { value: 'xinshi', label: '新塘街道' },
              { value: 'qiaonan', label: '衙前街道' },
              { value: 'ningwei', label: '宁围街道' },
              { value: 'wenyan', label: '闻堰街道' },
              { value: 'yipeng', label: '义蓬街道' },
              { value: 'linpu', label: '临浦街道' },
              { value: 'dangwan', label: '党湾街道' },
              { value: 'kanshan', label: '坎山街道' },
              { value: 'guali', label: '瓜沥街道' },
              { value: 'dangshan', label: '党山街道' },
              { value: 'yiqiao', label: '义桥街道' },
              { value: 'suoqian', label: '所前街道' },
              { value: 'hezhang', label: '河庄街道' },
              { value: 'dainan', label: '戴村街道' },
              { value: 'puyan', label: '浦阳街道' },
              { value: 'jinchan', label: '进化街道' },
              { value: 'louta', label: '楼塔街道' }
            ]
          },
          {
            value: 'yuhang',
            label: '余杭区',
            children: [
              { value: 'linping', label: '临平街道' },
              { value: 'nanyuan', label: '南苑街道' },
              { value: 'donghu', label: '东湖街道' },
              { value: 'xianlin', label: '星桥街道' },
              { value: 'wuchang', label: '五常街道' },
              { value: 'xianlin', label: '闲林街道' },
              { value: 'cangqian', label: '仓前街道' },
              { value: 'liangzhu', label: '良渚街道' },
              { value: 'pingyao', label: '瓶窑街道' },
              { value: 'jingshan', label: '径山街道' },
              { value: 'huanghu', label: '黄湖街道' },
              { value: 'yuhang', label: '余杭街道' },
              { value: 'zhongtai', label: '中泰街道' },
              { value: 'wuchang', label: '五常街道' }
            ]
          },
          {
            value: 'linping',
            label: '临平区',
            children: [
              { value: 'linping', label: '临平街道' },
              { value: 'nanyuan', label: '南苑街道' },
              { value: 'donghu', label: '东湖街道' },
              { value: 'xianlin', label: '星桥街道' },
              { value: 'yuhang', label: '运河街道' },
              { value: 'changan', label: '长安街道' },
              { value: 'qiaosi', label: '乔司街道' },
              { value: 'chongxian', label: '崇贤街道' },
              { value: 'tangqi', label: '塘栖街道' },
              { value: 'pingyao', label: '瓶窑街道' }
            ]
          },
          {
            value: 'qiantang',
            label: '钱塘区',
            children: [
              { value: 'xiasha', label: '下沙街道' },
              { value: 'baiyang', label: '白杨街道' },
              { value: 'hezhang', label: '河庄街道' },
              { value: 'yipeng', label: '义蓬街道' },
              { value: 'xinshi', label: '新湾街道' },
              { value: 'linjiang', label: '临江街道' },
              { value: 'qianjin', label: '前进街道' }
            ]
          },
          {
            value: 'fuyang',
            label: '富阳区',
            children: [
              { value: 'fuchun', label: '富春街道' },
              { value: 'chunjiang', label: '春江街道' },
              { value: 'dongzhou', label: '东洲街道' },
              { value: 'lushan', label: '鹿山街道' },
              { value: 'yinhu', label: '银湖街道' },
              { value: 'wanshi', label: '万市街道' },
              { value: 'dongqiao', label: '洞桥街道' },
              { value: 'xukou', label: '胥口街道' },
              { value: 'changkou', label: '常口街道' },
              { value: 'xindeng', label: '新登街道' },
              { value: 'lvtong', label: '渌渚街道' },
              { value: 'changan', label: '长安街道' }
            ]
          },
          {
            value: 'linan',
            label: '临安区',
            children: [
              { value: 'jincheng', label: '锦城街道' },
              { value: 'jinnan', label: '锦南街道' },
              { value: 'jingbei', label: '锦北街道' },
              { value: 'qingliangfeng', label: '清凉峰街道' },
              { value: 'heyuan', label: '河源街道' },
              { value: 'yunti', label: '云梯街道' },
              { value: 'banqiao', label: '板桥街道' },
              { value: 'gaohong', label: '高虹街道' },
              { value: 'yijiang', label: '於潜街道' },
              { value: 'tianmushan', label: '天目山街道' },
              { value: 'taihuyuan', label: '太湖源街道' }
            ]
          },
          {
            value: 'tonglu',
            label: '桐庐县',
            children: [
              { value: 'tongjun', label: '桐君街道' },
              { value: 'jiuxian', label: '旧县街道' },
              { value: 'fenshui', label: '分水镇' },
              { value: 'fuchunjiang', label: '富春江镇' },
              { value: 'hengcun', label: '横村镇' },
              { value: 'yaolin', label: '瑶琳镇' },
              { value: 'baiyunyuan', label: '白云源镇' }
            ]
          },
          {
            value: 'chunan',
            label: '淳安县',
            children: [
              { value: 'qiandaohu', label: '千岛湖镇' },
              { value: 'linqi', label: '临岐镇' },
              { value: 'weiping', label: '威坪镇' },
              { value: 'jiukeng', label: '鸠坑乡' },
              { value: 'wangzhuang', label: '王阜乡' },
              { value: 'guocun', label: '郭村乡' },
              { value: 'jiangjia', label: '姜家镇' },
              { value: 'zhangcun', label: '漳村镇' }
            ]
          },
          {
            value: 'jiande',
            label: '建德市',
            children: [
              { value: 'xinanjiang', label: '新安江街道' },
              { value: 'genglou', label: '更楼街道' },
              { value: 'yangxi', label: '洋溪街道' },
              { value: 'meicheng', label: '梅城镇' },
              { value: 'shouchang', label: '寿昌镇' },
              { value: 'datong', label: '大同镇' },
              { value: 'sanhe', label: '三都镇' },
              { value: 'gantan', label: '干潭镇' },
              { value: 'yangcunqiao', label: '杨村桥镇' },
              { value: 'xiaya', label: '下涯镇' },
              { value: 'hangzhouwan', label: '杭州湾镇' }
            ]
          }
        ]
      }
    ]
  },
  {
    value: 'shanghai',
    label: '上海市',
 
    
        children: [
          { value: 'huangpu', label: '黄浦区' },
          { value: 'xuhui', label: '徐汇区' },
          { value: 'changning', label: '长宁区' }
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

// 计算属性：根据选择的顶级区域过滤树形数据（排除顶级节点本身，直接显示其子节点）
const filteredTreeData = computed(() => {
  if (!selectedTopRegion.value) {
    return []
  }
  
  const findNodeById = (nodes, id) => {
    for (const node of nodes) {
      if (node.id === id) {
        // 返回该节点的子节点，而不是节点本身
        return node.children || []
      }
      if (node.children && node.children.length > 0) {
        const found = findNodeById(node.children, id)
        if (found) return found
      }
    }
    return []
  }
  
  return findNodeById(zoneTreeData.value, selectedTopRegion.value) || []
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
  zoneType: '',
  remark: ''
})

const roomRules = {
  roomName: [
    { required: true, message: "房间名称不能为空", trigger: "blur" }
  ],
  projectId: [
    { required: true, message: "所属项目不能为空", trigger: "change" }
  ],
  zoneType: [
    { required: true, message: "区域类别不能为空", trigger: "change" }
  ]
}

// 在 handleTreeNodeClick 函数中根据节点类型加载对应数据
function handleTreeNodeClick(data) {
  currentNode.value = data
  // 清空之前的详情数据
  projectDetail.value = null
  buildingDetail.value = null
  roomDetail.value = null
  
  // 根据节点类型加载对应的子级数据
  if (data.zonetype === 1) { // 项目层级
    loadProjectsByZoneId(data.id)
  } else if (data.zonetype === 2) { // 楼栋层级  
    loadBuildingsByProjectId(data.id)
  } else if (data.zonetype === 4) { // 房间层级
    loadRoomsByBuildingId(data.id)
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
  listRoomByBuildingId(buildingId).then(response => {
    console.log('房间数据:', response.data)
    roomDetail.value = response.data
  }).catch(error => {
    console.error('获取房间数据失败:', error)
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
    'other': '其他'
  }
  return typeMap[type] || type || '-'
}

/** 查询区域列表 */
function getList() {
  loading.value = true
  listZone(queryParams.value).then(response => {
    zoneTreeData.value = proxy.handleTree(response.data, "id", "pid")
    loading.value = false
    
    // 默认选择第一个顶级区域
    if (topLevelNodes.value.length > 0 && !selectedTopRegion.value) {
      selectedTopRegion.value = topLevelNodes.value[0].id
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

/** 顶级区域选择变化 */
function handleTopRegionChange(regionId) {
  selectedTopRegion.value = regionId
  // 清空当前选中的节点
  currentNode.value = null
  projectDetail.value = null
  buildingDetail.value = null
  roomDetail.value = null
}

/** 添加项目按钮 */
function handleAddProject() {
  const currentPid = selectedTopRegion.value || 1 // 默认为1，即钱塘区的ID
  projectForm.value = {
    zoneType:1,
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
    zoneType:2,
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
    zoneType: '',
    remark: ''
  }
  roomOpen.value = true
}

/** 项目选择变化 */
function handleProjectChange(projectId) {
  // 可以根据选择的项目自动填充一些信息
  console.log('选择的项目ID:', projectId)
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
      addRoom(roomForm.value).then(response => {
        proxy.$modal.msgSuccess("添加房间成功")
        roomOpen.value = false
        getList()
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
    form.value.pid = selectedTopRegion.value || 0
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

.top-region-selector {
  margin-bottom: 16px;
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

.zone-tree {
  flex: 1;
  overflow: auto;
  padding: 8px;
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
}
</style>