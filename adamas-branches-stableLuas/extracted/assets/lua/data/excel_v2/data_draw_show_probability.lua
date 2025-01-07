-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDrawShowProbability = Config.DataDrawShowProbability or {}


local DataDrawShowProbability = Config.DataDrawShowProbability
DataDrawShowProbability.FindLength = 9

DataDrawShowProbability.FindbyDrawId = {
	[1001] = { [1] = 1, [2] = 2, [3] = 3,},
	[1002] = { [4] = 4, [5] = 5, [6] = 6,},
	[9999] = { [7] = 7, [8] = 8, [9] = 9,},
}

DataDrawShowProbability.Find = {
	[1] = { draw_id = 1001, id = 1, name = "橙色角色", rate_str = "0.47%",},
	[2] = { draw_id = 1001, id = 2, name = "紫色角色&紫色武器", rate_str = "4.9%",},
	[3] = { draw_id = 1001, id = 3, name = "蓝色武器", rate_str = "94.63%",},
	[4] = { draw_id = 1002, id = 4, name = "橙色武器", rate_str = "0.47%",},
	[5] = { draw_id = 1002, id = 5, name = "紫色角色&紫色武器", rate_str = "4.9%",},
	[6] = { draw_id = 1002, id = 6, name = "蓝色武器", rate_str = "94.63%",},
	[7] = { draw_id = 9999, id = 7, name = "橙色角色", rate_str = "0.47%",},
	[8] = { draw_id = 9999, id = 8, name = "紫色角色&紫色武器", rate_str = "4.9%",},
	[9] = { draw_id = 9999, id = 9, name = "蓝色武器", rate_str = "94.63%",},
}


return DataDrawShowProbability
