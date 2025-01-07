-- Automatically generated - do not edit.

Config = Config or {}
Config.DataItemExchange = Config.DataItemExchange or {}


local DataItemExchange = Config.DataItemExchange
DataItemExchange.FindLength = 4

DataItemExchange.FindbyTargetId = {
	[3] = { [2] = 2,},
	[5] = { [1] = 1,},
	[10001] = { [3] = 3, [4] = 4,},
}

DataItemExchange.Find = {
	[1] = { consume = {{3,50,},{3,75,},{3,100,},{3,150,},{3,150,},{3,200,},{3,200,},}, daily_limit = 7, id = 1, target_id = 5, target_num = 80,},
	[2] = { consume = {{4,1,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},}, daily_limit = 0, id = 2, target_id = 3, target_num = 1,},
	[3] = { consume = {{3,150,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},}, daily_limit = 0, id = 3, target_id = 10001, target_num = 1,},
	[4] = { consume = {{4,150,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},{0,0,},}, daily_limit = 0, id = 4, target_id = 10001, target_num = 1,},
}


return DataItemExchange
