    package com.ruoyi.system.mapper;

    import java.util.List;

    import com.ruoyi.common.annotation.AutoFill;
    import com.ruoyi.common.enums.OperationType;
    import com.ruoyi.system.domain.DInspectionItem;

    /**
     * 检测项管理Mapper接口
     *
     * @author leland
     * @date 2026-01-10
     */
    public interface DInspectionItemMapper
    {
        /**
         * 查询检测项管理
         *
         * @param id 检测项管理主键
         * @return 检测项管理
         */
        public DInspectionItem selectDInspectionItemById(Long id);

        /**
         * 查询检测项管理列表
         *
         * @param dInspectionItem 检测项管理
         * @return 检测项管理集合
         */
        public List<DInspectionItem> selectDInspectionItemList(DInspectionItem dInspectionItem);

        /**
         * 新增检测项管理
         *
         * @param dInspectionItem 检测项管理
         * @return 结果
         */
        @AutoFill(value = OperationType.INSERT)
        public int insertDInspectionItem(DInspectionItem dInspectionItem);

        /**
         * 修改检测项管理
         *
         * @param dInspectionItem 检测项管理
         * @return 结果
         */
        @AutoFill(value = OperationType.UPDATE)
        public int updateDInspectionItem(DInspectionItem dInspectionItem);

        /**
         * 删除检测项管理
         *
         * @param id 检测项管理主键
         * @return 结果
         */
        public int deleteDInspectionItemById(Long id);

        /**
         * 批量删除检测项管理
         *
         * @param ids 需要删除的数据主键集合
         * @return 结果
         */
        public int deleteDInspectionItemByIds(Long[] ids);
    }
