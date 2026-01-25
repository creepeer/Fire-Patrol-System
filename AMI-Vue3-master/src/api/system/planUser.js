import request from '@/utils/request'

// 查询计划用户列表
export function listPlanUser(query) {
  return request({
    url: '/system/planUser/list',
    method: 'get',
    params: query
  })
}

// 查询计划用户详细
export function getPlanUser(id) {
  return request({
    url: '/system/planUser/' + id,
    method: 'get'
  })
}

// 修改计划用户关联
export function updatePlanUser(data) {
  return request({
    url: '/system/planUser',
    method: 'put',
    data: data
  })
}

// 根据区域ID获取计划设备信息
export function listPlanUserByZoneId(zoneId) {
  return request({
    url: '/system/planUser/planByZoneId/' + zoneId,
    method: 'get'
  })
}
