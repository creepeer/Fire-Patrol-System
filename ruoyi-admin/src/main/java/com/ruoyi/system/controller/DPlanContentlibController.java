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
import com.ruoyi.system.domain.DPlanContentlib;
import com.ruoyi.system.service.IDPlanContentlibService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 计划知识关联Controller
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@RestController
@RequestMapping("/system/planContentlib")
public class DPlanContentlibController extends BaseController
{
    @Autowired
    private IDPlanContentlibService dPlanContentlibService;

    /**
     * 查询计划知识关联列表
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:list')")
    @GetMapping("/list")
    public TableDataInfo list(DPlanContentlib dPlanContentlib)
    {
        startPage();
        List<DPlanContentlib> list = dPlanContentlibService.selectDPlanContentlibList(dPlanContentlib);
        return getDataTable(list);
    }

    /**
     * 导出计划知识关联列表
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:export')")
    @Log(title = "计划知识关联", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DPlanContentlib dPlanContentlib)
    {
        List<DPlanContentlib> list = dPlanContentlibService.selectDPlanContentlibList(dPlanContentlib);
        ExcelUtil<DPlanContentlib> util = new ExcelUtil<DPlanContentlib>(DPlanContentlib.class);
        util.exportExcel(response, list, "计划知识关联数据");
    }

    /**
     * 获取计划知识关联详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dPlanContentlibService.selectDPlanContentlibById(id));
    }

    /**
     * 新增计划知识关联
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:add')")
    @Log(title = "计划知识关联", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DPlanContentlib dPlanContentlib)
    {
        return toAjax(dPlanContentlibService.insertDPlanContentlib(dPlanContentlib));
    }

    /**
     * 修改计划知识关联
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:edit')")
    @Log(title = "计划知识关联", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DPlanContentlib dPlanContentlib)
    {
        return toAjax(dPlanContentlibService.updateDPlanContentlib(dPlanContentlib));
    }

    /**
     * 删除计划知识关联
     */
    @PreAuthorize("@ss.hasPermi('system:planContentlib:remove')")
    @Log(title = "计划知识关联", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dPlanContentlibService.deleteDPlanContentlibByIds(ids));
    }
}
