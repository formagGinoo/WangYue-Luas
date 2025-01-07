-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDebugClient = Config.DataDebugClient or {}


local DataDebugClient = Config.DataDebugClient
DataDebugClient.FindLength = 20
DataDebugClient.Find = {
	[101] = {id = 101, id_desc = "重载", group_id = 1, group_desc = "基础功能", gm_func = "ReloadLua", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[102] = {id = 102, id_desc = "地图列表", group_id = 1, group_desc = "", gm_func = "OpenMapList", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[103] = {id = 103, id_desc = "游戏速度X2", group_id = 1, group_desc = "", gm_func = "DoubleGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[104] = {id = 104, id_desc = "游戏速度X0.5", group_id = 1, group_desc = "", gm_func = "HalfGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[105] = {id = 105, id_desc = "游戏速度X1", group_id = 1, group_desc = "", gm_func = "OneGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[106] = {id = 106, id_desc = "攻击碰撞", group_id = 1, group_desc = "", gm_func = "ToggleAttackCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[107] = {id = 107, id_desc = "挤兑碰撞", group_id = 1, group_desc = "", gm_func = "ToggleCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[108] = {id = 108, id_desc = "角色死亡", group_id = 1, group_desc = "", gm_func = "SetRoleDeath", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[109] = {id = 109, id_desc = "GM", group_id = 1, group_desc = "", gm_func = "OpenGM", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[110] = {id = 110, id_desc = "日志", group_id = 1, group_desc = "", gm_func = "OpenLog", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[111] = {id = 111, id_desc = "实体属性", group_id = 1, group_desc = "", gm_func = "OpenEntityAttr", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[112] = {id = 112, id_desc = "执行lua代码", group_id = 1, group_desc = "", gm_func = "OpenLuaCmd", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[113] = {id = 113, id_desc = "剧情控制", group_id = 1, group_desc = "", gm_func = "OpenStoryCtrl", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[114] = {id = 114, id_desc = "角色技能", group_id = 1, group_desc = "", gm_func = "OpenRoleSkill", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[115] = {id = 115, id_desc = "替换怪物", group_id = 1, group_desc = "", gm_func = "ChangeMonster", param_num = 1, param1 = "", param2 = "", param3 = ""},
	[116] = {id = 116, id_desc = "显示激活实体", group_id = 1, group_desc = "", gm_func = "OpenActiveEntity", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[117] = {id = 117, id_desc = "游戏速度", group_id = 1, group_desc = "", gm_func = "SetGameSpeed", param_num = 1, param1 = "1", param2 = "", param3 = ""},
	[118] = {id = 118, id_desc = "隐藏飘字", group_id = 1, group_desc = "", gm_func = "HideFontAnim", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[119] = {id = 119, id_desc = "设置", group_id = 1, group_desc = "", gm_func = "OpenSetting", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[120] = {id = 120, id_desc = "条件查询", group_id = 1, group_desc = "", gm_func = "CheckCondition", param_num = 0, param1 = "", param2 = "", param3 = ""},
}
	

return DataDebugClient
