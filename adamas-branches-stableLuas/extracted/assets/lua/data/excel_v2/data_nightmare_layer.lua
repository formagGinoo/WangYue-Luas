-- Automatically generated - do not edit.

Config = Config or {}
Config.DataNightmareLayer = Config.DataNightmareLayer or {}


local DataNightmareLayer = Config.DataNightmareLayer
DataNightmareLayer.FindLength = 5

DataNightmareLayer.FindbyType = {
	[1] = { [1] = 1, [2] = 2, [3] = 3,},
	[2] = { [1] = 1001, [2] = 1002,},
}

DataNightmareLayer.Find = {
	[1] = { base_member = 50000, condition = 0, icon = "", layer = 1, name = "第1层", point_reward = 101, type = 1,},
	[2] = { base_member = 50000, condition = 300006, icon = "", layer = 2, name = "第2层", point_reward = 102, type = 1,},
	[3] = { base_member = 50000, condition = 300008, icon = "", layer = 3, name = "第3层", point_reward = 103, type = 1,},
	[1001] = { base_member = 50000, condition = 300010, icon = "", layer = 1001, name = "浅海区", point_reward = 100101, type = 2,},
	[1002] = { base_member = 50000, condition = 300010, icon = "", layer = 1002, name = "深海区", point_reward = 100202, type = 2,},
}


return DataNightmareLayer
