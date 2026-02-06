import request from '@/utils/request'

// 查询设备扫描记录列表
export function listScan(query) {
  return request({
    url: '/system/scan/list',
    method: 'get',
    params: query
  })
}

// 查询设备扫描记录详细
export function getScan(id) {
  return request({
    url: '/system/scan/' + id,
    method: 'get'
  })
}

// 新增设备扫描记录
export function addScan(data) {
  return request({
    url: '/system/scan',
    method: 'post',
    data: data
  })
}

// 修改设备扫描记录
export function updateScan(data) {
  return request({
    url: '/system/scan',
    method: 'put',
    data: data
  })
}

// 删除设备扫描记录
export function delScan(id) {
  return request({
    url: '/system/scan/' + id,
    method: 'delete'
  })
}
