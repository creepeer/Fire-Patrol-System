<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="设备名称" prop="deviceId">
        <el-select
          v-model="queryParams.deviceId"
          placeholder="请选择设备"
          clearable
          filterable
          style="width: 200px"
        >
          <el-option
            v-for="item in deviceOptions"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="用户名称" prop="creator">
        <el-select
          v-model="queryParams.creator"
          placeholder="请选择用户"
          clearable
          filterable
          style="width: 200px"
        >
          <el-option
            v-for="item in userOptions"
            :key="item.userName"
            :label="item.nickName || item.userName"
            :value="item.userName"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="扫描结果" prop="scanResult">
        <el-select v-model="queryParams.scanResult" placeholder="请选择扫描结果" clearable style="width: 200px">
          <el-option label="通过" value="1" />
          <el-option label="不通过" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
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
      <el-table-column label="设备名称" align="center" min-width="120">
        <template #default="scope">
          {{ formatDeviceName(scope.row.deviceId) }}
        </template>
      </el-table-column>
      <el-table-column label="区域名称" align="center" min-width="120">
        <template #default="scope">
          {{ formatZoneName(scope.row.zoneId) }}
        </template>
      </el-table-column>
      <el-table-column label="用户名称" align="center" min-width="100">
        <template #default="scope">
          {{ formatUserName(scope.row.creator) }}
        </template>
      </el-table-column>
      <el-table-column label="扫描结果" align="center" prop="scanResult">
         <template #default="scope">
            <el-tag :type="scope.row.scanResult == '1' ? 'success' : 'danger'">
               {{ scope.row.scanResult == '1' ? '通过' : '不通过' }}
            </el-tag>
         </template>
      </el-table-column>
      <el-table-column label="扫描备注" align="center" prop="scanRemark" />
      <el-table-column label="现场照片" align="center" prop="photos" />
      <el-table-column label="扫描时间" align="center" prop="creatorTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.creatorTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
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
  </div>
</template>

<script setup name="Scan">
import { listScan, delScan } from "@/api/system/scan"
import { listDevice } from "@/api/system/device"
import { listUser } from "@/api/system/user"
import { listZone } from "@/api/system/zone"

const { proxy } = getCurrentInstance()

const scanList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)

const deviceOptions = ref([])
const userOptions = ref([])
const zoneOptions = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    deviceId: null,
    scanResult: null,
    creator: null,
  }
})

const { queryParams } = toRefs(data)

/** 初始化数据 */
function initData() {
  // 获取设备列表
  listDevice({ pageNum: 1, pageSize: 1000 }).then(res => {
    deviceOptions.value = res.rows || []
  })
  // 获取用户列表
  listUser({ pageNum: 1, pageSize: 1000 }).then(res => {
    userOptions.value = res.rows || []
  })
  // 获取区域列表
  listZone({ pageNum: 1, pageSize: 1000 }).then(res => {
    zoneOptions.value = res.rows || []
  })
}

/** 格式化设备名称 */
function formatDeviceName(deviceId) {
  if (!deviceId) return ''
  const device = deviceOptions.value.find(d => d.id == deviceId)
  return device ? device.name : deviceId
}

/** 格式化区域名称 */
function formatZoneName(zoneId) {
  if (!zoneId) return ''
  const zone = zoneOptions.value.find(z => z.id == zoneId)
  return zone ? zone.zname : zoneId
}

/** 格式化用户名称 */
function formatUserName(userName) {
  if (!userName) return ''
  const user = userOptions.value.find(u => u.userName == userName)
  return user ? (user.nickName || user.userName) : userName
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

initData()
getList()
</script>
