<template>
  <div class="app-container">
    <el-container class="layout-container">
      <el-aside width="320px" class="sidebar">
        <el-card class="sidebar-card">
          <template #header>
            <div class="sidebar-header">
              <span class="header-title">检测项</span>
              <div class="header-actions">
                <el-button type="primary" size="small" @click="openAddSubject">添加科目</el-button>
                <el-button size="small" @click="openAddItem" :disabled="!selectedSubjectId">添加检测项</el-button>
              </div>
            </div>
          </template>

          <div class="subject-bar">
            <el-select
              v-model="selectedSubjectId"
              placeholder="请选择科目"
              size="small"
              clearable
              style="flex: 1"
              @change="handleSubjectChange"
            >
              <el-option
                v-for="subject in subjectList"
                :key="subject.id"
                :label="subject.name"
                :value="subject.id"
              />
            </el-select>
          </div>

          <div class="tree-container" v-loading="loading">
            <el-tree
              v-if="inspectionTreeData.length"
              :data="inspectionTreeData"
              node-key="id"
              :props="treeProps"
              highlight-current
              :expand-on-click-node="false"
              :default-expand-all="true"
              @node-click="handleNodeClick"
              class="inspection-tree"
            >
              <template #default="{ data }">
                <span class="tree-node">
                  <span class="node-title">
                    <span class="node-name">{{ data.name }}</span>
                    <el-tag
                      v-if="data.isSubject"
                      type="info"
                      size="small"
                      class="node-tag"
                    >
                      科目
                    </el-tag>
                  </span>
                  <span v-if="!data.isSubject && data.subject" class="node-subject">
                    {{ data.subject }}
                  </span>
                </span>
              </template>
            </el-tree>
            <div v-else class="tree-empty">
              <el-empty description="暂无检测项数据" :image-size="80" />
            </div>
          </div>
        </el-card>
      </el-aside>

      <el-main class="main-content">
        <div class="top-actions">
          <div class="left-info">
            <span v-if="currentItem.name" class="item-name">
              {{ currentItem.name }}
            </span>
            <span v-if="currentSubjectLabel" class="item-subject">
              科目：{{ currentSubjectLabel }}
            </span>
          </div>
          <div class="right-actions">
            <el-button
              type="primary"
              :disabled="!currentItem.id"
              :loading="saving"
              @click="handleSave"
            >
              保存
            </el-button>
            <el-button
              type="danger"
              :disabled="!currentItem.id"
              @click="handleDeleteCurrent"
            >
              删除
            </el-button>
          </div>
        </div>

        <div v-if="currentItem.id" class="detail-content">
          <div class="item-header">
            <div class="item-header-main">
              <span class="item-title">{{ currentItem.name }}</span>
              <span v-if="currentSubjectLabel" class="item-header-subject">
                （{{ currentSubjectLabel }}）
              </span>
            </div>
            <div v-if="currentItem.remark" class="item-remark">
              备注：{{ currentItem.remark }}
            </div>
          </div>

          <el-row :gutter="16">
            <el-col :span="24">
              <el-card class="editor-card" header="技术要求">
                <editor v-model="currentItem.requirements" :min-height="260" />
              </el-card>
            </el-col>
            <el-col :span="24">
              <el-card class="editor-card" header="检测方法">
                <editor v-model="currentItem.method" :min-height="260" />
              </el-card>
            </el-col>
          </el-row>
        </div>
        <div v-else class="empty-state">
          <p>请在左侧选择具体的检测项</p>
        </div>
      </el-main>

      <el-dialog
        v-model="addSubjectDialogVisible"
        title="添加科目"
        width="400px"
      >
        <el-form @submit.prevent>
          <el-form-item label="科目名称">
            <el-input v-model="addSubjectForm.name" placeholder="请输入科目名称" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="addSubjectDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitAddSubject">确定</el-button>
        </template>
      </el-dialog>

      <el-dialog
        v-model="addItemDialogVisible"
        title="添加检测项"
        width="800px"
      >
        <el-form label-width="90px" @submit.prevent>
          <el-form-item label="所属科目">
            <el-select
              v-model="addItemForm.subjectId"
              placeholder="请选择科目"
              style="width: 100%"
              @change="handleAddItemSubjectChange"
            >
              <el-option
                v-for="subject in subjectList"
                :key="subject.id"
                :label="subject.name"
                :value="subject.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="父级节点">
            <el-tree-select
              v-model="addItemForm.parentId"
              :data="addItemTreeOptions"
              :props="{
                value: 'id',
                label: 'name',
                children: 'children'
              }"
              value-key="id"
              placeholder="请选择父级检测项"
              check-strictly
              style="width: 100%"
              clearable
            />
          </el-form-item>
          <el-form-item label="名称">
            <el-input v-model="addItemForm.name" placeholder="请输入检测项名称" />
          </el-form-item>
          <el-form-item label="技术要求">
            <editor v-model="addItemForm.requirements" :min-height="160" />
          </el-form-item>
          <el-form-item label="检测方法">
            <editor v-model="addItemForm.method" :min-height="160" />
          </el-form-item>
        </el-form>
        <template #footer>
          <el-button @click="addItemDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitAddItem">确定</el-button>
        </template>
      </el-dialog>
    </el-container>
  </div>
</template>

<script setup name="InspectionItem">
import { listInspectionItem, addInspectionItem, updateInspectionItem, delInspectionItem } from "@/api/system/inspectionItem"

const { proxy } = getCurrentInstance()

const loading = ref(true)
const saving = ref(false)
const inspectionTreeData = ref([])
const allItems = ref([])
const currentItem = ref({})
const subjectList = ref([])
const selectedSubjectId = ref(null)
const fullTreeData = ref([])
const addSubjectDialogVisible = ref(false)
const addSubjectForm = reactive({
  name: ""
})
const addItemDialogVisible = ref(false)
const addItemForm = reactive({
  subjectId: null,
  parentId: null,
  name: "",
  requirements: "",
  method: ""
})
const addItemTreeOptions = ref([])

const treeProps = {
  children: "children",
  label: "name"
}

const currentSubjectLabel = computed(() => {
  if (!currentItem.value) return ""
  if (currentItem.value.subject) return currentItem.value.subject
  if (currentItem.value.subjectId != null) {
    return `科目 ${currentItem.value.subjectId}`
  }
  return ""
})

function markSubjects(list) {
  return list.map(item => ({
    ...item,
    isSubject: !item.pid || item.pid === 0
  }))
}

function buildFullTree(list) {
  return proxy.handleTree(list, "id", "pid")
}

function findNodeById(nodes, id) {
  for (const node of nodes) {
    if (node.id === id) {
      return node
    }
    if (node.children && node.children.length > 0) {
      const found = findNodeById(node.children, id)
      if (found) {
        return found
      }
    }
  }
  return null
}

function refreshTreeBySubject() {
  if (!selectedSubjectId.value) {
    inspectionTreeData.value = fullTreeData.value
    return
  }
  const node = findNodeById(fullTreeData.value, selectedSubjectId.value)
  inspectionTreeData.value = node ? [node] : []
}

function refreshAddItemTreeOptions() {
  if (!selectedSubjectId.value || !fullTreeData.value.length) {
    addItemTreeOptions.value = []
    return
  }
  const node = findNodeById(fullTreeData.value, selectedSubjectId.value)
  addItemTreeOptions.value = node ? [node] : []
}

function getList() {
  loading.value = true
  listInspectionItem().then(response => {
    let list = response.data || response.rows || []
    list = markSubjects(list)
    allItems.value = list
    fullTreeData.value = buildFullTree(list)
    subjectList.value = list.filter(item => item.isSubject)
    if (!selectedSubjectId.value && subjectList.value.length > 0) {
      selectedSubjectId.value = subjectList.value[0].id
    }
    refreshTreeBySubject()
    refreshAddItemTreeOptions()
    if (currentItem.value && currentItem.value.id) {
      const found = allItems.value.find(i => i.id === currentItem.value.id)
      currentItem.value = found ? { ...found } : {}
    } else {
      currentItem.value = {}
    }
  }).finally(() => {
    loading.value = false
  })
}

function handleNodeClick(node) {
  if (node.isSubject) {
    currentItem.value = {}
    return
  }
  const item = allItems.value.find(i => i.id === node.id)
  if (item) {
    currentItem.value = { ...item }
  }
}

function handleSave() {
  if (!currentItem.value || !currentItem.value.id) {
    proxy.$modal.msgError("请先选择需要保存的检测项")
    return
  }
  saving.value = true
  updateInspectionItem(currentItem.value).then(() => {
    proxy.$modal.msgSuccess("保存成功")
    getList()
  }).finally(() => {
    saving.value = false
  })
}

function handleDeleteCurrent() {
  if (!currentItem.value || !currentItem.value.id) {
    return
  }
  const id = currentItem.value.id
  proxy.$modal.confirm('是否确认删除该检测项？').then(() => {
    return delInspectionItem(id)
  }).then(() => {
    proxy.$modal.msgSuccess("删除成功")
    currentItem.value = {}
    getList()
  }).catch(() => {})
}

function handleSubjectChange() {
  refreshTreeBySubject()
  refreshAddItemTreeOptions()
  currentItem.value = {}
}

function openAddSubject() {
  addSubjectForm.name = ""
  addSubjectDialogVisible.value = true
}

function submitAddSubject() {
  if (!addSubjectForm.name) {
    proxy.$modal.msgError("请输入科目名称")
    return
  }
  addInspectionItem({
    name: addSubjectForm.name,
    pid: 0
  }).then(() => {
    proxy.$modal.msgSuccess("新增科目成功")
    addSubjectDialogVisible.value = false
    getList()
  })
}

function openAddItem() {
  if (!selectedSubjectId.value) {
    proxy.$modal.msgError("请先选择科目")
    return
  }
  addItemForm.subjectId = selectedSubjectId.value
  addItemForm.parentId = selectedSubjectId.value
  addItemForm.name = ""
  addItemForm.requirements = ""
  addItemForm.method = ""
  refreshAddItemTreeOptions()
  addItemDialogVisible.value = true
}

function handleAddItemSubjectChange() {
  selectedSubjectId.value = addItemForm.subjectId
  addItemForm.parentId = addItemForm.subjectId
  refreshTreeBySubject()
  refreshAddItemTreeOptions()
}

function submitAddItem() {
  if (!addItemForm.subjectId) {
    proxy.$modal.msgError("请选择所属科目")
    return
  }
  if (!addItemForm.name) {
    proxy.$modal.msgError("请输入检测项名称")
    return
  }
  const pid = addItemForm.parentId || addItemForm.subjectId
  addInspectionItem({
    name: addItemForm.name,
    pid,
    requirements: addItemForm.requirements,
    method: addItemForm.method
  }).then(() => {
    proxy.$modal.msgSuccess("新增检测项成功")
    addItemDialogVisible.value = false
    getList()
  })
}

onMounted(() => {
  getList()
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.subject-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.tree-container {
  flex: 1;
  overflow: auto;
  padding-top: 8px;
}

.inspection-tree :deep(.el-tree-node__content) {
  height: 40px;
}

.tree-node {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.node-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.node-name {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.node-tag {
  margin-left: 8px;
}

.node-subject {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

.tree-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
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
  align-items: center;
  margin-bottom: 16px;
}

.left-info {
  display: flex;
  align-items: center;
  gap: 16px;
  font-size: 14px;
  color: #606266;
}

.item-name {
  font-weight: 600;
  color: #303133;
}

.item-subject {
  color: #909399;
}

.detail-content {
  flex: 1;
}

.item-header {
  margin-bottom: 16px;
}

.item-header-main {
  display: flex;
  align-items: center;
  gap: 8px;
}

.item-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.item-header-subject {
  font-size: 14px;
  color: #909399;
}

.item-remark {
  margin-top: 4px;
  font-size: 13px;
  color: #909399;
}

.editor-card {
  height: 100%;
}

.editor-card + .editor-card {
  margin-top: 16px;
}

.empty-state {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #909399;
}

@media (max-width: 1024px) {
  .layout-container {
    flex-direction: column;
  }
  .sidebar {
    width: 100% !important;
    border-right: none;
    border-bottom: 1px solid #e4e7ed;
  }
}
</style>
