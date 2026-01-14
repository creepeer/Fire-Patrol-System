<template>
  <div class="intelligent-patrol-plan">
    <!-- 系统标题 -->
    <div class="system-header">
      <h1>智巡科防 —— AR + 物联数智化高危领域安全巡检系统</h1>
      <div class="system-subtitle">消防巡检系统 - 检测计划管理</div>
    </div>
    
    <!-- 步骤栏 -->
    <div class="step-bar">
      <div
        v-for="(step, index) in steps"
        :key="step.key"
        class="step-item"
        :class="{ active: currentStep === index, completed: step.completed }"
        @click="setStep(index)"
      >
        <div class="step-index">{{ index + 1 }}</div>
        <div class="step-label">{{ step.label }}</div>
        <div class="step-connector" v-if="index < steps.length - 1"></div>
      </div>
    </div>

    <!-- 步骤1: 选定项目 -->
    <div v-if="currentStep === 0" class="step-content">
      <div class="project-selection-container" style="display: flex; gap: 20px; height: 650px;">
        <!-- Left Panel -->
        <div class="left-panel" style="width: 350px; display: flex; flex-direction: column; border-right: 1px solid #eee; padding-right: 20px;">
          <div class="section-title" style="margin-bottom: 10px;">
            <h3><span class="icon">📋</span> 选定巡检区域</h3>
          </div>
          <el-select 
            v-model="selectedRegionId" 
            placeholder="请选择区域" 
            @change="handleRegionChange"
            style="width: 100%; margin-bottom: 20px;"
          >
            <el-option 
              v-for="node in topLevelRegions" 
              :key="node.id" 
              :label="node.zname" 
              :value="node.id" 
            />
          </el-select>

          <div class="section-title" style="margin-bottom: 10px;">
            <h3><span class="icon">🏗️</span> 选定项目</h3>
          </div>
          <el-select 
            v-model="selectedProjectId" 
            placeholder="请选择项目" 
            @change="handleProjectChange"
            :disabled="!selectedRegionId"
            style="width: 100%; margin-bottom: 20px;"
          >
            <el-option 
              v-for="node in availableProjects" 
              :key="node.id" 
              :label="node.zname" 
              :value="node.id" 
            />
          </el-select>

          <div class="section-title" style="margin-bottom: 10px;">
            <h3><span class="icon">🏢</span> 项目范围选择</h3>
          </div>
          <div class="tree-wrapper" style="flex: 1; overflow-y: auto; border: 1px solid #dcdfe6; border-radius: 4px; padding: 10px;">
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
          </div>
        </div>

        <!-- Right Panel -->
        <div class="right-panel" style="flex: 1; display: flex; flex-direction: column; overflow-y: auto; padding-left: 10px;">
          <!-- Plan Name Input -->
          <div class="form-group" style="margin-bottom: 20px;">
            <label style="display: block; margin-bottom: 8px; font-weight: bold;">计划名称：</label>
            <el-input v-model="formData.planName" placeholder="请输入检测计划名称" />
          </div>

          <div class="section-title" style="margin-bottom: 10px;">
            <h3><span class="icon">📍</span> 已选区域预览</h3>
          </div>
          <div class="selected-tags" style="margin-bottom: 20px; min-height: 100px; border: 1px dashed #dcdfe6; padding: 10px; border-radius: 4px; background-color: #f9f9f9;">
            <div v-if="selectedNodes.length === 0" style="color: #909399; text-align: center; padding: 30px;">
              请从左侧勾选需要巡检的区域
            </div>
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

          <div class="section-title" style="margin-bottom: 10px;">
            <h3><span class="icon">📝</span> 检测计划基本信息</h3>
          </div>
          
          <div class="plan-info-form">
             <div class="form-grid">
               <div class="form-group">
                 <label>巡检负责人：</label>
                 <el-input v-model="formData.inspector" placeholder="请输入巡检负责人姓名" />
               </div>
               <div class="form-group">
                 <label>负责人电话：</label>
                 <el-input v-model="formData.inspectorPhone" placeholder="请输入联系电话" />
               </div>
               <div class="form-group">
                 <label>巡检周期：</label>
                 <el-input v-model="formData.inspectionCycle" disabled placeholder="每月" />
               </div>
               <div v-if="formData.inspectionCycle === 'custom'" class="form-group">
                 <label>自定义周期(天)：</label>
                 <el-input-number v-model="formData.customCycle" :min="1" style="width: 100%" />
               </div>
             </div>
             
             <div class="form-row" style="margin-top: 15px;">
               <div class="form-group">
                 <label>计划开始时间：</label>
                 <el-date-picker v-model="formData.startTime" type="datetime" placeholder="选择开始时间" style="width: 100%" />
               </div>
               <div class="form-group">
                 <label>计划结束时间：</label>
                 <el-date-picker v-model="formData.endTime" type="datetime" placeholder="选择结束时间" style="width: 100%" />
               </div>
             </div>
             
             <div class="form-group full-width" style="margin-top: 15px;">
               <label>巡检要求说明：</label>
               <el-input 
                 type="textarea"
                 v-model="formData.requirements" 
                 placeholder="请输入巡检具体要求、注意事项等..."
                 :rows="4"
               />
             </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 步骤2: 选定公司 -->
    <div v-else-if="currentStep === 1" class="step-content">
      <div class="section">
        <h3><span class="icon">🏢</span> 选择巡检公司</h3>
        <div class="company-list">
          <div 
            v-for="company in companies" 
            :key="company.id" 
            class="company-card"
            :class="{ selected: selectedCompanyId === company.id }"
            @click="selectCompany(company.id)"
          >
            <div class="company-header">
              <h4>{{ company.name }}</h4>
              <span class="company-qualification">{{ company.qualification }}</span>
            </div>
            
            <div class="company-details">
              <div class="detail-row">
                <span class="detail-label">业务类型：</span>
                <span class="detail-value">{{ company.businessType }}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">资质等级：</span>
                <span class="detail-value" :class="company.qualificationClass">
                  {{ company.qualification }}
                </span>
              </div>
              <div class="detail-row">
                <span class="detail-label">联系人：</span>
                <span class="detail-value">{{ company.contact }}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">联系电话：</span>
                <span class="detail-value">{{ company.phone }}</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">巡检人员：</span>
                <span class="detail-value">{{ company.personnelCount }}人</span>
              </div>
              <div class="detail-row">
                <span class="detail-label">服务评分：</span>
                <span class="detail-value">
                  <span class="rating">
                    <span v-for="n in 5" :key="n" class="star" :class="{ active: n <= company.rating }">★</span>
                  </span>
                  ({{ company.rating }})
                </span>
              </div>
            </div>
            
            <div class="company-footer">
              <span class="ar-support" v-if="company.arSupport">
                <span class="icon">👓</span> 支持AR巡检
              </span>
              <span class="iot-support" v-if="company.iotSupport">
                <span class="icon">📡</span> 支持物联监测
              </span>
            </div>
          </div>
        </div>
        
        <div v-if="selectedCompany" class="selected-company-detail">
          <h4><span class="icon">✅</span> 已选公司详情</h4>
          <div class="detail-card">
            <div class="detail-header">
              <h5>{{ selectedCompany.name }}</h5>
              <button @click="clearCompany" class="btn-change">更换公司</button>
            </div>
            <div class="detail-content">
              <p>{{ selectedCompany.description }}</p>
              <div class="specialties">
                <span class="specialty-tag" v-for="specialty in selectedCompany.specialties" :key="specialty">
                  {{ specialty }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 步骤3: 人员区域分布 -->
    <div v-else-if="currentStep === 2" class="step-content">
      <div class="section">
        <h3><span class="icon">👥</span> 人员区域分配</h3>
        <div class="personnel-distribution">
          <!-- 公司人员列表 -->
          <div class="personnel-list">
            <h4><span class="icon">👨‍🔧</span> 巡检人员列表</h4>
            <div v-if="selectedCompany" class="personnel-cards">
              <div 
                v-for="person in personnelList" 
                :key="person.id"
                class="personnel-card"
                :class="{ active: selectedPersonnelId === person.id }"
                @click="selectPersonnel(person.id)"
              >
                <div class="personnel-avatar">{{ person.name.charAt(0) }}</div>
                <div class="personnel-info">
                  <div class="personnel-name">{{ person.name }}</div>
                  <div class="personnel-role">{{ person.role }}</div>
                  <div class="personnel-areas">
                    负责区域: <span class="area-count">{{ person.assignedAreas.length }}</span> 个
                  </div>
                </div>
                <div class="personnel-status" :class="person.status">
                  {{ person.status === 'online' ? '在线' : '离线' }}
                </div>
              </div>
            </div>
            <div v-else class="no-company-hint">
              <span class="icon">⚠️</span> 请先选择巡检公司
            </div>
          </div>
          
          <!-- 区域分配界面 -->
          <div class="area-assignment">
            <div class="assignment-header">
              <h4 v-if="selectedPersonnel">
                <span class="icon">📍</span> 为 {{ selectedPersonnel?.name }} 分配巡检区域
              </h4>
              <h4 v-else><span class="icon">ℹ️</span> 请选择巡检人员</h4>
              
              <div v-if="selectedPersonnel" class="assignment-controls">
                <button @click="assignAllAreas" class="btn-assign-all">分配全部</button>
                <button @click="clearAssignedAreas" class="btn-clear-assign">清空分配</button>
              </div>
            </div>
            
            <!-- 区域选择弹窗 -->
            <div v-if="selectedPersonnel" class="area-selection-modal">
              <div class="selected-project-info">
                <span class="project-name">{{ selectedProject?.name }}</span>
                <span class="selected-count">已选 {{ selectedAreas.length }} 个区域</span>
              </div>
              
              <div class="area-checkbox-list">
                <div 
                  v-for="area in selectedAreas" 
                  :key="area.id" 
                  class="area-checkbox-item"
                  :class="{ 'assigned-to-other': getAssignedOtherPerson(area.id) }"
                   :title="getAssignedOtherPerson(area.id) ? '该区域已分配给其他人员，点击可重新分配' : ''"
                 >
                   <label>
                    <input 
                      type="checkbox" 
                      :checked="isAreaAssignedToPersonnel(area.id)"
                      @change="toggleAreaAssignment(area.id, $event.target.checked)"
                    />
                    <span class="area-icon">
                      <template v-if="area.level === 'building'">🏢</template>
                      <template v-else-if="area.level === 'floor'">📊</template>
                      <template v-else>🚪</template>
                    </span>
                    <span class="area-name">{{ area.name }}</span>
                    <span class="area-path">{{ area.path }}</span>
                    <span v-if="getAssignedOtherPerson(area.id)" class="assigned-hint">
                      (已分配给: {{ getAssignedOtherPerson(area.id).name }})
                    </span>
                  </label>
                </div>
              </div>
              
              <div class="assignment-summary">
                <div class="summary-item">
                  <span class="label">总区域数：</span>
                  <span class="value">{{ selectedAreas.length }}</span>
                </div>
                <div class="summary-item">
                  <span class="label">已分配：</span>
                  <span class="value highlight">{{ getAssignedAreaCount(selectedPersonnelId) }}</span>
                </div>
                <div class="summary-item">
                  <span class="label">待分配：</span>
                  <span class="value">{{ selectedAreas.length - getAssignedAreaCount(selectedPersonnelId) }}</span>
                </div>
              </div>
            </div>
            
            <!-- 已分配区域列表 -->
            <div v-if="selectedPersonnel && selectedPersonnel.assignedAreas.length > 0" class="assigned-areas">
              <h5><span class="icon">✅</span> 已分配区域</h5>
              <div class="assigned-list">
                <div v-for="area in selectedPersonnel.assignedAreas" :key="area.id" class="assigned-item">
                  <span class="area-icon">
                    <template v-if="area.level === 'building'">🏢</template>
                    <template v-else-if="area.level === 'floor'">📊</template>
                    <template v-else>🚪</template>
                  </span>
                  <span class="area-info">{{ area.name }} ({{ area.path }})</span>
                  <button @click="removeAreaAssignment(area.id)" class="btn-remove-assignment">移除</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 步骤4: 选定文档 -->
    <div v-else-if="currentStep === 3" class="step-content">
      <div class="section">
        <h3><span class="icon">📚</span> 选择巡检文档</h3>
        
        <!-- 文档类别 -->
        <div class="document-categories">
          <div class="category-tabs">
            <button 
              v-for="category in documentCategories" 
              :key="category.id"
              class="category-tab"
              :class="{ active: activeCategoryId === category.id }"
              @click="activeCategoryId = category.id"
            >
              {{ category.name }} ({{ getCategoryDocumentCount(category.id) }})
            </button>
          </div>
          
          <!-- 文档列表 -->
          <div class="document-list">
            <div v-for="doc in getActiveCategoryDocuments()" :key="doc.id" class="document-card">
              <div class="document-header">
                <div class="document-title">
                  <span class="doc-icon">📄</span>
                  <h4>{{ doc.title }}</h4>
                  <span v-if="doc.version" class="doc-version">v{{ doc.version }}</span>
                </div>
                <div class="document-actions">
                  <button @click="previewDocument(doc)" class="btn-preview">预览</button>
                  <label class="checkbox-label">
                    <input 
                      type="checkbox" 
                      :checked="isDocumentSelected(doc.id)"
                      @change="toggleDocumentSelection(doc.id, $event.target.checked)"
                    />
                    选择
                  </label>
                </div>
              </div>
              
              <div class="document-content">
                <div class="doc-description">{{ doc.description }}</div>
                <div class="doc-meta">
                  <span class="meta-item"><span class="icon">📅</span> 更新: {{ doc.updateTime }}</span>
                  <span class="meta-item"><span class="icon">👤</span> 作者: {{ doc.author }}</span>
                  <span class="meta-item"><span class="icon">🏷️</span> 类型: {{ doc.fileType }}</span>
                  <span class="meta-item"><span class="icon">📏</span> 大小: {{ doc.fileSize }}</span>
                </div>
                
                <div v-if="doc.tags && doc.tags.length > 0" class="doc-tags">
                  <span v-for="tag in doc.tags" :key="tag" class="tag">{{ tag }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 已选文档 -->
        <div class="selected-documents">
          <h4><span class="icon">✅</span> 已选文档 ({{ selectedDocuments.length }})</h4>
          <div v-if="selectedDocuments.length > 0" class="selected-list">
            <div v-for="doc in selectedDocuments" :key="doc.id" class="selected-doc">
              <span class="doc-icon">📄</span>
              <span class="doc-title">{{ doc.title }}</span>
              <span class="doc-category">{{ getCategoryName(doc.categoryId) }}</span>
              <button @click="toggleDocumentSelection(doc.id, false)" class="btn-remove-doc">移除</button>
            </div>
          </div>
          <div v-else class="empty-hint">
            <span class="icon">📝</span> 尚未选择任何文档
          </div>
        </div>
      </div>
    </div>

    <!-- 步骤5: 预览发布 -->
    <div v-else-if="currentStep === 4" class="step-content">
      <div class="section">
        <h3><span class="icon">👁️</span> 计划预览与发布</h3>
        
        <!-- 计划概览 -->
        <div class="plan-overview">
          <div class="overview-header">
            <h4>智巡科防消防巡检计划</h4>
            <div class="plan-code">计划编号: {{ generatePlanCode() }}</div>
          </div>
          
          <div class="overview-sections">
            <!-- 项目信息 -->
            <div class="overview-section">
              <h5><span class="icon">📋</span> 项目信息</h5>
              <div class="info-grid">
                <div class="info-item">
                  <span class="label">项目名称:</span>
                  <span class="value">{{ selectedProject?.name || '未选择' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">计划名称:</span>
                  <span class="value">{{ formData.planName || '未填写' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">巡检负责人:</span>
                  <span class="value">{{ formData.inspector || '未填写' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">联系电话:</span>
                  <span class="value">{{ formData.inspectorPhone || '未填写' }}</span>
                </div>
              </div>
            </div>
            
            <!-- 巡检范围 -->
            <div class="overview-section">
              <h5><span class="icon">📍</span> 巡检范围</h5>
              <div class="scope-summary">
                <div class="summary-row">
                  <span class="label">总区域数:</span>
                  <span class="value">{{ selectedAreas.length }} 个</span>
                </div>
                <div class="area-breakdown">
                  <div class="breakdown-item">
                    <span class="icon">🏢</span>
                    <span class="count">{{ getAreaCountByLevel('building') }}</span>
                    <span class="type">楼栋</span>
                  </div>
                  <div class="breakdown-item">
                    <span class="icon">📊</span>
                    <span class="count">{{ getAreaCountByLevel('floor') }}</span>
                    <span class="type">楼层</span>
                  </div>
                  <div class="breakdown-item">
                    <span class="icon">🚪</span>
                    <span class="count">{{ getAreaCountByLevel('room') }}</span>
                    <span class="type">房间</span>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- 公司信息 -->
            <div class="overview-section">
              <h5><span class="icon">🏢</span> 巡检公司</h5>
              <div v-if="selectedCompany" class="company-summary">
                <div class="company-name">{{ selectedCompany.name }}</div>
                <div class="company-details">
                  <span class="detail">{{ selectedCompany.qualification }}</span>
                  <span class="detail">联系人: {{ selectedCompany.contact }}</span>
                  <span class="detail">电话: {{ selectedCompany.phone }}</span>
                </div>
              </div>
              <div v-else class="not-selected">未选择巡检公司</div>
            </div>
            
            <!-- 人员分配 -->
            <div class="overview-section">
              <h5><span class="icon">👥</span> 人员分配</h5>
              <div v-if="personnelList.length > 0" class="personnel-summary">
                <div class="summary-row">
                  <span class="label">总人员:</span>
                  <span class="value">{{ personnelList.length }} 人</span>
                </div>
                <div class="personnel-assignment">
                  <div v-for="person in personnelList" :key="person.id" class="person-assignment">
                    <span class="person-name">{{ person.name }}</span>
                    <span class="area-count">{{ person.assignedAreas.length }} 个区域</span>
                  </div>
                </div>
              </div>
              <div v-else class="not-selected">未分配巡检人员</div>
            </div>
            
            <!-- 文档清单 -->
            <div class="overview-section">
              <h5><span class="icon">📚</span> 巡检文档</h5>
              <div class="document-summary">
                <div class="summary-row">
                  <span class="label">文档总数:</span>
                  <span class="value">{{ selectedDocuments.length }} 个</span>
                </div>
                <div class="category-breakdown">
                  <div v-for="category in documentCategories" :key="category.id" class="category-count">
                    <span class="category-name">{{ category.name }}:</span>
                    <span class="count">{{ getSelectedDocumentCountByCategory(category.id) }}</span>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- 计划时间 -->
            <div class="overview-section">
              <h5><span class="icon">⏰</span> 计划时间</h5>
              <div class="time-info">
                <div class="time-item">
                  <span class="label">开始时间:</span>
                  <span class="value">{{ formatDateTime(formData.startTime) }}</span>
                </div>
                <div class="time-item">
                  <span class="label">结束时间:</span>
                  <span class="value">{{ formatDateTime(formData.endTime) }}</span>
                </div>
                <div class="time-item">
                  <span class="label">巡检周期:</span>
                  <span class="value">{{ getCycleText(formData.inspectionCycle) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 发布操作 -->
        <div class="publish-actions">
          <div class="publish-confirmations">
            <label class="confirm-checkbox">
              <input type="checkbox" v-model="confirmations.agreement" />
              <span>我已阅读并同意《智巡科防巡检服务协议》</span>
            </label>
            <label class="confirm-checkbox">
              <input type="checkbox" v-model="confirmations.infoVerified" />
              <span>我已确认所有信息准确无误</span>
            </label>
            <label class="confirm-checkbox">
              <input type="checkbox" v-model="confirmations.readyToPublish" />
              <span>我已准备好发布巡检计划</span>
            </label>
          </div>
          
          <div class="action-buttons">
            <button @click="downloadPlan" class="btn-download">
              <span class="icon">📥</span> 下载计划书
            </button>
            <button 
              @click="publishPlan" 
              class="btn-publish"
              :disabled="!canPublish || isPublishing"
            >
              <span class="icon">🚀</span> 
              {{ isPublishing ? '发布中...' : '发布巡检计划' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 导航按钮 -->
    <div class="navigation-buttons">
      <button 
        v-if="currentStep > 0" 
        @click="prevStep" 
        class="btn btn-prev"
      >
        上一步
      </button>
      <button 
        v-if="currentStep < steps.length - 1" 
        @click="nextStep" 
        class="btn btn-next"
        :disabled="!canProceed"
      >
        下一步
      </button>
      <button 
        v-if="currentStep === steps.length - 1" 
        @click="saveDraft" 
        class="btn btn-save"
      >
        保存草稿
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted, getCurrentInstance } from 'vue'
import { listZone } from "@/api/system/zone"
import { listDept } from "@/api/system/dept"
import { listUser } from "@/api/system/user"
import { listKnowledgeNode } from "@/api/system/knowledgeNode"

const emit = defineEmits(['save', 'cancel'])

// ================== 步骤配置 ==================
const steps = ref([
  { key: 'project', label: '选定项目', completed: false },
  { key: 'company', label: '选定公司', completed: false },
  { key: 'distribution', label: '人员区域分布', completed: false },
  { key: 'documents', label: '选定文档', completed: false },
  { key: 'preview', label: '发布预览', completed: false }
])

const currentStep = ref(0)

// ================== 项目数据 ==================
const { proxy } = getCurrentInstance()
const zoneTreeData = ref([])
const scopeTreeRef = ref(null)
const selectedNodes = ref([])

const selectedRegionId = ref(null)
const selectedProjectId = ref(null)

// 顶级节点（区域）
const topLevelRegions = computed(() => {
  return zoneTreeData.value.filter(node => node.pid === 0)
})

// 可选项目（选中区域的子节点）
const availableProjects = computed(() => {
  if (!selectedRegionId.value) return []
  const region = zoneTreeData.value.find(node => node.id === selectedRegionId.value)
  return region ? (region.children || []) : []
})

// 根据选中的项目过滤树数据
const filteredTreeData = computed(() => {
  if (!selectedProjectId.value) return []
  const projectNode = availableProjects.value.find(p => p.id === selectedProjectId.value)
  return projectNode ? [projectNode] : []
})

const selectedProject = computed(() => {
  return availableProjects.value.find(p => p.id === selectedProjectId.value)
})

// ================== 表单数据 ==================
const formData = reactive({
  planName: '',
  inspector: '张三',
  inspectorPhone: '17593958392',
  inspectionCycle: 'monthly',
  customCycle: 30,
  startTime: '2024-07-28T08:00',
  endTime: '2024-12-15T18:00',
  requirements: '定期检查消防设施，确保灭火器压力正常，消防通道畅通无阻。重点检查实验室、配电房等高风险区域。'
})

// ================== 公司数据 ==================
const companies = ref([])

const getCompanies = async () => {
  try {
    const response = await listDept()
    const list = response.data || []
    // 筛选根目录公司 (parentId === 0)
    companies.value = list
      .filter(dept => dept.parentId === 0)
      .map(dept => ({
        id: dept.deptId,
        name: dept.deptName,
        qualification: dept.deptType ? `${dept.deptType}资质` : '综合资质',
        qualificationClass: 'level-a', // 默认样式
        businessType: dept.deptType || '综合服务',
        contact: dept.leader,
        phone: dept.phone,
        personnelCount: 20, // 默认显示
        rating: 5.0, // 默认好评
        arSupport: true, // 默认支持
        iotSupport: true, // 默认支持
        description: dept.address ? `公司地址: ${dept.address}` : '暂无详细地址',
        specialties: dept.inspectionContent ? [dept.inspectionContent] : ['安全检测', '隐患排查']
      }))
  } catch (error) {
    console.error('Failed to load companies:', error)
  }
}

const selectedCompanyId = ref(null)
const selectedCompany = computed(() => {
  return companies.value.find(c => c.id === selectedCompanyId.value)
})

// ================== 人员数据 ==================
const personnelList = ref([])

const getPersonnel = async (deptId) => {
  if (!deptId) {
    personnelList.value = []
    return
  }
  try {
    const response = await listUser({ pageNum: 1, pageSize: 10, deptId: deptId })
    const users = response.rows || []
    
    // 保留现有的分配信息（如果有，比如来自草稿）
    const existingAssignments = new Map(
      personnelList.value.map(p => [p.id, p.assignedAreas])
    )
    
    personnelList.value = users.map(user => ({
      id: user.userId,
      name: user.nickName,
      role: '巡检员', // 默认角色
      status: 'online', // 默认状态
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

// ================== 文档数据 ==================
const documentCategories = ref([
  { id: 1, name: '全部文档', color: '#1890ff' }
])

const allDocuments = ref([])

const getDocuments = async () => {
  // 优先使用选中的项目ID，如果没有则默认为2（兼容测试）
  const projectId = selectedProjectId.value || 2
  
  try {
    const response = await listKnowledgeNode({ projectId: projectId })
    const list = response.rows || response.data || []
    
    allDocuments.value = list.map(item => ({
      id: item.nodeId || item.id,
      title: item.nodeName || item.title || '未命名文档',
      categoryId: 1, // 统一归类到"全部文档"
      description: item.remark || item.description || '暂无描述',
      version: item.version || '1.0',
      updateTime: item.createTime || item.updateTime || new Date().toISOString().split('T')[0],
      author: item.createBy || 'Admin',
      fileType: item.fileType || 'PDF',
      fileSize: item.fileSize || 'Unknown',
      tags: item.tags ? (typeof item.tags === 'string' ? item.tags.split(',') : item.tags) : ['文档']
    }))
    
  } catch (error) {
    console.error('Failed to load documents:', error)
    allDocuments.value = []
  }
}

// 监听步骤变化，进入文档选择步骤时获取数据
watch(currentStep, (newStep) => {
  if (newStep === 3) {
    getDocuments()
  }
})

const selectedDocuments = ref([])
const activeCategoryId = ref(1)

// ================== 发布确认 ==================
const confirmations = reactive({
  agreement: false,
  infoVerified: false,
  readyToPublish: false
})

const isPublishing = ref(false)

// ================== 计算属性 ==================
const canProceed = computed(() => {
  switch (currentStep.value) {
    case 0: // 选定项目
      return selectedProjectId.value && formData.planName && selectedAreas.value.length > 0
    case 1: // 选定公司
      return !!selectedCompanyId.value
    case 2: // 人员区域分布
      // 检查所有区域是否都已分配
      const totalAssignedAreas = personnelList.value.reduce((sum, person) => 
        sum + person.assignedAreas.length, 0)
      return totalAssignedAreas === selectedAreas.value.length && totalAssignedAreas > 0
    case 3: // 选定文档
      return true // 文档可选，不强求
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
    level: node.zonetype
  }))
})

const selectedAreaCount = computed(() => {
  return selectedAreas.value.length
})

// ================== 方法定义 ==================
const setStep = (index) => {
  // 允许返回上一步
  if (index < currentStep.value) {
    currentStep.value = index
    return
  }
  
  // 检查前面所有步骤是否完成
  for (let i = 0; i < index; i++) {
    if (!isStepValid(i)) {
      // 可以添加提示，或者直接阻止
      return
    }
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

// 处理区域变更
const handleRegionChange = () => {
  selectedProjectId.value = null
  selectedNodes.value = []
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setCheckedKeys([])
  }
}

// 处理项目变更
const handleProjectChange = (val) => {
  selectedNodes.value = [] // 清空已选
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setCheckedKeys([]) // 清空树勾选
  }

  // 继承项目负责人信息
  const project = availableProjects.value.find(p => p.id === val)
  if (project) {
    formData.inspector = project.manager || ''
    formData.inspectorPhone = project.managerPhone || ''
  }
}

// 处理树勾选变更
const handleCheckChange = (data, checkedInfo) => {
  selectedNodes.value = checkedInfo.checkedNodes
}

// 移除已选节点
const removeNode = (node) => {
  if (scopeTreeRef.value) {
    scopeTreeRef.value.setChecked(node.id, false)
    // 更新 selectedNodes
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
    // 检查是否已经分配给其他人
    const otherPerson = personnelList.value.find(person => 
      person.id !== selectedPersonnelId.value && 
      person.assignedAreas.some(a => a.id === areaId)
    )
    
    if (otherPerson) {
      // 如果已分配给其他人，直接重新分配（界面上已有浅蓝色提示）
      // 从其他人员中移除
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
  
  // 清空其他人的分配
  personnelList.value.forEach(person => {
    person.assignedAreas = []
  })
  
  // 全部分配给当前人员
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

const getCategoryDocumentCount = (categoryId) => {
  return allDocuments.value.filter(doc => doc.categoryId === categoryId).length
}

const getActiveCategoryDocuments = () => {
  return allDocuments.value.filter(doc => doc.categoryId === activeCategoryId.value)
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
  alert(`预览文档: ${doc.title}\n\n${doc.description}`)
}

const getCategoryName = (categoryId) => {
  const category = documentCategories.value.find(c => c.id === categoryId)
  return category ? category.name : '未知'
}

const generatePlanCode = () => {
  const timestamp = new Date().getTime().toString().slice(-6)
  const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0')
  return `ZC-${timestamp}-${random}`
}

const getAreaCountByLevel = (level) => {
  return selectedAreas.value.filter(area => area.level === level).length
}

const getSelectedDocumentCountByCategory = (categoryId) => {
  return selectedDocuments.value.filter(doc => doc.categoryId === categoryId).length
}

const formatDateTime = (datetime) => {
  if (!datetime) return '未设置'
  return datetime.replace('T', ' ')
}

const getCycleText = (cycle) => {
  const texts = {
    daily: '每日',
    weekly: '每周',
    monthly: '每月',
    quarterly: '每季度',
    yearly: '每年',
    custom: `${formData.customCycle}天`
  }
  return texts[cycle] || cycle
}

const downloadPlan = () => {
  const planData = {
    planCode: generatePlanCode(),
    project: selectedProject.value,
    formData: { ...formData },
    company: selectedCompany.value,
    personnel: personnelList.value.map(p => ({
      name: p.name,
      assignedAreas: p.assignedAreas
    })),
    documents: selectedDocuments.value,
    createdAt: new Date().toISOString()
  }
  
  const dataStr = JSON.stringify(planData, null, 2)
  const dataUri = 'data:application/json;charset=utf-8,' + encodeURIComponent(dataStr)
  
  const exportFileDefaultName = `智巡科防巡检计划-${generatePlanCode()}.json`
  
  const linkElement = document.createElement('a')
  linkElement.setAttribute('href', dataUri)
  linkElement.setAttribute('download', exportFileDefaultName)
  linkElement.click()
  
  alert('巡检计划书下载成功！')
}

const publishPlan = async () => {
  if (!canPublish.value) {
    alert('请完成所有确认项后再发布')
    return
  }
  
  isPublishing.value = true
  
  try {
    // 模拟API调用
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    const planData = {
      id: generatePlanCode(),
      name: formData.planName,
      project: selectedProject.value,
      company: selectedCompany.value,
      inspector: formData.inspector,
      areas: selectedAreas.value,
      personnel: personnelList.value,
      documents: selectedDocuments.value,
      schedule: {
        startTime: formData.startTime,
        endTime: formData.endTime,
        cycle: formData.inspectionCycle
      },
      status: 'active',
      createdAt: new Date().toISOString()
    }
    
    console.log('发布的巡检计划：', planData)
    alert(`巡检计划发布成功！\n计划编号：${planData.id}\n已分配给${personnelList.value.length}名巡检人员`)
    
    // 清空草稿
    localStorage.removeItem('patrolPlanDraft')
    
    // 可以跳转到计划管理页面
    // router.push('/plans')
    emit('save')
    
  } catch (error) {
    console.error('发布失败：', error)
    alert('发布失败，请稍后重试')
  } finally {
    isPublishing.value = false
  }
}

const saveDraft = () => {
  const draftData = {
    step: currentStep.value,
    selectedProjectId: selectedProjectId.value,
    formData: { ...formData },
    selectedCompanyId: selectedCompanyId.value,
    personnelList: personnelList.value,
    selectedDocuments: selectedDocuments.value
  }
  
  localStorage.setItem('patrolPlanDraft', JSON.stringify(draftData))
  // console.log('草稿自动保存成功')
}

// ================== 草稿相关 ==================
// 从 localStorage 加载草稿
const loadDraft = () => {
  const draftStr = localStorage.getItem('patrolPlanDraft')
  if (draftStr) {
    try {
      const draftData = JSON.parse(draftStr)
      currentStep.value = draftData.step
      selectedProjectId.value = draftData.selectedProjectId
      Object.assign(formData, draftData.formData)
      selectedCompanyId.value = draftData.selectedCompanyId
      personnelList.value = draftData.personnelList || personnelList.value
      selectedDocuments.value = draftData.selectedDocuments || []
    } catch (e) {
      console.warn('草稿解析失败', e)
      localStorage.removeItem('patrolPlanDraft') // 清除损坏的草稿
    }
  }
}

// ================== 监听内容变化自动保存 ==================
watch(
  () => ({
    currentStep: currentStep.value,
    selectedProjectId: selectedProjectId.value,
    formData: { ...formData },
    selectedCompanyId: selectedCompanyId.value,
    personnelList: [...personnelList.value],
    selectedDocuments: [...selectedDocuments.value]
  }),
  () => {
    // 防抖优化：避免频繁保存
    clearTimeout(window.draftSaveTimer)
    window.draftSaveTimer = setTimeout(() => {
      saveDraft()
    }, 3000) // 3秒无操作后自动保存
  },
  { deep: true }
)

const getProjects = async () => {
  try {
    const response = await listZone()
    const list = response.data || response.rows || []
    // 构建树结构
    zoneTreeData.value = proxy.handleTree(list, "id", "pid")
  } catch (error) {
    console.error('Failed to load projects:', error)
  }
}

// ================== 生命周期 ==================
// 组件挂载时加载草稿
onMounted(() => {
  loadDraft()
  getProjects()
  getCompanies()
})
</script>

<style scoped>
.intelligent-patrol-plan {
  padding: 20px;
  font-family: 'Microsoft YaHei', Arial, sans-serif;
  max-width: 1400px;
  margin: 0 auto;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
  min-height: 100vh;
}

.system-header {
  text-align: center;
  margin-bottom: 30px;
  padding: 20px;
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  border-radius: 12px;
  color: white;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.system-header h1 {
  margin: 0;
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 8px;
}

.system-subtitle {
  font-size: 16px;
  opacity: 0.9;
}

.step-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: relative;
}

.step-item {
  display: flex;
  align-items: center;
  cursor: pointer;
  position: relative;
  flex: 1;
  transition: all 0.3s;
  z-index: 1;
}

.step-item:hover {
  transform: translateY(-2px);
}

.step-item.active .step-index {
  background: linear-gradient(135deg, #1890ff, #52c41a);
  color: white;
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.step-item.completed .step-index {
  background: linear-gradient(135deg, #52c41a, #73d13d);
  color: white;
}

.step-index {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background-color: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  z-index: 2;
  transition: all 0.3s;
  font-size: 16px;
  border: 3px solid white;
}

.step-label {
  margin-left: 12px;
  font-size: 15px;
  color: #666;
  white-space: nowrap;
  font-weight: 500;
  background: white;
  padding: 4px 8px;
  border-radius: 4px;
}

.step-item.active .step-label {
  color: #1890ff;
  font-weight: bold;
  background: #e6f7ff;
}

.step-connector {
  flex: 1;
  height: 3px;
  background: linear-gradient(to right, #1890ff, #f0f0f0);
  margin: 0 10px;
  position: relative;
  z-index: 0;
}

.step-item.completed .step-connector {
  background: linear-gradient(to right, #52c41a, #1890ff);
}

.step-content {
  padding: 30px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  margin-bottom: 30px;
}

.section {
  margin-bottom: 30px;
  padding: 25px;
  border-radius: 10px;
  background: #fafafa;
  border: 1px solid #f0f0f0;
}

.section h3 {
  color: #1890ff;
  margin: 0 0 20px 0;
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.icon {
  font-size: 18px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.form-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  color: #666;
  font-weight: 500;
  font-size: 14px;
}

.form-group.full-width {
  width: 100%;
}

input, select, textarea {
  padding: 10px 12px;
  border: 2px solid #e8e8e8;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.3s;
  background: white;
}

input:focus, select:focus, textarea:focus {
  border-color: #1890ff;
  outline: none;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
}

textarea {
  min-height: 80px;
  resize: vertical;
}

/* 项目选择样式 */
.project-scope {
  margin-top: 20px;
}

.scope-selection {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  min-height: 400px;
}

.area-tree {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  overflow: hidden;
  background: white;
}

.tree-header {
  padding: 15px 20px;
  background: linear-gradient(135deg, #f6ffed, #e6f7ff);
  border-bottom: 1px solid #e8e8e8;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tree-actions {
  display: flex;
  gap: 10px;
}

.btn-select-all, .btn-clear {
  padding: 6px 12px;
  border: 1px solid #1890ff;
  background: white;
  color: #1890ff;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-clear {
  border-color: #ff4d4f;
  color: #ff4d4f;
}

.tree-content {
  padding: 15px;
  max-height: 350px;
  overflow-y: auto;
}

.tree-item {
  padding: 10px;
  border-radius: 6px;
  margin-bottom: 5px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.2s;
}

.tree-item:hover {
  background: #f5f5f5;
}

.tree-item.level-1 {
  background: #e6f7ff;
  border-left: 4px solid #1890ff;
}

.tree-item.level-2 {
  margin-left: 20px;
  border-left: 4px solid #52c41a;
}

.tree-item.level-3 {
  margin-left: 40px;
  border-left: 4px solid #faad14;
}

.tree-item.level-4 {
  margin-left: 60px;
  border-left: 4px solid #722ed1;
}

.toggle-icon {
  width: 20px;
  text-align: center;
  font-size: 12px;
}

.toggle-icon.expanded {
  transform: rotate(90deg);
}

.area-icon {
  font-size: 16px;
}

.area-name {
  flex: 1;
  color: #333;
}

.area-type {
  color: #888;
  font-size: 12px;
  padding: 2px 8px;
  background: #f0f0f0;
  border-radius: 4px;
}

.selection-control {
  margin-left: auto;
}

.tree-footer {
  padding: 15px;
  border-top: 1px solid #e8e8e8;
  background: #fafafa;
}

.selection-summary {
  text-align: center;
  font-size: 14px;
}

.highlight {
  color: #1890ff;
  font-weight: bold;
}

.selected-preview {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background: white;
}

.selected-list {
  max-height: 350px;
  overflow-y: auto;
}

.selected-item {
  padding: 10px;
  margin-bottom: 8px;
  background: #f6ffed;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid #b7eb8f;
}

.selected-icon {
  font-size: 16px;
}

.selected-path {
  flex: 1;
  font-size: 13px;
  color: #333;
}

.btn-remove {
  width: 24px;
  height: 24px;
  border: none;
  background: #ff4d4f;
  color: white;
  border-radius: 50%;
  cursor: pointer;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-hint {
  padding: 40px 20px;
  text-align: center;
  color: #888;
  background: #fafafa;
  border-radius: 6px;
  border: 2px dashed #e8e8e8;
}

/* 公司选择样式 */
.company-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.company-card {
  padding: 20px;
  border: 2px solid #e8e8e8;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  background: white;
  position: relative;
  overflow: hidden;
}

.company-card:hover {
  border-color: #1890ff;
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(24, 144, 255, 0.15);
}

.company-card.selected {
  border-color: #52c41a;
  background: linear-gradient(135deg, #f6ffed, #e6f7ff);
}

.company-card.selected::before {
  content: '✓';
  position: absolute;
  top: 10px;
  right: 10px;
  width: 24px;
  height: 24px;
  background: #52c41a;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}

.company-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.company-header h4 {
  margin: 0;
  color: #1890ff;
  font-size: 16px;
}

.company-qualification {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
  color: white;
}

.level-a {
  background: linear-gradient(135deg, #ff4d4f, #ff7a45);
}

.level-s {
  background: linear-gradient(135deg, #722ed1, #9254de);
}

.level-b {
  background: linear-gradient(135deg, #faad14, #ffc53d);
}

.company-details {
  margin-bottom: 15px;
}

.detail-row {
  display: flex;
  margin-bottom: 8px;
  font-size: 13px;
}

.detail-label {
  min-width: 80px;
  color: #888;
}

.detail-value {
  color: #333;
  flex: 1;
}

.rating {
  color: #ffc53d;
  font-size: 14px;
}

.star {
  margin-right: 2px;
}

.star.active {
  color: #faad14;
}

.company-footer {
  display: flex;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.ar-support, .iot-support {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  background: #e6f7ff;
  color: #1890ff;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.iot-support {
  background: #f6ffed;
  color: #52c41a;
}

.selected-company-detail {
  padding: 20px;
  background: linear-gradient(135deg, #e6f7ff, #f6ffed);
  border-radius: 8px;
  border: 2px solid #52c41a;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.detail-header h5 {
  margin: 0;
  color: #1890ff;
  font-size: 16px;
}

.btn-change {
  padding: 6px 16px;
  background: #ff4d4f;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.detail-content p {
  margin: 0 0 15px 0;
  color: #333;
  line-height: 1.6;
}

.specialties {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.specialty-tag {
  padding: 4px 12px;
  background: white;
  color: #1890ff;
  border-radius: 20px;
  font-size: 12px;
  border: 1px solid #1890ff;
}

/* 人员分配样式 */
.personnel-distribution {
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 30px;
  min-height: 500px;
}

.personnel-list {
  border-right: 1px solid #e8e8e8;
  padding-right: 20px;
}

.personnel-cards {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-top: 20px;
}

.btn-cancel {
  background: #f5f5f5;
  color: #666;
  border: 1px solid #d9d9d9;
  margin-right: auto;
}

.btn-cancel:hover {
  color: #1890ff;
  border-color: #1890ff;
}

.personnel-card {
  padding: 15px;
  border: 2px solid #e8e8e8;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  background: white;
  display: flex;
  align-items: center;
  gap: 15px;
}

.personnel-card:hover {
  border-color: #1890ff;
  transform: translateX(5px);
}

.personnel-card.active {
  border-color: #52c41a;
  background: linear-gradient(135deg, #f6ffed, #e6f7ff);
}

.personnel-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #1890ff, #36cfc9);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 18px;
}

.personnel-info {
  flex: 1;
}

.personnel-name {
  font-weight: bold;
  color: #333;
  margin-bottom: 4px;
}

.personnel-role {
  font-size: 12px;
  color: #888;
  margin-bottom: 4px;
}

.personnel-areas {
  font-size: 11px;
  color: #666;
}

.area-count {
  color: #1890ff;
  font-weight: bold;
}

.personnel-status {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: bold;
}

.personnel-status.online {
  background: #f6ffed;
  color: #52c41a;
}

.personnel-status.offline {
  background: #fff2e8;
  color: #fa8c16;
}

.no-company-hint {
  padding: 40px 20px;
  text-align: center;
  color: #faad14;
  background: #fff7e6;
  border-radius: 6px;
  border: 2px dashed #ffd591;
}

.area-assignment {
  padding: 20px;
  background: #fafafa;
  border-radius: 8px;
  border: 1px solid #e8e8e8;
}

.assignment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.assignment-header h4 {
  margin: 0;
  color: #1890ff;
}

.assignment-controls {
  display: flex;
  gap: 10px;
}

.btn-assign-all, .btn-clear-assign {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  font-weight: 500;
}

.btn-assign-all {
  background: #52c41a;
  color: white;
}

.btn-clear-assign {
  background: #ff4d4f;
  color: white;
}

.area-selection-modal {
  background: white;
  border-radius: 8px;
  border: 1px solid #e8e8e8;
  padding: 20px;
  margin-bottom: 20px;
  max-height: 400px;
  overflow-y: auto;
}

.selected-project-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #f0f0f0;
}

.project-name {
  font-weight: bold;
  color: #1890ff;
}

.selected-count {
  color: #666;
  font-size: 13px;
}

.area-checkbox-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 10px;
}

.area-checkbox-item {
  padding: 10px;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  background: #fafafa;
}

.area-checkbox-item.assigned-to-other {
  background-color: #e6f7ff;
  border-color: #91d5ff;
}

.assigned-hint {
  color: #1890ff;
  font-size: 12px;
  margin-left: 10px;
}

.area-checkbox-item label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  width: 100%;
}

.area-checkbox-item input[type="checkbox"] {
  width: 16px;
  height: 16px;
}

.area-name {
  font-weight: 500;
  color: #333;
}

.area-path {
  color: #888;
  font-size: 12px;
  margin-left: auto;
}

.assignment-summary {
  display: flex;
  justify-content: space-around;
  padding: 15px;
  background: #f0f7ff;
  border-radius: 6px;
  margin-top: 20px;
  border: 1px solid #e6f7ff;
}

.summary-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.summary-item .label {
  font-size: 12px;
  color: #666;
}

.summary-item .value {
  font-size: 20px;
  font-weight: bold;
  color: #1890ff;
}

.assigned-areas {
  margin-top: 20px;
}

.assigned-areas h5 {
  margin: 0 0 15px 0;
  color: #52c41a;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.assigned-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 10px;
}

.assigned-item {
  padding: 10px;
  background: #f6ffed;
  border: 1px solid #b7eb8f;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.area-info {
  flex: 1;
  font-size: 13px;
  color: #333;
}

.btn-remove-assignment {
  padding: 4px 8px;
  background: #ff4d4f;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 11px;
}

/* 文档选择样式 */
.document-categories {
  margin-bottom: 30px;
}

.category-tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 2px solid #f0f0f0;
  overflow-x: auto;
}

.category-tab {
  padding: 10px 20px;
  border: none;
  background: #f5f5f5;
  color: #666;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
  white-space: nowrap;
  transition: all 0.3s;
}

.category-tab:hover {
  background: #e6f7ff;
  color: #1890ff;
}

.category-tab.active {
  background: #1890ff;
  color: white;
}

.document-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.document-card {
  padding: 20px;
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  background: white;
}

.document-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.document-title {
  display: flex;
  align-items: center;
  gap: 10px;
}

.doc-icon {
  font-size: 20px;
}

.document-title h4 {
  margin: 0;
  color: #333;
  font-size: 16px;
}

.doc-version {
  padding: 2px 6px;
  background: #f0f0f0;
  color: #666;
  border-radius: 4px;
  font-size: 11px;
}

.document-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.btn-preview {
  padding: 6px 12px;
  background: #e6f7ff;
  color: #1890ff;
  border: 1px solid #1890ff;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  font-size: 13px;
}

.document-content {
  margin-left: 30px;
}

.doc-description {
  color: #666;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 10px;
}

.doc-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 10px;
  font-size: 12px;
  color: #888;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.doc-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  padding: 2px 8px;
  background: #f0f0f0;
  color: #666;
  border-radius: 4px;
  font-size: 11px;
}

.selected-documents {
  padding: 20px;
  background: #f6ffed;
  border-radius: 8px;
  border: 1px solid #b7eb8f;
}

.selected-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 10px;
  margin-top: 15px;
}

.selected-doc {
  padding: 10px;
  background: white;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.doc-title {
  flex: 1;
  font-weight: 500;
  color: #333;
  font-size: 13px;
}

.doc-category {
  padding: 2px 8px;
  background: #f0f0f0;
  color: #666;
  border-radius: 4px;
  font-size: 11px;
}

.btn-remove-doc {
  padding: 4px 8px;
  background: #ff4d4f;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 11px;
}

/* 预览发布样式 */
.plan-overview {
  background: white;
  border-radius: 12px;
  border: 1px solid #e8e8e8;
  overflow: hidden;
}

.overview-header {
  padding: 20px;
  background: linear-gradient(135deg, #1890ff, #36cfc9);
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.overview-header h4 {
  margin: 0;
  font-size: 20px;
}

.plan-code {
  background: rgba(255, 255, 255, 0.2);
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
}

.overview-sections {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  padding: 20px;
}

.overview-section {
  padding: 20px;
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  background: #fafafa;
}

.overview-section h5 {
  margin: 0 0 15px 0;
  color: #1890ff;
  font-size: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;
}

.info-item {
  display: flex;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
}

.info-item .label {
  min-width: 100px;
  color: #666;
  font-size: 13px;
}

.info-item .value {
  flex: 1;
  color: #333;
  font-weight: 500;
}

.scope-summary {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.area-breakdown {
  display: flex;
  justify-content: space-around;
}

.breakdown-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}

.breakdown-item .icon {
  font-size: 24px;
}

.breakdown-item .count {
  font-size: 20px;
  font-weight: bold;
  color: #1890ff;
}

.breakdown-item .type {
  font-size: 12px;
  color: #666;
}

.company-summary {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.company-name {
  font-weight: bold;
  color: #1890ff;
  font-size: 15px;
}

.company-details {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  font-size: 13px;
  color: #666;
}

.not-selected {
  padding: 20px;
  text-align: center;
  color: #888;
  background: #fafafa;
  border-radius: 6px;
  border: 2px dashed #e8e8e8;
}

.personnel-summary {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.personnel-assignment {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.person-assignment {
  display: flex;
  justify-content: space-between;
  padding: 8px 12px;
  background: white;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
}

.person-name {
  font-weight: 500;
  color: #333;
}

.area-count {
  color: #1890ff;
  font-weight: 500;
}

.document-summary {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.category-breakdown {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}

.category-count {
  display: flex;
  justify-content: space-between;
  padding: 6px 10px;
  background: white;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  font-size: 12px;
}

.category-name {
  color: #666;
}

.category-count .count {
  color: #1890ff;
  font-weight: bold;
}

.time-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.time-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.time-item:last-child {
  border-bottom: none;
}

.time-item .label {
  color: #666;
  font-size: 13px;
}

.time-item .value {
  color: #333;
  font-weight: 500;
}

/* 发布操作 */
.publish-actions {
  padding: 30px;
  background: #fafafa;
  border-radius: 10px;
  border: 1px solid #e8e8e8;
  margin-top: 30px;
}

.publish-confirmations {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 30px;
}

.confirm-checkbox {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 14px;
  color: #333;
}

.confirm-checkbox input[type="checkbox"] {
  width: 18px;
  height: 18px;
}

.action-buttons {
  display: flex;
  gap: 20px;
}

.btn-download, .btn-publish {
  flex: 1;
  padding: 15px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  transition: all 0.3s;
}

.btn-download {
  background: linear-gradient(135deg, #36cfc9, #13c2c2);
  color: white;
}

.btn-publish {
  background: linear-gradient(135deg, #52c41a, #389e0d);
  color: white;
}

.btn-publish:disabled {
  background: #d9d9d9;
  cursor: not-allowed;
}

.btn-publish:not(:disabled):hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(82, 196, 26, 0.3);
}

/* 导航按钮 */
.navigation-buttons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 30px;
  padding: 20px;
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.btn {
  padding: 12px 40px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
  min-width: 120px;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-prev {
  background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
  color: #666;
}

.btn-next {
  background: linear-gradient(135deg, #1890ff, #096dd9);
  color: white;
}

.btn-save {
  background: linear-gradient(135deg, #faad14, #d48806);
  color: white;
}
</style>