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
import com.ruoyi.system.domain.DInspectionPlan;
import com.ruoyi.system.service.IDInspectionPlanService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 检测计划管理Controller
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@RestController
@RequestMapping("/system/plan")
public class DInspectionPlanController extends BaseController
{
    @Autowired
    private IDInspectionPlanService dInspectionPlanService;

    /**
     * 查询检测计划管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:plan:list')")
    @GetMapping("/list")
    public TableDataInfo list(DInspectionPlan dInspectionPlan)
    {
        startPage();
        List<DInspectionPlan> list = dInspectionPlanService.selectDInspectionPlanList(dInspectionPlan);
        return getDataTable(list);
    }

    /**
     * 导出检测计划管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:plan:export')")
    @Log(title = "检测计划管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DInspectionPlan dInspectionPlan)
    {
        List<DInspectionPlan> list = dInspectionPlanService.selectDInspectionPlanList(dInspectionPlan);
        ExcelUtil<DInspectionPlan> util = new ExcelUtil<DInspectionPlan>(DInspectionPlan.class);
        util.exportExcel(response, list, "检测计划管理数据");
    }

    /**
     * 获取检测计划管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:plan:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dInspectionPlanService.selectDInspectionPlanById(id));
    }

    /**
     * 新增检测计划管理
     */
    @PreAuthorize("@ss.hasPermi('system:plan:add')")
    @Log(title = "检测计划管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DInspectionPlan dInspectionPlan)
    {
        return toAjax(dInspectionPlanService.insertDInspectionPlan(dInspectionPlan));
    }

    /**
     * 修改检测计划管理
     */
    @PreAuthorize("@ss.hasPermi('system:plan:edit')")
    @Log(title = "检测计划管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DInspectionPlan dInspectionPlan)
    {
        return toAjax(dInspectionPlanService.updateDInspectionPlan(dInspectionPlan));
    }

    /**
     * 删除检测计划管理
     */
    @PreAuthorize("@ss.hasPermi('system:plan:remove')")
    @Log(title = "检测计划管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dInspectionPlanService.deleteDInspectionPlanByIds(ids));
    }
}
