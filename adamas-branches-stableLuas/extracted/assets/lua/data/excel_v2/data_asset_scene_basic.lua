-- Automatically generated - do not edit.

Config = Config or {}
Config.DataAssetSceneBasic = Config.DataAssetSceneBasic or {}


local DataAssetSceneBasic = Config.DataAssetSceneBasic
DataAssetSceneBasic.FindLength = 3
DataAssetSceneBasic.Find = {
	["1001_1001001"] = {id = 1001, device_id = 1001001, coordinate = "Vector3(65,-1.3,-50)", toward = "Vector3(0,-45,0)"},
	["1001_1001004"] = {id = 1001, device_id = 1001004, coordinate = "Vector3(43,-1.3,-65)", toward = "Vector3(0,0,0)"},
	["1001_1001005"] = {id = 1001, device_id = 1001005, coordinate = "Vector3(34,-1.3,-65)", toward = "Vector3(0,0,0)"},
}
	
local DataAssetSceneBasic = Config.DataAssetSceneBasic
DataAssetSceneBasic.GetInitDecorationListByAssetIdLength = 1
DataAssetSceneBasic.GetInitDecorationListByAssetId = {
	[1001] = {1001001, 1001004, 1001005},
}
	

return DataAssetSceneBasic
