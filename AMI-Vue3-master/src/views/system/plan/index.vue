<template>
  <div class="app-container">
    <transition name="fade-transform" mode="out-in">
      <div v-if="currentView === 'list'" key="list">
        <el-card shadow="never" class="mb-10">
          <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
            <el-row :gutter="20">
              <el-col :md="6" :sm="12">
                <el-form-item label="计划名称" prop="name" class="w-full">
                  <el-input
                    v-model="queryParams.name"
                    placeholder="请输入计划名称"
                    clearable
                    @keyup.enter="handleQuery"
                  />
                </el-form-item>
              </el-col>
              <el-col :md="6" :sm="12">
                <el-form-item label="开始时间" prop="startTime" class="w-full">
                  <el-date-picker clearable
                    v-model="queryParams.startTime"
                    type="date"
                    value-format="YYYY-MM-DD"
                    placeholder="请选择开始时间"
                    class="w-full">
                  </el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :md="6" :sm="12">
                <el-form-item label="结束时间" prop="endTime" class="w-full">
                  <el-date-picker clearable
                    v-model="queryParams.endTime"
                    type="date"
                    value-format="YYYY-MM-DD"
                    placeholder="请选择结束时间"
                    class="w-full">
                  </el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :md="6" :sm="12">
                <el-form-item>
                  <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                  <el-button icon="Refresh" @click="resetQuery">重置</el-button>
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>
        </el-card>

        <el-card class="box-card" shadow="hover">
          <template #header>
            <div class="card-header flex justify-between items-center">
              <span class="font-bold"><el-icon class="mr-1"><List /></el-icon>检测计划列表</span>
              <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </div>
          </template>

          <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
              <el-button
                type="primary"
                plain
                icon="Plus"
                @click="handleAdd"
                v-hasPermi="['system:plan:add']"
              >新增</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button
                type="success"
                plain
                icon="Edit"
                :disabled="single"
                @click="handleUpdate"
                v-hasPermi="['system:plan:edit']"
              >修改</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button
                type="danger"
                plain
                icon="Delete"
                :disabled="multiple"
                @click="handleDelete"
                v-hasPermi="['system:plan:remove']"
              >删除</el-button>
            </el-col>
            <el-col :span="1.5">
              <el-button
                type="warning"
                plain
                icon="Download"
                @click="handleExport"
                v-hasPermi="['system:plan:export']"
              >导出</el-button>
            </el-col>
          </el-row>

          <el-table v-loading="loading" :data="planList" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="项目名称" align="center" prop="project.zname" />
            <el-table-column label="公司名称" align="center" prop="company.name" />
            <el-table-column label="计划名称" align="center" prop="name" />
            <el-table-column label="设备总数" align="center" prop="totalNum" />
            <el-table-column label="通过数" align="center" prop="goodNum" />
            <el-table-column label="不通过数" align="center" prop="badNum" />
            <el-table-column label="开始时间" align="center" prop="schedule.startTime" width="180">
              <template #default="scope">
                <span>{{ parseTime(scope.row.schedule?.startTime, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="结束时间" align="center" prop="schedule.endTime" width="180">
              <template #default="scope">
                <span>{{ parseTime(scope.row.schedule?.endTime, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="状态" align="center" prop="status">
               <template #default="scope">
                  <el-tag v-if="scope.row.status == 0" type="info">未检查完成</el-tag>
                  <el-tag v-else-if="scope.row.status == 1" type="success">检测通过</el-tag>
                  <el-tag v-else-if="scope.row.status == 2" type="danger">检测出现异常</el-tag>
               </template>
            </el-table-column>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
              <template #default="scope">
                <el-button link type="primary" icon="View" @click="handlePreview(scope.row)">预览</el-button>
                <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:plan:edit']">修改</el-button>
                <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:plan:remove']">删除</el-button>
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
      </div>

      <div v-else-if="currentView === 'add'" key="add">
        <plan-add @save="handleAddSave" @cancel="handleAddCancel" />
      </div>

      <div v-else-if="currentView === 'edit'" key="edit">
        <plan-edit :planId="currentPlanId" @save="handleEditSave" @cancel="handleEditCancel" />
      </div>
    </transition>

    <!-- 预览弹窗 -->
    <el-dialog title="检测计划预览" v-model="previewOpen" width="800px" append-to-body>
      <div v-if="previewData">
        <el-descriptions :column="2" border>
           <el-descriptions-item label="计划名称">{{ previewData.name }}</el-descriptions-item>
           <el-descriptions-item label="项目名称">{{ previewData.project?.zname }}</el-descriptions-item>
           <el-descriptions-item label="巡检负责人">{{ previewData.inspector }}</el-descriptions-item>
           <el-descriptions-item label="巡检公司">{{ previewData.company?.name }}</el-descriptions-item>
           <el-descriptions-item label="开始时间">{{ formatDateTime(previewData.schedule?.startTime) }}</el-descriptions-item>
           <el-descriptions-item label="结束时间">{{ formatDateTime(previewData.schedule?.endTime) }}</el-descriptions-item>
           <el-descriptions-item label="设备总数">{{ previewData.totalNum }}</el-descriptions-item>
           <el-descriptions-item label="通过数">{{ previewData.goodNum }}</el-descriptions-item>
           <el-descriptions-item label="不通过数">{{ previewData.badNum }}</el-descriptions-item>
           <el-descriptions-item label="计划状态">
              <el-tag v-if="previewData.status == 0" type="info">未检查完成</el-tag>
              <el-tag v-else-if="previewData.status == 1" type="success">检测通过</el-tag>
              <el-tag v-else-if="previewData.status == 2" type="danger">检测出现异常</el-tag>
           </el-descriptions-item>
        </el-descriptions>
        
        <el-divider content-position="left">区域与人员</el-divider>
        <el-table :data="previewData.personnel || []" style="width: 100%" border size="small">
          <el-table-column label="巡检人员" width="120">
             <template #default="scope">
                <el-link type="primary" @click="handlePlanUserClick(scope.row.id)">{{ scope.row.name }}</el-link>
             </template>
          </el-table-column>
          <el-table-column label="分配区域">
             <template #default="scope">
                <el-tag v-for="area in scope.row.assignedAreas" :key="area.id" class="mr-1 mb-1" size="small">
                  {{ area.name }}
                </el-tag>
             </template>
          </el-table-column>
        </el-table>

        <el-divider content-position="left">相关文档</el-divider>
        <el-table :data="previewData.documents || []" style="width: 100%" border size="small">
           <el-table-column label="文件名称">
              <template #default="scope">
                 <el-link type="primary" @click="handlePlanContentlibClick(scope.row.id)">{{ scope.row.title }}</el-link>
              </template>
           </el-table-column>
           <el-table-column label="查看">
              <template #default="scope">
                 <el-link type="primary" :href="getFullLocation(scope.row.location)" target="_blank">下载/查看</el-link>
              </template>
           </el-table-column>
        </el-table>
      </div>
      <template #footer>
        <el-button @click="previewOpen = false">关 闭</el-button>
      </template>
    </el-dialog>

    <!-- 计划用户详情弹窗 -->
    <el-dialog title="人员信息" v-model="planUserOpen" width="500px" append-to-body>
      <el-descriptions :column="1" border v-if="planUserData">
        <el-descriptions-item label="姓名">{{ planUserData.name }}</el-descriptions-item>
        <el-descriptions-item label="电话">{{ planUserData.phone }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ planUserData.remark }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="planUserOpen = false">关 闭</el-button>
      </template>
    </el-dialog>

    <!-- 计划文档详情弹窗 -->
    <el-dialog title="文件信息" v-model="planContentlibOpen" width="500px" append-to-body>
      <el-descriptions :column="1" border v-if="planContentlibData">
        <el-descriptions-item label="文件名称">{{ planContentlibData.title }}</el-descriptions-item>
        <el-descriptions-item label="文件路径">{{ planContentlibData.location }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="planContentlibOpen = false">关 闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Plan">
import { listPlan, getPlan, delPlan, addPlan, updatePlan } from "@/api/system/plan"
import { getPlanUser } from "@/api/system/planUser"
import { getPlanContentlib } from "@/api/system/planContentlib"
import PlanAdd from './add.vue'
import PlanEdit from './edit.vue'
import { getCurrentInstance, reactive, ref, toRefs } from "vue"

const { proxy } = getCurrentInstance()
const baseUrl = import.meta.env.VITE_APP_BASE_API

const planList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const currentView = ref('list') // list, add, edit
const currentPlanId = ref(null)

const previewOpen = ref(false)
const previewData = ref(null)

const planUserOpen = ref(false)
const planUserData = ref({})

const planContentlibOpen = ref(false)
const planContentlibData = ref({})

function handlePlanUserClick(id) {
  if (!id) return;
  getPlanUser(id).then(response => {
    planUserData.value = response.data
    planUserOpen.value = true
  })
}

function handlePlanContentlibClick(id) {
  if (!id) return;
  getPlanContentlib(id).then(response => {
    planContentlibData.value = response.data
    planContentlibOpen.value = true
  })
}

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    projectId: null,
    deptId: null,
    name: null,
    startTime: null,
    endTime: null,
    creator: null,
    creatorTime: null,
    modifier: null,
    modifierTime: null
  }
})

const { queryParams } = toRefs(data)

/** 查询检测计划管理列表 */
function getList() {
  loading.value = true
  listPlan(queryParams.value).then(response => {
    planList.value = response.rows
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

/** 新增按钮操作 */
function handleAdd() {
  currentView.value = 'add'
}

function handleAddSave() {
  currentView.value = 'list'
  getList()
  proxy.$modal.msgSuccess("新增成功")
}

function handleAddCancel() {
  currentView.value = 'list'
}

/** 修改按钮操作 */
function handleUpdate(row) {
  const _id = row.id || ids.value[0]
  if (!_id) {
    proxy.$modal.msgWarning("请选择一条记录")
    return
  }
  currentPlanId.value = _id
  currentView.value = 'edit'
}

function handleEditSave() {
  currentView.value = 'list'
  currentPlanId.value = null
  getList()
}

function handleEditCancel() {
  currentView.value = 'list'
  currentPlanId.value = null
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除检测计划管理编号为"' + _ids + '"的数据项？').then(function() {
    return delPlan(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/plan/export', {
    ...queryParams.value
  }, `plan_${new Date().getTime()}.xlsx`)
}

function handlePreview(row) {
  loading.value = true
  getPlan(row.id).then(response => {
    previewData.value = response.data
    previewOpen.value = true
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

function formatDateTime(datetime) {
  if (!datetime) return '未设置'
  return datetime.replace('T', ' ')
}

function getFullLocation(path) {
  if (!path) return ""
  if (path.startsWith("http://") || path.startsWith("https://")) {
    return path
  }
  return baseUrl + path
}

getList()
</script>

<style scoped>
.mb-10 {
  margin-bottom: 20px;
}
.w-full {
  width: 100%;
}
.font-bold {
  font-weight: bold;
}
.mr-1 {
  margin-right: 5px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
/* Animation */
.fade-transform-leave-active,
.fade-transform-enter-active {
  transition: all 0.5s;
}

.fade-transform-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.fade-transform-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>