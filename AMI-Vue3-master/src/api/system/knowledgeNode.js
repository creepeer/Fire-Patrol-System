import request from '@/utils/request'

// 查询知识库节点列表
export function listKnowledgeNode(query) {
  return request({
    url: '/system/knowledgeNode/list',
    method: 'get',
    params: query
  })
}

// 查询知识库节点详细
export function getKnowledgeNode(id) {
  return request({
    url: '/system/knowledgeNode/' + id,
    method: 'get'
  })
}

// 新增知识库节点
export function addKnowledgeNode(data) {
  return request({
    url: '/system/knowledgeNode',
    method: 'post',
    data: data
  })
}

// 修改知识库节点
export function updateKnowledgeNode(data) {
  return request({
    url: '/system/knowledgeNode',
    method: 'put',
    data: data
  })
}

// 删除知识库节点
export function delKnowledgeNode(id) {
  return request({
    url: '/system/knowledgeNode/' + id,
    method: 'delete'
  })
}
