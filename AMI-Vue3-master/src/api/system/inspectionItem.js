import request from '@/utils/request'

// 查询检测项管理列表
export function listInspectionItem(query) {
  return request({
    url: '/system/inspectionItem/list',
    method: 'get',
    params: query
  })
}

// 查询检测项管理详细
export function getInspectionItem(id) {
  return request({
    url: '/system/inspectionItem/' + id,
    method: 'get'
  })
}

// 新增检测项管理
export function addInspectionItem(data) {
  return request({
    url: '/system/inspectionItem',
    method: 'post',
    data: data
  })
}

// 修改检测项管理
export function updateInspectionItem(data) {
  return request({
    url: '/system/inspectionItem',
    method: 'put',
    data: data
  })
}

// 删除检测项管理
export function delInspectionItem(id) {
  return request({
    url: '/system/inspectionItem/' + id,
    method: 'delete'
  })
}
