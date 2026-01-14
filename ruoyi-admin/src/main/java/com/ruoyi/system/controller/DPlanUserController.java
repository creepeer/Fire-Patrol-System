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
import com.ruoyi.system.domain.DPlanUser;
import com.ruoyi.system.service.IDPlanUserService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 计划用户关联Controller
 * 
 * @author lelandcat
 * @date 2026-01-14
 */
@RestController
@RequestMapping("/system/planUser")
public class DPlanUserController extends BaseController
{
    @Autowired
    private IDPlanUserService dPlanUserService;

    /**
     * 查询计划用户关联列表
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:list')")
    @GetMapping("/list")
    public TableDataInfo list(DPlanUser dPlanUser)
    {
        startPage();
        List<DPlanUser> list = dPlanUserService.selectDPlanUserList(dPlanUser);
        return getDataTable(list);
    }

    /**
     * 导出计划用户关联列表
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:export')")
    @Log(title = "计划用户关联", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DPlanUser dPlanUser)
    {
        List<DPlanUser> list = dPlanUserService.selectDPlanUserList(dPlanUser);
        ExcelUtil<DPlanUser> util = new ExcelUtil<DPlanUser>(DPlanUser.class);
        util.exportExcel(response, list, "计划用户关联数据");
    }

    /**
     * 获取计划用户关联详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dPlanUserService.selectDPlanUserById(id));
    }

    /**
     * 新增计划用户关联
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:add')")
    @Log(title = "计划用户关联", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DPlanUser dPlanUser)
    {
        return toAjax(dPlanUserService.insertDPlanUser(dPlanUser));
    }

    /**
     * 修改计划用户关联
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:edit')")
    @Log(title = "计划用户关联", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DPlanUser dPlanUser)
    {
        return toAjax(dPlanUserService.updateDPlanUser(dPlanUser));
    }

    /**
     * 删除计划用户关联
     */
    @PreAuthorize("@ss.hasPermi('system:planUser:remove')")
    @Log(title = "计划用户关联", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dPlanUserService.deleteDPlanUserByIds(ids));
    }
}
