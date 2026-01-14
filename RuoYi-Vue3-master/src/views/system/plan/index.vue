<template>
  <div class="app-container">
    <transition name="fade-transform" mode="out-in">
      <div v-if="currentView === 'list'" key="list">
        <el-card class="box-card mb-10" shadow="hover">
          <template #header>
            <div class="card-header">
              <span class="font-bold"><el-icon class="mr-1"><Search /></el-icon>筛选查询</span>
            </div>
          </template>
          <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
            <el-row :gutter="20">
              <el-col :md="6" :sm="12">
                <el-form-item label="项目ID" prop="projectId" class="w-full">
                  <el-input
                    v-model="queryParams.projectId"
                    placeholder="请输入项目ID"
                    clearable
                    @keyup.enter="handleQuery"
                  />
                </el-form-item>
              </el-col>
              <el-col :md="6" :sm="12">
                <el-form-item label="公司ID" prop="deptId" class="w-full">
                  <el-input
                    v-model="queryParams.deptId"
                    placeholder="请输入公司ID"
                    clearable
                    @keyup.enter="handleQuery"
                  />
                </el-form-item>
              </el-col>
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
                <el-form-item label="创建者" prop="creator" class="w-full">
                  <el-input
                    v-model="queryParams.creator"
                    placeholder="请输入创建者"
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

          <el-table v-loading="loading" :data="planList" @selection-change="handleSelectionChange" border stripe>
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="编号" align="center" prop="id" width="80" />
            <el-table-column label="项目ID" align="center" prop="projectId" />
            <el-table-column label="公司ID" align="center" prop="deptId" />
            <el-table-column label="计划名称" align="center" prop="name" min-width="150" show-overflow-tooltip />
            <el-table-column label="开始时间" align="center" prop="startTime" width="120">
              <template #default="scope">
                <span>{{ parseTime(scope.row.startTime, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="结束时间" align="center" prop="endTime" width="120">
              <template #default="scope">
                <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="创建者" align="center" prop="creator" />
            <el-table-column label="创建时间" align="center" prop="creatorTime" width="120">
              <template #default="scope">
                <span>{{ parseTime(scope.row.creatorTime, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
              <template #default="scope">
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

        <!-- 修改检测计划管理对话框 (保留原逻辑用于修改) -->
        <el-dialog :title="title" v-model="open" width="500px" append-to-body>
          <el-form ref="planRef" :model="form" :rules="rules" label-width="80px">
            <el-form-item label="项目id" prop="projectId">
              <el-input v-model="form.projectId" placeholder="请输入项目id" />
            </el-form-item>
            <el-form-item label="公司id" prop="deptId">
              <el-input v-model="form.deptId" placeholder="请输入公司id" />
            </el-form-item>
            <el-form-item label="计划名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入计划名称" />
            </el-form-item>
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker clearable
                v-model="form.startTime"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择开始时间">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker clearable
                v-model="form.endTime"
                type="date"
                value-format="YYYY-MM-DD"
                placeholder="请选择结束时间">
              </el-date-picker>
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

      <div v-else-if="currentView === 'add'" key="add">
        <plan-add @save="handleAddSave" @cancel="handleAddCancel" />
      </div>
    </transition>
  </div>
</template>

<script setup name="Plan">
import { listPlan, getPlan, delPlan, addPlan, updatePlan } from "@/api/system/plan"
import PlanAdd from './add.vue'

const { proxy } = getCurrentInstance()

const planList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const currentView = ref('list') // list, add

const data = reactive({
  form: {},
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
  },
  rules: {
    projectId: [
      { required: true, message: "项目id不能为空", trigger: "blur" }
    ],
    deptId: [
      { required: true, message: "公司id不能为空", trigger: "blur" }
    ],
    name: [
      { required: true, message: "计划名称不能为空", trigger: "blur" }
    ],
    startTime: [
      { required: true, message: "开始时间不能为空", trigger: "blur" }
    ],
    endTime: [
      { required: true, message: "结束时间不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询检测计划管理列表 */
function getList() {
  loading.value = true
  listPlan(queryParams.value).then(response => {
    planList.value = response.rows
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
  proxy.resetForm("planRef")
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
  reset()
  const _id = row.id || ids.value
  getPlan(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改检测计划管理"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["planRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updatePlan(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addPlan(form.value).then(response => {
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
