-- Automatically generated - do not edit.

Config = Config or {}
Config.DataBargainNpcCharacter = Config.DataBargainNpcCharacter or {}


local DataBargainNpcCharacter = Config.DataBargainNpcCharacter
DataBargainNpcCharacter.FindLength = 5
DataBargainNpcCharacter.Find = {
	[1] = {id = 1, character_name = "复读机", character_desc = "复读机：对方第一轮选择诚，之后总是选择与玩家上一轮相同的选择", strategy_list = {1, 3, 3, 3, 3, 3, 3, 3, 3, 3}},
	[2] = {id = 2, character_name = "老油条", character_desc = "老油条：对方总是选择诈", strategy_list = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2}},
	[3] = {id = 3, character_name = "叛逆君", character_desc = "叛逆君：对方第一轮选择随机，之后总是选择与玩家上一轮相反的选择", strategy_list = {0, 4, 4, 4, 4, 4, 4, 4, 4, 4}},
	[4] = {id = 4, character_name = "老好人", character_desc = "老好人：对方总是选择诚", strategy_list = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}},
	[5] = {id = 5, character_name = "叛逆君", character_desc = "叛逆君：对方第一轮选择诚，之后总是选择与玩家上一轮相反的选择", strategy_list = {1, 4, 4, 4, 4, 4, 4, 4, 4, 4}},
}
	

return DataBargainNpcCharacter
