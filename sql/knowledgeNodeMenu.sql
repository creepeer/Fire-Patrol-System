-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点', '2059', '1', 'knowledgeNode', 'system/knowledgeNode/index', 1, 0, 'C', '0', '0', 'system:knowledgeNode:list', '#', 'admin', sysdate(), '', null, '知识库节点菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'system:knowledgeNode:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'system:knowledgeNode:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'system:knowledgeNode:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'system:knowledgeNode:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('知识库节点导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'system:knowledgeNode:export',       '#', 'admin', sysdate(), '', null, '');