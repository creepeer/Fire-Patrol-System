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
