-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataPlanner = Config.DataPlanner or {}


local DataPlanner = Config.DataPlanner
DataPlanner.data_planner_action_length = 55
DataPlanner.data_planner_action = {
	["Eat"] = {key = "Eat", name = "吃", prenode = {"Sleep", "Play"}},
	["Sleep"] = {key = "Sleep", name = "睡", prenode = {}},
	["Play"] = {key = "Play", name = "玩", prenode = {}},
	["Work"] = {key = "Work", name = "上班", prenode = {}},
	["FightBack"] = {key = "FightBack", name = "反击", prenode = {}},
	["1"] = {key = "1", name = "1", prenode = {}},
	["2"] = {key = "2", name = "2", prenode = {}},
	["3"] = {key = "3", name = "3", prenode = {}},
	["4"] = {key = "4", name = "4", prenode = {}},
	["5"] = {key = "5", name = "5", prenode = {}},
	["6"] = {key = "6", name = "6", prenode = {}},
	["7"] = {key = "7", name = "7", prenode = {}},
	["8"] = {key = "8", name = "8", prenode = {}},
	["9"] = {key = "9", name = "9", prenode = {}},
	["10"] = {key = "10", name = "10", prenode = {}},
	["11"] = {key = "11", name = "11", prenode = {}},
	["12"] = {key = "12", name = "12", prenode = {}},
	["13"] = {key = "13", name = "13", prenode = {}},
	["14"] = {key = "14", name = "14", prenode = {}},
	["15"] = {key = "15", name = "15", prenode = {}},
	["16"] = {key = "16", name = "16", prenode = {}},
	["17"] = {key = "17", name = "17", prenode = {}},
	["18"] = {key = "18", name = "18", prenode = {}},
	["19"] = {key = "19", name = "19", prenode = {}},
	["20"] = {key = "20", name = "20", prenode = {}},
	["21"] = {key = "21", name = "21", prenode = {}},
	["22"] = {key = "22", name = "22", prenode = {}},
	["23"] = {key = "23", name = "23", prenode = {}},
	["24"] = {key = "24", name = "24", prenode = {}},
	["25"] = {key = "25", name = "25", prenode = {}},
	["26"] = {key = "26", name = "26", prenode = {}},
	["27"] = {key = "27", name = "27", prenode = {}},
	["28"] = {key = "28", name = "28", prenode = {}},
	["29"] = {key = "29", name = "29", prenode = {}},
	["30"] = {key = "30", name = "30", prenode = {}},
	["31"] = {key = "31", name = "31", prenode = {}},
	["32"] = {key = "32", name = "32", prenode = {}},
	["33"] = {key = "33", name = "33", prenode = {}},
	["34"] = {key = "34", name = "34", prenode = {}},
	["35"] = {key = "35", name = "35", prenode = {}},
	["36"] = {key = "36", name = "36", prenode = {}},
	["37"] = {key = "37", name = "37", prenode = {}},
	["38"] = {key = "38", name = "38", prenode = {}},
	["39"] = {key = "39", name = "39", prenode = {}},
	["40"] = {key = "40", name = "40", prenode = {}},
	["41"] = {key = "41", name = "41", prenode = {}},
	["42"] = {key = "42", name = "42", prenode = {}},
	["43"] = {key = "43", name = "43", prenode = {}},
	["44"] = {key = "44", name = "44", prenode = {}},
	["45"] = {key = "45", name = "45", prenode = {}},
	["46"] = {key = "46", name = "46", prenode = {}},
	["47"] = {key = "47", name = "47", prenode = {}},
	["48"] = {key = "48", name = "48", prenode = {}},
	["49"] = {key = "49", name = "49", prenode = {}},
	["50"] = {key = "50", name = "50", prenode = {}},
}
	
local DataPlanner = Config.DataPlanner
DataPlanner.data_planner_attr_length = 45
DataPlanner.data_planner_attr = {
	["Cruel"] = {key = "Cruel", name = "残忍"},
	["Attack"] = {key = "Attack", name = "攻击性"},
	["Guoduan"] = {key = "Guoduan", name = "果断"},
	["Haoqi"] = {key = "Haoqi", name = "好奇心"},
	["Huopo"] = {key = "Huopo", name = "活泼"},
	["1"] = {key = "1", name = "1"},
	["2"] = {key = "2", name = "2"},
	["3"] = {key = "3", name = "3"},
	["4"] = {key = "4", name = "4"},
	["5"] = {key = "5", name = "5"},
	["6"] = {key = "6", name = "6"},
	["7"] = {key = "7", name = "7"},
	["8"] = {key = "8", name = "8"},
	["9"] = {key = "9", name = "9"},
	["10"] = {key = "10", name = "10"},
	["11"] = {key = "11", name = "11"},
	["12"] = {key = "12", name = "12"},
	["13"] = {key = "13", name = "13"},
	["14"] = {key = "14", name = "14"},
	["15"] = {key = "15", name = "15"},
	["16"] = {key = "16", name = "16"},
	["17"] = {key = "17", name = "17"},
	["18"] = {key = "18", name = "18"},
	["19"] = {key = "19", name = "19"},
	["20"] = {key = "20", name = "20"},
	["21"] = {key = "21", name = "21"},
	["22"] = {key = "22", name = "22"},
	["23"] = {key = "23", name = "23"},
	["24"] = {key = "24", name = "24"},
	["25"] = {key = "25", name = "25"},
	["26"] = {key = "26", name = "26"},
	["27"] = {key = "27", name = "27"},
	["28"] = {key = "28", name = "28"},
	["29"] = {key = "29", name = "29"},
	["30"] = {key = "30", name = "30"},
	["31"] = {key = "31", name = "31"},
	["32"] = {key = "32", name = "32"},
	["33"] = {key = "33", name = "33"},
	["34"] = {key = "34", name = "34"},
	["35"] = {key = "35", name = "35"},
	["36"] = {key = "36", name = "36"},
	["37"] = {key = "37", name = "37"},
	["38"] = {key = "38", name = "38"},
	["39"] = {key = "39", name = "39"},
	["40"] = {key = "40", name = "40"},
}
	
