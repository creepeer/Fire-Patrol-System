import request from '@/utils/request'

// 查询检测计划管理列表
export function listPlan(query) {
  return request({
    url: '/system/plan/list',
    method: 'get',
    params: query
  })
}

// 查询检测计划管理详细
export function getPlan(id) {
  return request({
    url: '/system/plan/' + id,
    method: 'get'
  })
}

// 新增检测计划管理
export function addPlan(data) {
  return request({
    url: '/system/plan',
    method: 'post',
    data: data
  })
}

// 修改检测计划管理
export function updatePlan(data) {
  return request({
    url: '/system/plan',
    method: 'put',
    data: data
  })
}

// 删除检测计划管理
export function delPlan(id) {
  return request({
    url: '/system/plan/' + id,
    method: 'delete'
  })
}
