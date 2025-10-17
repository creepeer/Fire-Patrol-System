<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="类别名称" prop="cname">
        <el-input
          v-model="queryParams.cname"
          placeholder="请输入类别名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="结点类型" prop="ctype">
        <el-select v-model="queryParams.ctype" placeholder="请选择结点类型" clearable>
          <el-option label="分支" :value="0" />
          <el-option label="结点" :value="1" />
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
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['system:category:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="Sort"
          @click="toggleExpandAll"
        >展开/折叠</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Refresh"
          @click="getList"
        >刷新</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 可拖拽类别树 -->
    <el-card class="category-tree-card">
      <template #header>
        <div class="card-header">
          <span>类别管理</span>
          <div class="drag-tips">
            <el-tag type="info" size="small">提示：拖拽节点可调整父子关系</el-tag>
          </div>
        </div>
      </template>
      
      <el-tree
        ref="categoryTreeRef"
        v-loading="loading"
        :data="categoryTreeData"
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
              <!-- 类别图标 -->
              <span class="node-icon">
                <el-icon v-if="data.ctype === 0" color="#e6a23c">
                  <Folder />
                </el-icon>
                <el-icon v-else color="#409eff">
                  <Document />
                </el-icon>
              </span>
              
              <!-- 类别名称 -->
              <span class="category-name">{{ data.cname }}</span>
              
              <!-- 类别信息标签 -->
              <div class="category-tags">
                <el-tag :type="data.ctype === 0 ? 'warning' : 'primary'" size="small">
                  {{ data.ctype === 0 ? '分支' : '结点' }}
                </el-tag>
                <el-tag v-if="data.subjectId" type="info" size="small">
                  科目: {{ data.subjectId }}
                </el-tag>
              </div>
              
              <!-- 类别详情 -->
              <div class="category-details">
                <span class="category-remark" v-if="data.remark">{{ data.remark }}</span>
                <span class="category-children" v-if="data.children && data.children.length > 0">
                  子节点: {{ data.children.length }}个
                </span>
              </div>
            </div>
            
            <!-- 操作按钮 -->
            <div class="node-actions">
              <el-button link type="primary" size="small" icon="Edit" @click="handleUpdate(data)" v-hasPermi="['system:category:edit']">
                修改
              </el-button>
              <el-button link type="primary" size="small" icon="Plus" @click="handleAdd(data)" v-hasPermi="['system:category:add']">
                新增
              </el-button>
              <el-button link type="danger" size="small" icon="Delete" @click="handleDelete(data)" v-hasPermi="['system:category:remove']">
                删除
              </el-button>
            </div>
          </div>
        </template>
      </el-tree>
      
      <!-- 空状态 -->
      <div v-if="categoryTreeData.length === 0 && !loading" class="tree-empty">
        <el-empty description="暂无类别数据" :image-size="100" />
      </div>
    </el-card>

    <!-- 添加或修改类别对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="categoryRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="类别名称" prop="cname">
          <el-input v-model="form.cname" placeholder="请输入类别名称" />
        </el-form-item>
        <el-form-item label="父节点" prop="pid">
          <el-tree-select
            v-model="form.pid"
            :data="categoryOptions"
            :props="{ value: 'id', label: 'cname', children: 'children' }"
            value-key="id"
            placeholder="请选择父节点"
            check-strictly
            clearable
          />
        </el-form-item>
        <el-form-item label="结点类型" prop="ctype">
          <el-radio-group v-model="form.ctype">
            <el-radio :label="0">分支</el-radio>
            <el-radio :label="1">结点</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="所属科目" prop="subjectId">
          <el-input v-model="form.subjectId" placeholder="请输入所属科目ID" />
        </el-form-item>
        <el-form-item label="图示" prop="cicon">
          <el-input v-model="form.cicon" placeholder="请输入图示URL" />
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

<script setup name="Category">
import { ref, reactive, getCurrentInstance, nextTick } from 'vue'
import { Folder, Document } from '@element-plus/icons-vue'
import { listCategory, getCategory, delCategory, addCategory, updateCategory } from "@/api/system/category"
import { ElMessage } from 'element-plus'

const { proxy } = getCurrentInstance()

const categoryList = ref([])
const categoryTreeData = ref([])
const categoryOptions = ref([])
const categoryTreeRef = ref()
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const title = ref("")
const isExpandAll = ref(true)
const lastWarningTime = ref(0) // 最后警告时间戳
const WARNING_INTERVAL = 3000 // 3秒防重复间隔

const data = reactive({
  form: {},
  queryParams: {
    cname: null,
    pid: null,
    ctype: null,
    subjectId: null,
    cicon: null,
  },
  rules: {
    cname: [
      { required: true, message: "类别名称不能为空", trigger: "blur" }
    ],
    ctype: [
      { required: true, message: "结点类型不能为空", trigger: "change" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 显示警告消息（带防重复） */
function showWarningMessage(message) {
  const currentTime = Date.now()
  if (currentTime - lastWarningTime.value > WARNING_INTERVAL) {
    ElMessage.warning(message)
    lastWarningTime.value = currentTime
  }
}

/** 查询类别列表 */
function getList() {
  loading.value = true
  listCategory(queryParams.value).then(response => {
    categoryList.value = response.data
    // 构建树状结构数据
    categoryTreeData.value = buildCategoryTree(categoryList.value)
    loading.value = false
  }).catch(() => {
    loading.value = false
  })
}

/** 将扁平类别数据转换为树状结构 */
function buildCategoryTree(categories) {
  const categoryMap = new Map()
  const tree = []
  
  // 创建映射
  categories.forEach(category => {
    categoryMap.set(category.id, {
      ...category,
      children: []
    })
  })
  
  // 构建树结构
  categories.forEach(category => {
    const node = categoryMap.get(category.id)
    if (category.pid && categoryMap.has(category.pid)) {
      const parent = categoryMap.get(category.pid)
      parent.children.push(node)
    } else {
      tree.push(node)
    }
  })
  
  return tree
}

/** 查询类别下拉树结构 */
function getTreeselect() {
  listCategory().then(response => {
    categoryOptions.value = []
    const data = { id: 0, cname: '顶级节点', children: [] }
    data.children = proxy.handleTree(response.data, "id", "pid")
    categoryOptions.value.push(data)
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
    cname: null,
    pid: 0,
    ctype: 0,
    subjectId: null,
    cicon: null,
    remark: null,
    deleted: 0,
    creator: '',
    creatorTime: null,
    modifier: '',
    modifierTime: null
  }
  proxy.resetForm("categoryRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 新增按钮操作 */
function handleAdd(row) {
  reset()
  getTreeselect()
  if (row != null && row.id) {
    form.value.pid = row.id
  } else {
    form.value.pid = 0
  }
  open.value = true
  title.value = "添加类别"
}

/** 展开/折叠操作 */
function toggleExpandAll() {
  if (categoryTreeRef.value) {
    const treeStore = categoryTreeRef.value.store
    const allNodes = treeStore._getAllNodes()
    allNodes.forEach(node => {
      node.expanded = !isExpandAll.value
    })
    isExpandAll.value = !isExpandAll.value
  }
}

/** 修改按钮操作 */
async function handleUpdate(row) {
  reset()
  await getTreeselect()
  getCategory(row.id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改类别"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["categoryRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateCategory(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addCategory(form.value).then(response => {
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
  proxy.$modal.confirm('是否确认删除类别"' + row.cname + '"？').then(function() {
    return delCategory(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

// 拖拽相关方法
/** 拖拽开始 */
const handleDragStart = (node) => {
  console.log('拖拽开始:', node.data.cname)
}

/** 拖拽结束 */
const handleDragEnd = (draggingNode, dropNode, dropType) => {
  console.log('拖拽结束:', draggingNode.data.cname, dropNode?.data.cname, dropType)
}

/** 节点放置 */
const handleDrop = async (draggingNode, dropNode, dropType) => {
  console.log('节点放置:', draggingNode.data.cname, dropNode.data.cname, dropType)
  
  try {
    // 计算新的父节点ID
    let newPid = 0
    if (dropType === 'inner') {
      // 放置在节点内部，作为子节点
      newPid = dropNode.data.id
    } else if (dropType === 'before' || dropType === 'after') {
      // 放置在节点前后，与目标节点同级
      newPid = dropNode.data.pid
    }
    
    // 更新类别的父节点关系
    const updateData = {
      id: draggingNode.data.id,
      pid: newPid
    }
    
    await updateCategory(updateData)
    ElMessage.success('类别关系更新成功')
    
    // 重新加载数据
    getList()
    
  } catch (error) {
    console.error('更新类别关系失败:', error)
    ElMessage.error('类别关系更新失败')
    // 拖拽失败，重新加载数据恢复原状
    getList()
  }
}

/** 允许拖拽 */
const allowDrag = (draggingNode) => {
  // 所有类别都可以拖拽
  return true
}

/** 允许放置 */
const allowDrop = (draggingNode, dropNode, type) => {
  // 禁止将类别拖拽到自己的子节点中
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
      showWarningMessage('不能将类别拖拽到自己的子节点中')
      return false
    }
  }
  
  // 检查结点类型限制：结点类型不能有子节点
  if (type === 'inner' && dropNode.data.ctype === 1) {
    showWarningMessage('结点类型不能包含子节点')
    return false
  }
  
  // 允许其他所有拖拽操作
  return true
}

// 初始化
getList()
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.category-tree-card {
  min-height: 500px;
}

.category-tree-card :deep(.el-card__body) {
  padding: 16px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.drag-tips {
  margin-left: auto;
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

.category-name {
  font-weight: 500;
  color: #303133;
  margin-right: 12px;
  min-width: 120px;
}

.category-tags {
  display: flex;
  gap: 4px;
  margin-right: 12px;
}

.category-details {
  display: flex;
  gap: 12px;
  color: #909399;
  font-size: 12px;
  flex: 1;
  min-width: 0;
}

.category-remark,
.category-children {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.category-remark {
  flex: 1;
  min-width: 100px;
  max-width: 200px;
}

.category-children {
  min-width: 80px;
  color: #67c23a;
}

.node-actions {
  display: flex;
  gap: 4px;
  margin-left: 12px;
}

.tree-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
}

/* 树形组件样式优化 */
.category-tree-card :deep(.el-tree) {
  min-height: 400px;
}

.category-tree-card :deep(.el-tree-node__content) {
  height: auto;
  padding: 4px 0;
}

.category-tree-card :deep(.el-tree-node__children) {
  padding-left: 16px;
}

.category-tree-card :deep(.el-tree-node.is-drop-inner) > .el-tree-node__content {
  background-color: #f0f7ff;
  border: 1px dashed #409eff;
}

/* 响应式布局 */
@media (max-width: 768px) {
  .custom-tree-node {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .node-actions {
    align-self: flex-end;
  }
  
  .category-details {
    flex-direction: column;
    gap: 2px;
  }
}
</style>