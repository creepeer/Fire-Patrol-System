import request from '@/utils/request'

// 查询类别列表
export function listCategory(query) {
  return request({
    url: '/system/category/list',
    method: 'get',
    params: query
  })
}

// 查询类别详细
export function getCategory(id) {
  return request({
    url: '/system/category/' + id,
    method: 'get'
  })
}

// 新增类别
export function addCategory(data) {
  return request({
    url: '/system/category',
    method: 'post',
    data: data
  })
}

// 修改类别
export function updateCategory(data) {
  return request({
    url: '/system/category',
    method: 'put',
    data: data
  })
}

// 删除类别
export function delCategory(id) {
  return request({
    url: '/system/category/' + id,
    method: 'delete'
  })
}
