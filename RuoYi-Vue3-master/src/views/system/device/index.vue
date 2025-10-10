<template>
  <div class="app-container">
    <el-container class="layout-container">
      <!-- 左侧菜单侧边栏 -->
      <el-aside width="300px" class="sidebar">
        <el-card class="sidebar-card">
          <template #header>
            <div class="sidebar-header">
              <span class="header-title">项目管理</span>
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

          <!-- 项目按钮列表 -->
          <div class="project-list" v-loading="loading">
            <div
              v-for="project in filteredProjects"
              :key="project.id"
              class="project-button"
              :class="{ active: currentProject?.id === project.id }"
              @click="handleProjectClick(project)"
            >
              <div class="project-info">
                <span class="project-name">{{ project.zname }}</span>
                <span class="project-type-tag">项目</span>
              </div>
              <span class="device-count">{{ getDeviceCount(project.id) }}</span>
            </div>
            
            <!-- 空状态 -->
            <div v-if="filteredProjects.length === 0" class="empty-projects">
              <el-empty description="暂无项目数据" :image-size="80" />
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
                <el-input
                  v-model="queryParams.name"
                  placeholder="请输入设备名称"
                  clearable
                  style="width: 200px"
                  @keyup.enter="handleQuery"
                />
              </el-form-item>
              <el-form-item>
                <el-input
                  v-model="queryParams.categoryId"
                  placeholder="请输入所属类别"
                  clearable
                  style="width: 200px"
                  @keyup.enter="handleQuery"
                />
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
                @click="handleAdd"
                v-hasPermi="['system:device:add']"
              >新增设备</el-button>
            </el-button-group>
            <div class="action-tools">
              <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </div>
          </div>
        </div>

        <!-- 设备列表 -->
        <div class="device-content">
          <!-- 当前选中的项目信息 -->
          <div v-if="currentProject" class="current-project-info">
            <el-card shadow="never">
              <div class="project-header">
                <h3>{{ currentProject.zname }} - 设备列表</h3>
                <span class="total-count">共 {{ total }} 台设备</span>
              </div>
            </el-card>
          </div>

          <!-- 设备表格 -->
          <el-card v-if="currentProject" shadow="never" class="device-table-card">
            <el-table v-loading="loading" :data="deviceList" @selection-change="handleSelectionChange">
              <el-table-column type="selection" width="55" align="center" />
              <el-table-column label="设备名称" align="center" prop="name" min-width="120" show-overflow-tooltip />
              <el-table-column label="设备类别" align="center" prop="categoryId" min-width="100" />
              <el-table-column label="品牌" align="center" prop="brand" min-width="100" />
              <el-table-column label="型号" align="center" prop="model" min-width="120" />
              <el-table-column label="是否主机" align="center" prop="isHost" min-width="80">
                <template #default="scope">
                  <el-tag :type="scope.row.isHost ? 'success' : 'info'">
                    {{ scope.row.isHost ? '是' : '否' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="是否总线" align="center" prop="isBus" min-width="80">
                <template #default="scope">
                  <el-tag :type="scope.row.isBus ? 'success' : 'info'">
                    {{ scope.row.isBus ? '是' : '否' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="具体位置" align="center" prop="location" min-width="150" show-overflow-tooltip />
              <el-table-column label="生产日期" align="center" prop="productionDate" width="110">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.productionDate, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
              <el-table-column label="启用时间" align="center" prop="startDate" width="110">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.startDate, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
              <el-table-column label="设备状态" align="center" prop="deviceStatus" min-width="80">
                <template #default="scope">
                  <el-tag :type="getDeviceStatusType(scope.row.deviceStatus)">
                    {{ getDeviceStatusText(scope.row.deviceStatus) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
                <template #default="scope">
                  <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:device:edit']">修改</el-button>
                  <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:device:remove']">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <pagination
              v-show="total>0"
              :total="total"
              v-model:page="queryParams.pageNum"
              v-model:limit="queryParams.pageSize"
              @pagination="getList"
            />
          </el-card>

          <!-- 空状态 -->
          <div v-if="!currentProject" class="empty-state">
            <el-card header="设备管理" class="detail-card">
              <div class="empty-content">
                <el-icon size="48" color="#909399"><InfoFilled /></el-icon>
                <p>请选择左侧的项目查看设备列表</p>
              </div>
            </el-card>
          </div>
        </div>
      </el-main>
    </el-container>

    <!-- 添加或修改设施设备对话框 -->
    <el-dialog :title="title" v-model="open" width="700px" append-to-body>
      <el-form ref="deviceRef" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入设备名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备类别" prop="categoryId">
              <el-input v-model="form.categoryId" placeholder="请输入设备类别" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="所属项目" prop="projectId">
              <el-select 
                v-model="form.projectId" 
                placeholder="请选择所属项目"
                style="width: 100%"
                :disabled="!!currentProject"
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
            <el-form-item label="具体位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入具体位置" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="品牌" prop="brand">
              <el-input v-model="form.brand" placeholder="请输入品牌" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="型号" prop="model">
              <el-input v-model="form.model" placeholder="请输入型号" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="是否主机" prop="isHost">
              <el-radio-group v-model="form.isHost">
                <el-radio :label="1">是</el-radio>
                <el-radio :label="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否总线" prop="isBus">
              <el-radio-group v-model="form.isBus">
                <el-radio :label="1">是</el-radio>
                <el-radio :label="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="8">
            <el-form-item label="生产日期" prop="productionDate">
              <el-date-picker 
                clearable
                v-model="form.productionDate"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择生产日期"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="启用时间" prop="startDate">
              <el-date-picker 
                clearable
                v-model="form.startDate"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择启用时间"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="使用期限" prop="serviceLife">
              <el-input v-model="form.serviceLife" placeholder="请输入使用期限">
                <template #append>年</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="经度" prop="lng">
              <el-input v-model="form.lng" placeholder="请输入经度" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="纬度" prop="lat">
              <el-input v-model="form.lat" placeholder="请输入纬度" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, getCurrentInstance, computed, onMounted } from 'vue'
import { Plus, Edit, Delete, InfoFilled } from '@element-plus/icons-vue'
import { listDevice, getDevice, delDevice, addDevice, updateDevice } from "@/api/system/device"
import { listZone } from "@/api/system/zone"

const { proxy } = getCurrentInstance()

// 响应式数据
const zoneTreeData = ref([])
const projectOptions = ref([])
const deviceList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const selectedTopRegion = ref(null)
const currentProject = ref(null) // 当前选中的项目
const deviceCountMap = ref({}) // 项目设备数量映射

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    categoryId: null,
    projectId: null, // 用于根据项目筛选设备
    zoneId1: null,
    zoneId2: null,
    zoneId3: null,
    location: null,
    relatedLocation: null,
    brand: null,
    model: null,
    isHost: null,
    isBus: null,
    productionDate: null,
    startDate: null,
    warrantyStart: null,
    serviceLife: null,
    deviceStatus: null,
    bindStatus: null,
    qrCode: null,
    qrUrl: null,
    diagram2d: null,
    lng: null,
    lat: null
  },
  rules: {
    name: [
      { required: true, message: "设备名称不能为空", trigger: "blur" }
    ],
    categoryId: [
      { required: true, message: "设备类别不能为空", trigger: "blur" }
    ],
    projectId: [
      { required: true, message: "所属项目不能为空", trigger: "change" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

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

// 计算属性：根据选择的顶级区域过滤项目列表
const filteredProjects = computed(() => {
  if (!selectedTopRegion.value) {
    return []
  }
  
  const findNodeById = (nodes, id) => {
    for (const node of nodes) {
      if (node.id === id) {
        // 返回该节点的子节点，并过滤只显示项目（zonetype === 1）
        const children = node.children || []
        return children.filter(child => child.zonetype === 1)
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

/** 获取设备状态文本 */
function getDeviceStatusText(status) {
  const statusMap = {
    0: '停用',
    1: '启用',
    2: '维修中',
    3: '报废'
  }
  return statusMap[status] || '未知'
}

/** 获取设备状态标签类型 */
function getDeviceStatusType(status) {
  const typeMap = {
    0: 'info',
    1: 'success',
    2: 'warning',
    3: 'danger'
  }
  return typeMap[status] || 'info'
}

/** 获取项目设备数量 */
function getDeviceCount(projectId) {
  return deviceCountMap.value[projectId] || 0
}

/** 查询区域列表 */
function getZoneList() {
  loading.value = true
  listZone().then(response => {
    zoneTreeData.value = proxy.handleTree(response.data, "id", "pid")
    loading.value = false
    
    // 提取所有项目用于下拉选择
    extractProjects(zoneTreeData.value)
    
    // 默认选择第一个顶级区域
    if (topLevelNodes.value.length > 0 && !selectedTopRegion.value) {
      selectedTopRegion.value = topLevelNodes.value[0].id
    }
    
    // 加载所有项目的设备数量
    loadDeviceCounts()
  }).catch(() => {
    loading.value = false
  })
}

/** 从树数据中提取所有项目 */
function extractProjects(nodes) {
  nodes.forEach(node => {
    if (node.zonetype === 1) {
      projectOptions.value.push(node)
    }
    if (node.children && node.children.length > 0) {
      extractProjects(node.children)
    }
  })
}

/** 加载所有项目的设备数量 */
function loadDeviceCounts() {
  projectOptions.value.forEach(project => {
    listDevice({ projectId: project.id, pageSize: 1 }).then(response => {
      deviceCountMap.value[project.id] = response.total || 0
    })
  })
}

/** 查询设备列表 */
function getList() {
  loading.value = true
  listDevice(queryParams.value).then(response => {
    deviceList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

/** 顶级区域选择变化 */
function handleTopRegionChange(regionId) {
  selectedTopRegion.value = regionId
  // 清空当前选中的项目
  currentProject.value = null
  deviceList.value = []
  queryParams.value.projectId = null
}

/** 项目点击事件 */
function handleProjectClick(project) {
  currentProject.value = project
  queryParams.value.projectId = project.id
  queryParams.value.pageNum = 1 // 重置页码
  getList()
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
    name: null,
    categoryId: null,
    projectId: currentProject.value ? currentProject.value.id : null,
    zoneId1: null,
    zoneId2: null,
    zoneId3: null,
    location: null,
    relatedLocation: null,
    brand: null,
    model: null,
    isHost: 0,
    isBus: 0,
    productionDate: null,
    startDate: null,
    warrantyStart: null,
    serviceLife: null,
    deviceStatus: 1,
    bindStatus: 0,
    qrCode: null,
    qrUrl: null,
    diagram2d: null,
    lng: null,
    lat: null,
    remark: null
  }
  proxy.resetForm("deviceRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  // 保持当前项目的筛选
  if (currentProject.value) {
    queryParams.value.projectId = currentProject.value.id
  }
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加设备"
  // 如果当前有选中的项目，自动设置项目ID
  if (currentProject.value) {
    form.value.projectId = currentProject.value.id
  }
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getDevice(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改设备"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["deviceRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateDevice(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
          // 刷新设备数量
          if (form.value.projectId) {
            loadDeviceCounts()
          }
        })
      } else {
        addDevice(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
          // 刷新设备数量
          if (form.value.projectId) {
            loadDeviceCounts()
          }
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除设备编号为"' + _ids + '"的数据项？').then(function() {
    return delDevice(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
    // 刷新设备数量
    if (currentProject.value) {
      loadDeviceCounts()
    }
  }).catch(() => {})
}

// 初始化
onMounted(() => {
  getZoneList()
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

.project-list {
  flex: 1;
  overflow: auto;
  padding: 8px;
}

.project-button {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  margin-bottom: 8px;
  background: #fff;
  border: 1px solid #e4e7ed;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.project-button:hover {
  border-color: #409eff;
  background: #f0f7ff;
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.project-button.active {
  border-color: #409eff;
  background: #ecf5ff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
}

.project-info {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.project-name {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
}

.project-type-tag {
  font-size: 12px;
  color: #909399;
  margin-left: 8px;
  background: #f4f4f5;
  padding: 2px 6px;
  border-radius: 4px;
}

.device-count {
  font-size: 12px;
  color: #409eff;
  background: #ecf5ff;
  padding: 4px 8px;
  border-radius: 12px;
  min-width: 30px;
  text-align: center;
  font-weight: 500;
}

.empty-projects {
  padding: 40px 20px;
  text-align: center;
}

.main-content {
  padding: 20px;
  background: #fff;
  display: flex;
  flex-direction: column;
  height: 100%;
}

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

.action-tools {
  display: flex;
  align-items: center;
  gap: 12px;
}

.device-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.current-project-info {
  margin-bottom: 16px;
}

.project-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
}

.project-header h3 {
  margin: 0;
  color: #303133;
}

.total-count {
  color: #409eff;
  font-weight: 500;
}

.device-table-card {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.device-table-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.empty-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-content {
  text-align: center;
  color: #909399;
  padding: 60px 0;
}

.empty-content p {
  margin-top: 12px;
  font-size: 14px;
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
  
  .sidebar {
    width: 280px !important;
  }
}

@media (max-width: 768px) {
  .layout-container {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100% !important;
    height: 300px;
  }
}
</style>