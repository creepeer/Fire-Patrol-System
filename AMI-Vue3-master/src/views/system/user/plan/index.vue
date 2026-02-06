<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 左侧区域列表 -->
      <el-col :span="6" :xs="24">
        <el-card class="box-card" shadow="always">
          <template #header>
            <div class="clearfix">
              <span>需检查区域</span>
            </div>
          </template>
          
          <!-- 计划选择 -->
          <div class="mb-4">
            <el-select 
              v-model="selectedPlanId" 
              placeholder="请选择检测计划" 
              style="width: 100%" 
              clearable
              @change="handlePlanChange"
            >
              <el-option
                v-for="plan in myPlanOptions"
                :key="plan.id"
                :label="plan.name"
                :value="plan.id"
              />
            </el-select>
          </div>

          <div v-loading="zoneLoading">
            <el-empty v-if="!currentZoneTree.length" description="暂无分配的区域" />
            <div v-else class="zone-tree-container">
              <el-input 
                v-model="filterText" 
                class="mb-2" 
                placeholder="过滤区域" 
                clearable
                prefix-icon="Search"
              />
              <el-tree
                ref="treeRef"
                class="filter-tree"
                :data="currentZoneTree"
                :props="{ label: 'zname', children: 'children' }"
                node-key="id"
                :filter-node-method="filterNode"
                default-expand-all
                highlight-current
                :expand-on-click-node="false"
                @node-click="handleZoneClick"
              >
                <template #default="{ node, data }">
                  <span class="custom-tree-node">
                    <span>{{ node.label }}</span>
                    <el-tag v-if="data.isAssigned" size="small" type="success" effect="plain" class="assigned-tag">需检</el-tag>
                    <el-tag v-if="data.status === '1'" size="small" type="success" class="ml-2">已通过</el-tag>
                  </span>
                </template>
              </el-tree>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 右侧设备列表 -->
      <el-col :span="18" :xs="24">
        <el-card class="box-card" shadow="always">
          <template #header>
            <div class="clearfix">
              <span>设备检查清单</span>
              <span v-if="selectedZoneName" style="margin-left: 10px; font-size: 14px; color: #666;">
                (当前区域: {{ selectedZoneName }})
              </span>
            </div>
          </template>
          
          <div v-if="!selectedZoneId" class="select-hint">
            <el-empty description="请选择左侧区域查看设备" />
          </div>
          
          <div v-else>
             <!-- 列表已隐藏 -->
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 提交确认对话框 -->
    <el-dialog
      v-model="submitDialogVisible"
      title="提交检测结果"
      width="500px"
      append-to-body
    >
      <el-form ref="submitFormRef" :model="submitForm" :rules="submitRules" label-width="80px">
        <el-form-item label="检测状态">
          <el-tag :type="submitForm.status === '1' ? 'success' : 'danger'">
            {{ submitForm.status === '1' ? '已通过' : '未通过' }}
          </el-tag>
        </el-form-item>
        <el-form-item label="备注说明" prop="remark" v-if="submitForm.status !== '1'">
          <el-input 
            v-model="submitForm.remark" 
            type="textarea" 
            placeholder="请输入未通过原因" 
            :rows="3"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="submitDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="confirmSubmit">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="PlanCheck">
import { ref, onMounted, computed, watch, nextTick } from 'vue';
import { listPlanUser, updatePlanUser } from '@/api/system/planUser';
import { getPlan } from '@/api/system/plan';
import { listDeviceByZoneId, listDevicePlanByZoneId } from '@/api/system/device';
import { listZone } from '@/api/system/zone';
import useUserStore from '@/store/modules/user';
import { parseTime, handleTree } from '@/utils/ruoyi';
import { ElMessage } from 'element-plus';
import { ArrowRight, Search } from '@element-plus/icons-vue';

const userStore = useUserStore();
const zoneLoading = ref(false);
const deviceLoading = ref(false);
const zoneList = ref([]); // 所有的区域列表（扁平数据，包含 planId 关联）
const deviceList = ref([]);
const selectedZoneId = ref(null);
const selectedZoneName = ref('');
const planUserMap = ref(new Map()); // 存储 planUser 记录，key 为 zoneId 或 deviceId

// 树形控件相关
const filterText = ref('');
const treeRef = ref(null);

watch(filterText, (val) => {
  treeRef.value?.filter(val);
});

const filterNode = (value, data) => {
  if (!value) return true;
  return data.zname && data.zname.includes(value);
};

// 计划相关
const selectedPlanId = ref(null);
const myPlanOptions = ref([]);

// 构建当前计划对应的区域树
const currentZoneTree = computed(() => {
  if (!selectedPlanId.value) {
    return [];
  }
  
  // 1. 获取当前计划下所有关联的区域ID
  const assignedZoneIds = new Set(
    zoneList.value
      .filter(item => item.planId === selectedPlanId.value)
      .map(item => item.id)
  );

  if (assignedZoneIds.size === 0) return [];

  // 2. 辅助函数：查找某个节点的所有父级ID
  const findAllParents = (nodeId, allZonesMap, parentIdsSet) => {
    let currentId = nodeId;
    while (currentId) {
      const node = allZonesMap.get(currentId);
      if (!node) break;
      const parentId = node.parentId || node.pid;
      if (parentId) {
        parentIdsSet.add(parentId);
        currentId = parentId;
      } else {
        break;
      }
    }
  };

  // 3. 收集所有需要显示的节点ID (包括被分配的节点 + 它们的祖先节点)
  const nodesToShow = new Set(assignedZoneIds);
  
  // 需要访问原始的完整区域Map，这里我们利用 getMyZones 中缓存的数据或者重新构建
  // 为了简单起见，我们在 getMyZones 中把完整树结构或Map保存下来会更好
  // 这里我们假设 zoneList 中已经包含了所有必要的路径信息是不够的，
  // 因为 zoneList 目前只存了 assigned 的区域。
  // 必须依赖 cachedAllZones (完整区域数据) 来构建树。
  
  if (!cachedAllZones.value || cachedAllZones.value.length === 0) return [];

  const zoneMap = new Map();
  const flatten = (list) => {
    list.forEach(item => {
      zoneMap.set(item.id, item);
      if (item.children) flatten(item.children);
    });
  };
  flatten(cachedAllZones.value);

  // 向上查找所有父节点
  assignedZoneIds.forEach(id => {
    findAllParents(id, zoneMap, nodesToShow);
  });

  // 4. 构建树结构
  const buildTree = (nodes) => {
    const res = [];
    nodes.forEach(node => {
      // 只有在 nodesToShow 中的节点才会被处理
      if (nodesToShow.has(node.id)) {
        const newNode = {
          ...node,
          isAssigned: assignedZoneIds.has(node.id), // 标记是否为需检区域
          children: node.children ? buildTree(node.children) : []
        };
        // 如果该节点是需检节点，或者它有子节点被显示，则加入结果
        if (newNode.isAssigned || newNode.children.length > 0) {
          res.push(newNode);
        }
      }
    });
    return res;
  };

  return buildTree(cachedAllZones.value);
});

const cachedAllZones = ref([]); // 缓存原始完整区域树

/** 获取当前用户的区域列表 */
async function getMyZones() {
  zoneLoading.value = true;
  try {
    // 1. 并行请求：获取用户计划关联、获取所有区域列表(用于匹配名称)
    const [planUserRes, zoneRes] = await Promise.all([
      listPlanUser({ userId: userStore.id }),
      listZone()
    ]);

    const planUserRows = planUserRes.rows || [];
    const allZones = zoneRes.rows || zoneRes.data || [];
    
    // 转换为树结构，适配后端返回的 flat 数据 (id, pid)
    const treeData = handleTree(allZones, "id", "pid");
    cachedAllZones.value = treeData; // 保存完整树结构

    // 建立区域Map以便快速查找 (处理扁平或树状结构)
    const zoneMap = new Map();
    const flattenZones = (list, parent = null) => {
      list.forEach(item => {
        // 确保有 parentId 信息 (如果后端未返回，根据层级手动补全)
        if (parent && !item.parentId) {
          item.parentId = parent.id;
        }
        zoneMap.set(item.id, item);
        if (item.children && item.children.length > 0) {
          flattenZones(item.children, item);
        }
      });
    };
    flattenZones(treeData);

    const uniquePlanIds = new Set();
    const areas = [];
    const seenZone = new Set();
    planUserMap.value.clear();

    // 2. 遍历关联数据，提取计划ID和区域ID
    planUserRows.forEach(row => {
      const pId = row.planId;
      if (pId) {
        uniquePlanIds.add(pId);
      }

      // 如果有 deviceId，记录映射关系
      if (row.deviceId) {
         planUserMap.value.set(`device-${row.deviceId}`, row);
      }
      
      // 提取区域ID
      const zoneIdsToCheck = [];
      
      // 情况A: 嵌套对象 assignedAreas
      const myAreas = row.assignedAreas || row.areaList;
      if (Array.isArray(myAreas) && myAreas.length > 0) {
        myAreas.forEach(a => {
           zoneIdsToCheck.push(a.id);
           // 如果是按区域分配，也可以记录 planUser
           planUserMap.value.set(`zone-${a.id}`, row);
        });
      } 
      // 情况B: 扁平字段 zoneId
      else if (row.zoneId) {
        zoneIdsToCheck.push(row.zoneId);
        // 记录区域对应的 planUser
        planUserMap.value.set(`zone-${row.zoneId}`, row);
      }

      // 处理找到的区域ID
      zoneIdsToCheck.forEach(zId => {
        const uniqueKey = `${pId}-${zId}`;
        if (!seenZone.has(uniqueKey)) {
          seenZone.add(uniqueKey);
          // 仅记录关联关系，具体树结构构建交给 computed
          // 在这里我们也可以把 planUser 的状态附加到 areas 里，
          // 但 areas 最终会被转化为树，所以我们需要把状态信息传递给树节点
          
          // 查找 zoneMap 中的节点并附加状态
          const zoneNode = zoneMap.get(zId);
          if (zoneNode) {
              // 注意：row.status 是 planUser 的状态
              zoneNode.status = row.status; 
          }

          areas.push({
            id: zId,
            planId: pId
          });
        }
      });
    });

    // 3. 根据 Plan ID 获取计划详细信息 (主要是名称)
    const planPromises = Array.from(uniquePlanIds).map(id => getPlan(id));
    const plansResults = await Promise.all(planPromises);

    myPlanOptions.value = plansResults.map(res => {
      const data = res.data;
      return {
        id: data.id,
        name: data.name
      };
    });

    // 默认选中第一个计划
    if (myPlanOptions.value.length > 0 && !selectedPlanId.value) {
      selectedPlanId.value = myPlanOptions.value[0].id;
    }

    zoneList.value = areas;
  } catch (error) {
    console.error("获取计划区域失败", error);
    ElMessage.error("获取需检查区域失败");
  } finally {
    zoneLoading.value = false;
  }
}

/** 计划变更 */
function handlePlanChange() {
  selectedZoneId.value = null;
  selectedZoneName.value = '';
  deviceList.value = [];
  filterText.value = ''; // 重置搜索
}

/** 点击区域加载设备 */
async function handleZoneClick(data) {
  // 只有被标记为 assigned 的节点才允许点击查询设备，或者允许查询所有节点下的设备？
  // 根据需求，通常只检查分配的区域。但也可能允许查看父级。
  // 这里假设所有显示的节点都可以点击，但只有 assigned 的会有数据？
  // 或者：如果点击的是父节点，是否应该显示所有子孙节点的设备？
  // 简单起见，点击任何节点都尝试加载设备。
  
  selectedZoneId.value = data.id;
  selectedZoneName.value = data.zname;
  deviceLoading.value = true;
  deviceList.value = []; // 清空旧数据
  
  try {
    // 使用新接口获取计划设备信息 (包含状态)
    const response = await listDevicePlanByZoneId(data.id);
    const apiData = response.rows || response.data || [];
    
    // 如果返回的是 DPlanUser 对象列表，我们需要提取其中的设备信息并合并状态
    // 假设返回结构中包含 device 对象或者 deviceId 等字段
    // 如果后端直接返回设备列表并附带状态最好，如果是 PlanUser 列表，需要映射
    
    // 尝试根据返回数据结构适配
    deviceList.value = apiData.map(item => {
        let device = {};
        let status = '0';
        let planUserId = null;

        // 情况1: 返回的是 DPlanUser 对象，包含 device 信息
        if (item.device) {
             device = item.device;
             status = item.status;
             planUserId = item.id;
        }
        // 情况2: 返回的是 Device 对象，包含 planUser 信息
        else if (item.id && item.planUserId) {
             device = item;
             status = item.status;
             planUserId = item.planUserId;
        }
        // 情况3: 混合结构
        else {
             device = item;
             status = item.status;
             planUserId = item.id || item.planUserId; // 假设 item 本身是 PlanUser
        }

        // 检查当前区域是否已经“已通过”
        // 如果区域状态是 '1'，则所有设备强制显示为已通过
        const zonePlanUser = planUserMap.value.get(`zone-${data.id}`);
        const isZonePassed = zonePlanUser && zonePlanUser.status === '1';

        const isChecked = isZonePassed || status === '1';

        return {
            ...device,
            // 补全可能缺失的设备字段
            id: device.id || item.deviceId,
            name: device.name || item.deviceName || '未知设备',
            model: device.model || '',
            brand: device.brand || '',
            location: device.location || '',
            categoryName: device.categoryName || '',
            deviceStatus: device.deviceStatus,
            relatedlocation: device.relatedlocation || '',
            
            isChecked: isChecked,
            planUserId: planUserId
        };
    });
    
  } catch (error) {
    console.error("获取设备失败", error);
    ElMessage.error("获取设备列表失败");
  } finally {
    deviceLoading.value = false;
  }
}

const isAllDevicesChecked = computed(() => {
  if (deviceList.value.length === 0) return false;
  return deviceList.value.every(device => device.isChecked);
});

// 提交相关
const submitDialogVisible = ref(false);
const submitFormRef = ref(null);
const submitForm = ref({
  status: '1',
  remark: ''
});
const submitRules = {
  remark: [
    { required: true, message: "请输入未通过原因", trigger: "blur" }
  ]
};

/** 点击提交按钮 */
function handleSubmitClick() {
  if (!selectedZoneId.value) return;

  // 根据当前设备勾选状态判断
  if (isAllDevicesChecked.value) {
    submitForm.value = { status: '1', remark: '' };
  } else {
    // 状态2表示异常/未通过
    submitForm.value = { status: '2', remark: '' };
  }
  submitDialogVisible.value = true;
}

/** 确认提交 */
async function confirmSubmit() {
  if (submitForm.value.status !== '1') {
    // 校验备注
    if (!submitFormRef.value) return;
    await submitFormRef.value.validate(async (valid) => {
      if (valid) {
        await executeSubmit();
      }
    });
  } else {
    await executeSubmit();
  }
}

/** 执行提交逻辑 */
async function executeSubmit() {
  try {
    let zonePlanUser = planUserMap.value.get(`zone-${selectedZoneId.value}`);
    if (!zonePlanUser) {
        ElMessage.warning("未找到关联的区域检查任务信息，无法提交");
        return;
    }

    const data = {
      id: zonePlanUser.id,
      status: submitForm.value.status,
      remark: submitForm.value.remark
    };
    
    await updatePlanUser(data);
    ElMessage.success(submitForm.value.status === '1' ? "区域检测已通过" : "已提交检测异常记录");
    
    submitDialogVisible.value = false;

    // 刷新设备列表以显示最新状态
    await handleZoneClick({ id: selectedZoneId.value, zname: selectedZoneName.value });
    
    // 刷新左侧树状态
    await getMyZones();

  } catch (error) {
    console.error("提交区域状态失败", error);
    ElMessage.error("提交失败");
  }
}

/** 勾选状态改变 */
function handleCheckChange(row) {
  // 仅在前端切换状态，不再自动提交
}

/** 获取设备状态文本 */
function getDeviceStatusText(status) {
  const statusMap = {
    1: '正常',
    2: '异常',
    3: '修理中',
    4: '待复检'
  }
  return statusMap[status] || '未知'
}

/** 获取设备状态标签类型 */
function getDeviceStatusType(status) {
  const typeMap = {
    1: 'success',
    2: 'danger',
    3: 'warning',
    4: 'info'
  }
  return typeMap[status] || 'info'
}

onMounted(() => {
  getMyZones();
});
</script>

<style scoped lang="scss">
.zone-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.zone-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
  
  &:hover {
    background-color: #f5f7fa;
    border-color: #409eff;
  }
  
  &.active {
    background-color: #ecf5ff;
    border-color: #409eff;
    color: #409eff;
  }
  
  .zone-info {
    display: flex;
    flex-direction: column;
    
    .zone-name {
      font-weight: bold;
      margin-bottom: 5px;
    }
    
    .zone-level {
      font-size: 12px;
    }
  }
}

.select-hint {
  padding: 50px 0;
  text-align: center;
  color: #909399;
}
</style>
