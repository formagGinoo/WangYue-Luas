-- Automatically generated - do not edit.

Config = Config or {}
Config.DataStoryClue = Config.DataStoryClue or {}


local DataStoryClue = Config.DataStoryClue
DataStoryClue.FindLength = 4
DataStoryClue.Find = {
	[1001] = {id = 1001, type = 1, leading_clue = {}, title = "手机", content = "受害者正在打电话"},
	[1002] = {id = 1002, type = 1, leading_clue = {}, title = "炸弹", content = "袭击者手里拿着炸弹"},
	[1003] = {id = 1003, type = 1, leading_clue = {}, title = "袭击", content = "受害者遭到了袭击"},
	[1004] = {id = 1004, type = 1, leading_clue = {1001, 1002, 1003}, title = "手机掉落", content = "受害者电话掉落在附近"},
}
	

return DataStoryClue
