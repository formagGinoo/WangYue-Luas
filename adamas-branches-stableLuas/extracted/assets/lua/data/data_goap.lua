-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataGoap = Config.DataGoap or {}


local DataGoap = Config.DataGoap
DataGoap.data_action_length = 4
DataGoap.data_action = {
	["Eat"] = {key = "Eat", name = "吃", pre_attr = "Money", pre_attr_value = 20, relation = ">", effect_attr = "Money", effect_attr_value = 20},
	["Sleep"] = {key = "Sleep", name = "睡", pre_attr = "", pre_attr_value = 0, relation = "", effect_attr = "", effect_attr_value = 0},
	["Play"] = {key = "Play", name = "玩", pre_attr = "Money", pre_attr_value = 60, relation = ">", effect_attr = "Money", effect_attr_value = 60},
	["Work"] = {key = "Work", name = "工作", pre_attr = "Stamina", pre_attr_value = 60, relation = ">", effect_attr = "Stamina", effect_attr_value = 20},
}
	
local DataGoap = Config.DataGoap
DataGoap.data_dynamic_attr_length = 4
DataGoap.data_dynamic_attr = {
	["Hunger"] = {key = "Hunger", name = "饥饿", min = 60, max = 80},
	["Stamina"] = {key = "Stamina", name = "体力", min = 60, max = 80},
	["Mood"] = {key = "Mood", name = "心情", min = 60, max = 80},
	["Money"] = {key = "Money", name = "金钱", min = 80, max = 90},
}
	
local DataGoap = Config.DataGoap
DataGoap.data_global_attr_length = 5
DataGoap.data_global_attr = {
	["Bellyful"] = {key = "Bellyful", change_attr = "Hunger"},
	["Sleep"] = {key = "Sleep", change_attr = "Attack"},
	["Play"] = {key = "Play", change_attr = "Guoduan"},
	["Work"] = {key = "Work", change_attr = "Haoqi"},
	["FightBack"] = {key = "FightBack", change_attr = "Huopo"},
}
	
local DataGoap = Config.DataGoap
DataGoap.data_goal_length = 5
DataGoap.data_goal = {
	["Bellyful"] = {key = "Bellyful", change_attr = "Hunger", plus_or_minus = true},
	["Sleep"] = {key = "Sleep", change_attr = "Attack", plus_or_minus = true},
	["Play"] = {key = "Play", change_attr = "Guoduan", plus_or_minus = true},
	["Work"] = {key = "Work", change_attr = "Haoqi", plus_or_minus = true},
	["FightBack"] = {key = "FightBack", change_attr = "Huopo", plus_or_minus = true},
}
	
local DataGoap = Config.DataGoap
DataGoap.data_static_attr_length = 4
DataGoap.data_static_attr = {
	["Diligent"] = {key = "Diligent", name = "勤奋"},
	["CarpeDiem"] = {key = "CarpeDiem", name = "爱玩"},
	["Foodie"] = {key = "Foodie", name = "吃货"},
	["Sleepiness"] = {key = "Sleepiness", name = "嗜睡"},
}
	
