-- Automatically generated - do not edit.

Config = Config or {}
Config.DataAction = Config.DataAction or {}


local DataAction = Config.DataAction
DataAction.FindLength = 5
DataAction.Find = {
	["Eat"] = {key = "Eat", name = "吃", effect_attr = "Hunger", effect_attr_value = 20, pre_attr = {{"Money", ">", 10}}, sub_attr = {{"Money", -30}, {"", 0}, {"", 0}, {"", 0}}},
	["Sleep"] = {key = "Sleep", name = "睡", effect_attr = "Stamina", effect_attr_value = 20, pre_attr = {{"", "", 0}}, sub_attr = {{"Stamina", -15}, {"", 0}, {"", 0}, {"", 0}}},
	["Play"] = {key = "Play", name = "玩", effect_attr = "Mood", effect_attr_value = 30, pre_attr = {{"Stamina", ">", 10}}, sub_attr = {{"Hunger", -10}, {"", 0}, {"", 0}, {"", 0}}},
	["Work"] = {key = "Work", name = "工作", effect_attr = "Money", effect_attr_value = 20, pre_attr = {{"", "", 0}}, sub_attr = {{"Mood", -20}, {"", 0}, {"", 0}, {"", 0}}},
	["Idle"] = {key = "Idle", name = "待机", effect_attr = "", effect_attr_value = 0, pre_attr = {{"", "", 0}}, sub_attr = {{"", 0}, {"", 0}, {"", 0}, {"", 0}}},
}
	

return DataAction
