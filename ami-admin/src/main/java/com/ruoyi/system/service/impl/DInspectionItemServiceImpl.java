package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.DInspectionItemMapper;
import com.ruoyi.system.domain.DInspectionItem;
import com.ruoyi.system.service.IDInspectionItemService;

/**
 * 检测项管理Service业务层处理
 * 
 * @author leland
 * @date 2026-01-10
 */
@Service
public class DInspectionItemServiceImpl implements IDInspectionItemService 
{
    @Autowired
    private DInspectionItemMapper dInspectionItemMapper;

    /**
     * 查询检测项管理
     * 
     * @param id 检测项管理主键
     * @return 检测项管理
     */
    @Override
    public DInspectionItem selectDInspectionItemById(Long id)
    {
        return dInspectionItemMapper.selectDInspectionItemById(id);
    }

    /**
     * 查询检测项管理列表
     * 
     * @param dInspectionItem 检测项管理
     * @return 检测项管理
     */
    @Override
    public List<DInspectionItem> selectDInspectionItemList(DInspectionItem dInspectionItem)
    {
        return dInspectionItemMapper.selectDInspectionItemList(dInspectionItem);
    }

    /**
     * 新增检测项管理
     * 
     * @param dInspectionItem 检测项管理
     * @return 结果
     */
    @Override
    public int insertDInspectionItem(DInspectionItem dInspectionItem)
    {
        return dInspectionItemMapper.insertDInspectionItem(dInspectionItem);
    }

    /**
     * 修改检测项管理
     * 
     * @param dInspectionItem 检测项管理
     * @return 结果
     */
    @Override
    public int updateDInspectionItem(DInspectionItem dInspectionItem)
    {
        return dInspectionItemMapper.updateDInspectionItem(dInspectionItem);
    }

    /**
     * 批量删除检测项管理
     * 
     * @param ids 需要删除的检测项管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionItemByIds(Long[] ids)
    {
        return dInspectionItemMapper.deleteDInspectionItemByIds(ids);
    }

    /**
     * 删除检测项管理信息
     * 
     * @param id 检测项管理主键
     * @return 结果
     */
    @Override
    public int deleteDInspectionItemById(Long id)
    {
        return dInspectionItemMapper.deleteDInspectionItemById(id);
    }
}
