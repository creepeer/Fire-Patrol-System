<template>
  <div class="app-container">
    <!-- 设备信息卡片 -->
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

    <!-- 关联计划卡片 -->
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

    <!-- 设备列表 (去掉了区域树) -->
    <el-card shadow="hover" v-if="planInfo">
      <template #header>
        <span>设备列表</span>
      </template>
      <el-table v-loading="deviceLoading" :data="deviceListData" border>
        <el-table-column label="设备名称" prop="name" />
        <el-table-column label="设备编号" prop="deviceCode" />
        <el-table-column label="位置" prop="location" />
        <el-table-column label="二维码" align="center" width="100">
           <template #default="scope">
              <el-image 
                v-if="scope.row.qrUrl" 
                :src="scope.row.qrUrl" 
                :preview-src-list="[scope.row.qrUrl]"
                style="width: 50px; height: 50px"
              />
              <span v-else>无</span>
           </template>
        </el-table-column>
        <el-table-column label="扫描状态" align="center">
          <template #default="scope">
            <el-tag :type="scope.row.scanStatus === '1' ? 'success' : (scope.row.scanStatus === '2' ? 'danger' : 'info')">
              {{ scope.row.scanStatus === '1' ? '已通过' : (scope.row.scanStatus === '2' ? '不通过' : '未扫描') }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200">
          <template #default="scope">
             <el-button size="small" type="success" @click="handleStatusChange(scope.row, '1')">通过</el-button>
             <el-button size="small" type="danger" @click="handleStatusChange(scope.row, '2')">不通过</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 备注弹窗 -->
    <el-dialog title="填写备注" v-model="remarkOpen" width="400px" append-to-body>
       <el-input v-model="remarkContent" type="textarea" placeholder="请输入不通过理由" />
       <template #footer>
          <div class="dialog-footer">
             <el-button type="primary" @click="submitRemark">确 定</el-button>
             <el-button @click="remarkOpen = false">取 消</el-button>
          </div>
       </template>
    </el-dialog>
  </div>
</template>

<script setup name="PlanUser">
import { listPlanUser, updatePlanUser } from "@/api/system/planUser"
import { listDevicePlanByZoneId, getDevice } from "@/api/system/device"
import { listPlan } from "@/api/system/plan"
import useUserStore from '@/store/modules/user'
import { useRoute } from 'vue-router'
import { Monitor, List } from '@element-plus/icons-vue'

const { proxy } = getCurrentInstance()
const route = useRoute()
const userStore = useUserStore()

const deviceInfo = ref(null)
const planInfo = ref(null)
const deviceListData = ref([])
const deviceLoading = ref(false)
const planOptions = ref([])
const currentPlanId = ref(null)
const currentZoneId = ref(null)

const remarkOpen = ref(false)
const remarkContent = ref("")
const currentOperateRow = ref(null)

// 监听计划变更
function handlePlanChange(val) {
  planInfo.value = planOptions.value.find(p => p.id === val)
  if (planInfo.value && deviceInfo.value) {
    loadDevices(currentZoneId.value)
  }
}

// 加载设备列表和状态
function loadDevices(zoneId) {
  if (!deviceInfo.value) {
    return
  }
  if (zoneId) {
    currentZoneId.value = zoneId
  }
  deviceLoading.value = true
  
  // 只请求当前设备的关联记录，不再获取整个区域的设备列表
  listPlanUser({ 
    planId: currentPlanId.value,
    userId: userStore.id,
    deviceId: deviceInfo.value.id
  }).then(response => {
     const planUsers = response.rows || response.data || []
     
     // 查找匹配的记录（通常只有一条或没有）
     const userRecord = planUsers.find(u => u.deviceId == deviceInfo.value.id)
     
     // 构造当前设备的数据对象，直接使用 deviceInfo 作为基础
     const currentDevice = {
        ...deviceInfo.value,
        // 根据用户需求：设备编号取 device.qrCode
        deviceCode: deviceInfo.value.qrCode || deviceInfo.value.qr_code || '',
        planUserId: userRecord ? userRecord.id : null,
        // 状态可能是数字或字符串，统一处理
        scanStatus: userRecord ? String(userRecord.status) : '0', 
        statusText: userRecord ? userRecord.statusText : '',
        // 构造二维码地址：取 device.qrUrl
        qrUrl: deviceInfo.value.qrUrl || deviceInfo.value.qr_url || null 
     }
     
     // 列表只显示当前这一个设备
     deviceListData.value = [currentDevice]
     deviceLoading.value = false
  })
}

// 点击通过/不通过
function handleStatusChange(row, status) {
  // status 传入的是字符串 '1' 或 '2'
  if (status === '2') {
     // 不通过需要填写备注
     remarkContent.value = ""
     currentOperateRow.value = row
     remarkOpen.value = true
  } else {
     submitScanResult(row, status, "")
  }
}

// 提交备注
function submitRemark() {
   if (!remarkContent.value) {
      proxy.$modal.msgError("请填写不通过理由")
      return
   }
   submitScanResult(currentOperateRow.value, '2', remarkContent.value)
   remarkOpen.value = false
}

// 提交结果
function submitScanResult(row, status, remark) {
   if (!row.planUserId) {
      // 如果没有 planUserId，说明还没有关联记录，可能需要先创建？
      // 但用户示例中是有 id 的，说明应该能找到。
      // 如果找不到，暂时提示错误或尝试仅提交必需字段
      // 这里假设一定能找到，或者后端支持无 ID 提交(如果是新增)
      // 但 updatePlanUser 是 PUT，通常需要 ID。
      // 让我们先尝试查找是否真的有 ID
      console.warn("未找到关联的 planUser ID")
   }

   const data = {
      planId: currentPlanId.value,
      deviceId: row.id,
      userId: userStore.id, // 当前用户ID
      zoneId: row.zoneId || currentZoneId.value, // 优先使用设备自身的zoneId，否则使用当前加载的zoneId
      status: status,
      remark: remark
   }
   
   if (!data.zoneId) {
      proxy.$modal.msgError("缺少区域ID，无法提交")
      return
   }
   
   if (row.planUserId) {
      data.id = row.planUserId
   }
   
   updatePlanUser(data).then(response => {
      proxy.$modal.msgSuccess("操作成功")
      // 刷新列表
      loadDevices(currentZoneId.value)
   })
}

onMounted(() => {
  const { deviceId } = route.query
  if (deviceId) {
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
      
      const uniqueZoneIds = [...new Set(relevantZoneIds)]

      // 获取关联计划
      if (uniqueZoneIds.length > 0) {
        const planPromises = uniqueZoneIds.map(zid => listPlan({ zoneId: zid }))
        
        Promise.all(planPromises).then(results => {
           let allPlans = []
           results.forEach(res => {
              if (res.rows && res.rows.length > 0) {
                 allPlans = allPlans.concat(res.rows)
              }
           })
           
           if (allPlans.length > 0) {
              const uniquePlans = Array.from(new Map(allPlans.map(item => [item.id, item])).values());
              planOptions.value = uniquePlans
              
              const activePlan = uniquePlans.find(p => p.status === '0')
              planInfo.value = activePlan || uniquePlans[0]
              currentPlanId.value = planInfo.value.id
              
              if (planInfo.value && deviceInfo.value) {
                // 确定使用哪个zoneId加载设备列表
                let targetZoneId = deviceInfo.value.zoneId
                if (!targetZoneId) {
                   // 如果deviceInfo.zoneId为空，尝试使用关联区域中的第一个（通常是叶子节点）
                   // 注意 uniqueZoneIds 是从 relevantZoneIds 去重得到的，顺序可能保留
                   // relevantZoneIds 添加顺序是 zoneId, zoneId3, zoneId2, zoneId1
                   if (uniqueZoneIds.length > 0) {
                      targetZoneId = uniqueZoneIds[0]
                   }
                }
                loadDevices(targetZoneId)
              }
            }
        })
      }
    })
  }
})
</script>
