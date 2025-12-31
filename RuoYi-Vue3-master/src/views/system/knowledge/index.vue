<template>
  <div class="app-container">
    <el-container class="layout-container">
      <el-aside width="300px" class="sidebar">
        <el-card class="sidebar-card">
          <template #header>
            <div class="sidebar-header">
              <span class="header-title">知识库节点</span>
            </div>
          </template>

          <div class="top-region-selector">
            <el-select
              v-model="selectedRootId"
              placeholder="请选择项目"
              style="width: 100%"
              @change="handleRootChange"
            >
              <el-option
                v-for="item in zoneRootList"
                :key="item.id"
                :label="item.zname"
                :value="item.id"
              />
            </el-select>
          </div>

          <div class="project-list" v-loading="loading">
            <el-tree
              v-if="refreshTable"
              :data="knowledgeNodeList"
              node-key="id"
              :default-expand-all="isExpandAll"
              :expand-on-click-node="false"
              highlight-current
              @node-click="handleNodeClick"
            >
              <template #default="{ data }">
                <div class="custom-tree-node">
                  <div class="node-content">
                    <span class="node-name">{{ data.name }}</span>
                  </div>
                  <div class="node-actions">
                    <el-button
                      link
                      type="primary"
                      size="small"
                      icon="Edit"
                      @click.stop="handleUpdate(data)"
                      v-hasPermi="['system:knowledgeNode:edit']"
                    />
                    <el-button
                      link
                      type="primary"
                      size="small"
                      icon="Plus"
                      @click.stop="handleAdd(data)"
                      v-hasPermi="['system:knowledgeNode:add']"
                    />
                    <el-button
                      link
                      type="primary"
                      size="small"
                      icon="Delete"
                      @click.stop="handleDelete(data)"
                      v-hasPermi="['system:knowledgeNode:remove']"
                    />
                  </div>
                </div>
              </template>
            </el-tree>

            <div v-if="knowledgeNodeList.length === 0 && !loading" class="tree-empty">
              <el-empty description="暂无知识库节点" :image-size="80" />
            </div>
          </div>
        </el-card>
      </el-aside>

      <el-main class="main-content">
        <div class="top-actions">
          <div class="left-actions">
            <el-form
              :model="queryParams"
              ref="queryRef"
              :inline="true"
              v-show="showSearch"
              label-width="68px"
              class="search-form"
            >
         
           
              <el-form-item label="节点名称" prop="name">
                <el-input
                  v-model="queryParams.name"
                  placeholder="请输入节点名称"
                  clearable
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
          
            <el-button
              type="info"
              plain
              icon="Sort"
              @click="toggleExpandAll"
            >
              展开/折叠
            </el-button>
            <div class="action-tools">
              <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </div>
          </div>
        </div>

        <div class="detail-content">
          <template v-if="currentNode">
            <div class="detail-bar">
              <span class="detail-field detail-name">{{ currentNode.name }}</span>
              <span class="detail-field">
                项目ID：{{ currentNode.projectId || '暂无项目' }}
              </span>
              <span class="detail-field">
                备注：{{ currentNode.remark || '暂无备注' }}
              </span>
            </div>
            <div class="content-header">
              <el-button type="primary" icon="Plus" @click="handleAddContent">
                添加文档
              </el-button>
            </div>
            <el-table
              v-loading="contentLoading"
              :data="contentList"
              border
              size="small"
              class="content-table"
            >
              <el-table-column
                type="index"
                label="序号"
                width="60"
                align="center"
              />
              <el-table-column
                label="文档名称"
                prop="name"
                min-width="160"
                show-overflow-tooltip
              />
              <el-table-column
                label="模块类型"
                min-width="120"
                show-overflow-tooltip
              >
                <template #default="scope">
                  {{ getModuleTypeLabel(scope.row.status) }}
                </template>
              </el-table-column>
              <el-table-column
                label="备注"
                prop="remark"
                min-width="200"
                show-overflow-tooltip
              />
              <el-table-column
                label="文件"
                min-width="180"
                show-overflow-tooltip
              >
                <template #default="scope">
                  <el-link
                    v-if="scope.row.location"
                    :href="getFullLocation(scope.row.location)"
                    target="_blank"
                    type="primary"
                  >
                    {{ getFileNameFromPath(scope.row.location) }}
                  </el-link>
                  <span v-else>暂无</span>
                </template>
              </el-table-column>
              <el-table-column
                label="操作"
                width="160"
                align="center"
              >
                <template #default="scope">
                  <el-button
                    link
                    type="primary"
                    icon="Download"
                    @click="handleDownloadContent(scope.row)"
                  >
                    下载
                  </el-button>
                  <el-button
                    link
                    type="danger"
                    icon="Delete"
                    @click="handleDeleteContent(scope.row)"
                  >
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </template>
          <div v-else class="empty-state">
            <div class="empty-content">
              <p>请选择左侧的节点进行查看或在右上角新增节点</p>
            </div>
          </div>
        </div>
      </el-main>
    </el-container>

    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="knowledgeNodeRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="父节点" prop="pid">
          <el-tree-select
            v-model="form.pid"
            :data="knowledgeNodeOptions"
            :props="{ value: 'id', label: 'name', children: 'children' }"
            value-key="id"
            placeholder="请选择父节点"
            check-strictly
          />
        </el-form-item>
        <el-form-item label="项目ID" prop="projectId">
          <el-input v-model="form.projectId" placeholder="请输入项目ID" :disabled="true" />
        </el-form-item>
        <el-form-item label="子节点名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入子节点名称" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog title="添加文档" v-model="contentDialogOpen" width="600px" append-to-body>
      <el-form ref="contentFormRef" :model="contentForm" label-width="90px">
        <el-form-item label="文档名称" prop="name">
          <el-input v-model="contentForm.name" placeholder="请输入文档名称" />
        </el-form-item>
        <el-form-item label="模块类型" prop="status">
          <el-select v-model="contentForm.status" placeholder="请选择模块类型">
            <el-option label="通用" :value=1 />
            <el-option label="检测" :value=2 />
            <el-option label="验收" :value=3 />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="contentForm.remark" type="textarea" :rows="3" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="文件" prop="location">
          <file-upload
            v-model="contentForm.location"
            :limit="1"
            :file-size="20"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="contentDialogOpen = false">取 消</el-button>
          <el-button type="primary" :loading="contentSaving" @click="handleSaveContent">
            保 存
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="KnowledgeNode">
import request from "@/utils/request"
import { listKnowledgeNode, getKnowledgeNode, delKnowledgeNode, addKnowledgeNode, updateKnowledgeNode } from "@/api/system/knowledgeNode"
import { listZone } from "@/api/system/zone"

const { proxy } = getCurrentInstance()

const knowledgeNodeList = ref([])
const knowledgeNodeOptions = ref([])
const zoneRootList = ref([])
const selectedRootId = ref(null)
const currentNode = ref(null)
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const refreshTable = ref(true)
const contentList = ref([])
const contentLoading = ref(false)
const contentSaving = ref(false)
const contentDialogOpen = ref(false)
const contentFormRef = ref(null)
const baseUrl = import.meta.env.VITE_APP_BASE_API

const data = reactive({
  form: {},
  queryParams: {
    pid: null,
    projectId: null,
    name: null
  },
  contentForm: {
    id: null,
    pid: null,
    name: "",
    status: null,
    remark: "",
    location: ""
  },
  rules: {
    pid: [
      { required: true, message: "父节点不能为空", trigger: "blur" }
    ],
    name: [
      { required: true, message: "子节点名称不能为空", trigger: "blur" }
    ]
  }
})

const { queryParams, form, contentForm, rules } = toRefs(data)

/** 查询知识库节点列表 */
function getList() {
  loading.value = true
  listKnowledgeNode(queryParams.value).then(response => {
    knowledgeNodeList.value = proxy.handleTree(response.data, "id", "pid")
    loading.value = false
  })
}

function getContentList() {
  if (!currentNode.value) {
    contentList.value = []
    return
  }
  contentLoading.value = true
  request({
    url: "/system/contentlib/list",
    method: "get",
    params: {
      pid: currentNode.value.id
    }
  }).then(response => {
    const list = response.rows || response.data || []
    contentList.value = list
  }).finally(() => {
    contentLoading.value = false
  })
}

function resetContentForm() {
  contentForm.value = {
    id: null,
    pid: null,
    name: "",
    status: null,
    remark: "",
    location: ""
  }
}

/** 查询根区域列表（公司信息） */
function getZoneRootList() {
  listZone().then(response => {
    const list = response.data || response.rows || []
    zoneRootList.value = list.filter(item => item.zonetype === 1)
    if (!selectedRootId.value && zoneRootList.value.length > 0) {
      selectedRootId.value = zoneRootList.value[0].id
      queryParams.value.projectId = selectedRootId.value
      getList()
    }
    if (!zoneRootList.value.length) {
      getList()
    }
  }).catch(() => {
    getList()
  })
}

/** 查询知识库节点下拉树结构 */
function getTreeselect() {
  const params = {}
  if (form.value.projectId || queryParams.value.projectId) {
    params.projectId = form.value.projectId || queryParams.value.projectId
  }
  listKnowledgeNode(params).then(response => {
    knowledgeNodeOptions.value = []
    const data = { id: 0, name: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "id", "pid")
    knowledgeNodeOptions.value.push(data)
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
    pid: null,
    projectId: null,
    name: null,
    remark: null
  }
  proxy.resetForm("knowledgeNodeRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  if (selectedRootId.value) {
    queryParams.value.projectId = selectedRootId.value
  }
  handleQuery()
}

/** 新增按钮操作 */
function handleAdd(row) {
  reset()
  if (selectedRootId.value) {
    form.value.projectId = selectedRootId.value
  }
  getTreeselect()
  if (row != null && row.id) {
    form.value.pid = row.id
  } else {
    form.value.pid = 0
  }
  open.value = true
  title.value = "添加知识库节点"
}

function handleNodeClick(data) {
  currentNode.value = data
  resetContentForm()
  getContentList()
}

/** 根节点选择变化，根据根节点ID筛选知识节点的 projectId */
function handleRootChange(id) {
  queryParams.value.projectId = id
  handleQuery()
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  refreshTable.value = false
  isExpandAll.value = !isExpandAll.value
  nextTick(() => {
    refreshTable.value = true
  })
}

/** 修改按钮操作 */
async function handleUpdate(row) {
  reset()
  await getTreeselect()
  if (row != null) {
    form.value.pid = row.pid
  }
  getKnowledgeNode(row.id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改知识库节点"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["knowledgeNodeRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateKnowledgeNode(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addKnowledgeNode(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除知识库节点编号为"' + row.id + '"的数据项？').then(function() {
    return delKnowledgeNode(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

onMounted(() => {
  getZoneRootList()
})

function getFileNameFromPath(path) {
  if (!path) {
    return ""
  }
  const parts = path.split("/")
  return parts[parts.length - 1] || ""
}

function getModuleTypeLabel(val) {
  const v = String(val ?? "")
  if (v === "1") return "通用"
  if (v === "2") return "检测"
  if (v === "3") return "验收"
  return ""
}

function getFullLocation(path) {
  if (!path) {
    return ""
  }
  if (path.startsWith("http://") || path.startsWith("https://")) {
    return path
  }
  return baseUrl + path
}

function handleSaveContent() {
  if (!currentNode.value) {
    proxy.$modal.msgError("请先选择左侧的节点")
    return
  }
  if (!contentForm.value.location) {
    proxy.$modal.msgError("请先上传文件或图片")
    return
  }
  const locations = contentForm.value.location.split(",").filter(Boolean)
  const location = locations[0] || ""
  if (!location) {
    proxy.$modal.msgError("上传结果异常，请重新上传")
    return
  }
  const payload = {
    id: contentForm.value.id,
    pid: currentNode.value.id,
    name: contentForm.value.name || getFileNameFromPath(location),
    status: contentForm.value.status,
    remark: contentForm.value.remark,
    location,
  }
  contentSaving.value = true
  request({
    url: "/system/contentlib",
    method: payload.id ? "put" : "post",
    data: payload
  }).then(() => {
    proxy.$modal.msgSuccess("已保存到知识库")
    resetContentForm()
    getContentList()
  }).finally(() => {
    contentSaving.value = false
  })
}

function handleDeleteContent(row) {
  if (!row || !row.id) {
    return
  }
  proxy.$modal.confirm('是否确认删除该文件？').then(() => {
    const fileName = getFileNameFromPath(row.location || "")
    if (!fileName) {
      return request({
        url: "/system/contentlib/" + row.id,
        method: "delete"
      })
    }
    return request({
      url: "/common/delete",
      method: "post",
      params: { fileName }
    }).then(() => {
      return request({
        url: "/system/contentlib/" + row.id,
        method: "delete"
      })
    })
  }).then(() => {
    proxy.$modal.msgSuccess("删除成功")
    getContentList()
  }).catch(() => {})
}

function handleAddContent() {
  resetContentForm()
  contentForm.value.pid = currentNode.value ? currentNode.value.id : null
  contentDialogOpen.value = true
}

function handleDownloadContent(row) {
  if (!row || !row.location) {
    return
  }
  const url = getFullLocation(row.location)
  window.open(url, "_blank")
}
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

.action-tools {
  display: flex;
  align-items: center;
  gap: 12px;
}

.custom-tree-node {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
  position: relative;
}

.custom-tree-node:last-child {
  border-bottom: none;
}

.node-content {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-width: 0;
  padding-right: 80px;
}

.node-name {
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.node-extra {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 12px;
  color: #909399;
}

.node-actions {
  display: flex;
  gap: 4px;
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  opacity: 0;
  transition: opacity 0.2s ease;
}

.custom-tree-node:hover .node-actions {
  opacity: 1;
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

.detail-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.detail-bar {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  background-color: #f5f7fa;
  min-height: 44px;
}

.detail-field {
  font-size: 14px;
  color: #303133;
}

.detail-field + .detail-field {
  margin-left: 32px;
}

.detail-name {
  font-weight: 600;
}

.content-header {
  margin-top: 16px;
  margin-bottom: 8px;
}

.content-section {
  margin-top: 16px;
  display: flex;
  flex-direction: column;
}

.content-upload {
  display: flex;
  align-items: center;
  gap: 16px;
}

.content-name-input {
  max-width: 260px;
}

.content-table {
  margin-top: 16px;
}

@media (max-width: 1200px) {
  .top-actions {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
  }

  .left-actions,
  .right-actions {
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
