-- Automatically generated - do not edit.

Config = Config or {}
Config.DataGrowNotice = Config.DataGrowNotice or {}


local DataGrowNotice = Config.DataGrowNotice
DataGrowNotice.FindLength = 7

DataGrowNotice.FindbySystemId = {
	[101] = { [1] = 2,},
	[102] = { [1] = 1,},
	[103] = { [1] = 5,},
	[104] = { [1] = 6,},
	[201] = { [1] = 3,},
	[301] = { [1] = 4,},
	[909] = { [1] = 7,},
}

DataGrowNotice.Find = {
	[1] = { id = 1, judge_id_range = {{10000,99999,},}, notice_text = "有%d个角色可进行突破", system_id = 102, tip_text = "%s可进行突破", title = "角色突破",},
	[2] = { id = 2, judge_id_range = {{2000000,2999999,},}, notice_text = "有%d个角色可替换武器", system_id = 101, tip_text = "%s可穿戴", title = "获得武器",},
	[3] = { id = 3, judge_id_range = {{10000,99999,},}, notice_text = "有%d个角色可突破武器", system_id = 201, tip_text = "%s可进行突破", title = "武器突破",},
	[4] = { id = 4, judge_id_range = {{3000000,3999999,},}, notice_text = "有%d个角色可穿戴月灵", system_id = 301, tip_text = "%s可穿戴", title = "月灵佩戴",},
	[5] = { id = 5, judge_id_range = {{10000,99999,},}, notice_text = "有%d个角色可升级技能", system_id = 103, tip_text = "%s可升级技能", title = "技能升级",},
	[6] = { id = 6, judge_id_range = {{20600,20699,},}, notice_text = "有%d个角色可提升脉象", system_id = 104, tip_text = "%s可提升脉象", title = "脉象提升",},
	[7] = { id = 7, judge_id_range = {{20502,20503,},}, notice_text = "可进行天赋加点", param = {20502,20503,}, system_id = 909, tip_text = "可进行天赋加点", title = "玩家天赋",},
}


return DataGrowNotice
