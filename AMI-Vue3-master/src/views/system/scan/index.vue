<template>
  <div class="app-container">
    <el-card v-if="deviceInfo" class="box-card mb8" shadow="hover">
      <template #header>
        <div class="clearfix">
          <span><el-icon><Monitor /></el-icon> 设备信息</span>
        </div>
      </template>
      <el-descriptions :column="3" border>
        <el-descriptions-item label="设备名称">{{ deviceInfo.name }}</el-descriptions-item>
        <el-descriptions-item label="设备ID">{{ deviceInfo.id }}</el-descriptions-item>
        <el-descriptions-item label="设备型号">{{ deviceInfo.model || '无' }}</el-descriptions-item>
        <el-descriptions-item label="设备品牌">{{ deviceInfo.brand || '无' }}</el-descriptions-item>
        <el-descriptions-item label="具体位置">{{ deviceInfo.location || '无' }}</el-descriptions-item>
        <el-descriptions-item label="所属区域">{{ deviceInfo.zonePath || '无' }}</el-descriptions-item>
        <el-descriptions-item label="关联位置">{{ deviceInfo.relatedlocation || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ deviceInfo.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card class="box-card mb8" shadow="hover" v-if="deviceInfo">
      <template #header>
        <div class="clearfix">
          <span><el-icon><List /></el-icon> 关联计划</span>
          <el-select 
            v-if="planOptions.length > 1" 
            v-model="currentPlanId" 
            placeholder="切换计划" 
            size="small" 
            style="float: right; width: 200px" 
            @change="handlePlanChange"
          >
            <el-option v-for="item in planOptions" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </div>
      </template>
      <div v-if="planInfo">
        <el-descriptions :column="3" border>
          <el-descriptions-item label="计划名称">{{ planInfo.name }}</el-descriptions-item>
          <el-descriptions-item label="项目名称">{{ planInfo.project?.zname || '无' }}</el-descriptions-item>
          <el-descriptions-item label="巡检负责人">{{ planInfo.inspector || '无' }}</el-descriptions-item>
          <el-descriptions-item label="开始时间">{{ parseTime(planInfo.schedule?.startTime, '{y}-{m}-{d}') }}</el-descriptions-item>
          <el-descriptions-item label="结束时间">{{ parseTime(planInfo.schedule?.endTime, '{y}-{m}-{d}') }}</el-descriptions-item>
          <el-descriptions-item label="状态">
             <el-tag :type="planInfo.status === '0' ? 'success' : 'info'">
               {{ planInfo.status === '0' ? '正常' : '停用' }}
             </el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <el-empty v-else description="暂无计划" :image-size="80"></el-empty>
    </el-card>

    <el-row :gutter="20" class="mb8" v-if="planInfo">
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <span>区域列表</span>
          </template>
          <div v-loading="zoneLoading">
             <el-tree
              :data="zoneTreeData"
              :props="{ label: 'zname', children: 'children' }"
              node-key="id"
              default-expand-all
              highlight-current
              @node-click="handleNodeClick"
             />
          </div>
        </el-card>
      </el-col>
      <el-col :span="18">
        <el-card shadow="hover">
          <template #header>
            <span>设备列表 <span v-if="currentZone">- {{ currentZone.zname }}</span></span>
          </template>
          <el-table v-loading="deviceLoading" :data="deviceListData" border>
            <el-table-column label="设备名称" prop="name" />
            <el-table-column label="设备编号" prop="deviceCode" />
            <el-table-column label="位置" prop="location" />
            <el-table-column label="扫描状态" align="center">
              <template #default="scope">
                <el-tag :type="scope.row.scanResult === '1' ? 'success' : (scope.row.scanResult === '2' ? 'danger' : 'info')">
                  {{ scope.row.scanResult === '1' ? '已通过' : (scope.row.scanResult === '2' ? '不通过' : '未扫描') }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
              <template #default="scope">
                 <el-button size="small" type="success" @click="handleStatusChange(scope.row, '1')" v-hasPermi="['system:scan:edit']">通过</el-button>
                 <el-button size="small" type="danger" @click="handleStatusChange(scope.row, '2')" v-hasPermi="['system:scan:edit']">不通过</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="设备ID，关联c_device表" prop="deviceId">
        <el-input
          v-model="queryParams.deviceId"
          placeholder="请输入设备ID，关联c_device表"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="计划ID，关联d_inspection_plan表" prop="planId">
        <el-input
          v-model="queryParams.planId"
          placeholder="请输入计划ID，关联d_inspection_plan表"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="区域ID" prop="zoneId">
        <el-input
          v-model="queryParams.zoneId"
          placeholder="请输入区域ID"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="扫描结果" prop="scanResult">
        <el-input
          v-model="queryParams.scanResult"
          placeholder="请输入扫描结果"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="删除状态" prop="deleted">
        <el-input
          v-model="queryParams.deleted"
          placeholder="请输入删除状态"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建者" prop="creator">
        <el-input
          v-model="queryParams.creator"
          placeholder="请输入创建者"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建时间" prop="creatorTime">
        <el-date-picker clearable
          v-model="queryParams.creatorTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择创建时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="修改者" prop="modifier">
        <el-input
          v-model="queryParams.modifier"
          placeholder="请输入修改者"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="修改时间" prop="modifierTime">
        <el-date-picker clearable
          v-model="queryParams.modifierTime"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="请选择修改时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['system:scan:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:scan:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:scan:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['system:scan:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="scanList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="主键" align="center" prop="id" />
      <el-table-column label="设备ID，关联c_device表" align="center" prop="deviceId" />
      <el-table-column label="计划ID，关联d_inspection_plan表" align="center" prop="planId" />
      <el-table-column label="区域ID" align="center" prop="zoneId" />
      <el-table-column label="扫描结果" align="center" prop="scanResult" />
      <el-table-column label="扫描备注" align="center" prop="scanRemark" />
      <el-table-column label="现场照片" align="center" prop="photos" />
      <el-table-column label="删除状态" align="center" prop="deleted" />
      <el-table-column label="创建者" align="center" prop="creator" />
      <el-table-column label="创建时间" align="center" prop="creatorTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.creatorTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="修改者" align="center" prop="modifier" />
      <el-table-column label="修改时间" align="center" prop="modifierTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.modifierTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:scan:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:scan:remove']">删除</el-button>
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

    <!-- 添加或修改设备扫描记录对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="scanRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="设备ID，关联c_device表" prop="deviceId">
          <el-input v-model="form.deviceId" placeholder="请输入设备ID，关联c_device表" />
        </el-form-item>
        <el-form-item label="计划ID，关联d_inspection_plan表" prop="planId">
          <el-input v-model="form.planId" placeholder="请输入计划ID，关联d_inspection_plan表" />
        </el-form-item>
        <el-form-item label="区域ID" prop="zoneId">
          <el-input v-model="form.zoneId" placeholder="请输入区域ID" />
        </el-form-item>
        <el-form-item label="扫描结果" prop="scanResult">
          <el-input v-model="form.scanResult" placeholder="请输入扫描结果" />
        </el-form-item>
        <el-form-item label="扫描备注" prop="scanRemark">
          <el-input v-model="form.scanRemark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="现场照片" prop="photos">
          <el-input v-model="form.photos" type="textarea" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="删除状态" prop="deleted">
          <el-input v-model="form.deleted" placeholder="请输入删除状态" />
        </el-form-item>
        <el-form-item label="创建者" prop="creator">
          <el-input v-model="form.creator" placeholder="请输入创建者" />
        </el-form-item>
        <el-form-item label="创建时间" prop="creatorTime">
          <el-date-picker clearable
            v-model="form.creatorTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择创建时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="修改者" prop="modifier">
          <el-input v-model="form.modifier" placeholder="请输入修改者" />
        </el-form-item>
        <el-form-item label="修改时间" prop="modifierTime">
          <el-date-picker clearable
            v-model="form.modifierTime"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="请选择修改时间">
          </el-date-picker>
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

<script setup name="Scan">
import { listScan, getScan, delScan, addScan, updateScan } from "@/api/system/scan"
import { getDevice, listDevice } from "@/api/system/device"
import { listPlan } from "@/api/system/plan"
import { listZone } from "@/api/system/zone"
import { handleTree } from "@/utils/ruoyi"
import useUserStore from '@/store/modules/user'
import { useRoute } from 'vue-router'
import { Monitor, List } from '@element-plus/icons-vue'

const { proxy } = getCurrentInstance()
const route = useRoute()
const userStore = useUserStore()

const deviceInfo = ref(null)
const planInfo = ref(null)
const scanList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

// 新增状态
const zoneTreeData = ref([])
const zoneLoading = ref(false)
const deviceListData = ref([])
const deviceLoading = ref(false)
const currentZone = ref(null)
const planOptions = ref([])
const currentPlanId = ref(null)

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    deviceId: null,
    planId: null,
    zoneId: null,
    scanResult: null,
    scanRemark: null,
    photos: null,
    deleted: null,
    creator: null,
    creatorTime: null,
    modifier: null,
    modifierTime: null
  },
  rules: {
    deviceId: [
      { required: true, message: "设备ID，关联c_device表不能为空", trigger: "blur" }
    ],
    planId: [
      { required: true, message: "计划ID，关联d_inspection_plan表不能为空", trigger: "blur" }
    ],
    scanResult: [
      { required: true, message: "扫描结果不能为空", trigger: "blur" }
    ],
    deleted: [
      { required: true, message: "删除状态不能为空", trigger: "blur" }
    ],
    creator: [
      { required: true, message: "创建者不能为空", trigger: "blur" }
    ],
    creatorTime: [
      { required: true, message: "创建时间不能为空", trigger: "blur" }
    ],
    modifier: [
      { required: true, message: "修改者不能为空", trigger: "blur" }
    ],
    modifierTime: [
      { required: true, message: "修改时间不能为空", trigger: "blur" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 计划变更 */
function handlePlanChange(val) {
  planInfo.value = planOptions.value.find(p => p.id === val)
  loadZoneTree()
  // 清空右侧设备列表
  deviceListData.value = []
  currentZone.value = null
}

/** 加载区域树 */
function loadZoneTree() {
  if (!planInfo.value || !planInfo.value.zoneId) return
  zoneLoading.value = true
  listZone().then(response => {
     const allZones = response.rows || response.data
     const tree = handleTree(allZones, "id", "parentId")
     // 查找计划关联的根区域
     const findNode = (nodes, id) => {
        for (const node of nodes) {
           if (node.id == id) return node
           if (node.children) {
              const found = findNode(node.children, id)
              if (found) return found
           }
        }
        return null
     }
     const rootNode = findNode(tree, planInfo.value.zoneId)
     zoneTreeData.value = rootNode ? [rootNode] : []
     zoneLoading.value = false
  })
}

/** 区域点击 */
function handleNodeClick(data) {
  currentZone.value = data
  loadDevices(data.id)
}

/** 加载设备和扫描状态 */
function loadDevices(zoneId) {
  deviceLoading.value = true
  Promise.all([
    listDevice({ zoneId: zoneId }),
    listScan({ planId: planInfo.value.id, zoneId: zoneId })
  ]).then(([deviceRes, scanRes]) => {
     const devices = deviceRes.rows || deviceRes.data
     const scans = scanRes.rows || scanRes.data
     
     deviceListData.value = devices.map(d => {
        const scan = scans.find(s => s.deviceId === d.id)
        return {
           ...d,
           scanRecord: scan, 
           scanResult: scan ? scan.scanResult : null
        }
     })
     deviceLoading.value = false
  })
}

/** 更新扫描状态 */
function handleStatusChange(row, status) {
   const data = {
      deviceId: row.id,
      planId: planInfo.value.id,
      zoneId: currentZone.value.id,
       scanResult: status,
       scanRemark: status === '2' ? '检测不通过' : '检测通过',
       creator: userStore.name || 'admin',
       creatorTime: proxy.parseTime(new Date(), '{y}-{m}-{d}'),
      deleted: '0'
   }
   
   // 如果已有记录，则更新
   if (row.scanRecord && row.scanRecord.id) {
      data.id = row.scanRecord.id
      data.modifier = userStore.name || 'admin'
      data.modifierTime = proxy.parseTime(new Date(), '{y}-{m}-{d}')
      updateScan(data).then(() => {
         proxy.$modal.msgSuccess("状态更新成功")
         loadDevices(currentZone.value.id)
      })
   } else {
      // 否则新增
      addScan(data).then(() => {
         proxy.$modal.msgSuccess("状态更新成功")
         loadDevices(currentZone.value.id)
      })
   }
}

/** 查询设备扫描记录列表 */
function getList() {
  loading.value = true
  listScan(queryParams.value).then(response => {
    scanList.value = response.rows
    total.value = response.total
    loading.value = false
  })
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
    deviceId: null,
    planId: null,
    zoneId: null,
    scanResult: null,
    scanRemark: null,
    photos: null,
    deleted: null,
    creator: null,
    creatorTime: null,
    modifier: null,
    modifierTime: null
  }
  proxy.resetForm("scanRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
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
  title.value = "添加设备扫描记录"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getScan(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改设备扫描记录"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["scanRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateScan(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addScan(form.value).then(response => {
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
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除设备扫描记录编号为"' + _ids + '"的数据项？').then(function() {
    return delScan(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/scan/export', {
    ...queryParams.value
  }, `scan_${new Date().getTime()}.xlsx`)
}

onMounted(() => {
  const { deviceId, planId, zoneId } = route.query
  if (deviceId) {
    queryParams.value.deviceId = deviceId
    getDevice(deviceId).then(response => {
      deviceInfo.value = response.data
      
      // 构造显示用的区域路径
      if (!deviceInfo.value.zonePath) {
         const names = []
         if (deviceInfo.value.zoneName1) names.push(deviceInfo.value.zoneName1)
         if (deviceInfo.value.zoneName2) names.push(deviceInfo.value.zoneName2)
         if (deviceInfo.value.zoneName3) names.push(deviceInfo.value.zoneName3)
         if (names.length > 0) {
             deviceInfo.value.zonePath = names.join('/')
         }
      }

      // 获取设备关联的所有区域ID (从叶子到根)
      const relevantZoneIds = []
      if (deviceInfo.value.zoneId) relevantZoneIds.push(deviceInfo.value.zoneId)
      if (deviceInfo.value.zoneId3) relevantZoneIds.push(deviceInfo.value.zoneId3)
      if (deviceInfo.value.zoneId2) relevantZoneIds.push(deviceInfo.value.zoneId2)
      if (deviceInfo.value.zoneId1) relevantZoneIds.push(deviceInfo.value.zoneId1)
      
      // 去重
      const uniqueZoneIds = [...new Set(relevantZoneIds)]

      // 获取关联计划 (尝试查找所有层级的计划)
      if (uniqueZoneIds.length > 0) {
        // 并行查询所有相关区域的计划
        const planPromises = uniqueZoneIds.map(zid => listPlan({ zoneId: zid }))
        
        Promise.all(planPromises).then(results => {
           let allPlans = []
           results.forEach(res => {
              if (res.rows && res.rows.length > 0) {
                 allPlans = allPlans.concat(res.rows)
              }
           })
           
           if (allPlans.length > 0) {
              // 去重 (根据计划ID)
              const uniquePlans = Array.from(new Map(allPlans.map(item => [item.id, item])).values());
              planOptions.value = uniquePlans
              
              // 优先显示正常状态的计划，其次按创建时间倒序
              const activePlan = uniquePlans.find(p => p.status === '0')
              planInfo.value = activePlan || uniquePlans[0]
              currentPlanId.value = planInfo.value.id
              
              if (planInfo.value) {
                loadZoneTree()
              }
            }
        })
      }
    })
  }
  if (planId) {
    queryParams.value.planId = planId
  }
  if (zoneId) {
    queryParams.value.zoneId = zoneId
  }
  getList()
})
</script>
