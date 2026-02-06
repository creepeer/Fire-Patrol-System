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
                <el-select
                  v-model="queryParams.categoryId"
                  placeholder="设备类别"
                  clearable
                  style="width: 120px"
                >
                  <el-option
                    v-for="category in categoryOptions"
                    :key="category.id"
                    :label="category.cname"
                    :value="category.id"
                  />
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
                <div class="drag-tips">
                  <el-tag type="info" size="small">提示：拖拽设备节点可调整父子关系</el-tag>
                </div>
              </div>
            </el-card>
          </div>

          <!-- 可拖拽设备树 -->
          <el-card v-if="currentProject" shadow="never" class="device-tree-card">
            <el-tree
              ref="deviceTreeRef"
              :data="deviceTreeData"
              node-key="id"
              default-expand-all
              draggable
              :allow-drop="allowDrop"
              :allow-drag="allowDrag"
              :expand-on-click-node="false"
              @node-drag-start="handleDragStart"
              @node-drag-end="handleDragEnd"
              @node-drop="handleDrop"
            >
              <template #default="{ node, data }">
                <div class="custom-tree-node">
                  <div class="node-content">
                    <!-- 设备图标 -->
                    <span class="node-icon">
                      <el-icon v-if="data.children && data.children.length > 0" color="#e6a23c">
                        <Folder />
                      </el-icon>
                      <el-icon v-else color="#909399">
                        <Document />
                      </el-icon>
                    </span>
                    
                    <!-- 设备名称 -->
                    <span class="device-name">{{ data.name }}</span>
                    
                    <!-- 设备信息标签 -->
                    <div class="device-tags">
                      <el-tag v-if="data.isHost" type="success" size="small">主机</el-tag>
                      <el-tag v-if="data.isBus" type="warning" size="small">总线</el-tag>
                      <el-tag :type="getDeviceStatusType(data.deviceStatus)" size="small">
                        {{ getDeviceStatusText(data.deviceStatus) }}
                      </el-tag>
                      <el-tag v-if="data.categoryName" type="info" size="small">
                        {{ data.categoryName }}
                      </el-tag>
                    </div>
                    
                    <!-- 设备详情 -->
                    <div class="device-details">
                      <span class="device-model">{{ data.model }}</span>
                      <span class="device-brand">{{ data.brand }}</span>
                      <span class="device-location">{{ data.location }}</span>
                      <span v-if="data.zonePath" class="device-zone">{{ data.zonePath }}</span>
                      <span v-if="data.relatedlocation" class="device-related-location">{{ data.relatedlocation }}</span>
                    </div>
                  </div>
                  
                  <!-- 操作按钮 -->
                  <div class="node-actions">
                    <el-button link type="primary" size="small" icon="Edit" @click="handleUpdate(data)" v-hasPermi="['system:device:edit']">
                      修改
                    </el-button>
                    <el-button link type="primary" size="small" icon="Picture" @click="handleViewQrCode(data)">
                      二维码
                    </el-button>
                    <el-button link type="primary" size="small" icon="Delete" @click="handleDelete(data)" v-hasPermi="['system:device:remove']">
                      删除
                    </el-button>
                  </div>
                </div>
              </template>
            </el-tree>
            
            <!-- 空状态 -->
            <div v-if="deviceTreeData.length === 0 && !loading" class="tree-empty">
              <el-empty description="暂无设备数据" :image-size="100" />
            </div>
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
    <el-dialog :title="title" v-model="open" width="900px" append-to-body>
      <el-form ref="deviceRef" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="设备名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入设备名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="父设备" prop="parentDeviceId">
              <el-select 
                v-model="form.parentDeviceId" 
                placeholder="请选择父设备"
                style="width: 100%"
                clearable
                filterable
              >
                <el-option label="无父设备（根设备）" :value="null" />
                <el-option
                  v-for="device in parentDeviceOptions"
                  :key="device.id"
                  :label="getParentDeviceLabel(device)"
                  :value="device.id"
                />
              </el-select>
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
            <el-form-item label="设备类别" prop="categoryId">
              <el-select 
                v-model="form.categoryId" 
                placeholder="请选择设备类别"
                style="width: 100%"
                clearable
              >
                <el-option
                  v-for="category in categoryOptions"
                  :key="category.id"
                  :label="category.cname"
                  :value="category.id"
                >
                  <div class="category-option">
                    <span class="category-name">{{ category.cname }}</span>
                    <el-tag :type="category.ctype === 0 ? 'warning' : 'primary'" size="small" style="margin-left: 8px">
                      {{ category.ctype === 0 ? '分支' : '结点' }}
                    </el-tag>
                    <span v-if="category.subjectId" class="category-subject" style="margin-left: 8px; color: #909399; font-size: 12px">
                      科目: {{ category.subjectId }}
                    </span>
                  </div>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 区域选择 - 显示完整层级关系 -->
        <el-form-item label="所属区域" prop="zonePath">
          <el-cascader
            v-model="form.zonePath"
            :options="zoneTreeOptions"
            :props="zoneCascaderProps"
            placeholder="请选择完整区域路径"
            style="width: 100%"
            clearable
            filterable
            @change="handleZoneChange"
          />
          <div class="form-tip">选择设备所在的完整区域路径</div>
        </el-form-item>

        <el-row>
          <el-col :span="12">
            <el-form-item label="具体位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入具体位置" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="品牌" prop="brand">
              <el-input v-model="form.brand" placeholder="请输入品牌" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="型号" prop="model">
              <el-input v-model="form.model" placeholder="请输入型号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否主机" prop="isHost">
              <el-radio-group v-model="form.isHost" @change="handleHostChange">
                <el-radio :label="1">是</el-radio>
                <el-radio :label="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="是否总线" prop="isBus">
              <el-radio-group v-model="form.isBus" @change="handleBusChange">
                <el-radio :label="1">是</el-radio>
                <el-radio :label="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="使用期限" prop="serviceLife">
              <el-input v-model="form.serviceLife" placeholder="请输入使用期限">
                <template #append>年</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 关联位置信息 -->
        <el-form-item label="关联位置" prop="relatedlocation">
          <el-input 
            v-model="form.relatedlocation" 
            placeholder="请输入关联位置信息" 
            type="textarea"
            :rows="2"
          />
          <div class="form-tip">例如：浙江省杭州市钱塘区 / 杭电辅助教学楼 / 一号教学楼 / 一楼 / 01教室</div>
        </el-form-item>

        <!-- 主机设备子设备选择 -->
        <el-form-item 
          v-if="form.isHost === 1" 
          label="关联子设备" 
          prop="childDeviceIds"
        >
          <el-card shadow="never" class="child-device-card">
            <template #header>
              <div class="card-header">
                <span>选择子设备</span>
                <div class="header-actions">
                  <el-button 
                    type="primary" 
                    link 
                    @click="refreshChildDevices"
                    :loading="childDeviceLoading"
                  >
                    刷新设备列表
                  </el-button>
                  <el-button 
                    type="info" 
                    link 
                    @click="clearSelectedZone"
                  >
                    清除区域筛选
                  </el-button>
                </div>
              </div>
            </template>
            
            <!-- 区域选择器 -->
            <div class="zone-selector-section">
              <div class="section-title">区域筛选</div>
              <div class="zone-selector">
                <el-cascader
                  v-model="selectedZonePath"
                  :options="zoneTreeOptions"
                  :props="zoneCascaderProps"
                  placeholder="请选择区域进行筛选"
                  style="width: 100%"
                  clearable
                  filterable
                  @change="handleZoneFilterChange"
                />
                <div class="zone-tip">
                  当前筛选: {{ selectedZoneName || '全部区域' }}
                  <el-tag v-if="selectedZoneName" type="success" size="small" style="margin-left: 8px">
                    {{ selectedZoneName }}
                  </el-tag>
                </div>
              </div>
            </div>
            
            <!-- 设备搜索和统计 -->
            <div class="child-device-filter">
              <el-input
                v-model="childDeviceFilter"
                placeholder="搜索设备名称、型号、位置"
                clearable
                style="width: 300px"
                @input="filterChildDevices"
              />
              <span class="selected-count">已选择 {{ selectedChildDevices.length }} 个设备</span>
            </div>
            
            <!-- 设备列表 -->
            <div class="child-device-list">
              <el-table
                ref="childDeviceTableRef"
                :data="filteredChildDevices"
                height="300"
                @selection-change="handleChildDeviceSelectionChange"
                v-loading="childDeviceLoading"
              >
                <el-table-column type="selection" width="55" />
                <el-table-column prop="name" label="设备名称" min-width="120" />
                <el-table-column prop="model" label="型号" width="100" />
                <el-table-column prop="brand" label="品牌" width="80" />
                <el-table-column prop="location" label="位置" min-width="120" show-overflow-tooltip />
                <el-table-column prop="zonePath" label="所属区域" min-width="150" show-overflow-tooltip>
                  <template #default="scope">
                    <el-tag v-if="scope.row.zonePath" type="info" size="small">
                      {{ scope.row.zonePath }}
                    </el-tag>
                    <span v-else>-</span>
                  </template>
                </el-table-column>
                <el-table-column prop="categoryName" label="设备类别" width="100" />
                <el-table-column label="状态" width="80">
                  <template #default="scope">
                    <el-tag :type="getDeviceStatusType(scope.row.deviceStatus)" size="small">
                      {{ getDeviceStatusText(scope.row.deviceStatus) }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="是否主机" width="80">
                  <template #default="scope">
                    <el-tag :type="scope.row.isHost ? 'success' : 'info'" size="small">
                      {{ scope.row.isHost ? '是' : '否' }}
                    </el-tag>
                  </template>
                </el-table-column>
              </el-table>
            </div>
            
            <!-- 空状态 -->
            <div v-if="filteredChildDevices.length === 0 && !childDeviceLoading" class="child-device-empty">
              <el-empty description="暂无可用设备" :image-size="60" />
            </div>
          </el-card>
        </el-form-item>

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
            <el-form-item label="质保开始" prop="warrantyStart">
              <el-date-picker 
                clearable
                v-model="form.warrantyStart"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择质保开始"
                style="width: 100%"
              />
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

    <!-- 二维码查看对话框 -->
    <el-dialog title="设备二维码" v-model="qrCodeVisible" width="400px" append-to-body align-center>
      <div class="qrcode-container" style="text-align: center; padding: 20px;">
        <div v-if="currentQrUrl" class="qr-image">
           <el-image 
             :src="currentQrUrl" 
             style="width: 200px; height: 200px"
             fit="contain"
             :preview-src-list="[currentQrUrl]"
           >
             <template #error>
               <div class="image-error" style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 200px; background-color: #f5f7fa; color: #909399;">
                 <el-icon size="40"><Picture /></el-icon>
                 <div style="margin-top: 10px;">无法加载二维码</div>
               </div>
             </template>
           </el-image>
        </div>
        <el-empty v-else description="暂无二维码信息" />
        <div v-if="currentQrUrl" class="mt-10">
           <el-link :href="currentQrUrl" target="_blank" type="primary">下载/查看原图</el-link>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, getCurrentInstance, computed, onMounted, nextTick, watch } from 'vue'
import { Plus, Edit, Delete, InfoFilled, Folder, Document, Picture } from '@element-plus/icons-vue'
import { listDevice, getDevice, delDevice, addDevice, updateDevice } from "@/api/system/device"
import { listZone } from "@/api/system/zone"
import { listCategory } from "@/api/system/category"
import { ElMessage, ElMessageBox } from 'element-plus'

const { proxy } = getCurrentInstance()

// 响应式数据
const zoneTreeData = ref([])
const zoneTreeOptions = ref([])
const categoryOptions = ref([])
const projectOptions = ref([])
const deviceList = ref([])
const deviceTreeData = ref([])
const parentDeviceOptions = ref([])
const childDeviceOptions = ref([])
const filteredChildDevices = ref([])
const selectedChildDevices = ref([])
const childDeviceFilter = ref('')
const childDeviceLoading = ref(false)
const childDeviceTableRef = ref()
const deviceTreeRef = ref()
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const selectedTopRegion = ref(null)
const currentProject = ref(null)
const deviceCountMap = ref({})

// 新增：区域筛选相关
const selectedZonePath = ref([])
const selectedZoneName = ref('')

// 区域级联选择配置
const zoneCascaderProps = {
  value: 'id',
  label: 'zname',
  children: 'children',
  checkStrictly: true,
  emitPath: true
}

const data = reactive({
  form: {
    id: null,
    name: null,
    categoryId: null,
    projectId: null,
    parentDeviceId: null,
    zoneId1: null,
    zoneId2: null,
    zoneId3: null,
    zonePath: [],
    location: null,
    brand: null,
    model: null,
    isHost: 0,
    isBus: 0,
    childDeviceIds: [],
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
    remark: null,
    // 新增关联位置字段
    relatedlocation: '浙江省杭州市钱塘区 / 杭电辅助教学楼 / 一号教学楼 / 一楼 / 01教室'
  },
  queryParams: {
    pageNum: 1,
    pageSize: 1000,
    name: null,
    categoryId: null,
    projectId: null,
    zoneId1: null,
    zoneId2: null,
    zoneId3: null,
    location: null,
    brand: null,
    model: null,
    isHost: null,
    isBus: null
  },
  rules: {
    name: [
      { required: true, message: "设备名称不能为空", trigger: "blur" }
    ],
    categoryId: [
      { required: true, message: "设备类别不能为空", trigger: "change" }
    ],
    projectId: [
      { required: true, message: "所属项目不能为空", trigger: "change" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

// 计算属性
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

const filteredProjects = computed(() => {
  if (!selectedTopRegion.value) {
    return []
  }
  
  const findNodeById = (nodes, id) => {
    for (const node of nodes) {
      if (node.id === id) {
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

// 监听主机设备状态变化
watch(() => form.value.isHost, (newVal) => {
  if (newVal === 1) {
    loadChildDevices()
  } else {
    selectedChildDevices.value = []
    form.value.childDeviceIds = []
  }
})

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

/** 获取设备状态标签类型 */
function getDeviceStatusType(status) {
  const typeMap = {
    1: 'success',
    2: 'danger',
    3: 'warning',
    4: 'info'
  }
  return typeMap[status] || 'info'
}

/** 获取项目设备数量 */
function getDeviceCount(projectId) {
  return deviceCountMap.value[projectId] || 0
}

/** 获取父设备显示标签 */
function getParentDeviceLabel(device) {
  let label = device.name
  if (device.model) {
    label += ` (${device.model})`
  }
  if (device.zonePath) {
    label += ` - ${device.zonePath}`
  }
  if (device.relatedlocation) {
    label += ` [${device.relatedlocation}]`
  }
  return label
}

/** 将扁平设备数据转换为树状结构 */
function buildDeviceTree(devices) {
  const deviceMap = new Map()
  const tree = []
  
  devices.forEach(device => {
    deviceMap.set(device.id, {
      ...device,
      children: []
    })
  })
  
  devices.forEach(device => {
    const node = deviceMap.get(device.id)
    if (device.parentDeviceId && deviceMap.has(device.parentDeviceId)) {
      const parent = deviceMap.get(device.parentDeviceId)
      parent.children.push(node)
    } else {
      tree.push(node)
    }
  })
  
  return tree
}

/** 查询区域列表 */
function getZoneList() {
  loading.value = true
  listZone().then(response => {
    zoneTreeData.value = proxy.handleTree(response.data, "id", "pid")
    zoneTreeOptions.value = buildZoneTreeOptions(zoneTreeData.value)
    loading.value = false
    
    extractProjects(zoneTreeData.value)
    
    if (topLevelNodes.value.length > 0 && !selectedTopRegion.value) {
      selectedTopRegion.value = topLevelNodes.value[0].id
    }
    
    loadDeviceCounts()
  }).catch(() => {
    loading.value = false
  })
}

/** 构建区域树选项 */
function buildZoneTreeOptions(nodes) {
  const options = []
  nodes.forEach(node => {
    const option = {
      id: node.id,
      zname: node.zname,
      children: node.children ? buildZoneTreeOptions(node.children) : []
    }
    options.push(option)
  })
  return options
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

/** 查询类别列表 */
function getCategoryList() {
  listCategory().then(response => {
    // 适配不同的响应结构
    const categoryData = response.rows || response.data || []
    categoryOptions.value = categoryData.map(category => ({
      id: category.id,
      cname: category.cname,
      ctype: category.ctype,
      subjectId: category.subjectId,
      remark: category.remark
    }))
  }).catch(error => {
    console.error('加载类别数据失败:', error)
    ElMessage.error('加载设备类别数据失败')
  })
}

/** 查询设备列表 */
function getList() {
  loading.value = true
  listDevice(queryParams.value).then(response => {
    deviceList.value = response.rows || response.data || []
    total.value = response.total || deviceList.value.length
    
    deviceList.value.forEach(device => {
      device.zonePath = getZonePath(device.zoneId1, device.zoneId2, device.zoneId3)
      device.categoryName = getCategoryName(device.categoryId)
    })
    
    deviceTreeData.value = buildDeviceTree(deviceList.value)
    updateParentDeviceOptions()
    loading.value = false
  }).catch(error => {
    console.error('API请求错误:', error)
    loading.value = false
  })
}

/** 获取区域路径 */
function getZonePath(zoneId1, zoneId2, zoneId3) {
  const path = []
  if (zoneId1) {
    const zone1 = findZoneById(zoneId1)
    if (zone1) path.push(zone1.zname)
  }
  if (zoneId2) {
    const zone2 = findZoneById(zoneId2)
    if (zone2) path.push(zone2.zname)
  }
  if (zoneId3) {
    const zone3 = findZoneById(zoneId3)
    if (zone3) path.push(zone3.zname)
  }
  return path.join(' - ')
}

/** 获取类别名称 */
function getCategoryName(categoryId) {
  if (!categoryId) return ''
  const category = categoryOptions.value.find(cat => cat.id === categoryId)
  return category ? category.cname : ''
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

/** 更新父设备选项 */
function updateParentDeviceOptions() {
  // 排除当前编辑的设备本身，避免循环引用
  const currentDeviceId = form.value.id
  parentDeviceOptions.value = deviceList.value.filter(device => 
    device.id !== currentDeviceId && (device.isHost || device.isBus)
  )
}

/** 顶级区域选择变化 */
function handleTopRegionChange(regionId) {
  selectedTopRegion.value = regionId
  currentProject.value = null
  deviceList.value = []
  deviceTreeData.value = []
  queryParams.value.projectId = null
}

/** 项目点击事件 */
function handleProjectClick(project) {
  currentProject.value = project
  queryParams.value.projectId = project.id
  queryParams.value.pageNum = 1
  getList()
}

/** 区域选择变化 */
function handleZoneChange(value) {
  if (value && value.length > 0) {
    const len = value.length
    // 取最后三个（或少于三个）作为区域ID，确保层级关系：id1(根) -> id2 -> id3(叶)
    // 例如：
    // [A, B, C, D] -> 取[B, C, D] -> id1=B, id2=C, id3=D
    // [A, B, C]    -> 取[A, B, C] -> id1=A, id2=B, id3=C
    // [A, B]       -> 取[A, B]    -> id1=A, id2=B, id3=null
    // [A]          -> 取[A]       -> id1=A, id2=null, id3=null
    
    const start = Math.max(0, len - 3)
    const relevantIds = value.slice(start)
    
    form.value.zoneId1 = relevantIds.length > 0 ? relevantIds[0] : null
    form.value.zoneId2 = relevantIds.length > 1 ? relevantIds[1] : null
    form.value.zoneId3 = relevantIds.length > 2 ? relevantIds[2] : null
  } else {
    form.value.zoneId1 = null
    form.value.zoneId2 = null
    form.value.zoneId3 = null
  }
}

/** 主机状态变化 */
function handleHostChange(value) {
  if (value === 1) {
    form.value.isBus = 0
    loadChildDevices()
  }
}

/** 总线状态变化 */
function handleBusChange(value) {
  if (value === 1) {
    form.value.isHost = 0
  }
}

/** 加载子设备选项 */
function loadChildDevices() {
  if (!form.value.projectId && !currentProject.value) {
    ElMessage.warning('请先选择项目')
    return
  }
  
  childDeviceLoading.value = true
  const projectId = form.value.projectId || currentProject.value?.id
  
  listDevice({
    projectId: projectId,
    pageSize: 1000,
    isHost: 0 // 只加载非主机设备作为子设备
  }).then(response => {
    childDeviceOptions.value = (response.rows || response.data || []).map(device => ({
      ...device,
      zonePath: getZonePath(device.zoneId1, device.zoneId2, device.zoneId3),
      categoryName: getCategoryName(device.categoryId)
    }))
    
    // 应用当前区域筛选
    applyZoneFilter()
    
    if (form.value.id && form.value.childDeviceIds) {
      const selectedIds = form.value.childDeviceIds
      selectedChildDevices.value = childDeviceOptions.value.filter(device => 
        selectedIds.includes(device.id)
      )
      nextTick(() => {
        selectedChildDevices.value.forEach(row => {
          const found = filteredChildDevices.value.find(item => item.id === row.id)
          if (found && childDeviceTableRef.value) {
            childDeviceTableRef.value.toggleRowSelection(found, true)
          }
        })
      })
    }
    
    childDeviceLoading.value = false
  }).catch(error => {
    console.error('加载子设备失败:', error)
    childDeviceLoading.value = false
  })
}

/** 区域筛选变化 */
function handleZoneFilterChange(value) {
  selectedZonePath.value = value
  if (value && value.length > 0) {
    // 获取选中的区域名称
    const zoneId = value[value.length - 1]
    const zone = findZoneById(zoneId)
    selectedZoneName.value = zone ? zone.zname : ''
  } else {
    selectedZoneName.value = ''
  }
  applyZoneFilter()
}

/** 应用区域筛选 */
function applyZoneFilter() {
  if (!selectedZonePath.value || selectedZonePath.value.length === 0) {
    filteredChildDevices.value = [...childDeviceOptions.value]
    return
  }
  
  const targetZoneId = selectedZonePath.value[selectedZonePath.value.length - 1]
  
  filteredChildDevices.value = childDeviceOptions.value.filter(device => {
    // 检查设备是否属于选中的区域或其子区域
    return isDeviceInZone(device, targetZoneId)
  })
  
  // 同时应用文本搜索筛选
  if (childDeviceFilter.value) {
    filterChildDevices()
  }
}

/** 检查设备是否在指定区域 */
function isDeviceInZone(device, zoneId) {
  // 检查设备的三个区域ID是否匹配
  if (device.zoneId1 === zoneId || device.zoneId2 === zoneId || device.zoneId3 === zoneId) {
    return true
  }
  
  // 如果设备有区域路径，检查路径中是否包含该区域
  if (device.zonePath && device.zonePath.includes(selectedZoneName.value)) {
    return true
  }
  
  return false
}

/** 清除区域筛选 */
function clearSelectedZone() {
  selectedZonePath.value = []
  selectedZoneName.value = ''
  filteredChildDevices.value = [...childDeviceOptions.value]
  if (childDeviceFilter.value) {
    filterChildDevices()
  }
}

/** 刷新子设备列表 */
function refreshChildDevices() {
  loadChildDevices()
}

/** 子设备选择变化 */
function handleChildDeviceSelectionChange(selection) {
  selectedChildDevices.value = selection
  form.value.childDeviceIds = selection.map(device => device.id)
}

/** 过滤子设备 */
function filterChildDevices() {
  if (!childDeviceFilter.value) {
    // 如果没有搜索文本，只应用区域筛选
    applyZoneFilter()
    return
  }
  
  const filter = childDeviceFilter.value.toLowerCase()
  
  if (selectedZonePath.value && selectedZonePath.value.length > 0) {
    // 在已区域筛选的基础上进行文本搜索
    filteredChildDevices.value = filteredChildDevices.value.filter(device => 
      device.name?.toLowerCase().includes(filter) ||
      device.model?.toLowerCase().includes(filter) ||
      device.location?.toLowerCase().includes(filter) ||
      device.brand?.toLowerCase().includes(filter) ||
      device.zonePath?.toLowerCase().includes(filter)
    )
  } else {
    // 没有区域筛选时，在所有设备中搜索
    filteredChildDevices.value = childDeviceOptions.value.filter(device => 
      device.name?.toLowerCase().includes(filter) ||
      device.model?.toLowerCase().includes(filter) ||
      device.location?.toLowerCase().includes(filter) ||
      device.brand?.toLowerCase().includes(filter) ||
      device.zonePath?.toLowerCase().includes(filter)
    )
  }
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
    parentDeviceId: null,
    zoneId1: null,
    zoneId2: null,
    zoneId3: null,
    zonePath: [],
    location: null,
    brand: null,
    model: null,
    isHost: 0,
    isBus: 0,
    childDeviceIds: [],
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
    remark: null,
    // 重置时也包含默认的关联位置
    relatedlocation: '浙江省杭州市钱塘区 / 杭电辅助教学楼 / 一号教学楼 / 一楼 / 01教室'
  }
  selectedChildDevices.value = []
  selectedZonePath.value = []
  selectedZoneName.value = ''
  childDeviceFilter.value = ''
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
  if (currentProject.value) {
    form.value.projectId = currentProject.value.id
  }
  updateParentDeviceOptions()
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getDevice(_id).then(response => {
    const deviceData = response.data
    form.value = {
      ...deviceData,
      zonePath: deviceData.zoneId1 && deviceData.zoneId2 && deviceData.zoneId3 ? 
        [deviceData.zoneId1, deviceData.zoneId2, deviceData.zoneId3] : [],
      // 确保 relatedlocation 有值，如果没有则使用默认值
      relatedlocation: deviceData.relatedlocation || '浙江省杭州市钱塘区 / 杭电辅助教学楼 / 一号教学楼 / 一楼 / 01教室'
    }
    open.value = true
    title.value = "修改设备"
    updateParentDeviceOptions()
    
    if (form.value.isHost === 1) {
      nextTick(() => {
        loadChildDevices()
      })
    }
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["deviceRef"].validate(valid => {
    if (valid) {
      const submitData = {
        ...form.value,
        childDeviceIds: form.value.childDeviceIds || []
      }
      
      if (form.value.id != null) {
        updateDevice(submitData).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
          if (form.value.projectId) {
            loadDeviceCounts()
          }
        })
      } else {
        addDevice(submitData).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
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
    if (currentProject.value) {
      loadDeviceCounts()
    }
  }).catch(() => {})
}

// 拖拽相关方法
/** 拖拽开始 */
const handleDragStart = (node) => {
  console.log('拖拽开始:', node.data.name)
}

/** 拖拽结束 */
const handleDragEnd = (draggingNode, dropNode, dropType) => {
  console.log('拖拽结束:', draggingNode.data.name, dropNode?.data.name, dropType)
}

/** 节点放置 */
const handleDrop = async (draggingNode, dropNode, dropType) => {
  console.log('节点放置:', draggingNode.data.name, dropNode.data.name, dropType)
  
  try {
    let newParentDeviceId = null
    if (dropType === 'inner') {
      newParentDeviceId = dropNode.data.id
    } else if (dropType === 'before' || dropType === 'after') {
      newParentDeviceId = dropNode.data.parentDeviceId
    }
    
    const updateData = {
      id: draggingNode.data.id,
      parentDeviceId: newParentDeviceId
    }
    
    await updateDevice(updateData)
    ElMessage.success('设备关系更新成功')
    getList()
    
  } catch (error) {
    console.error('更新设备关系失败:', error)
    ElMessage.error('设备关系更新失败')
    getList()
  }
}

/** 允许拖拽 */
const allowDrag = (draggingNode) => {
  return true
}

/** 允许放置 */
const allowDrop = (draggingNode, dropNode, type) => {
  if (type === 'inner') {
    const isDescendant = (node, targetId) => {
      if (node.data.id === targetId) return true
      if (node.childNodes) {
        for (const child of node.childNodes) {
          if (isDescendant(child, targetId)) return true
        }
      }
      return false
    }
    
    if (isDescendant(draggingNode, dropNode.data.id)) {
      ElMessage.warning('不能将设备拖拽到自己的子节点中')
      return false
    }
  }
  
  return true
}

// ================== 二维码查看 ==================
const qrCodeVisible = ref(false)
const currentQrUrl = ref('')

const handleViewQrCode = (row) => {
  if (row.qrUrl) {
    currentQrUrl.value = row.qrUrl
    qrCodeVisible.value = true
  } else if (row.qrCode && (row.qrCode.startsWith('http') || row.qrCode.startsWith('data:image'))) {
    // 兼容 qrCode 字段存储 URL 的情况
    currentQrUrl.value = row.qrCode
    qrCodeVisible.value = true
  } else {
    ElMessage.warning('该设备暂无二维码信息')
  }
}

// 初始化
onMounted(() => {
  getZoneList()
  getCategoryList()
})
</script>

<style scoped>
/* 样式保持不变，与之前相同 */
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

.drag-tips {
  margin-left: auto;
}

.device-tree-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 400px;
}

.device-tree-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 16px;
}

/* 自定义树节点样式 */
.custom-tree-node {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.custom-tree-node:last-child {
  border-bottom: none;
}

.node-content {
  display: flex;
  align-items: center;
  flex: 1;
  min-width: 0;
}

.node-icon {
  margin-right: 8px;
  display: flex;
  align-items: center;
}

.device-name {
  font-weight: 500;
  color: #303133;
  margin-right: 12px;
  min-width: 120px;
}

.device-tags {
  display: flex;
  gap: 4px;
  margin-right: 12px;
}

.device-details {
  display: flex;
  gap: 12px;
  color: #909399;
  font-size: 12px;
  flex: 1;
  min-width: 0;
}

.device-model,
.device-brand,
.device-location,
.device-zone,
.device-related-location {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.device-model {
  min-width: 80px;
  max-width: 120px;
}

.device-brand {
  min-width: 60px;
  max-width: 80px;
}

.device-location {
  min-width: 100px;
}

.device-zone {
  color: #67c23a;
  background: #f0f9ff;
  padding: 2px 6px;
  border-radius: 4px;
  margin-left: 8px;
}

.device-related-location {
  color: #e6a23c;
  background: #fdf6ec;
  padding: 2px 6px;
  border-radius: 4px;
  margin-left: 8px;
  font-style: italic;
}

.node-actions {
  display: flex;
  gap: 4px;
  margin-left: 12px;
}

.tree-empty {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
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

/* 树形组件样式优化 */
.device-tree-card :deep(.el-tree) {
  flex: 1;
}

.device-tree-card :deep(.el-tree-node__content) {
  height: auto;
  padding: 4px 0;
}

.device-tree-card :deep(.el-tree-node__children) {
  padding-left: 16px;
}

.device-tree-card :deep(.el-tree-node.is-drop-inner) > .el-tree-node__content {
  background-color: #f0f7ff;
  border: 1px dashed #409eff;
}

/* 新增样式 */
.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.child-device-card {
  margin-top: 8px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 8px;
}

/* 区域选择器样式 */
.zone-selector-section {
  margin-bottom: 16px;
  padding: 12px;
  background: #f8f9fa;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
}

.section-title {
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  font-size: 14px;
}

.zone-tip {
  font-size: 12px;
  color: #606266;
  margin-top: 8px;
  display: flex;
  align-items: center;
}

.child-device-filter {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.selected-count {
  font-size: 12px;
  color: #409eff;
}

.child-device-list {
  border: 1px solid #e4e7ed;
  border-radius: 4px;
}

.child-device-empty {
  padding: 40px 20px;
  text-align: center;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
}

/* 类别选项样式 */
.category-option {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}

.category-name {
  flex: 1;
}

.category-subject {
  font-size: 12px;
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
  
  .device-details {
    flex-direction: column;
    gap: 2px;
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
  
  .custom-tree-node {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .node-actions {
    align-self: flex-end;
  }
}
</style>