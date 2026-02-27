import request from '@/utils/request'

// 获取实时位置
export function getRealTimePosition() {
  return request({
    url: '/system/monitor/position',
    method: 'get'
  })
}
