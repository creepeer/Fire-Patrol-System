import request from '@/utils/request'

// 查询设施设备列表
export function listDevice(query) {
  return request({
    url: '/system/device/list',
    method: 'get',
    params: query
  })
}

// 查询设施设备详细
export function getDevice(id) {
  return request({
    url: '/system/device/' + id,
    method: 'get'
  })
}

// 新增设施设备
export function addDevice(data) {
  return request({
    url: '/system/device',
    method: 'post',
    data: data
  })
}

// 修改设施设备
export function updateDevice(data) {
  return request({
    url: '/system/device',
    method: 'put',
    data: data
  })
}

// 删除设施设备
export function delDevice(id) {
  return request({
    url: '/system/device/' + id,
    method: 'delete'
  })
}
export function listDeviceByZoneId(zoneId) {
  return request({
    url: '/system/device/listByZoneId/' + zoneId,
    method: 'get'
  })
}

// 根据区域ID获取设备及检测计划信息
export function listDevicePlanByZoneId(zoneId) {
  return request({
    url: '/system/device/planByZoneId/' + zoneId,
    method: 'get'
  })
}

