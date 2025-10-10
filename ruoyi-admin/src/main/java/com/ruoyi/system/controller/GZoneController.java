package com.ruoyi.system.controller;

import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletResponse;


import com.ruoyi.system.DTO.Building.AddBuildingDTO;
import com.ruoyi.system.DTO.Project.AddProjectDTO;
import com.ruoyi.system.domain.GBuilding;
import com.ruoyi.system.domain.GProject;
import com.ruoyi.system.service.IGBuildingService;
import com.ruoyi.system.service.IGProjectService;

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
import com.ruoyi.system.domain.GZone;
import com.ruoyi.system.service.IGZoneService;
import com.ruoyi.common.utils.poi.ExcelUtil;

/**
 * 区域管理Controller
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@RestController
@RequestMapping("/system/zone")
public class GZoneController extends BaseController
{
    @Autowired
    private IGZoneService gZoneService;
    @Autowired
    private IGProjectService gProjectService;
    @Autowired
    private IGBuildingService gBuildingService;
    /**
     * 查询区域管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:zone:list')")
    @GetMapping("/list")
    public AjaxResult list(GZone gZone)
    {
        List<GZone> list = gZoneService.selectGZoneList(gZone);
        return success(list);
    }

    /**
     * 导出区域管理列表
     */
    @PreAuthorize("@ss.hasPermi('system:zone:export')")
    @Log(title = "区域管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GZone gZone)
    {
        List<GZone> list = gZoneService.selectGZoneList(gZone);
        ExcelUtil<GZone> util = new ExcelUtil<GZone>(GZone.class);
        util.exportExcel(response, list, "区域管理数据");
    }

    /**
     * 获取区域管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:zone:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(gZoneService.selectGZoneById(id));
    }

    /**
     * 新增区域管理
     */
    @PreAuthorize("@ss.hasPermi('system:zone:add')")
    @Log(title = "区域管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GZone gZone)
    {
        return toAjax(gZoneService.insertGZone(gZone));
    }

    /**
     * 修改区域管理
     */
    @PreAuthorize("@ss.hasPermi('system:zone:edit')")
    @Log(title = "区域管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GZone gZone)
    {
        return toAjax(gZoneService.updateGZone(gZone));
    }

    /**
     * 删除区域管理
     */
    @PreAuthorize("@ss.hasPermi('system:zone:remove')")
    @Log(title = "区域管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(gZoneService.deleteGZoneByIds(ids));
    }

    /**
     * 新增项目
     */
    @PreAuthorize("@ss.hasPermi('system:project:add')")
    @Log(title = "项目", businessType = BusinessType.INSERT)
    @PostMapping("/project")
    public AjaxResult add(@RequestBody AddProjectDTO Data)
    {

        gZoneService.insertGZoneProject(Data);
        Long id=gZoneService.selectIdByZnameAndPid(Data.getProjectName(),Data.getPid());
        return toAjax(gProjectService.insertGProject(Data,id));
    }

    /**
     * 根据区域ID查询项目列表
     */
    @PreAuthorize("@ss.hasPermi('system:project:list')")
    @GetMapping("/project/list/{zoneId}")
    public AjaxResult listProjectByZoneId(@PathVariable("zoneId") Long zoneId)
    {
        GProject list = gProjectService.selectGProjectByPid(zoneId);
        return success(list);
    }
    /**
     * 查询建筑列表
     */
    @PreAuthorize("@ss.hasPermi('system:building:list')")
    @GetMapping("/building/list/{Pid}")
    public AjaxResult listBuildingByZoneId( @PathVariable("Pid") Long pid)
    {

      GBuilding list = gBuildingService.selectGBuildingByPid(pid);
        return success(list);
    }

    /**
     * 新增建筑
     */
    @PreAuthorize("@ss.hasPermi('system:building:add')")
    @Log(title = "建筑", businessType = BusinessType.INSERT)
    @PostMapping("/building")
    public AjaxResult add(@RequestBody AddBuildingDTO Data)
    {
        System.out.println(Data);
        Long id= gZoneService.insertGZoneBuilding(Data);
        System.out.println(id);
        return toAjax(gBuildingService.insertGBuilding(Data,id));
    }


}
