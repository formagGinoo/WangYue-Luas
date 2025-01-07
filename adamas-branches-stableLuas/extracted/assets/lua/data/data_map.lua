-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataMap = Config.DataMap or {}


local DataMap = Config.DataMap
DataMap.data_map_length = 6
DataMap.data_map = {
	[10020001] = {map_id = 10020001, name = "卯迹", length = 4096.00, width = 4096.00, icon = "Textures/Maps/10020001/", mini_map = "Textures/Maps/10020001/100200012.png"},
	[1002000301] = {map_id = 1002000301, name = "月灵研究中心", length = 2048.00, width = 2048.00, icon = "Textures/Maps/10020003/", mini_map = "Textures/Maps/10020003/10020003.png"},
	[1002000302] = {map_id = 1002000302, name = "月灵研究中心2", length = 2048.00, width = 2048.00, icon = "Textures/Maps/10020003/", mini_map = "Textures/Maps/10020003/10020003.png"},
	[10020004] = {map_id = 10020004, name = "旧月城", length = 2048.00, width = 2048.00, icon = "Textures/Maps/10020004/", mini_map = "Textures/Maps/10020004/10020004.png"},
	[10020005] = {map_id = 10020005, name = "天月城", length = 2048.00, width = 2048.00, icon = "Textures/Maps/10020005/", mini_map = "Textures/Maps/10020005/10020005.png"},
	[10020006] = {map_id = 10020006, name = "月灵研究中心", length = 2048.00, width = 2048.00, icon = "Textures/Maps/10020006/", mini_map = "Textures/Maps/10020006/10020006.png"},
}
	
local DataMap = Config.DataMap
DataMap.data_map_area_length = 13
DataMap.data_map_area = {
	[4304987297] = {id = 1, map_id = 10020001, name = "望月山", parent = 1, change_scale = 0},
	[8599954593] = {id = 2, map_id = 10020001, name = "创生地", parent = 1, change_scale = 0},
	[12894921889] = {id = 3, map_id = 10020001, name = "快乐山", parent = 1, change_scale = 0},
	[17189889185] = {id = 4, map_id = 10020001, name = "开心山", parent = 1, change_scale = 0},
	[21484856481] = {id = 5, map_id = 10020001, name = "黄金海岸", parent = 1, change_scale = 0},
	[433801716900] = {id = 101, map_id = 10020004, name = "商业区", parent = 1, change_scale = 6},
	[438096684196] = {id = 102, map_id = 10020004, name = "旧城区", parent = 1, change_scale = 6},
	[442391651492] = {id = 103, map_id = 10020004, name = "娱乐区", parent = 1, change_scale = 6},
	[446686618788] = {id = 104, map_id = 10020004, name = "开发区", parent = 1, change_scale = 6},
	[4304987301] = {id = 1, map_id = 10020005, name = "商业区", parent = 1, change_scale = 6},
	[8599954597] = {id = 2, map_id = 10020005, name = "广场区", parent = 1, change_scale = 6},
	[12894921893] = {id = 3, map_id = 10020005, name = "居民区", parent = 1, change_scale = 6},
	[17189889189] = {id = 4, map_id = 10020005, name = "中心公园", parent = 1, change_scale = 6},
}
	
local DataMap = Config.DataMap
DataMap.data_map_big_area_length = 3
DataMap.data_map_big_area = {
	[4304987297] = {id = 1, map_id = 10020001, name = "卯迹"},
	[4304987300] = {id = 1, map_id = 10020004, name = "天月城"},
	[4304987301] = {id = 1, map_id = 10020005, name = "新天月城"},
}
	
local DataMap = Config.DataMap
DataMap.data_map_block_area_length = 2
DataMap.data_map_block_area = {
	[42945388012705] = {id = 9999, map_id = 10020001, name = "封锁1", condition = 1, position_x = 1280.00, position_y = -3510.00, block_type = 1},
	[42945388012708] = {id = 9999, map_id = 10020004, name = "封锁1", condition = 1, position_x = 1280.00, position_y = -3510.00, block_type = 1},
}
	
local DataMap = Config.DataMap
DataMap.data_map_change_length = 2
DataMap.data_map_change = {
	[10020001] = {map_trs_id = 10020001, name = "卯迹", map_icon = "Textures/Icon/Single/MapIcon/dijiang", map_id = 10020001, map_condition = 205001},
	[10020005] = {map_trs_id = 10020005, name = "天月城", map_icon = "Textures/Icon/Single/MapIcon/tianguicheng", map_id = 10020005, map_condition = 0},
}
	
local DataMap = Config.DataMap
DataMap.data_map_small_area_length = 2
DataMap.data_map_small_area = {
	[8594239579297] = {id = 2001, map_id = 10020001, name = "离去之路", change_scale = 0},
	[8598534546593] = {id = 2002, map_id = 10020001, name = "熙来", change_scale = 6},
}
	
local DataMap = Config.DataMap
DataMap.data_map_transport_length = 9
DataMap.data_map_transport = {
	[1003001010001] = {id = 1003001010001, position = {"map10020005_Transport", "map10020005_Transport01T"}, rot_y = -90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010002] = {id = 1003001010002, position = {"map10020005_Transport", "map10020005_Transport02T"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010003] = {id = 1003001010003, position = {"map10020005_Transport", "map10020005_Transport03T"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010004] = {id = 1003001010004, position = {"map10020005_Transport", "map10020005_Transport04T"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010005] = {id = 1003001010005, position = {"map10020005_Transport", "map10020005_Transport05T"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010006] = {id = 1003001010006, position = {"map10020005_Transport", "map10020005_Transport06T"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = false},
	[1003001010091] = {id = 1003001010091, position = {"map10020005_Transport", "HideT1"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = true},
	[1003001010092] = {id = 1003001010092, position = {"map10020005_Transport", "HideT2"}, rot_y = 90.00, mid_area = 0, type = 2, default_active = true},
	[1003001020001] = {id = 1003001020001, position = {"map10020005_Transport", "BigbellT"}, rot_y = 90.00, mid_area = 1, type = 1, default_active = false},
}
	
local DataMap = Config.DataMap
DataMap.data_scene_length = 20
DataMap.data_scene = {
	[10020001] = {id = 10020001, position_id = 10020001, default_revive_pos = {"Logic10020001_6", "pb1"}, scene_prefab = "Scene10020001/Scene10020001.prefab", name = "卯迹", description = "卯迹", map_id = 10020001, anchor_pos = {"LogicWorldTest01", "anchorPos", "endAnchorPos"}},
	[10020002] = {id = 10020002, position_id = 0, default_revive_pos = {}, scene_prefab = "Scene10010006/Scene10010006.prefab", name = "smzh一楼", description = "smzh一楼", map_id = 0, anchor_pos = {}},
	[10020007] = {id = 10020007, position_id = 10020007, default_revive_pos = {}, scene_prefab = "Scene10020002/Scene10020002.prefab", name = "回忆场景", description = "回忆场景-带关卡", map_id = 0, anchor_pos = {}},
	[10020008] = {id = 10020008, position_id = 0, default_revive_pos = {}, scene_prefab = "Scene10020002/Scene10020002.prefab", name = "回忆场景", description = "回忆场景-测试用", map_id = 0, anchor_pos = {}},
	[20000001] = {id = 20000001, position_id = 0, default_revive_pos = {}, scene_prefab = "SceneWorldTest01/SceneWorldTest01.prefab", name = "测试白模", description = "测试白模", map_id = 0, anchor_pos = {}},
	[20000011] = {id = 20000011, position_id = 20000011, default_revive_pos = {}, scene_prefab = "SceneDriveTest/SceneDriveTest.prefab", name = "载具测试", description = "载具测试", map_id = 0, anchor_pos = {}},
	[10020009] = {id = 10020009, position_id = 10020011, default_revive_pos = {}, scene_prefab = "Scene10020003/Scene10020003.prefab", name = "新回忆场景", description = "新回忆场景-带关卡", map_id = 0, anchor_pos = {}},
	[10020010] = {id = 10020010, position_id = 0, default_revive_pos = {}, scene_prefab = "Scene10020003/Scene10020003.prefab", name = "新回忆场景", description = "新回忆场景-测试用", map_id = 0, anchor_pos = {}},
	[10020004] = {id = 10020004, position_id = 10020004, default_revive_pos = {"MainTask04", "DazhongxuanTgc"}, scene_prefab = "Scene10020004/Scene10020004.prefab", name = "旧月城", description = "旧月城", map_id = 10020004, anchor_pos = {"WorldMap", "anchorPos", "endAnchorPos"}},
	[500100001] = {id = 500100001, position_id = 0, default_revive_pos = {}, scene_prefab = "1020001_Boss_02/1020001_Boss_02.prefab", name = "离歌Boss场景", description = "离歌Boss场景", map_id = 0, anchor_pos = {}},
	[500100002] = {id = 500100002, position_id = 0, default_revive_pos = {}, scene_prefab = "Scene10010006/Scene10010006.prefab", name = "smzh一楼", description = "smzh一楼", map_id = 0, anchor_pos = {}},
	[500100003] = {id = 500100003, position_id = 0, default_revive_pos = {}, scene_prefab = "1020001_Boss_02/1020001_Boss_02.prefab", name = "离歌Boss场景", description = "离歌Boss场PV", map_id = 0, anchor_pos = {}},
	[10020005] = {id = 10020005, position_id = 10020005, default_revive_pos = {"MayTask", "PlayerBorn"}, scene_prefab = "Scene10020005/Scene10020005.prefab", name = "天月城", description = "天月城", map_id = 10020005, anchor_pos = {"MayTask", "anchorPos", "endAnchorPos"}},
	[1002000501] = {id = 1002000501, position_id = 10020005, default_revive_pos = {"Task_main_01", "playerBorn"}, scene_prefab = "Scene10020005/Scene10020005.prefab", name = "天月城", description = "天月城", map_id = 10020005, anchor_pos = {"WorldMap", "anchorPos", "endAnchorPos"}},
	[1002000301] = {id = 1002000301, position_id = 10020003, default_revive_pos = {}, scene_prefab = "Scene10020003/Scene10020003.prefab", name = "月灵研究中心", description = "资产测试场景", map_id = 1002000301, anchor_pos = {"WorldMap", "anchorPos", "endAnchorPos"}},
	[1002000302] = {id = 1002000302, position_id = 10020003, default_revive_pos = {}, scene_prefab = "Scene10020003/Scene10020003.prefab", name = "月灵研究中心2", description = "资产测试场景2", map_id = 1002000301, anchor_pos = {"WorldMap", "anchorPos", "endAnchorPos"}},
	[10020006] = {id = 10020006, position_id = 10020006, default_revive_pos = {"Asset_logic", "YuelingCenter_Enter"}, scene_prefab = "Scene10020006/Scene10020006_test.prefab", name = "月灵研究中心3", description = "资产测试场景3", map_id = 10020006, anchor_pos = {"WorldMap", "anchorPos", "endAnchorPos"}},
	[102650102] = {id = 102650102, position_id = 102650101, default_revive_pos = {"LogicStealth", "playerBorn"}, scene_prefab = "SceneStealth/SceneStealthTest3.prefab", name = "潜入关卡测试", description = "潜入关卡测试", map_id = 0, anchor_pos = {}},
	[90030001] = {id = 90030001, position_id = 90030001, default_revive_pos = {"", "BornPos_true"}, scene_prefab = "Scene90030001/temple1.prefab", name = "月灵神庙1", description = "月灵神庙1", map_id = 0, anchor_pos = {}},
	[90030009] = {id = 90030009, position_id = 90030009, default_revive_pos = {"", "pos1"}, scene_prefab = "SceneFight/SceneFight.prefab", name = "战斗白模测试", description = "战斗白模测试", map_id = 0, anchor_pos = {}},
}
	
