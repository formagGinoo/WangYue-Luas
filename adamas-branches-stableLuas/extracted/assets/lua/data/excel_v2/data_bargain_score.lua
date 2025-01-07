-- Automatically generated - do not edit.

Config = Config or {}
Config.DataBargainScore = Config.DataBargainScore or {}


local DataBargainScore = Config.DataBargainScore
DataBargainScore.FindLength = 6

DataBargainScore.FindbyPlayerChoice = {
	[1] = { [4294967297] = 4294967297, [8589934593] = 8589934593,},
	[2] = { [4294967298] = 4294967298, [8589934594] = 8589934594,},
	[3] = { [4294967299] = 4294967299, [8589934595] = 8589934595,},
}

DataBargainScore.FindbyNpcChoice = {
	[1] = { [4294967297] = 4294967297, [4294967298] = 4294967298, [4294967299] = 4294967299,},
	[2] = { [8589934593] = 8589934593, [8589934594] = 8589934594, [8589934595] = 8589934595,},
}

DataBargainScore.Find = {
	[4294967297] = { player_choice = 1, npc_choice = 1, effect = "ShowTimePlayerUpNpcUp", npc_score = 2, player_score = 2, show_order = 1,},
	[4294967298] = { player_choice = 2, npc_choice = 1, effect = "ShowTimePlayerUnderNpcUp", npc_score = -1, player_score = 1, show_order = 2,},
	[4294967299] = { player_choice = 3, npc_choice = 1, effect = "ShowTimePlayerNoChoiceNpcUp", npc_score = 0, player_score = 0, show_order = 0,},
	[8589934593] = { player_choice = 1, npc_choice = 2, effect = "ShowTimePlayerUpNpcUnder", npc_score = 1, player_score = -1, show_order = 4,},
	[8589934594] = { player_choice = 2, npc_choice = 2, effect = "ShowTimePlayerUnderNpcUnder", npc_score = 0, player_score = 0, show_order = 3,},
	[8589934595] = { player_choice = 3, npc_choice = 2, effect = "ShowTimePlayerNoChoiceNpcUnder", npc_score = 1, player_score = -1, show_order = 0,},
}


return DataBargainScore
