-- Automatically generated - do not edit.

Config = Config or {}
Config.DataAbilityMain = Config.DataAbilityMain or {}


local DataAbilityMain = Config.DataAbilityMain
DataAbilityMain.FindLength = 7

DataAbilityMain.FindbySkillType = {
	[1] = { [101] = 101, [102] = 102, [103] = 103, [104] = 104, [201] = 201, [301] = 301,},
	[2] = { [105] = 105,},
}

DataAbilityMain.Find = {
	[101] = { cool = 5.0, desc = "释放<color=#e06a02>【骇入】</color>时，可骇入周遭环境的<color=#e06a02>可交互物件</color>，拥有丰富的效果。\n可骇入的范围包括<color=#e06a02>飞行器、怪物、人物</color>等，多多尝试或许会发现奇妙的用法。", icon = "Textures/Icon/Single/SkillIcon/PartnerHacking.png", id = 101, is_hide_tips = true, name = "骇入", partner = {3001041,3001042,3001043,3001044,3001045,}, priority = 999, skill_id = 60008000, skill_type = 1, type = 1, video = "Prefabs/UI/Video/Tips_SHacking.prefab",},
	[102] = { cool = 5.0, desc = "释放【建造】时，可以在周边消耗<color=#e06a02>【建造能源】</color>建造多样的建筑，可以多多尝试探索不同建筑的效果。", icon = "Textures/Icon/Single/SkillIcon/PartnerBuilddemo.png", id = 102, name = "建造", partner = {3001041,3001042,3001043,3001044,3001045,}, priority = 998, skill_id = 60008000, skill_type = 1, type = 1, video = "Prefabs/UI/Video/Tips_SBuild.prefab",},
	[103] = { cool = 5.0, desc = "释放【潜地】后，角色将变身色金若龙<color=#e06a02>潜入地下，无法被敌人察觉</color>。", icon = "Textures/Icon/Single/SkillIcon/PartnerHideDown.png", id = 103, name = "潜地", partner = {3002012,3002013,3002014,3002015,}, priority = 997, skill_id = 610025005, skill_type = 1, type = 1, video = "Prefabs/UI/Video/Tips_SDive.prefab",},
	[104] = { cool = 5.0, desc = "【蓝图】记录各类建造物和建造物组合，使用后能够瞬间重现记录的建造物。建造物和各类组合可拍照获得。", icon = "Textures/Icon/Single/SkillIcon/pictureLantu.png", id = 104, is_hide_tips = true, name = "蓝图", partner = {3001041,3001042,3001043,3001044,3001045,}, priority = 996, skill_id = 60008000, skill_type = 1, type = 1, video = "Prefabs/UI/Video/Tips_SBuleprint.prefab",},
	[105] = { desc = "装备【远程专精】时，角色造成的远程伤害会得到一定程度的提升。\n（被动技尚未开发，此处占位）", icon = "Textures/Icon/Single/SkillIcon/PartnerAiming.png", id = 105, name = "远程专精", partner = {3001031,3001032,3001033,3001034,3001035,}, priority = 995, skill_type = 2, type = 1, video = "Prefabs/UI/Video/Tips_MZhenshizhilie.prefab",},
	[201] = { desc = "释放【拍照】后，可以拍摄并保存图片。", icon = "Textures/Icon/Single/FuncIcon/System_photo.png", id = 201, name = "拍照", priority = 989, skill_type = 1, type = 2, video = "Prefabs/UI/Video/Tips_SPhoto.prefab",},
	[301] = { desc = "释放【叫车】后，可以唤出叫车界面，在该界面可以呼叫车辆至玩家位置。", icon = "Textures/Icon/Single/FuncIcon/System_car.png", id = 301, name = "叫车", priority = 988, skill_type = 1, type = 3, video = "Prefabs/UI/Video/Tips_SVehicle.prefab",},
}


return DataAbilityMain
