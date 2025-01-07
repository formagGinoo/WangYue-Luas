-- Automatically generated - do not edit.

Config = Config or {}
Config.DataGoapGoal = Config.DataGoapGoal or {}


local DataGoapGoal = Config.DataGoapGoal
DataGoapGoal.FindLength = 5
DataGoapGoal.Find = {
	["Bellyful"] = {key = "Bellyful", change_attr = "Hunger", plus_or_minus = true, effect_action = {"Eat", "Sleep", "Play", "Work", ""}},
	["Sleep"] = {key = "Sleep", change_attr = "Stamina", plus_or_minus = true, effect_action = {"Eat", "Sleep", "Play", "Work", ""}},
	["Play"] = {key = "Play", change_attr = "Mood", plus_or_minus = true, effect_action = {"Eat", "Sleep", "Play", "Work", ""}},
	["Work"] = {key = "Work", change_attr = "Money", plus_or_minus = true, effect_action = {"Eat", "Sleep", "Play", "Work", ""}},
	["FightBack"] = {key = "FightBack", change_attr = "Stamina", plus_or_minus = true, effect_action = {"Eat", "Sleep", "Play", "Work", ""}},
}
	

return DataGoapGoal
