import request from '@/utils/request'

// 区域相关接口
export function listZone(query) {
  return request({
    url: '/system/zone/list',
    method: 'get',
    params: query
  })
}

export function getZone(id) {
  return request({
    url: '/system/zone/' + id,
    method: 'get'
  })
}

export function addZone(data) {
  return request({
    url: '/system/zone',
    method: 'post',
    data: data
  })
}

export function updateZone(data) {
  return request({
    url: '/system/zone',
    method: 'put',
    data: data
  })
}

export function delZone(id) {
  return request({
    url: '/system/zone/' + id,
    method: 'delete'
  })
}

// 项目相关接口
export function addProject(data) {
  return request({
    url: '/system/zone/project',
    method: 'post',
    data: data
  })
}

export function updateProject(data) {
  return request({
    url: '/system/zone/project',
    method: 'put',
    data: data
  })
}

export function delProject(ids) {
  return request({
    url: '/system/zone/project/' + ids,
    method: 'delete'
  })
}

export function listProjectByZoneId(zoneId) {
  return request({
    url: '/system/zone/project/list/' + zoneId,
    method: 'get'
  })
}

// 楼栋相关接口
export function addBuilding(data) {
  return request({
    url: '/system/zone/building',
    method: 'post',
    data: data
  })
}

export function updateBuilding(data) {
  return request({
    url: '/system/zone/building',
    method: 'put',
    data: data
  })
}

export function delBuilding(ids) {
  return request({
    url: '/system/zone/building/' + ids,
    method: 'delete'
  })
}

export function listBuildingByProjectId(projectId) {
  return request({
    url: '/system/zone/building/list/' + projectId,
    method: 'get'
  })
}

// 房间相关接口
export function addRoom(data) {
  return request({
    url: '/system/zone/room',
    method: 'post',
    data: data
  })
}

export function updateRoom(data) {
  return request({
    url: '/system/zone/room',
    method: 'put',
    data: data
  })
}

export function delRoom(ids) {
  return request({
    url: '/system/zone/room/' + ids,
    method: 'delete'
  })
}

export function listRoomByBuildingId(buildingId) {
  return request({
    url: '/system/zone/room/list/' + buildingId,
    method: 'get'
  })
}

// 通用层级查询接口
export function getDataByLevel(levelType, parentId) {
  return request({
    url: `/system/zone/level/${levelType}/${parentId}`,
    method: 'get'
  })
}
