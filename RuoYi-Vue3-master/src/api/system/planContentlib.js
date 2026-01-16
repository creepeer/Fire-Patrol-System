import request from '@/utils/request'

// 查询计划文档列表
export function listPlanContentlib(query) {
  return request({
    url: '/system/planContentlib/list',
    method: 'get',
    params: query
  })
}

// 查询计划文档详细
export function getPlanContentlib(id) {
  return request({
    url: '/system/planContentlib/' + id,
    method: 'get'
  })
}
