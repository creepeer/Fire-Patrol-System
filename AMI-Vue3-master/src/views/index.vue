<template>
  <div class="dashboard">
    <div class="dashboard-header">
      <h2>巡检概览</h2>
      <span class="dashboard-subtitle">系统基础数据统计</span>
    </div>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-title">区域数量</div>
          <div class="stat-value">{{ zoneCount }}</div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-title">项目数量</div>
          <div class="stat-value">{{ projectCount }}</div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listZone } from '@/api/system/zone'

const zoneCount = ref(0)
const projectCount = ref(0)
const loading = ref(false)

function getCountFromRes(res) {
  if (typeof res.total === 'number') {
    return res.total
  }
  if (Array.isArray(res.rows)) {
    return res.rows.length
  }
  if (Array.isArray(res.data)) {
    return res.data.length
  }
  return 0
}

async function loadCounts() {
  loading.value = true
  try {
    const [projectRes, level1Res, level2Res, level3Res] = await Promise.all([
      listZone({ zonetype: 1 }),
      listZone({ zonetype: 2 }),
      listZone({ zonetype: 3 }),
      listZone({ zonetype: 4 })
    ])
    projectCount.value = getCountFromRes(projectRes)
    zoneCount.value =
      getCountFromRes(level1Res) +
      getCountFromRes(level2Res) +
      getCountFromRes(level3Res)
  } catch (e) {
    ElMessage.error('加载统计数据失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCounts()
})
</script>

<style scoped lang="scss">
.dashboard {
  padding: 20px;
  height: calc(100vh - 84px);
  background-color: #f0f2f5;
  box-sizing: border-box;

  .dashboard-header {
    display: flex;
    align-items: baseline;
    gap: 12px;
    margin-bottom: 20px;

    h2 {
      margin: 0;
      font-size: 22px;
      color: #303133;
    }

    .dashboard-subtitle {
      font-size: 14px;
      color: #909399;
    }
  }

  .stat-card {
    text-align: center;

    .stat-title {
      font-size: 16px;
      color: #909399;
      margin-bottom: 10px;
    }

    .stat-value {
      font-size: 32px;
      font-weight: 600;
      color: #409eff;
    }
  }
}
</style>
