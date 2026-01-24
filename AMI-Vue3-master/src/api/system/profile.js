import request from '@/utils/request'

// 查询文件存储列表
export function listProfile(query) {
  return request({
    url: '/system/profile/list',
    method: 'get',
    params: query
  })
}

// 查询文件存储详细
export function getProfile(id) {
  return request({
    url: '/system/profile/' + id,
    method: 'get'
  })
}

// 新增文件存储
export function addProfile(data) {
  return request({
    url: '/system/profile',
    method: 'post',
    data: data
  })
}

// 修改文件存储
export function updateProfile(data) {
  return request({
    url: '/system/profile',
    method: 'put',
    data: data
  })
}

// 删除文件存储
export function delProfile(id) {
  return request({
    url: '/system/profile/' + id,
    method: 'delete'
  })
}
