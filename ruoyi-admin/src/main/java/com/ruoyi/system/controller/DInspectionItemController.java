package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.DInspectionItem;
import com.ruoyi.system.service.IDInspectionItemService;
import com.ruoyi.common.utils.poi.ExcelUtil;

/**
 * 检测项管理Controller
 * 
 * @author leland
 * @date 2026-01-10
 */
@RestController
@RequestMapping("/system/inspectionItem")
public class DInspectionItemController extends BaseController
{
    @Autowired
    private IDInspectionItemService dInspectionItemService;

    /**
     * 查询检测项管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:list')")
    @GetMapping("/list")
    public AjaxResult list(DInspectionItem dInspectionItem)
    {
        List<DInspectionItem> list = dInspectionItemService.selectDInspectionItemList(dInspectionItem);
        return success(list);
    }

    /**
     * 导出检测项管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:export')")
    @Log(title = "检测项管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DInspectionItem dInspectionItem)
    {
        List<DInspectionItem> list = dInspectionItemService.selectDInspectionItemList(dInspectionItem);
        ExcelUtil<DInspectionItem> util = new ExcelUtil<DInspectionItem>(DInspectionItem.class);
        util.exportExcel(response, list, "检测项管理数据");
    }

    /**
     * 获取检测项管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dInspectionItemService.selectDInspectionItemById(id));
    }

    /**
     * 新增检测项管理
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:add')")
    @Log(title = "检测项管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DInspectionItem dInspectionItem)
    {
        return toAjax(dInspectionItemService.insertDInspectionItem(dInspectionItem));
    }

    /**
     * 修改检测项管理
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:edit')")
    @Log(title = "检测项管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DInspectionItem dInspectionItem)
    {
        return toAjax(dInspectionItemService.updateDInspectionItem(dInspectionItem));
    }

    /**
     * 删除检测项管理
     */
    @PreAuthorize("@ss.hasPermi('system:inspectionItem:remove')")
    @Log(title = "检测项管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dInspectionItemService.deleteDInspectionItemByIds(ids));
    }
}
