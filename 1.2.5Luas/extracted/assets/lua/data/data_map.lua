-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataMap = Config.DataMap or {}


local DataMap = Config.DataMap
DataMap.data_map_length = 11
DataMap.data_map = {
	[10020001] = {id = 10020001, level_id = 10020001, scene_prefab = "Scene10020001/Scene10020001.prefab", map_area_prefab = "Scene10020001/MapArea/MapAreaTest.prefab", name = "大世界", description = "大世界", anchor_pos = {"LogicWorldTest01", "anchorPos", "endAnchorPos"}, length = 4096.00, width = 4096.00, icon = "Textures/Maps/10020001/", mini_map = "Textures/Maps/10020001/100200012.png"},
	[10020002] = {id = 10020002, level_id = 20000002, scene_prefab = "Scene10010006/Scene10010006.prefab", map_area_prefab = "", name = "smzh一楼", description = "smzh一楼", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020003] = {id = 10020003, level_id = 0, scene_prefab = "Scene10010008/Scene10010008.prefab", map_area_prefab = "", name = "天台", description = "天台", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020005] = {id = 10020005, level_id = 0, scene_prefab = "SceneTest/SceneTest.prefab", map_area_prefab = "", name = "测试场景", description = "测试场景", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020006] = {id = 10020006, level_id = 0, scene_prefab = "Scene10020001_1/Scene10020001_1.prefab", map_area_prefab = "", name = "离去之路", description = "离去之路", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020007] = {id = 10020007, level_id = 20010006, scene_prefab = "Scene10020002/Scene10020002.prefab", map_area_prefab = "", name = "回忆场景", description = "回忆场景-带关卡", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020008] = {id = 10020008, level_id = 0, scene_prefab = "Scene10020002/Scene10020002.prefab", map_area_prefab = "", name = "回忆场景", description = "回忆场景-测试用", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[20000001] = {id = 20000001, level_id = 0, scene_prefab = "SceneWorldTest01/SceneWorldTest01.prefab", map_area_prefab = "", name = "测试白模", description = "测试白模", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020009] = {id = 10020009, level_id = 20010007, scene_prefab = "Scene10020003/Scene10020003.prefab", map_area_prefab = "", name = "新回忆场景", description = "新回忆场景-带关卡", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020010] = {id = 10020010, level_id = 0, scene_prefab = "Scene10020003/Scene10020003.prefab", map_area_prefab = "", name = "新回忆场景", description = "新回忆场景-测试用", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
	[10020004] = {id = 10020004, level_id = 10020004, scene_prefab = "Scene10020004/Scene10020004.prefab", map_area_prefab = "", name = "测试-天柜城", description = "", anchor_pos = {}, length = 0.00, width = 0.00, icon = "", mini_map = ""},
}
	
local DataMap = Config.DataMap
DataMap.data_map_area_length = 5
DataMap.data_map_area = {
	[1] = {id = 1, name = "望月山", parent = 1, position_x = 460.00, position_y = 391.00},
	[2] = {id = 2, name = "创生地", parent = 1, position_x = 1566.00, position_y = 558.00},
	[3] = {id = 3, name = "快乐山", parent = 1, position_x = 2272.00, position_y = 1100.00},
	[4] = {id = 4, name = "开心山", parent = 1, position_x = 544.00, position_y = 1612.00},
	[5] = {id = 5, name = "黄金海岸", parent = 1, position_x = 1125.00, position_y = 2038.00},
}
	
local DataMap = Config.DataMap
DataMap.data_map_big_area_length = 1
DataMap.data_map_big_area = {
	[1] = {id = 1, name = "地江"},
}
	
local DataMap = Config.DataMap
DataMap.data_map_block_area_length = 1
DataMap.data_map_block_area = {
	[9999] = {id = 9999, name = "封锁1", condition = 1, position_x = 1280.00, position_y = -3510.00, block_type = 1},
}
	
local DataMap = Config.DataMap
DataMap.data_map_small_area_length = 2
DataMap.data_map_small_area = {
	[2001] = {id = 2001, name = "离去之路", change_scale = 0},
	[2002] = {id = 2002, name = "熙来", change_scale = 6},
}
	
local DataMap = Config.DataMap
DataMap.data_map_transport_length = 23
DataMap.data_map_transport = {
	[1001010006] = {id = 1001010006, position = {"Logic10020001_6", "checkPoint1"}, rot_y = -38.59, mid_area = 0, type = 101},
	[1001010007] = {id = 1001010007, position = {"Logic10020001_6", "checkPoint2"}, rot_y = 12.09, mid_area = 0, type = 101},
	[1001010008] = {id = 1001010008, position = {"Logic10020001_6", "checkPoint3"}, rot_y = 25.69, mid_area = 0, type = 101},
	[1001010009] = {id = 1001010009, position = {"Logic10020001_6", "checkPoint4"}, rot_y = -4.75, mid_area = 0, type = 101},
	[1001010010] = {id = 1001010010, position = {"Logic10020001_6", "checkPoint5"}, rot_y = 24.34, mid_area = 0, type = 101},
	[1001010011] = {id = 1001010011, position = {"Logic10020001_6", "checkPoint6"}, rot_y = 37.36, mid_area = 0, type = 101},
	[1001010012] = {id = 1001010012, position = {"Logic10020001_6", "checkPoint7"}, rot_y = 16.59, mid_area = 0, type = 101},
	[1001010013] = {id = 1001010013, position = {"Logic10020001_6", "checkPoint8"}, rot_y = 6.02, mid_area = 0, type = 101},
	[1001010014] = {id = 1001010014, position = {"Logic10020001_6", "checkPoint9"}, rot_y = -13.86, mid_area = 0, type = 101},
	[1001010015] = {id = 1001010015, position = {"Logic10020001_6", "checkPoint10"}, rot_y = 3.10, mid_area = 0, type = 101},
	[1001010016] = {id = 1001010016, position = {"Logic10020001_6", "checkPoint11"}, rot_y = 4.13, mid_area = 0, type = 101},
	[1001010017] = {id = 1001010017, position = {"Logic10020001_6", "checkPoint12"}, rot_y = 88.92, mid_area = 0, type = 101},
	[1001010018] = {id = 1001010018, position = {"Logic10020001_6", "checkPoint13"}, rot_y = 74.58, mid_area = 0, type = 101},
	[1001010019] = {id = 1001010019, position = {"Logic10020001_6", "checkPoint14"}, rot_y = 54.75, mid_area = 0, type = 101},
	[1002020001] = {id = 1002020001, position = {"LogicWorldTest01", "ZhonglouT"}, rot_y = -59.00, mid_area = 0, type = 1},
	[1002020002] = {id = 1002020002, position = {"LogicWorldTest01", "Zhonglou2"}, rot_y = -114.00, mid_area = 1, type = 1},
	[1002020003] = {id = 1002020003, position = {"LogicWorldTest01", "Zhonglou3"}, rot_y = -114.00, mid_area = 3, type = 1},
	[1002020004] = {id = 1002020004, position = {"LogicWorldTest01", "Zhonglou4"}, rot_y = -114.00, mid_area = 4, type = 1},
	[1002020005] = {id = 1002020005, position = {"LogicWorldTest01", "Zhonglou5"}, rot_y = -114.00, mid_area = 5, type = 1},
	[1002020011] = {id = 1002020011, position = {"LogicWorldTest01", "TempZhonglou1T"}, rot_y = -317.63, mid_area = 0, type = 2},
	[1002020012] = {id = 1002020012, position = {"LogicWorldTest01", "TempZhonglou2T"}, rot_y = -75.69, mid_area = 2, type = 2},
	[1002020013] = {id = 1002020013, position = {"LogicWorldTest01", "TempZhonglou3T"}, rot_y = 54.27, mid_area = 0, type = 2},
	[1002020014] = {id = 1002020014, position = {"LogicWorldTest01", "TempZhonglou4T"}, rot_y = 126.00, mid_area = 0, type = 2},
}
	
