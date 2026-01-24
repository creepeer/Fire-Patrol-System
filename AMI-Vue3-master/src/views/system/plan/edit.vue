<template>
  <div class="app-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>修改检测计划</span>
        </div>
      </template>

      <!-- 步骤条 -->
      <el-steps :active="currentStep" finish-status="success" align-center class="mb-20">
        <el-step v-for="(step, index) in steps" :key="step.key" :title="step.label" />
      </el-steps>

      <!-- 步骤1: 选定区域与项目 -->
      <div v-show="currentStep === 0">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-card shadow="never" class="mb-20">
              <template #header>
                <span>选定区域与项目</span>
              </template>
              <el-form label-position="top">
                <el-form-item label="选定巡检区域">
                  <el-select v-model="selectedRegionId" placeholder="请选择区域" @change="handleRegionChange" style="width: 100%">
                    <el-option v-for="node in topLevelRegions" :key="node.id" :label="node.zname" :value="node.id" />
                  </el-select>
                </el-form-item>
                <el-form-item label="选定项目">
                  <el-select v-model="selectedProjectId" placeholder="请选择项目" @change="handleProjectChange" :disabled="!selectedRegionId" style="width: 100%">
                    <el-option v-for="node in availableProjects" :key="node.id" :label="node.zname" :value="node.id" />
                  </el-select>
                </el-form-item>
              </el-form>
            </el-card>

            <el-card shadow="never" class="mb-20" body-style="height: 400px; overflow-y: auto;">
              <template #header>
                <span>项目范围选择</span>
              </template>
              <el-tree
                ref="scopeTreeRef"
                :data="filteredTreeData"
                :props="{ label: 'zname', children: 'children' }"
                show-checkbox
                node-key="id"
                default-expand-all
                @check="handleCheckChange"
              >
                <template #default="{ node, data }">
                  <span>
                    <span v-if="data.zonetype === 1">🏫</span>
                    <span v-else-if="data.zonetype === 2">🏢</span>
                    <span v-else-if="data.zonetype === 3">📊</span>
                    <span v-else>🚪</span>
                    {{ node.label }}
                  </span>
                </template>
              </el-tree>
            </el-card>
          </el-col>

          <el-col :span="16">
            <el-card shadow="never" class="mb-20">
              <template #header>
                <span>已选区域预览</span>
              </template>
              <div style="min-height: 100px; padding: 10px; border: 1px dashed #dcdfe6; border-radius: 4px;">
                <el-empty v-if="selectedNodes.length === 0" description="请从左侧勾选需要巡检的区域" :image-size="60"></el-empty>
                <el-tag
                  v-for="node in selectedNodes"
                  :key="node.id"
                  closable
                  @close="removeNode(node)"
                  style="margin: 5px;"
                  type="info"
                >
                  {{ node.zname }}
                </el-tag>
              </div>
            </el-card>

            <el-card shadow="never">
              <template #header>
                <span>检测计划基本信息</span>
              </template>
              <el-form :model="formData" label-width="120px">
                <el-form-item label="计划名称" required>
                  <el-input v-model="formData.planName" placeholder="请输入检测计划名称" />
                </el-form-item>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="巡检负责人">
                      <el-input v-model="formData.inspector" placeholder="请输入巡检负责人姓名" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="负责人电话">
                      <el-input v-model="formData.inspectorPhone" placeholder="请输入联系电话" />
                    </el-form-item>
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="巡检周期">
                      <el-input v-model="formData.inspectionCycle" disabled placeholder="每月" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12" v-if="formData.inspectionCycle === 'custom'">
                    <el-form-item label="自定义周期(天)">
                      <el-input-number v-model="formData.customCycle" :min="1" style="width: 100%" />
                    </el-form-item>
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="计划开始时间">
                      <el-date-picker v-model="formData.startTime" type="datetime" placeholder="选择开始时间" style="width: 100%" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="计划结束时间">
                      <el-date-picker v-model="formData.endTime" type="datetime" placeholder="选择结束时间" style="width: 100%" />
                    </el-form-item>
                  </el-col>
                </el-row>
                <el-form-item label="巡检要求说明">
                  <el-input type="textarea" v-model="formData.requirements" placeholder="请输入巡检具体要求、注意事项等..." :rows="4" />
                </el-form-item>
                <el-form-item label="计划状态">
                  <el-radio-group v-model="formData.status">
                    <el-radio label="0">正常</el-radio>
                    <el-radio label="1">停用</el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-form>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 步骤2: 选定公司 -->
      <div v-show="currentStep === 1">
        <el-row :gutter="20">
          <el-col :span="selectedCompany ? 16 : 24">
             <el-table :data="companies" highlight-current-row @current-change="handleCompanyChange" style="width: 100%" border>
                <el-table-column width="55" align="center">
                    <template #default="scope">
                         <el-radio :model-value="selectedCompanyId" :label="scope.row.id" @change="selectCompany(scope.row.id)">&nbsp;</el-radio>
                    </template>
                </el-table-column>
                <el-table-column prop="name" label="公司名称" />
                <el-table-column prop="qualification" label="资质等级" />
                <el-table-column prop="businessType" label="业务类型" />
                <el-table-column prop="contact" label="联系人" />
                <el-table-column prop="phone" label="联系电话" />
                <el-table-column label="支持服务">
                   <template #default="scope">
                      <el-tag v-if="scope.row.arSupport" type="success" size="small" class="mr-5">AR</el-tag>
                      <el-tag v-if="scope.row.iotSupport" type="warning" size="small">IoT</el-tag>
                   </template>
                </el-table-column>
             </el-table>
          </el-col>
          <el-col :span="8" v-if="selectedCompany">
            <el-card shadow="hover">
              <template #header>
                <span>已选公司详情</span>
                <el-button style="float: right; padding: 3px 0" text type="primary" @click="clearCompany">更换</el-button>
              </template>
              <div>
                <h3>{{ selectedCompany.name }}</h3>
                <p class="mt-10">{{ selectedCompany.description }}</p>
                <div class="mt-10">
                  <el-tag v-for="specialty in selectedCompany.specialties" :key="specialty" class="mr-5 mb-5">{{ specialty }}</el-tag>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 步骤3: 人员区域分布 -->
      <div v-show="currentStep === 2">
        <el-row :gutter="20">
          <!-- 人员列表 -->
          <el-col :span="6">
            <el-card shadow="never">
              <template #header>
                <span>巡检人员列表</span>
              </template>
              <div v-if="!selectedCompany" class="text-center text-gray">请先选择巡检公司</div>
              <div v-else>
                <div 
                  v-for="person in personnelList" 
                  :key="person.id"
                  class="personnel-item mb-10 p-10 cursor-pointer"
                  :class="{ 'active-person': selectedPersonnelId === person.id }"
                  @click="selectPersonnel(person.id)"
                  style="border: 1px solid #eee; border-radius: 4px;"
                >
                  <div class="flex justify-between items-center">
                    <span class="font-bold">{{ person.name }}</span>
                    <el-tag size="small" :type="person.status === 'online' ? 'success' : 'info'">{{ person.status === 'online' ? '在线' : '离线' }}</el-tag>
                  </div>
                  <div class="text-xs text-gray mt-5">{{ person.role }} | 区域: {{ person.assignedAreas.length }}</div>
                </div>
              </div>
            </el-card>
          </el-col>
          
          <!-- 区域分配 -->
          <el-col :span="18">
            <el-card shadow="never">
               <template #header>
                 <div class="flex justify-between items-center">
                   <span>{{ selectedPersonnel ? `为 ${selectedPersonnel.name} 分配巡检区域` : '请选择巡检人员' }}</span>
                   <div v-if="selectedPersonnel">
                     <el-button size="small" type="primary" @click="assignAllAreas">分配全部</el-button>
                     <el-button size="small" @click="clearAssignedAreas">清空</el-button>
                   </div>
                 </div>
               </template>
               
               <div v-if="selectedPersonnel">
                 <div class="mb-10">
                    <span class="mr-20">已选项目: {{ selectedProject?.name }}</span>
                    <span>待分配区域: {{ selectedAreas.length - getAssignedAreaCount(selectedPersonnelId) }} / {{ selectedAreas.length }}</span>
                 </div>
                 
                 <el-divider content-position="left">区域选择</el-divider>
                 
                 <div class="area-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 10px;">
                    <div 
                      v-for="area in selectedAreas" 
                      :key="area.id" 
                      class="area-item p-10 border rounded"
                      :class="{ 'bg-blue-50 border-blue-200': getAssignedOtherPerson(area.id) }"
                    >
                      <el-checkbox 
                        :model-value="isAreaAssignedToPersonnel(area.id)"
                        @change="(val) => toggleAreaAssignment(area.id, val)"
                      >
                        {{ area.name }}
                      </el-checkbox>
                      <div class="text-xs text-gray ml-20">{{ area.path }}</div>
                      <div v-if="getAssignedOtherPerson(area.id)" class="text-xs text-blue-500 ml-20 mt-5">
                         已分配给: {{ getAssignedOtherPerson(area.id).name }}
                      </div>
                    </div>
                 </div>
                 
                 <el-divider content-position="left" class="mt-20">已分配区域</el-divider>
                 <div class="mt-10">
                    <el-tag 
                      v-for="area in selectedPersonnel.assignedAreas" 
                      :key="area.id" 
                      closable 
                      @close="removeAreaAssignment(area.id)"
                      class="mr-5 mb-5"
                    >
                      {{ area.name }}
                    </el-tag>
                 </div>
               </div>
               <el-empty v-else description="请从左侧选择人员进行分配" />
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 步骤4: 选定文档 -->
      <div v-show="currentStep === 3">
        <el-row :gutter="20">
          <!-- 左侧：知识库树 -->
          <el-col :span="6">
            <el-card shadow="never" class="h-full" body-style="height: 400px; overflow-y: auto;">
              <template #header>
                <span>知识库目录</span>
              </template>
              <el-tree
                ref="knowledgeTreeRef"
                :data="knowledgeTreeData"
                :props="{ label: 'name', children: 'children' }"
                node-key="id"
                highlight-current
                default-expand-all
                :expand-on-click-node="false"
                @node-click="handleKnowledgeNodeClick"
              >
                <template #default="{ node, data }">
                  <span class="custom-tree-node">
                    <el-icon class="mr-5"><Folder /></el-icon>
                    <span>{{ node.label }}</span>
                  </span>
                </template>
              </el-tree>
            </el-card>
          </el-col>
          
          <!-- 右侧：文档列表 -->
          <el-col :span="18">
            <el-card shadow="never" class="h-full">
               <template #header>
                 <span>{{ currentKnowledgeNode ? currentKnowledgeNode.name : '请选择左侧目录' }} - 文档列表</span>
               </template>
               
               <el-table :data="currentNodeDocuments" style="width: 100%" v-loading="loadingDocuments" border>
                <el-table-column width="55" align="center">
                   <template #default="scope">
                      <el-checkbox 
                        :model-value="isDocumentSelected(scope.row.id)"
                        @change="(val) => toggleDocumentSelection(scope.row.id, val)"
                      />
                   </template>
                </el-table-column>
                <el-table-column label="文档名称" prop="title" />
                <el-table-column label="文件" min-width="150" show-overflow-tooltip>
                   <template #default="scope">
                      <el-link 
                        v-if="scope.row.location" 
                        type="primary" 
                        :href="getFullLocation(scope.row.location)" 
                        target="_blank"
                        :underline="false"
                      >
                        {{ getFileNameFromPath(scope.row.location) }}
                      </el-link>
                      <span v-else>暂无</span>
                   </template>
                </el-table-column>
                <el-table-column label="版本" prop="version" width="80" />
                <el-table-column label="类型" prop="fileType" width="80" />
                <el-table-column label="更新时间" prop="updateTime" width="160" />
                <el-table-column label="操作" width="100" align="center">
                   <template #default="scope">
                      <el-button link type="primary" @click="previewDocument(scope.row)">预览</el-button>
                   </template>
                </el-table-column>
              </el-table>
              
              <!-- 已选文档展示 -->
              <div class="mt-20 p-10 bg-gray-50 border rounded" v-if="selectedDocuments.length > 0">
                 <div class="flex justify-between items-center mb-10">
                    <h4 class="m-0">已选文档 ({{ selectedDocuments.length }})</h4>
                    <el-button link type="danger" size="small" @click="clearSelectedDocuments">清空</el-button>
                 </div>
                 <div class="flex flex-wrap gap-2">
                   <el-tag 
                     v-for="doc in selectedDocuments" 
                     :key="doc.id" 
                     closable 
                     @close="toggleDocumentSelection(doc.id, false)"
                     class="mr-5 mb-5"
                   >
                     {{ doc.title }}
                   </el-tag>
                 </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 步骤5: 预览发布 -->
      <div v-show="currentStep === 4">
        <el-descriptions title="计划概览" :column="2" border>
           <el-descriptions-item label="计划名称">{{ formData.planName }}</el-descriptions-item>
           <el-descriptions-item label="计划编号">{{ generatePlanCode() }}</el-descriptions-item>
           <el-descriptions-item label="项目名称">{{ selectedProject?.name }}</el-descriptions-item>
           <el-descriptions-item label="巡检负责人">{{ formData.inspector }}</el-descriptions-item>
           <el-descriptions-item label="开始时间">{{ formatDateTime(formData.startTime) }}</el-descriptions-item>
           <el-descriptions-item label="结束时间">{{ formatDateTime(formData.endTime) }}</el-descriptions-item>
           <el-descriptions-item label="巡检公司">{{ selectedCompany?.name || '未选择' }}</el-descriptions-item>
           <el-descriptions-item label="文档数量">{{ selectedDocuments.length }} 个</el-descriptions-item>
           <el-descriptions-item label="计划状态">
              <el-tag :type="formData.status === '0' ? 'success' : 'info'">
                {{ formData.status === '0' ? '正常' : '停用' }}
              </el-tag>
           </el-descriptions-item>
        </el-descriptions>
        
        <div class="mt-20">
           <el-checkbox v-model="confirmations.agreement">我已阅读并同意《智巡科防巡检服务协议》</el-checkbox>
           <br/>
           <el-checkbox v-model="confirmations.infoVerified">我已确认所有信息准确无误</el-checkbox>
           <br/>
           <el-checkbox v-model="confirmations.readyToPublish">我已准备好提交修改</el-checkbox>
        </div>
      </div>

      <!-- 底部按钮 -->
      <div class="mt-20 text-center">
        <el-button v-if="currentStep > 0" @click="prevStep">上一步</el-button>
        <el-button v-if="currentStep < steps.length - 1" type="primary" @click="nextStep">下一步</el-button>
        <el-button v-if="currentStep === steps.length - 1" type="success" :disabled="!canPublish || isPublishing" @click="submitUpdate">
          {{ isPublishing ? '提交中...' : '提交修改' }}
        </el-button>
        <el-button @click="cancel">取消</el-button>
      </div>

    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted, getCurrentInstance } from 'vue'
import request from "@/utils/request"
import { listZone } from "@/api/system/zone"
import { listDept } from "@/api/system/dept"
import { listUser } from "@/api/system/user"
import { listKnowledgeNode } from "@/api/system/knowledgeNode"
import { getPlan, updatePlan } from "@/api/system/plan"

const props = defineProps({
  planId: {
    type: [Number, String],
    default: null
  }
})

const baseUrl = import.meta.env.VITE_APP_BASE_API

const getFileNameFromPath = (path) => {
  if (!path) return ""
  const parts = path.split("/")
  return parts[parts.length - 1] || ""
}

const getFullLocation = (path) => {
  if (!path) return ""
  if (path.startsWith("http://") || path.startsWith("https://")) {
    return path
  }
  return baseUrl + path
}

const emit = defineEmits(['save', 'cancel'])

const steps = ref([
  { key: 'project', label: '选定项目', completed: false },
  { key: 'company', label: '选定公司', completed: false },
  { key: 'distribution', label: '人员区域分布', completed: false },
  { key: 'documents', label: '选定文档', completed: false },
  { key: 'preview', label: '提交预览', completed: false }
])

const currentStep = ref(0)
const { proxy } = getCurrentInstance()
const zoneTreeData = ref([])
const scopeTreeRef = ref(null)
const selectedNodes = ref([])
const selectedRegionId = ref(null)
const selectedProjectId = ref(null)

const topLevelRegions = computed(() => {
  return zoneTreeData.value.filter(node => node.pid === 0)
})

const availableProjects = computed(() => {
  if (!selectedRegionId.value) return []
  const region = zoneTreeData.value.find(node => node.id === selectedRegionId.value)
  return region ? (region.children || []) : []
})

const filteredTreeData = computed(() => {
  if (!selectedProjectId.value) return []
  const projectNode = availableProjects.value.find(p => p.id === selectedProjectId.value)
  return projectNode ? [projectNode] : []
})

const selectedProject = computed(() => {
  return availableProjects.value.find(p => p.id === selectedProjectId.value)
})

const formData = reactive({
  planName: '',
  inspector: '',
  inspectorPhone: '',
  inspectionCycle: 'monthly',
  customCycle: 30,
  startTime: '',
  endTime: '',
  requirements: '',
  status: '0'
})

const companies = ref([])

const getCompanies = async () => {
  try {
    const response = await listDept()
    const list = response.data || []
    companies.value = list
      .filter(dept => dept.parentId === 0)
      .map(dept => ({
        id: dept.deptId,
        name: dept.deptName,
        qualification: dept.deptType ? `${dept.deptType}资质` : '综合资质',
        qualificationClass: 'level-a',
        businessType: dept.deptType || '综合服务',
        contact: dept.leader || '暂无',
        phone: dept.phone || '暂无',
        arSupport: true,
        iotSupport: true,
        description: '专业提供检测服务',
        specialties: ['消防', '电气']
      }))
  } catch (error) {
    console.error('Failed to load companies:', error)
  }
}

const selectedCompanyId = ref(null)
const selectedCompany = computed(() => {
  return companies.value.find(c => c.id === selectedCompanyId.value)
})

const handleCompanyChange = (val) => {
  if (val) selectCompany(val.id)
}

const personnelList = ref([])

const getPersonnel = async (deptId) => {
  if (!deptId) return
  try {
    const response = await listUser({ pageNum: 1, pageSize: 10, deptId: deptId })
    const users = response.rows || []
    const existingAssignments = new Map(
      personnelList.value.map(p => [p.id, p.assignedAreas])
    )
    personnelList.value = users.map(user => ({
      id: user.userId,
      name: user.nickName,
      role: '巡检员',
      status: 'online',
      companyId: deptId,
      assignedAreas: existingAssignments.get(user.userId) || []
    }))
  } catch (error) {
    console.error('Failed to load personnel:', error)
    personnelList.value = []
  }
}

watch(selectedCompanyId, (newVal) => {
  if (newVal) {
    getPersonnel(newVal)
  } else {
    personnelList.value = []
  }
})

const selectedPersonnelId = ref(null)
const selectedPersonnel = computed(() => {
  return personnelList.value.find(p => p.id === selectedPersonnelId.value)
})

const knowledgeTreeData = ref([])
const knowledgeTreeRef = ref(null)
const currentKnowledgeNode = ref(null)
const loadingDocuments = ref(false)
const allDocuments = ref([])

const getModuleTypeLabel = (val) => {
  const v = String(val ?? "")
  if (v === "1") return "通用"
  if (v === "2") return "检测"
  if (v === "3") return "验收"
  return "其他"
}

const getKnowledgeNodes = async () => {
  try {
    const response = await listKnowledgeNode()
    const list = response.data || response.rows || []
    knowledgeTreeData.value = proxy.handleTree(list, "id", "pid")
    allDocuments.value = []
  } catch (error) {
    console.error('Failed to load knowledge nodes:', error)
    knowledgeTreeData.value = []
  } finally {
    loadingDocuments.value = false
  }
}

const handleKnowledgeNodeClick = async (data) => {
  currentKnowledgeNode.value = data
  loadingDocuments.value = true
  try {
    const res = await request({
      url: "/system/contentlib/list",
      method: "get",
      params: { pid: data.id }
    })
    const rows = res.rows || res.data || []
    const newDocs = rows.map(row => ({
      id: row.id,
      title: row.name || '未命名文档',
      categoryId: data.id,
      categoryName: data.name,
      description: row.remark || '暂无描述',
      version: '1.0',
      updateTime: row.createTime,
      author: row.createBy || 'Admin',
      fileType: getModuleTypeLabel(row.status),
      location: row.location
    }))
    newDocs.forEach(doc => {
      const exists = allDocuments.value.some(d => d.id === doc.id)
      if (!exists) {
        allDocuments.value.push(doc)
      }
    })
  } catch (error) {
    console.error('Failed to load documents for node:', error)
  } finally {
    loadingDocuments.value = false
  }
}

const currentNodeDocuments = computed(() => {
  if (!currentKnowledgeNode.value) return []
  return allDocuments.value.filter(doc => doc.categoryId === currentKnowledgeNode.value.id)
})

const clearSelectedDocuments = () => {
  selectedDocuments.value = []
}

watch(currentStep, (newStep) => {
  if (newStep === 3) {
    getKnowledgeNodes()
  }
})

const selectedDocuments = ref([])

const confirmations = reactive({
  agreement: false,
  infoVerified: false,
  readyToPublish: false
})

const isPublishing = ref(false)

const canProceed = computed(() => {
  switch (currentStep.value) {
    case 0:
      return selectedProjectId.value && formData.planName && selectedAreas.value.length > 0
    case 1:
      return !!selectedCompanyId.value
    case 2:
      const totalAssignedAreas = personnelList.value.reduce((sum, person) => 
        sum + person.assignedAreas.length, 0)
      return totalAssignedAreas === selectedAreas.value.length && totalAssignedAreas > 0
    case 3:
      return true
    default:
      return true
  }
})

const canPublish = computed(() => {
  return confirmations.agreement && confirmations.infoVerified && confirmations.readyToPublish
})

const selectedAreas = computed(() => {
  return selectedNodes.value.map(node => ({
    id: node.id,
    name: node.zname,
    level: node.zonetype,
    path: node.path // assuming node has path or we can't show it
  }))
})

const setStep = (index) => {
  if (index < currentStep.value) {
    currentStep.value = index
    return
  }
  for (let i = 0; i < index; i++) {
    if (i === 0 && !selectedProjectId.value) return
    if (i === 1 && !selectedCompanyId.value) return
  }
  currentStep.value = index
}

const nextStep = () => {
  if (currentStep.value < steps.value.length - 1) {
    steps.value[currentStep.value].completed = true
    currentStep.value++
  }
}

const prevStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

const cancel = () => {
  emit('cancel')
}

const handleRegionChange = () => {
  selectedProjectId.value = null
  selectedNodes.value = []
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setCheckedKeys([])
  }
}

const handleProjectChange = (val) => {
  selectedNodes.value = []
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setCheckedKeys([])
  }
  const project = availableProjects.value.find(p => p.id === val)
  if (project) {
    formData.inspector = project.manager || ''
    formData.inspectorPhone = project.managerPhone || ''
  }
}

const handleCheckChange = (data, checkedInfo) => {
  selectedNodes.value = checkedInfo.checkedNodes
}

const removeNode = (node) => {
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setChecked(node.id, false)
    selectedNodes.value = scopeTreeRef.value.getCheckedNodes()
  }
}

const selectCompany = (companyId) => {
  selectedCompanyId.value = companyId
}

const clearCompany = () => {
  selectedCompanyId.value = null
}

const selectPersonnel = (personnelId) => {
  selectedPersonnelId.value = personnelId
}

const getAssignedOtherPerson = (areaId) => {
  if (!selectedPersonnelId.value) return null
  return personnelList.value.find(person => 
    person.id !== selectedPersonnelId.value && 
    person.assignedAreas.some(a => a.id === areaId)
  )
}

const isAreaAssignedToPersonnel = (areaId) => {
  if (!selectedPersonnel.value) return false
  return selectedPersonnel.value.assignedAreas.some(a => a.id === areaId)
}

const toggleAreaAssignment = (areaId, checked) => {
  if (!selectedPersonnel.value) return
  const area = selectedAreas.value.find(a => a.id === areaId)
  if (!area) return
  if (checked) {
    const otherPerson = personnelList.value.find(person => 
      person.id !== selectedPersonnelId.value && 
      person.assignedAreas.some(a => a.id === areaId)
    )
    if (otherPerson) {
      otherPerson.assignedAreas = otherPerson.assignedAreas.filter(a => a.id !== areaId)
    }
    selectedPersonnel.value.assignedAreas.push(area)
  } else {
    selectedPersonnel.value.assignedAreas = selectedPersonnel.value.assignedAreas.filter(
      a => a.id !== areaId
    )
  }
}

const assignAllAreas = () => {
  if (!selectedPersonnel.value) return
  personnelList.value.forEach(person => {
    person.assignedAreas = []
  })
  selectedPersonnel.value.assignedAreas = [...selectedAreas.value]
}

const clearAssignedAreas = () => {
  if (!selectedPersonnel.value) return
  selectedPersonnel.value.assignedAreas = []
}

const removeAreaAssignment = (areaId) => {
  if (!selectedPersonnel.value) return
  selectedPersonnel.value.assignedAreas = selectedPersonnel.value.assignedAreas.filter(
    a => a.id !== areaId
  )
}

const getAssignedAreaCount = (personnelId) => {
  const person = personnelList.value.find(p => p.id === personnelId)
  return person ? person.assignedAreas.length : 0
}

const isDocumentSelected = (docId) => {
  return selectedDocuments.value.some(doc => doc.id === docId)
}

const toggleDocumentSelection = (docId, checked) => {
  if (checked) {
    const doc = allDocuments.value.find(d => d.id === docId)
    if (doc && !isDocumentSelected(docId)) {
      selectedDocuments.value.push(doc)
    }
  } else {
    selectedDocuments.value = selectedDocuments.value.filter(doc => doc.id !== docId)
  }
}

const previewDocument = (doc) => {
  proxy.$modal.alert(doc.description, `预览文档: ${doc.title}`)
}

const generatePlanCode = () => {
  const timestamp = new Date().getTime().toString().slice(-6)
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0')
  return `ZC-${timestamp}-${random}`
}

const formatDateTime = (datetime) => {
  if (!datetime) return '未设置'
  return datetime.replace('T', ' ')
}

const submitUpdate = async () => {
  if (!canPublish.value) {
    proxy.$modal.msgWarning('请完成所有确认项后再提交')
    return
  }
  
  isPublishing.value = true
  
  try {
    const planData = {
      id: props.planId,
      name: formData.planName,
      project: {
        id: selectedProject.value.id,
        zname: selectedProject.value.zname,
        pid: selectedProject.value.pid,
        zonetype: selectedProject.value.zonetype
      },
      company: {
        id: selectedCompany.value.id,
        name: selectedCompany.value.name,
        contact: selectedCompany.value.contact,
        phone: selectedCompany.value.phone
      },
      inspector: formData.inspector,
      areas: selectedAreas.value.map(area => ({
        id: area.id,
        name: area.name,
        level: area.level
      })),
      personnel: personnelList.value.map(p => ({
        id: p.id,
        name: p.name,
        role: p.role,
        assignedAreas: p.assignedAreas.map(area => ({
          id: area.id,
          name: area.name,
          level: area.level
        }))
      })),
      documents: selectedDocuments.value.map(doc => ({
        id: doc.id,
        title: doc.title,
        location: doc.location
      })),
      schedule: {
        startTime: new Date(formData.startTime).toISOString(),
        endTime: new Date(formData.endTime).toISOString(),
        cycle: formData.inspectionCycle
      },
      status: formData.status
    }
    
    await updatePlan(planData)
    
    proxy.$modal.msgSuccess(`巡检计划修改成功！`)
    emit('save')
    
  } catch (error) {
    console.error('修改失败：', error)
    proxy.$modal.msgError('修改失败，请稍后重试')
  } finally {
    isPublishing.value = false
  }
}

const getProjects = async () => {
  try {
    const response = await listZone()
    const list = response.data || response.rows || []
    zoneTreeData.value = proxy.handleTree(list, "id", "pid")
  } catch (error) {
    console.error('Failed to load projects:', error)
  }
}

const initData = async (id) => {
  try {
    const res = await getPlan(id)
    const data = res.data
    
    formData.planName = data.name
    formData.inspector = data.inspector
    formData.status = data.status || '0'
    
    if (data.schedule) {
       formData.startTime = data.schedule.startTime
       formData.endTime = data.schedule.endTime
       formData.inspectionCycle = data.schedule.cycle
    }
    
    if (data.project) {
       // Need to ensure zoneTreeData is loaded
       selectedRegionId.value = data.project.pid
       selectedProjectId.value = data.project.id
    }
    
    if (data.areas) {
       selectedNodes.value = data.areas.map(a => ({
          id: a.id,
          zname: a.name,
          zonetype: a.level
       }))
       // Restore tree check
       if (scopeTreeRef.value) {
          scopeTreeRef.value.setCheckedNodes(selectedNodes.value)
       }
    }
    
    if (data.company) {
       selectedCompanyId.value = data.company.id
    }
    
    if (data.personnel) {
       personnelList.value = data.personnel.map(p => ({
          id: p.id,
          name: p.name,
          role: p.role,
          status: 'online', 
          companyId: data.company.id,
          assignedAreas: p.assignedAreas.map(a => ({
             id: a.id,
             name: a.name,
             level: a.level
          }))
       }))
    }
    
    if (data.documents) {
       selectedDocuments.value = data.documents.map(d => ({
          id: d.id,
          title: d.title,
          location: d.location
       }))
       // Also add to allDocuments so they appear in list if step is visited
       data.documents.forEach(doc => {
          if (!allDocuments.value.some(d => d.id === doc.id)) {
            allDocuments.value.push(doc)
          }
       })
    }
    
  } catch (e) {
    console.error("Failed to init plan data", e)
  }
}

onMounted(async () => {
  await getProjects()
  await getCompanies()
  if (props.planId) {
    await initData(props.planId)
  }
})
</script>

<style scoped>
.app-container {
  padding: 20px;
}
.mb-20 {
  margin-bottom: 20px;
}
.mb-10 {
  margin-bottom: 10px;
}
.mb-5 {
  margin-bottom: 5px;
}
.mt-20 {
  margin-top: 20px;
}
.mt-10 {
  margin-top: 10px;
}
.mt-5 {
  margin-top: 5px;
}
.mr-20 {
  margin-right: 20px;
}
.mr-5 {
  margin-right: 5px;
}
.p-10 {
  padding: 10px;
}
.text-center {
  text-align: center;
}
.text-gray {
  color: #909399;
}
.text-xs {
  font-size: 12px;
}
.font-bold {
  font-weight: bold;
}
.flex {
  display: flex;
}
.justify-between {
  justify-content: space-between;
}
.items-center {
  align-items: center;
}
.cursor-pointer {
  cursor: pointer;
}
.bg-blue-50 {
  background-color: #e6f7ff;
}
.border-blue-200 {
  border-color: #91d5ff;
}
.text-blue-500 {
  color: #1890ff;
}
.active-person {
  border-color: #1890ff !important;
  background-color: #f0f7ff;
}
</style>