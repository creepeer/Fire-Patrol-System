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
import com.ruoyi.system.domain.GCategory;
import com.ruoyi.system.service.IGCategoryService;
import com.ruoyi.common.utils.poi.ExcelUtil;

/**
 * 类别Controller
 * 
 * @author ruoyi
 * @date 2025-10-13
 */
@RestController
@RequestMapping("/system/category")
public class GCategoryController extends BaseController
{
    @Autowired
    private IGCategoryService gCategoryService;

    /**
     * 查询类别列表
     */
    @PreAuthorize("@ss.hasPermi('system:category:list')")
    @GetMapping("/list")
    public AjaxResult list(GCategory gCategory)
    {
        List<GCategory> list = gCategoryService.selectGCategoryList(gCategory);
        return success(list);
    }

    /**
     * 导出类别列表
     */
    @PreAuthorize("@ss.hasPermi('system:category:export')")
    @Log(title = "类别", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GCategory gCategory)
    {
        List<GCategory> list = gCategoryService.selectGCategoryList(gCategory);
        ExcelUtil<GCategory> util = new ExcelUtil<GCategory>(GCategory.class);
        util.exportExcel(response, list, "类别数据");
    }

    /**
     * 获取类别详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:category:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(gCategoryService.selectGCategoryById(id));
    }

    /**
     * 新增类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:add')")
    @Log(title = "类别", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GCategory gCategory)
    {
        return toAjax(gCategoryService.insertGCategory(gCategory));
    }

    /**
     * 修改类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:edit')")
    @Log(title = "类别", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GCategory gCategory)
    {
        return toAjax(gCategoryService.updateGCategory(gCategory));
    }

    /**
     * 删除类别
     */
    @PreAuthorize("@ss.hasPermi('system:category:remove')")
    @Log(title = "类别", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(gCategoryService.deleteGCategoryByIds(ids));
    }
}
