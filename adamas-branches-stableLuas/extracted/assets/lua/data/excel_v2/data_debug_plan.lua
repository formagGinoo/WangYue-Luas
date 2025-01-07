-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDebugPlan = Config.DataDebugPlan or {}


local DataDebugPlan = Config.DataDebugPlan
DataDebugPlan.FindLength = 38
DataDebugPlan.Find = {
	[101] = {id = 101, id_desc = "新手：拔剑区", group_id = 1, group_desc = "传送", gm_func = "TransferToGetSword", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[102] = {id = 102, id_desc = "新手：龙Boss门口", group_id = 1, group_desc = "", gm_func = "TransferToBaXi", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[103] = {id = 103, id_desc = "新手：大世界眺望点", group_id = 1, group_desc = "", gm_func = "TransferToWatchWorld", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[104] = {id = 104, id_desc = "地江：小钟悬区域", group_id = 1, group_desc = "", gm_func = "TransferToSmallBell", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[105] = {id = 105, id_desc = "地江：熙来村", group_id = 1, group_desc = "", gm_func = "TransferToXiLaiCity", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[106] = {id = 106, id_desc = "地江：据点", group_id = 1, group_desc = "", gm_func = "TransferToStrongHold", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[107] = {id = 107, id_desc = "地江：神荼BOSS区", group_id = 1, group_desc = "", gm_func = "TransferToShenTu", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[108] = {id = 108, id_desc = "天柜城：咖啡馆", group_id = 1, group_desc = "", gm_func = "TransferToCoffee", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[109] = {id = 109, id_desc = "天柜城：街道", group_id = 1, group_desc = "", gm_func = "TransferToStreet", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[110] = {id = 110, id_desc = "天柜城：广场区", group_id = 1, group_desc = "", gm_func = "TransferToSquare", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[111] = {id = 111, id_desc = "天柜城：战斗楼顶", group_id = 1, group_desc = "", gm_func = "TransferToTiantai", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[112] = {id = 112, id_desc = "离歌Boss场景", group_id = 1, group_desc = "", gm_func = "TransferToLigeBoss", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[113] = {id = 113, id_desc = "离歌Boss场景2", group_id = 1, group_desc = "", gm_func = "TransferToLigePv", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[114] = {id = 114, id_desc = "天柜城通风口", group_id = 1, group_desc = "", gm_func = "TransferToPVTFK", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[115] = {id = 115, id_desc = "生命之环", group_id = 1, group_desc = "", gm_func = "TransferToshengmingzhihuan", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[116] = {id = 116, id_desc = "地江：加油站", group_id = 1, group_desc = "", gm_func = "TransferToGasStation", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[117] = {id = 117, id_desc = "浮空岛", group_id = 1, group_desc = "", gm_func = "TransferToSkyIsland", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[118] = {id = 118, id_desc = "副本测试-类型1并行交互", group_id = 1, group_desc = "", gm_func = "TransferToTaskDup1", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[119] = {id = 119, id_desc = "副本测试-类型2顺序交互", group_id = 1, group_desc = "", gm_func = "TransferToTaskDup2", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[120] = {id = 120, id_desc = "副本测试-类型3野外Boss", group_id = 1, group_desc = "", gm_func = "TransferToTaskDup3", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[124] = {id = 124, id_desc = "天月城：镜像副本测试", group_id = 1, group_desc = "", gm_func = "TransferToTestpoint", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[125] = {id = 125, id_desc = "天月城：天台", group_id = 1, group_desc = "", gm_func = "TransferToRoofTop", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[126] = {id = 126, id_desc = "资产：月灵中心", group_id = 1, group_desc = "", gm_func = "TransferToYueLingCenter", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[199] = {id = 199, id_desc = "传送坐标", group_id = 1, group_desc = "", gm_func = "Transport", param_num = 2, param1 = "地图id", param2 = "", param3 = ""},
	[201] = {id = 201, id_desc = "跳过全部任务", group_id = 2, group_desc = "任务", gm_func = "SkipAllTask", param_num = 0, param1 = "", param2 = "坐标", param3 = ""},
	[301] = {id = 301, id_desc = "创建实体", group_id = 3, group_desc = "创建实体", gm_func = "CreateEntity", param_num = 3, param1 = "实体id", param2 = "", param3 = ""},
	[401] = {id = 401, id_desc = "关闭BGM", group_id = 4, group_desc = "功能", gm_func = "MuteBgm", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[402] = {id = 402, id_desc = "开启BGM", group_id = 4, group_desc = "", gm_func = "ActiveBgm", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[403] = {id = 403, id_desc = "开启渲染帧", group_id = 4, group_desc = "", gm_func = "ActiveRenderFrame", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[404] = {id = 404, id_desc = "关闭渲染帧", group_id = 4, group_desc = "", gm_func = "DeactiveRenderFrame", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[405] = {id = 405, id_desc = "开启NpcAiLOD", group_id = 4, group_desc = "", gm_func = "ActiveNpcAiLOD", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[406] = {id = 406, id_desc = "关闭NpcAiLOD", group_id = 4, group_desc = "", gm_func = "DeactiveNpcAiLOD", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[407] = {id = 407, id_desc = "降低相机移动速度", group_id = 4, group_desc = "", gm_func = "SlowCameraSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[408] = {id = 408, id_desc = "游戏暂停", group_id = 4, group_desc = "", gm_func = "GamePause", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[409] = {id = 409, id_desc = "游戏恢复", group_id = 4, group_desc = "", gm_func = "GameResume", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[410] = {id = 410, id_desc = "打印bgm状态", group_id = 4, group_desc = "", gm_func = "PrintBgmState", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[411] = {id = 411, id_desc = "显示所有关卡位置", group_id = 4, group_desc = "", gm_func = "LoadLogicPosition", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[412] = {id = 412, id_desc = "卸载所有关卡位置", group_id = 4, group_desc = "", gm_func = "UnLoadLogicPosition", param_num = 0, param1 = "", param2 = "", param3 = ""},
}
	

return DataDebugPlan
