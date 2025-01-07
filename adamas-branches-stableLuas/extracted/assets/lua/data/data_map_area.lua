-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataMapArea = Config.DataMapArea or {}


local DataMapArea = Config.DataMapArea
DataMapArea.data_map_area_length = 1
DataMapArea.data_map_area = {
	[1] = {id = 1, name = "王土外围", prefab = "UI_dixing_02.prefab", place_list = {101, 102, 103, 104, 105}},
}
	
local DataMapArea = Config.DataMapArea
DataMapArea.data_map_area_place_length = 5
DataMapArea.data_map_area_place = {
	[101] = {id = 101, name = "训练场", place_node = "1", duplicate_list = {200100101, 200100102}, unlock_cond = {1, 200100101}, explore_gold = {{"kill_mon_count", {5}}, {"kill_mon_count", {10}}}, award = {{100111, 1}, {90001, 1000}}, explore_duplicate_id = 215000001, discover_name = "训练场探索副本", discover_child_name = "【探索】训练场探索副本", discover_time_section = 1, discover_desc = "探险名描述XXXX"},
	[102] = {id = 102, name = "星辰世界的荒漠", place_node = "2", duplicate_list = {200100103, 200100104, 200100105}, unlock_cond = {3, 200100102}, explore_gold = {{"kill_mon_count", {5}}, {"kill_mon_count", {12}}, {"kill_mon_count", {20}}}, award = {{100111, 1}, {90001, 1000}, {100113, 1}}, explore_duplicate_id = 215000002, discover_name = "荒漠探索副本", discover_child_name = "【探索】荒漠探索副本", discover_time_section = 1, discover_desc = "探险名描述XXXX"},
	[103] = {id = 103, name = "生命之环1-2层", place_node = "3", duplicate_list = {200100106, 200100107}, unlock_cond = {3, 200100105}, explore_gold = {{"kill_mon_count", {8}}, {"kill_mon_count", {15}}}, award = {{100111, 1}, {90001, 1000}, {100112, 1}}, explore_duplicate_id = 215000003, discover_name = "庭院1-2层探索副本", discover_child_name = "【探索】庭院1-2层探索副本", discover_time_section = 1, discover_desc = "探险名描述XXXX"},
	[104] = {id = 104, name = "生命之环顶层", place_node = "4", duplicate_list = {200100108, 200100109}, unlock_cond = {3, 200100107}, explore_gold = {{"kill_mon_count", {1}}, {"kill_mon_count", {2}}}, award = {{100111, 1}, {90001, 1000}, {10311, 10}}, explore_duplicate_id = 215000004, discover_name = "庭院3层探索副本", discover_child_name = "【探索】庭院3层探索副本", discover_time_section = 1, discover_desc = "探险名描述XXXX"},
	[105] = {id = 105, name = "城市高架桥", place_node = "5", duplicate_list = {200200101, 200200102, 200200103}, unlock_cond = {3, 200100109}, explore_gold = {{"kill_mon_count", {5}}, {"kill_mon_count", {10}}, {"kill_mon_count", {15}}}, award = {{100111, 1}, {90001, 1000}, {10311, 10}}, explore_duplicate_id = 215000005, discover_name = "高架桥探索副本", discover_child_name = "【探索】高架桥探索副本", discover_time_section = 1, discover_desc = "探险名描述XXXX"},
}
	
