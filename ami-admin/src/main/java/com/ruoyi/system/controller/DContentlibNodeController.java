package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;
import lombok.extern.slf4j.XSlf4j;
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
import com.ruoyi.system.domain.DContentlibNode;
import com.ruoyi.system.service.IDContentlibNodeService;
import com.ruoyi.common.utils.poi.ExcelUtil;

/**
 * 知识库节点Controller
 * 
 * @author ruoyi
 * @date 2025-12-29
 */
@Slf4j
@RestController
@RequestMapping("/system/knowledgeNode")
public class DContentlibNodeController extends BaseController
{
    @Autowired
    private IDContentlibNodeService dContentlibNodeService;

    /**
     * 查询知识库节点列表
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:list')")
    @GetMapping("/list")
    public AjaxResult list(DContentlibNode dContentlibNode)
    {
        List<DContentlibNode> list = dContentlibNodeService.selectDContentlibNodeList(dContentlibNode);
        return success(list);
    }

    /**
     * 导出知识库节点列表
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:export')")
    @Log(title = "知识库节点", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DContentlibNode dContentlibNode)
    {
        List<DContentlibNode> list = dContentlibNodeService.selectDContentlibNodeList(dContentlibNode);
        ExcelUtil<DContentlibNode> util = new ExcelUtil<DContentlibNode>(DContentlibNode.class);
        util.exportExcel(response, list, "知识库节点数据");
    }

    /**
     * 获取知识库节点详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(dContentlibNodeService.selectDContentlibNodeById(id));
    }

    /**
     * 新增知识库节点
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:add')")
    @Log(title = "知识库节点", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DContentlibNode dContentlibNode)
    {
        log.info("开始添加知识库节点{}",dContentlibNode);
        return toAjax(dContentlibNodeService.insertDContentlibNode(dContentlibNode));
    }

    /**
     * 修改知识库节点
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:edit')")
    @Log(title = "知识库节点", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DContentlibNode dContentlibNode)
    {
        return toAjax(dContentlibNodeService.updateDContentlibNode(dContentlibNode));
    }

    /**
     * 删除知识库节点
     */
    @PreAuthorize("@ss.hasPermi('system:knowledgeNode:remove')")
    @Log(title = "知识库节点", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(dContentlibNodeService.deleteDContentlibNodeByIds(ids));
    }
}
