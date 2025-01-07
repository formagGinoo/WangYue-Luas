-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDebugPlan = Config.DataDebugPlan or {}


local DataDebugPlan = Config.DataDebugPlan
DataDebugPlan.FindLength = 7
DataDebugPlan.Find = {
	[101] = {id = 101, id_desc = "传送到龙Boss门口", group_id = 1, group_desc = "传送点", gm_func = "TransferToBaXi", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[102] = {id = 102, id_desc = "传送到拔剑", group_id = 1, group_desc = "", gm_func = "TransferToGetSword", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[103] = {id = 103, id_desc = "传送到小镇", group_id = 1, group_desc = "", gm_func = "TransferToXiLaiCity", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[201] = {id = 201, id_desc = "跳过新手流程", group_id = 2, group_desc = "任务接取", gm_func = "SkipRookieTask", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[202] = {id = 202, id_desc = "贝露贝特训练关", group_id = 2, group_desc = "", gm_func = "ReciveBlbtTrainLevel", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[203] = {id = 203, id_desc = "贝露贝特训练关后", group_id = 2, group_desc = "", gm_func = "SkipBlbtTrainLevel", param_num = 0, param1 = "", param2 = "", param3 = ""},
	[204] = {id = 204, id_desc = "打龙Boss", group_id = 2, group_desc = "", gm_func = "ReciveBaXiTask", param_num = 0, param1 = "", param2 = "", param3 = ""},
}
	

return DataDebugPlan
