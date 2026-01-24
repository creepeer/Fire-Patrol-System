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
import com.ruoyi.system.domain.DContentlib;
import com.ruoyi.system.service.IDContentlibService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 知识库Controller
 * 
 * @author ruoyi
 * @date 2025-12-30
 */
@RestController
@RequestMapping("/system/contentlib")
public class DContentlibController extends BaseController
{
    @Autowired
    private IDContentlibService dContentlibService;

    /**
     * 查询知识库列表
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:list')")
    @GetMapping("/list")
    public TableDataInfo list(DContentlib dContentlib)
    {
        startPage();
        List<DContentlib> list = dContentlibService.selectDContentlibList(dContentlib);
        return getDataTable(list);
    }

    /**
     * 导出知识库列表
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:export')")
    @Log(title = "知识库", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DContentlib dContentlib)
    {
        List<DContentlib> list = dContentlibService.selectDContentlibList(dContentlib);
        ExcelUtil<DContentlib> util = new ExcelUtil<DContentlib>(DContentlib.class);
        util.exportExcel(response, list, "知识库数据");
    }

    /**
     * 获取知识库详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dContentlibService.selectDContentlibById(id));
    }

    /**
     * 新增知识库
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:add')")
    @Log(title = "知识库", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DContentlib dContentlib)
    {
        return toAjax(dContentlibService.insertDContentlib(dContentlib));
    }

    /**
     * 修改知识库
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:edit')")
    @Log(title = "知识库", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DContentlib dContentlib)
    {
        return toAjax(dContentlibService.updateDContentlib(dContentlib));
    }

    /**
     * 删除知识库
     */
    @PreAuthorize("@ss.hasPermi('system:contentlib:remove')")
    @Log(title = "知识库", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dContentlibService.deleteDContentlibByIds(ids));
    }
}
