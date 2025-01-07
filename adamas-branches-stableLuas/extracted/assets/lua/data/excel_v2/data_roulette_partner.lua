-- Automatically generated - do not edit.

Config = Config or {}
Config.DataRoulettePartner = Config.DataRoulettePartner or {}


local DataRoulettePartner = Config.DataRoulettePartner
DataRoulettePartner.FindLength = 2

DataRoulettePartner.FindbyOptionalList = {
	[3001041] = { [1] = 1,},
	[3001042] = { [1] = 1,},
	[3001043] = { [1] = 1,},
	[3001044] = { [1] = 1,},
	[3002012] = { [2] = 2,},
	[3002013] = { [2] = 2,},
	[3002014] = { [2] = 2,},
	[3002015] = { [2] = 2,},
}

DataRoulettePartner.RoulettePartnerSkillLinkAbilityData = {
	[101] = 10411,
	[102] = 10421,
	[103] = 20111,
	[104] = 10451,
}

DataRoulettePartner.Find = {
	[1] = { id = 1, name = "箴石之劣", optional_list = {3001041,3001042,3001043,3001044,}, partner_skill_link_ability = {{10411,101,},{10421,102,},{10451,104,},}, unselected_icon = "Textures/Icon/Single/Partner/ability_zhenshizhilie.png",},
	[2] = { id = 2, name = "若金石龙", optional_list = {3002012,3002013,3002014,3002015,}, partner_skill_link_ability = {{20111,103,},}, unselected_icon = "Textures/Icon/Single/Partner/ability_shilong.png",},
}


return DataRoulettePartner
