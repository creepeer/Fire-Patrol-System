<template>
  <div class="control-center">
    <!-- Header Area -->
    <div class="header-controls">
      <h2>巡检中控中心</h2>
      <div class="status-panel">
        <el-tag type="success" v-if="mapLoaded">地图已加载</el-tag>
        <el-tag type="info" v-else>正在加载地图...</el-tag>
        <span class="location-text" v-if="inspectorPosition.lat">
          当前位置: {{ inspectorPosition.lng.toFixed(6) }}, {{ inspectorPosition.lat.toFixed(6) }}
        </span>
      </div>
    </div>
    
    <!-- Navigation Controls -->
    <div class="nav-controls">
       <el-form :inline="true" :model="navForm" class="nav-form">
         <el-form-item label="起点坐标">
           <el-input v-model="navForm.start" placeholder="lat,lng (例如: 27.56,120.56)"></el-input>
         </el-form-item>
         <el-form-item label="终点坐标">
           <el-input v-model="navForm.end" placeholder="lat,lng"></el-input>
         </el-form-item>
         <el-form-item>
           <el-button type="primary" @click="startNavigation" :loading="navLoading">开始导航</el-button>
           <el-button @click="clearNavigation">清除路线</el-button>
         </el-form-item>
       </el-form>
    </div>

    <!-- Map Container -->
    <div class="map-container" id="tencent-map-container">
      <!-- 腾讯地图挂载点 -->
    </div>
  </div>
</template>

<script setup name="Index">
import { ref, onMounted, onUnmounted, reactive } from 'vue'
import { getRealTimePosition } from '@/api/system/monitor'
import { ElMessage } from 'element-plus'

// 状态变量
const mapLoaded = ref(false)
const inspectorPosition = ref({ lat: 0, lng: 0 })
const navLoading = ref(false)
let mapInstance = null
let markerLayer = null
let polylineLayer = null
let timer = null

// 导航表单
const navForm = reactive({
  start: '27.56407,120.56809', // 默认当前位置附近
  end: '27.57000,120.57500'   // 默认一个附近的点
})

// 腾讯地图 Key
const MAP_KEY = import.meta.env.VITE_TENGXUN_MAP_KEY || '' 

/** 动态加载腾讯地图脚本 (包含 WebService API 库) */
function loadMapScript() {
  return new Promise((resolve, reject) => {
    if (window.TMap) {
      resolve(window.TMap)
      return
    }
    if (!MAP_KEY) {
      console.error('未配置腾讯地图 Key，请在 .env 文件中配置 VITE_TENGXUN_MAP_KEY')
      reject(new Error('Missing Map Key'))
      return
    }
    const script = document.createElement('script')
    script.type = 'text/javascript'
    // 引入 GL JS
    script.src = `https://map.qq.com/api/gljs?v=1.exp&key=${MAP_KEY}&libraries=service`
    script.onload = () => resolve(window.TMap)
    script.onerror = reject
    document.head.appendChild(script)
  })
}

/** 初始化地图 */
function initMap() {
  const TMap = window.TMap
  // 初始化地图中心点（默认苍南县某地）
  const center = new TMap.LatLng(27.56407, 120.56809)
  
  // 创建地图实例
  mapInstance = new TMap.Map(document.getElementById('tencent-map-container'), {
    center: center,
    zoom: 15,
    pitch: 0,
    rotation: 0,
    viewMode: '2D' 
  })

  // 创建 MultiMarker 用于显示小车
  markerLayer = new TMap.MultiMarker({
    map: mapInstance,
    styles: {
      car: new TMap.MarkerStyle({ 
        width: 24, 
        height: 24, 
        anchor: { x: 12, y: 12 },
        src: 'https://mapapi.qq.com/web/lbs/javascriptGL/demo/img/markerDefault.png', 
        color: '#ff0000' 
      }),
      start: new TMap.MarkerStyle({
         width: 25,
         height: 35,
         anchor: { x: 16, y: 32 },
         src: 'https://mapapi.qq.com/web/lbs/javascriptGL/demo/img/start.png'
      }),
      end: new TMap.MarkerStyle({
         width: 25,
         height: 35,
         anchor: { x: 16, y: 32 },
         src: 'https://mapapi.qq.com/web/lbs/javascriptGL/demo/img/end.png'
      })
    },
    geometries: [] 
  })
  
  // 创建 MultiPolyline 用于显示路线
  polylineLayer = new TMap.MultiPolyline({
      id: 'polyline-layer', // 图层唯一标识
      map: mapInstance, // 绘制到目标地图
      // 折线样式定义
      styles: {
        'style_blue': new TMap.PolylineStyle({
          'color': '#3777FF', // 线填充色
          'width': 6, // 折线宽度
          'borderWidth': 2, // 边线宽度
          'borderColor': '#FFF', // 边线颜色
          'lineCap': 'round', // 线端头方式
        })
      },
      geometries: []
  });

  mapLoaded.value = true
}

/** 开始导航 */
function startNavigation() {
    if (!mapLoaded.value || !mapInstance) return
    
    // 解析坐标
    const parseCoord = (str) => {
        const parts = str.split(',')
        if (parts.length !== 2) return null
        const lat = parseFloat(parts[0])
        const lng = parseFloat(parts[1])
        if (isNaN(lat) || isNaN(lng)) return null
        return new TMap.LatLng(lat, lng)
    }
    
    const startLatLng = parseCoord(navForm.start)
    const endLatLng = parseCoord(navForm.end)
    
    if (!startLatLng || !endLatLng) {
        ElMessage.error('坐标格式不正确，请使用 "lat,lng" 格式')
        return
    }
    
    navLoading.value = true
    
    // 调用腾讯地图 WebService API (JS 封装版) 进行驾车路线规划
    // 注意：需要在 loadMapScript 中添加 &libraries=service
    // TMap.service.Driving 是 GL JS 封装的接口
    // 但是 GL JS 本身可能不直接包含 Service 类，需要检查文档。
    // 实际上 GL JS 推荐使用 WebService API，但在前端需要解决跨域问题，或者使用 jsonp
    // 或者使用 TMap.service (如果库已加载)
    
    // 尝试使用 TMap.service.Driving
    // 如果没有，可能需要自己 fetch WebService API，但会跨域。
    // 通常使用 jsonp 或者后端代理。
    // 这里我们假设腾讯地图 JS API 提供了 TMap.service (需在 URL 加 libraries=service，实际上是 libraries=visualization,tools 等，service 属于附加库)
    // 修正：GL JS 没有直接的 TMap.service.Driving。
    // 通常使用：https://apis.map.qq.com/ws/direction/v1/driving/
    // 为了简单演示，我们这里使用前端 JSONP 方式请求 (如果支持) 或者假设后端有代理。
    // 鉴于 RuoYi 框架，我们可以写死一个简单的模拟路线，或者尝试直接 fetch。
    // 实际上腾讯地图 WebService API 是支持 JSONP 的。
    
    // 为了稳妥，我们使用 JSONP 请求腾讯地图 WebService API
    // https://apis.map.qq.com/ws/direction/v1/driving/?from=lat,lng&to=lat,lng&key=KEY&output=jsonp
    
    const url = `https://apis.map.qq.com/ws/direction/v1/driving/?from=${startLatLng.lat},${startLatLng.lng}&to=${endLatLng.lat},${endLatLng.lng}&key=${MAP_KEY}&output=jsonp&callback=handleDirection`
    
    // 定义回调
    window.handleDirection = (res) => {
        navLoading.value = false
        if (res.status !== 0) {
            ElMessage.error('路线规划失败: ' + res.message)
            return
        }
        
        const route = res.result.routes[0]
        const coors = route.polyline
        const pl = []
        
        // 坐标解压：腾讯地图返回的是压缩坐标，需要解压
        // 前两个是起始点 lat, lng
        // 后续是差值
        for (let i = 2; i < coors.length; i++) {
            coors[i] = coors[i-2] + coors[i]/1000000
        }
        
        // 构造路径点数组
        const path = []
        for(let i = 0; i < coors.length; i+=2) {
            path.push(new TMap.LatLng(coors[i], coors[i+1]))
        }
        
        // 绘制路线
        drawRoute(path)
        
        // 更新起终点 Marker
        updateStartEndMarkers(startLatLng, endLatLng)
        
        // 调整视野
        const bounds = new TMap.LatLngBounds()
        path.forEach(p => bounds.extend(p))
        mapInstance.fitBounds(bounds, { padding: 50 })
        
        // 清理全局回调
        delete window.handleDirection
        document.getElementById('jsonp-script')?.remove()
    }
    
    const script = document.createElement('script')
    script.id = 'jsonp-script'
    script.src = url
    document.body.appendChild(script)
}

function drawRoute(path) {
    if (!polylineLayer) return
    polylineLayer.setGeometries([
        {
            id: 'nav-route',
            styleId: 'style_blue',
            paths: path
        }
    ])
}

function updateStartEndMarkers(start, end) {
    // 保持小车 Marker 不变，添加起点终点
    // 这里我们简单地向 markerLayer 添加 geometries
    // 注意：需要先获取现有的（小车），再添加新的
    
    // 实际上，MultiMarker 的 setGeometries 是覆盖式的。
    // 我们需要维护一个列表。
    // 为了简单，我们专门用 markerLayer 管理起终点和小车。
    // 但是小车是实时更新的。
    // 策略：在 updateInspectorPosition 中保留起终点。
    
    // 暂存起终点
    window.navPoints = [
        {
            id: 'start',
            styleId: 'start',
            position: start,
            properties: { title: '起点' }
        },
        {
            id: 'end',
            styleId: 'end',
            position: end,
            properties: { title: '终点' }
        }
    ]
    
    // 触发一次更新
    updateInspectorPosition(inspectorPosition.value.lat, inspectorPosition.value.lng)
}

function clearNavigation() {
    if(polylineLayer) polylineLayer.setGeometries([])
    window.navPoints = []
    navForm.start = ''
    navForm.end = ''
    // 刷新小车（会移除起终点）
    updateInspectorPosition(inspectorPosition.value.lat, inspectorPosition.value.lng)
}

/** 更新小车位置 */
function updateInspectorPosition(lat, lng) {
  if (!mapInstance || !markerLayer) return

  const TMap = window.TMap
  const newPosition = new TMap.LatLng(lat, lng)
  
  // 更新数据
  inspectorPosition.value = { lat, lng }
  
  // 基础 geometries：小车
  const geometries = [
    {
      id: 'inspector',
      styleId: 'car',
      position: newPosition,
      properties: { title: '巡检小车' }
    }
  ]
  
  // 如果有导航起终点，加上
  if (window.navPoints) {
      geometries.push(...window.navPoints)
  }

  // 更新 Marker
  markerLayer.setGeometries(geometries)

  // 如果没有导航，则跟随小车；如果有导航，则不强制跟随，以免影响查看路线
  // 或者：仅当小车移出视野时跟随？
  // 这里简单处理：如果没有导航路径，才自动居中
  if (!window.navPoints || window.navPoints.length === 0) {
      mapInstance.setCenter(newPosition)
  }
}

/** 获取实时位置 */
function fetchPosition() {
  getRealTimePosition().then(res => {
     if (res.data) {
        const lat = res.data.y
        const lng = res.data.x
        
        if (mapLoaded.value) {
          updateInspectorPosition(lat, lng)
        } else {
          inspectorPosition.value = { lat, lng }
        }
     }
  }).catch(err => {
     console.error('获取位置失败', err)
  })
}

onMounted(() => {
  loadMapScript().then(() => {
    initMap()
    // 开始轮询
    fetchPosition()
    timer = setInterval(fetchPosition, 2000)
  }).catch(e => {
    console.error('地图加载失败:', e)
  })
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
  if (mapInstance) {
    mapInstance.destroy()
    mapInstance = null
  }
})
</script>

<style scoped lang="scss">
.control-center {
  padding: 20px;
  height: calc(100vh - 84px);
  display: flex;
  flex-direction: column;
  background-color: #f0f2f5;

  .header-controls {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    background: #fff;
    padding: 15px 20px;
    border-radius: 4px;
    box-shadow: 0 1px 4px rgba(0,21,41,.08);

    h2 {
      margin: 0;
      font-size: 20px;
      color: #303133;
    }
    
    .status-panel {
      display: flex;
      align-items: center;
      gap: 10px;
      
      .location-text {
        font-size: 14px;
        color: #666;
        margin-left: 10px;
      }
    }
  }
  
  .nav-controls {
      background: #fff;
      padding: 15px 20px;
      margin-bottom: 20px;
      border-radius: 4px;
      box-shadow: 0 1px 4px rgba(0,21,41,.08);
      
      .nav-form {
          margin-bottom: 0;
          :deep(.el-form-item) {
              margin-bottom: 0;
              margin-right: 20px;
          }
      }
  }

  .map-container {
    flex: 1;
    position: relative;
    background-color: #e5e5e5;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }
}
</style>
