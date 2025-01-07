-- Automatically generated - do not edit.

Config = Config or {}
Config.DataNightmareBuff = Config.DataNightmareBuff or {}


local DataNightmareBuff = Config.DataNightmareBuff
DataNightmareBuff.FindLength = 4

DataNightmareBuff.Find = {
	[10001] = { fight_base_id = 10001, fight_buff = {{1001,10001,},{1002,10002,},{1003,10003,},{1004,10004,},}, name = "强化",},
	[10002] = { fight_base_id = 10002, fight_buff = {{1005,10001,},{1006,10002,},{1007,10003,},{1008,10004,},}, name = "强化2",},
	[20001] = { fight_base_id = 20001, fight_buff = {{1010,20001,},}, name = "控血",},
	[30001] = { fight_base_id = 30001, fight_buff = {{1009,30001,},}, name = "计时",},
}


return DataNightmareBuff
