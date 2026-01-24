<template>
  <div class="app-container">
    <el-container class="layout-container">
      <!-- 左侧菜单侧边栏 -->
      <el-aside width="350px" class="sidebar">
        <el-card header="区域：" class="sidebar-card">
          <!-- 树形菜单 -->
          <el-tree
            v-loading="loading"
            :data="areaTreeData"
            :props="treeProps"
            node-key="areaCode"
            highlight-current
            :expand-on-click-node="false"
            :default-expand-all="isExpandAll"
            @node-click="handleTreeNodeClick"
            class="area-tree"
          >
            <template #default="{ node, data }">
              <span class="custom-tree-node">
                <span class="node-info">
                  <span class="area-name">{{ data.areaName }}</span>
                </span>
                <span class="tree-actions">
                  <el-button link type="primary" size="small" @click.stop="handleAdd(data)" title="添加子地区">
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
          <el-form :model="queryParams" ref="queryRef" :inline="true" class="search-form">
            <el-form-item>
              <el-input
                v-model="queryParams.areaName"
                placeholder="请输入地区名称"
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
          
          <div class="action-buttons">
            <el-button
              type="primary"
              icon="Plus"
              @click="handleAdd"
              v-hasPermi="['system:area:add']"
            >新增</el-button>
            <el-button
              type="info"
              icon="Sort"
              @click="toggleExpandAll"
            >{{ isExpandAll ? '折叠' : '展开' }}</el-button>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
          </div>
        </div>

        <!-- 详情面板 -->
        <el-card header="地区详情" v-if="currentNode" class="detail-card">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="地区名称">{{ currentNode.areaName }}</el-descriptions-item>
            <el-descriptions-item label="行政代码">{{ currentNode.areaCode }}</el-descriptions-item>
            <el-descriptions-item label="层级">{{ currentNode.level }}</el-descriptions-item>
            <el-descriptions-item label="父级代码">{{ currentNode.parentCode || '无' }}</el-descriptions-item>
            <el-descriptions-item label="邮政编码">{{ currentNode.zipCode || '-' }}</el-descriptions-item>
            <el-descriptions-item label="区号">{{ currentNode.cityCode || '-' }}</el-descriptions-item>
            <el-descriptions-item label="简称">{{ currentNode.shortName || '-' }}</el-descriptions-item>
            <el-descriptions-item label="拼音">{{ currentNode.pinyin || '-' }}</el-descriptions-item>
            <el-descriptions-item label="经度">{{ currentNode.lng || '-' }}</el-descriptions-item>
            <el-descriptions-item label="纬度">{{ currentNode.lat || '-' }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="2">{{ currentNode.remark || '-' }}</el-descriptions-item>
          </el-descriptions>
        </el-card>
        
        <el-card v-else header="地区详情" class="detail-card">
          <div class="empty-state">
            <el-icon size="48" color="#909399"><InfoFilled /></el-icon>
            <p>请选择左侧的地区节点查看详情</p>
          </div>
        </el-card>
      </el-main>
    </el-container>

    <!-- 添加或修改地区对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="areaRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="层级" prop="level">
          <el-input-number v-model="form.level" placeholder="请输入层级" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="父级地区" prop="parentCode">
          <el-tree-select
            v-model="form.parentCode"
            :data="areaOptions"
            :props="{ value: 'areaCode', label: 'areaName', children: 'children' }"
            value-key="areaCode"
            placeholder="请选择父级地区"
            check-strictly
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="行政代码" prop="areaCode">
          <el-input v-model="form.areaCode" placeholder="请输入行政代码" />
        </el-form-item>
        <el-form-item label="地区名称" prop="areaName">
          <el-input v-model="form.areaName" placeholder="请输入地区名称" />
        </el-form-item>
        <el-form-item label="邮政编码" prop="zipCode">
          <el-input v-model="form.zipCode" placeholder="请输入邮政编码" />
        </el-form-item>
        <el-form-item label="区号" prop="cityCode">
          <el-input v-model="form.cityCode" placeholder="请输入区号" />
        </el-form-item>
        <el-form-item label="简称" prop="shortName">
          <el-input v-model="form.shortName" placeholder="请输入简称" />
        </el-form-item>
        <el-form-item label="组合名" prop="mergerName">
          <el-input v-model="form.mergerName" placeholder="请输入组合名" />
        </el-form-item>
        <el-form-item label="拼音" prop="pinyin">
          <el-input v-model="form.pinyin" placeholder="请输入拼音" />
        </el-form-item>
        <el-form-item label="经度" prop="lng">
          <el-input v-model="form.lng" placeholder="请输入经度" />
        </el-form-item>
        <el-form-item label="纬度" prop="lat">
          <el-input v-model="form.lat" placeholder="请输入纬度" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
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
import { ref, reactive, getCurrentInstance, nextTick } from 'vue'
import { Plus, Edit, Delete, InfoFilled } from '@element-plus/icons-vue'
import { listArea, getArea, delArea, addArea, updateArea } from "@/api/system/area"

const { proxy } = getCurrentInstance()

// 响应式数据
const areaTreeData = ref([])
const areaOptions = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const currentNode = ref(null) // 当前选中的节点

// 树形组件配置
const treeProps = {
  children: 'children',
  label: 'areaName'
}

// 表单数据
const data = reactive({
  form: {},
  queryParams: {
    areaName: null,
    areaCode: null,
    level: null
  },
  rules: {
    level: [
      { required: true, message: "层级不能为空", trigger: "blur" }
    ],
    areaCode: [
      { required: true, message: "行政代码不能为空", trigger: "blur" }
    ],
    areaName: [
      { required: true, message: "地区名称不能为空", trigger: "blur" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询地区列表 */
function getList() {
  loading.value = true
  listArea(queryParams.value).then(response => {
    areaTreeData.value = proxy.handleTree(response.data, "areaCode", "parentCode")
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

/** 查询地区下拉树结构 */
function getTreeselect() {
  listArea().then(response => {
    areaOptions.value = []
    const data = { areaCode: '0', areaName: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "areaCode", "parentCode")
    areaOptions.value.push(data)
  })
}

/** 树节点点击事件 */
function handleTreeNodeClick(data) {
  currentNode.value = data
  console.log('树节点点击:', data)
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
    level: null,
    parentCode: '0',
    areaCode: null,
    zipCode: null,
    cityCode: null,
    areaName: null,
    shortName: null,
    mergerName: null,
    pinyin: null,
    abbr: null,
    lng: null,
    lat: null,
    remark: null
  }
  if (proxy.$refs.areaRef) {
    proxy.$refs.areaRef.resetFields()
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
  if (row && row.areaCode) {
    form.value.parentCode = row.areaCode
  } else {
    form.value.parentCode = '0'
  }
  open.value = true
  title.value = "添加地区"
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  isExpandAll.value = !isExpandAll.value
  // 重新渲染树组件
  nextTick(() => {
    const tempData = [...areaTreeData.value]
    areaTreeData.value = []
    nextTick(() => {
      areaTreeData.value = tempData
    })
  })
}

/** 修改按钮操作 */
async function handleUpdate(row) {
  reset()
  await getTreeselect()
  if (row != null) {
    form.value.parentCode = row.parentCode
  }
  getArea(row.id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改地区"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["areaRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateArea(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addArea(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除地区 "' + row.areaName + '"？').then(function() {
    return delArea(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
    // 如果删除的是当前选中的节点，清空右侧详情
    if (currentNode.value && currentNode.value.id === row.id) {
      currentNode.value = null
    }
  }).catch(() => {})
}

// 初始化
getList()
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

.sidebar-card :deep(.el-card__header) {
  padding: 12px 16px;
  background: #f5f7fa;
  border-bottom: 1px solid #e4e7ed;
  font-weight: 600;
}

.sidebar-card :deep(.el-card__body) {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 0;
}

.area-tree {
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

.area-name {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
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

.top-actions {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
  gap: 16px;
}

.search-form {
  display: flex;
  align-items: center;
  gap: 12px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  align-items: center;
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
</style>