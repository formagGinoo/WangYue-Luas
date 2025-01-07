-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataLevelEvent = Config.DataLevelEvent or {}


local DataLevelEvent = Config.DataLevelEvent
DataLevelEvent.data_level_event_length = 17
DataLevelEvent.data_level_event = {
	[100001] = {id = 100001, type = 1, event_name = "街道水-1", level_id = 302040301, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos1"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100002] = {id = 100002, type = 1, event_name = "街道金-1", level_id = 302040401, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos2"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100003] = {id = 100003, type = 1, event_name = "街道土-1", level_id = 302040501, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos3"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100004] = {id = 100004, type = 1, event_name = "街道火-1", level_id = 302040601, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos4"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100005] = {id = 100005, type = 1, event_name = "街道木-1", level_id = 302040701, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos5"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100006] = {id = 100006, type = 1, event_name = "街道战斗事件", level_id = 302040801, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos6"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[100007] = {id = 100007, type = 1, event_name = "街道战斗事件", level_id = 302040802, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StreetEvent", "Pos7"}, unlock_radius = 100, load_radius = 90, reward_id = 301000, jump_id = 100003, show_reward = true},
	[201001] = {id = 201001, type = 2, event_name = "小型月灵据点", level_id = 500501001, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StrongholdEvent", "SmallPos1"}, unlock_radius = 1000, load_radius = 90, reward_id = 0, jump_id = 100005, show_reward = false},
	[201002] = {id = 201002, type = 2, event_name = "小型月灵据点", level_id = 500501002, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StrongholdEvent", "SmallPos2"}, unlock_radius = 1000, load_radius = 90, reward_id = 0, jump_id = 100005, show_reward = false},
	[202001] = {id = 202001, type = 2, event_name = "中型月灵据点", level_id = 500502001, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"StrongholdEvent", "MidPos1"}, unlock_radius = 1000, load_radius = 90, reward_id = 0, jump_id = 100005, show_reward = false},
	[300001] = {id = 300001, type = 3, event_name = "室内解密-1", level_id = 200502001, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"InRoomLevelevent", "Pos1"}, unlock_radius = 1000, load_radius = 90, reward_id = 303000, jump_id = 100006, show_reward = true},
	[300002] = {id = 300002, type = 3, event_name = "室内解密-2", level_id = 200502002, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"InRoomLevelevent", "Pos7"}, unlock_radius = 1000, load_radius = 90, reward_id = 303000, jump_id = 100006, show_reward = true},
	[400001] = {id = 400001, type = 4, event_name = "月能威胁1", level_id = 200508001, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"RoofCombatPuzzle", "type_normal_1"}, unlock_radius = 420, load_radius = 400, reward_id = 304000, jump_id = 100007, show_reward = true},
	[400002] = {id = 400002, type = 4, event_name = "月能威胁2", level_id = 200508002, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"RoofCombatPuzzle", "type_higher_1"}, unlock_radius = 420, load_radius = 400, reward_id = 304000, jump_id = 100007, show_reward = true},
	[400003] = {id = 400003, type = 4, event_name = "月能威胁3", level_id = 200508003, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"RoofCombatPuzzle", "type_pipeline_1"}, unlock_radius = 420, load_radius = 400, reward_id = 304000, jump_id = 100007, show_reward = true},
	[400004] = {id = 400004, type = 4, event_name = "月能威胁4", level_id = 200508004, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"RoofCombatPuzzle", "type_findhole_1"}, unlock_radius = 420, load_radius = 400, reward_id = 304000, jump_id = 100007, show_reward = true},
	[400005] = {id = 400005, type = 4, event_name = "月能威胁5", level_id = 200508005, condition = 0, map_id = 10020005, position_id = 10020005, positing = {"RoofCombatPuzzle", "type_findhole_2"}, unlock_radius = 420, load_radius = 400, reward_id = 304000, jump_id = 100007, show_reward = true},
}
	
