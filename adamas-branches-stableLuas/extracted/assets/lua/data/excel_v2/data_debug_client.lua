-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDebugClient = Config.DataDebugClient or {}


local DataDebugClient = Config.DataDebugClient
DataDebugClient.FindLength = 55
DataDebugClient.Find = {
	[101] = {id = 101, id_desc = "重载", group_id = 1, group_desc = "基础功能", gm_func = "ReloadLua", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[102] = {id = 102, id_desc = "地图列表", group_id = 4, group_desc = "关卡", gm_func = "OpenMapList", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[103] = {id = 103, id_desc = "游戏速度X2", group_id = 1, group_desc = "基础功能", gm_func = "DoubleGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[104] = {id = 104, id_desc = "游戏速度X0.5", group_id = 1, group_desc = "基础功能", gm_func = "HalfGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[105] = {id = 105, id_desc = "游戏速度X1", group_id = 1, group_desc = "基础功能", gm_func = "OneGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[106] = {id = 106, id_desc = "攻击碰撞", group_id = 2, group_desc = "战斗", gm_func = "ToggleAttackCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[107] = {id = 107, id_desc = "挤兑碰撞", group_id = 2, group_desc = "战斗", gm_func = "ToggleCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[108] = {id = 108, id_desc = "角色死亡", group_id = 1, group_desc = "基础功能", gm_func = "SetRoleDeath", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[109] = {id = 109, id_desc = "GM", group_id = 1, group_desc = "基础功能", gm_func = "OpenGM", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[110] = {id = 110, id_desc = "日志", group_id = 1, group_desc = "基础功能", gm_func = "OpenLog", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[111] = {id = 111, id_desc = "实体属性", group_id = 2, group_desc = "战斗", gm_func = "OpenEntityAttr", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[112] = {id = 112, id_desc = "执行lua代码", group_id = 1, group_desc = "基础功能", gm_func = "OpenLuaCmd", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[113] = {id = 113, id_desc = "剧情控制", group_id = 3, group_desc = "剧情", gm_func = "OpenStoryCtrl", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[114] = {id = 114, id_desc = "角色技能", group_id = 2, group_desc = "战斗", gm_func = "OpenRoleSkill", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[115] = {id = 115, id_desc = "替换怪物", group_id = 4, group_desc = "关卡", gm_func = "ChangeMonster", param_num = 1, param1 = "", param2 = "", param3 = ""},
	[116] = {id = 116, id_desc = "显示激活实体", group_id = 2, group_desc = "战斗", gm_func = "OpenActiveEntity", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[117] = {id = 117, id_desc = "游戏速度", group_id = 1, group_desc = "基础功能", gm_func = "SetGameSpeed", param_num = 1, param1 = "1", param2 = "", param3 = ""},
	[118] = {id = 118, id_desc = "隐藏飘字", group_id = 5, group_desc = "系统", gm_func = "HideFontAnim", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[119] = {id = 119, id_desc = "设置", group_id = 1, group_desc = "基础功能", gm_func = "OpenSetting", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[120] = {id = 120, id_desc = "条件查询", group_id = 1, group_desc = "基础功能", gm_func = "CheckCondition", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[121] = {id = 121, id_desc = "伤害暂停", group_id = 2, group_desc = "战斗", gm_func = "DamagePause", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[122] = {id = 122, id_desc = "设置窗口大小", group_id = 5, group_desc = "系统", gm_func = "SetScreenSize", param_num = 3, param1 = "", param2 = "", param3 = ""},
	[123] = {id = 123, id_desc = "交通路径点调试", group_id = 4, group_desc = "关卡", gm_func = "TrafficTest", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[124] = {id = 124, id_desc = "关闭所有UI", group_id = 5, group_desc = "系统", gm_func = "CloseAllUI", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[125] = {id = 125, id_desc = "显示本次包体信息", group_id = 1, group_desc = "基础功能", gm_func = "ShowPackageInfo", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[126] = {id = 126, id_desc = "子弹投影", group_id = 2, group_desc = "战斗", gm_func = "BulletProject", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[127] = {id = 127, id_desc = "修改移速", group_id = 1, group_desc = "基础功能", gm_func = "ChangeRoleSpeed", param_num = 1, param1 = "", param2 = "", param3 = ""},
	[128] = {id = 128, id_desc = "角色满血", group_id = 1, group_desc = "基础功能", gm_func = "RegenerateMaxHealth", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[129] = {id = 129, id_desc = "伤害倍率", group_id = 1, group_desc = "基础功能", gm_func = "SetDamageMultiplier", param_num = 1, param1 = "", param2 = "", param3 = ""},
	[130] = {id = 130, id_desc = "修改年龄", group_id = 5, group_desc = "系统", gm_func = "SetAge", param_num = 1, param1 = "", param2 = "", param3 = ""},
	[131] = {id = 131, id_desc = "显示服务器信息", group_id = 5, group_desc = "系统", gm_func = "ShowServerInfo", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[132] = {id = 132, id_desc = "阻塞弹窗", group_id = 5, group_desc = "系统", gm_func = "BlockPopWindow", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[133] = {id = 133, id_desc = "Profiler", group_id = 6, group_desc = "性能", gm_func = "OpenProfiler", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[144] = {id = 144, id_desc = "开启/关闭伤害日志", group_id = 7, group_desc = "数值", gm_func = "ShowDamageLog", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[145] = {id = 145, id_desc = "暂停/恢复怪物逻辑", group_id = 2, group_desc = "战斗", gm_func = "StopMonsterLogic", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[146] = {id = 146, id_desc = "获得所有物品", group_id = 1, group_desc = "基础功能", gm_func = "GetAllItem", param_num = 1, param1 = "物品数量", param2 = "", param3 = ""},
	[147] = {id = 147, id_desc = "打印实体属性", group_id = 7, group_desc = "数值", gm_func = "TDLogEntityAttr", param_num = 2, param1 = "实体id", param2 = "属性id", param3 = ""},
	[148] = {id = 148, id_desc = "设置实体属性", group_id = 7, group_desc = "数值", gm_func = "TDSetEntityAttr", param_num = 3, param1 = "实体id", param2 = "属性id", param3 = "属性value"},
	[149] = {id = 149, id_desc = "使用Magic", group_id = 2, group_desc = "战斗", gm_func = "TDDoMagic", param_num = 3, param1 = "主目标id", param2 = "从目标id", param3 = "MagicId"},
	[150] = {id = 150, id_desc = "打印护盾属性", group_id = 7, group_desc = "数值", gm_func = "TDLogEntitySheild", param_num = 1, param1 = "实体id", param2 = "", param3 = ""},
	[151] = {id = 151, id_desc = "显示碰撞查询", group_id = 2, group_desc = "战斗", gm_func = "ShowCheckEntityCollide", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[152] = {id = 152, id_desc = "强制允许二段跳", group_id = 2, group_desc = "战斗", gm_func = "ForceAllowDoubleJump", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[153] = {id = 153, id_desc = "快捷Magic", group_id = 2, group_desc = "战斗", gm_func = "FastMagic", param_num = 3, param1 = "", param2 = "", param3 = ""},
	[154] = {id = 154, id_desc = "快捷EntitySign", group_id = 2, group_desc = "战斗", gm_func = "FastEntitySign", param_num = 3, param1 = "", param2 = "", param3 = ""},
	[155] = {id = 155, id_desc = "执行lua文件", group_id = 1, group_desc = "基础功能", gm_func = "LoadLuaFile", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[156] = {id = 156, id_desc = "伤害报告", group_id = 7, group_desc = "数值", gm_func = "OpenDamgeStatistics", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[157] = {id = 157, id_desc = "创建生态怪物", group_id = 4, group_desc = "关卡", gm_func = "CreateEcoEntity", param_num = 2, param1 = "生态ID", param2 = "怪物等级", param3 = ""},
	[158] = {id = 158, id_desc = "伤害免疫", group_id = 1, group_desc = "基础功能", gm_func = "SetInvincibleState", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[159] = {id = 159, id_desc = "协议测试", group_id = 5, group_desc = "系统", gm_func = "ProtocolTest", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[160] = {id = 160, id_desc = "禁用生态和车辆", group_id = 4, group_desc = "关卡", gm_func = "DisableEcoAndCar", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[162] = {id = 162, id_desc = "加载并实例化资源", group_id = 1, group_desc = "基础功能", gm_func = "LoadABAsset", param_num = 2, param1 = "路径", param2 = "距离", param3 = ""},
	[163] = {id = 163, id_desc = "打开能力轮盘", group_id = 5, group_desc = "系统", gm_func = "OpenAbilityFightPanel", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[164] = {id = 164, id_desc = "月灵演出debug", group_id = 5, group_desc = "系统", gm_func = "OpenPartnerDisplayDebug", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[165] = {id = 165, id_desc = "游戏内存回收", group_id = 6, group_desc = "性能", gm_func = "UnloadUnusedAssets", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[166] = {id = 166, id_desc = "地图传送工具", group_id = 1, group_desc = "基础功能", gm_func = "SetMapTool", param_num = 0, param1 = "", param2 = "", param3 = ""},
}
	

return DataDebugClient
