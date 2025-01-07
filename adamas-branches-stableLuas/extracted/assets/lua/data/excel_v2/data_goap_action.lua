-- Automatically generated - do not edit.

Config = Config or {}
Config.DataGoapAction = Config.DataGoapAction or {}


local DataGoapAction = Config.DataGoapAction
DataGoapAction.FindLength = 5
DataGoapAction.Find = {
	["Eat"] = {key = "Eat", name = "吃", effect_attr = "Hunger", effect_attr_value = 20, pre_attr = {{"Money", ">", 50}}, sub_attr = {{"Money", -15}, {"Stamina", 10}, {"Hunger", 0}, {"Mood", 5}}},
	["Sleep"] = {key = "Sleep", name = "睡", effect_attr = "Stamina", effect_attr_value = 20, pre_attr = {{"", "", 0}}, sub_attr = {{"Money", 0}, {"Stamina", 0}, {"Hunger", -20}, {"Mood", 5}}},
	["Play"] = {key = "Play", name = "玩", effect_attr = "Mood", effect_attr_value = 30, pre_attr = {{"Stamina", ">", 60}}, sub_attr = {{"Money", -20}, {"Stamina", -30}, {"Hunger", -10}, {"Mood", 0}}},
	["Work"] = {key = "Work", name = "工作", effect_attr = "Money", effect_attr_value = 20, pre_attr = {{"", "", 0}}, sub_attr = {{"Money", 0}, {"Stamina", -20}, {"Hunger", -5}, {"Mood", -20}}},
	["Idle"] = {key = "Idle", name = "待机", effect_attr = "", effect_attr_value = 0, pre_attr = {{"", "", 0}}, sub_attr = {{"", 0}, {"", 0}, {"", 0}, {"", 0}}},
}
	

return DataGoapAction
