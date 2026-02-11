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
            <el-table v-loading="deviceLoading" :data="deviceList" style="width: 100%" border>
              <el-table-column prop="name" label="设备名称" min-width="120" />
              <el-table-column prop="scanStatus" label="检测状态" width="100" align="center">
                <template #default="scope">
                  <el-tag :type="getScanStatusType(scope.row.scanStatus)">
                    {{ getScanStatusText(scope.row.scanStatus) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="deviceCode" label="设备编号" width="120" />
              <el-table-column label="设备二维码" width="100" align="center">
                <template #default="scope">
                  <el-image 
                    v-if="scope.row.qrUrl"
                    style="width: 50px; height: 50px"
                    :src="scope.row.qrUrl"
                    :preview-src-list="[scope.row.qrUrl]"
                    fit="contain"
                    preview-teleported
                  >
                    <template #error>
                      <div class="image-slot">
                        <el-icon><Picture /></el-icon>
                      </div>
                    </template>
                  </el-image>
                  <span v-else>无</span>
                </template>
              </el-table-column>
              <el-table-column prop="location" label="具体位置" min-width="150" show-overflow-tooltip />
              <el-table-column label="操作" width="180" align="center" fixed="right">
                <template #default="scope">
                  <el-button
                    size="small"
                    type="success"
                    link
                    icon="Check"
                    @click="handlePass(scope.row)"
                  >
                    通过
                  </el-button>
                  <el-button
                    size="small"
                    type="danger"
                    link
                    icon="Close"
                    @click="handleFail(scope.row)"
                  >
                    不通过
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 不通过备注对话框 -->
    <el-dialog
      v-model="remarkDialogVisible"
      title="填写不通过理由"
      width="500px"
      append-to-body
    >
      <el-form :model="remarkForm" label-width="80px">
        <el-form-item label="备注说明">
          <el-input 
            v-model="remarkForm.remark" 
            type="textarea" 
            placeholder="请输入不通过原因" 
            :rows="3"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="remarkDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="confirmFail">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="PlanCheck">
import { ref, onMounted, computed, watch, nextTick } from 'vue';
import { listPlanUser, updatePlanUser, addPlanUser } from "@/api/system/planUser";
import { getPlan } from '@/api/system/plan';
import { listDevice, listDevicePlanByZoneId } from '@/api/system/device';
import { listZone } from '@/api/system/zone';
import useUserStore from '@/store/modules/user';
import { parseTime, handleTree } from '@/utils/ruoyi';
import { ElMessage } from 'element-plus';
import { ArrowRight, Search, Picture } from '@element-plus/icons-vue';

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
  selectedZoneId.value = data.id;
  selectedZoneName.value = data.zname;
  deviceLoading.value = true;
  deviceList.value = []; // 清空旧数据
  
  try {
    // 并行获取：区域下的设备列表 + 当前用户的检查记录
    const [deviceRes, planUserRes] = await Promise.all([
      listDevicePlanByZoneId(data.id),
      listPlanUser({ 
        userId: userStore.id, 
        planId: selectedPlanId.value 
      })
    ]);

    const apiData = deviceRes.rows || deviceRes.data || deviceRes || [];
    const userPlanRecords = planUserRes.rows || planUserRes.data || planUserRes || [];
    
    // 建立 deviceId -> planUser 记录的映射
    const recordMap = new Map();
    userPlanRecords.forEach(record => {
      if (record.deviceId) {
        recordMap.set(record.deviceId, record);
      }
    });

    // 映射数据
    deviceList.value = apiData.map(item => {
      const deviceId = item.id;
      const planId = item.planId || selectedPlanId.value;
      
      // 从 planUser 记录中查找匹配的记录
      const userRecord = recordMap.get(deviceId);
      
      // 优先使用 planUser 记录中的 id (这是 d_plan_user 表的主键)
      // 如果没有记录，则 planUserId 为 null
      const planUserId = userRecord ? userRecord.id : null;
      
      const device = item.device || {};
      const deviceName = item.name || item.deviceName || device.name || '';
      const deviceCode = item.qrCode || item.qr_code || item.deviceCode || device.qrCode || device.qr_code || device.deviceCode || '';
      const qrUrl = item.qrUrl || item.qr_url || device.qrUrl || device.qr_url || '';
      
      const categoryName = item.categoryName || device.categoryName || '';
      const location = item.location || device.location || '';

      // 状态优先从 userRecord 中获取
      let status = 0;
      let remark = '';
      
      if (userRecord) {
        status = userRecord.status;
        remark = userRecord.remark || '';
      } else {
        // 如果没有记录，尝试读取 item 中的 status (可能是旧逻辑遗留)
        status = item.status;
        if (status === undefined || status === null) {
          status = 0; 
        }
        remark = item.remark || '';
      }

      return {
        id: deviceId, // 设备ID
        planUserId: planUserId, // 关联表ID (d_plan_user.id)
        planId: planId,
        name: deviceName,
        deviceCode: deviceCode,
        qrUrl: qrUrl,
        categoryName: categoryName,
        location: location,
        scanStatus: status,
        scanRemark: remark
      };
    });
    
  } catch (error) {
    console.error("获取设备失败", error);
    ElMessage.error("获取设备列表失败");
  } finally {
    deviceLoading.value = false;
  }
}

/** 获取扫描状态文本 */
function getScanStatusText(status) {
  const statusMap = {
    0: '未检测',
    1: '已通过',
    2: '不通过'
  }
  return statusMap[status] || '未检测'
}

/** 获取扫描状态标签类型 */
function getScanStatusType(status) {
  const typeMap = {
    0: 'info',
    1: 'success',
    2: 'danger'
  }
  return typeMap[status] || 'info'
}

/** 处理状态变更 */
const currentDevice = ref(null);
const remarkDialogVisible = ref(false);
const remarkForm = ref({ remark: '' });

function handlePass(row) {
  submitScanResult(row, 1);
}

function handleFail(row) {
  currentDevice.value = row;
  remarkForm.value.remark = row.scanRemark || '';
  remarkDialogVisible.value = true;
}

async function confirmFail() {
  if (!remarkForm.value.remark) {
    ElMessage.warning("请输入不通过理由");
    return;
  }
  await submitScanResult(currentDevice.value, 2, remarkForm.value.remark);
  remarkDialogVisible.value = false;
}

async function submitScanResult(row, status, remark = '') {
  // 根据用户要求：
  // 1. 不需要提交 id (PlanUser主键)
  // 2. deviceId 的值取自 row.id (即设备ID)
  // 3. planId 取自左上角选择的 selectedPlanId
  
  const data = {
    planId: selectedPlanId.value,
    deviceId: row.id,
    userId: userStore.id, // 当前用户ID
    zoneId: selectedZoneId.value, // 当前区域ID
    status: status,
    remark: remark
  };

  // 用户要求：想要更新，不能直接用planuser和deviceid直接找到对应的实体更新吗？
  // 答：如果后端支持根据 planId 和 deviceId 更新，则不需要 id。
  // 我们直接调用 updatePlanUser，并带上所有必要参数。
  // 如果之前因为缺少 userId/zoneId 导致 500，现在补上后应该能正常工作。
  
  if (row.planUserId) {
    data.id = row.planUserId;
  }
  
  // 无论是否有ID，都尝试调用更新接口
  // 注意：如果后端严格要求ID，且这里没有ID，仍然可能失败。
  // 但根据用户意图，我们优先尝试更新。
  await updatePlanUser(data).then(() => {
    ElMessage.success("状态更新成功");
    refreshDeviceRow(row.id, status, remark);
  });
}

function refreshDeviceRow(deviceId, status, remark) {
  const device = deviceList.value.find(d => d.id === deviceId);
  if (device) {
    device.scanStatus = status;
    device.scanRemark = remark;
  }
}

const isAllDevicesChecked = computed(() => {
  // 此逻辑可能不再适用，因为现在是逐个操作，或者可以保留作为“一键通过”的基础
  if (deviceList.value.length === 0) return false;
  return deviceList.value.every(device => device.scanStatus === 1);
});

// ----------------------------------------------------------------
// 下面是旧代码清理或保留
// ----------------------------------------------------------------

// 提交相关 (旧逻辑，暂时保留变量定义以防报错，但不再使用)
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

/** 点击提交按钮 (旧) */
function handleSubmitClick() {
   // 已废弃
}

/** 确认提交 (旧) */
async function confirmSubmit() {
   // 已废弃
}

/** 执行提交逻辑 (旧) */
async function executeSubmit() {
   // 已废弃
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
