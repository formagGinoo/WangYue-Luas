-- Automatically generated - do not edit.

Config = Config or {}
Config.DataHeroStageUpgrade = Config.DataHeroStageUpgrade or {}


local DataHeroStageUpgrade = Config.DataHeroStageUpgrade
DataHeroStageUpgrade.FindLength = 35

DataHeroStageUpgrade.FindDeblockSkillIdInfo = {
	[100109] = { stage = 1,},
	[100209] = { stage = 1,},
	[100509] = { stage = 1,},
	[100609] = { stage = 1,},
}

DataHeroStageUpgrade.Find = {
	["1001001_0"] = { id = 1001001, stage = 0, condition = 0, deblock_skill_id = 0, limit_hero_lev = 20, limit_hero_skill_lev = 2, need_gold = 0, need_item = {}, stage_info = {},},
	["1001001_1"] = { id = 1001001, stage = 1, condition = 0, deblock_skill_id = 100109, limit_hero_lev = 30, limit_hero_skill_lev = 4, need_gold = 10000, need_item = {{20151,3,},{10336,3,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>2</color>级","解锁天赋<color=#e89e1d>酉之余烬</color>","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001001_2"] = { id = 1001001, stage = 2, condition = 100102, deblock_skill_id = 0, limit_hero_lev = 40, limit_hero_skill_lev = 6, need_gold = 20000, need_item = {{20151,6,},{10336,10,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>4</color>级","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001001_3"] = { id = 1001001, stage = 3, condition = 100103, deblock_skill_id = 0, limit_hero_lev = 50, limit_hero_skill_lev = 7, need_gold = 30000, need_item = {{20152,3,},{10336,20,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>5</color>级","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001001_4"] = { id = 1001001, stage = 4, condition = 100104, deblock_skill_id = 0, limit_hero_lev = 60, limit_hero_skill_lev = 8, need_gold = 40000, need_item = {{20152,6,},{10336,30,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>6</color>级","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001001_5"] = { id = 1001001, stage = 5, condition = 100105, deblock_skill_id = 0, limit_hero_lev = 70, limit_hero_skill_lev = 9, need_gold = 50000, need_item = {{20153,3,},{10336,40,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>8</color>级","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001001_6"] = { id = 1001001, stage = 6, condition = 100106, deblock_skill_id = 0, limit_hero_lev = 80, limit_hero_skill_lev = 10, need_gold = 60000, need_item = {{20153,6,},{10336,50,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>10</color>级","突破属性-攻击力<color=#e89e1d>+5%</color>",},},
	["1001002_0"] = { id = 1001002, stage = 0, condition = 0, deblock_skill_id = 0, limit_hero_lev = 20, limit_hero_skill_lev = 2, need_gold = 0, need_item = {}, stage_info = {},},
	["1001002_1"] = { id = 1001002, stage = 1, condition = 0, deblock_skill_id = 100209, limit_hero_lev = 30, limit_hero_skill_lev = 4, need_gold = 10000, need_item = {{20121,3,},{10334,3,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>2</color>级","解锁天赋<color=#e89e1d>闪灵宗浪徒</color>","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001002_2"] = { id = 1001002, stage = 2, condition = 100102, deblock_skill_id = 0, limit_hero_lev = 40, limit_hero_skill_lev = 6, need_gold = 20000, need_item = {{20121,6,},{10334,10,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>4</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001002_3"] = { id = 1001002, stage = 3, condition = 100103, deblock_skill_id = 0, limit_hero_lev = 50, limit_hero_skill_lev = 7, need_gold = 30000, need_item = {{20122,3,},{10334,20,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>5</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001002_4"] = { id = 1001002, stage = 4, condition = 100104, deblock_skill_id = 0, limit_hero_lev = 60, limit_hero_skill_lev = 8, need_gold = 40000, need_item = {{20122,6,},{10334,30,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>6</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001002_5"] = { id = 1001002, stage = 5, condition = 100105, deblock_skill_id = 0, limit_hero_lev = 70, limit_hero_skill_lev = 9, need_gold = 50000, need_item = {{20123,3,},{10334,40,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>8</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001002_6"] = { id = 1001002, stage = 6, condition = 100106, deblock_skill_id = 0, limit_hero_lev = 80, limit_hero_skill_lev = 10, need_gold = 60000, need_item = {{20123,6,},{10334,50,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>10</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_0"] = { id = 1001003, stage = 0, condition = 0, deblock_skill_id = 0, limit_hero_lev = 20, limit_hero_skill_lev = 2, need_gold = 0, need_item = {}, stage_info = {},},
	["1001003_1"] = { id = 1001003, stage = 1, condition = 0, deblock_skill_id = 0, limit_hero_lev = 30, limit_hero_skill_lev = 4, need_gold = 10000, need_item = {{20121,3,},{10334,3,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>2</color>级","解锁天赋<color=#e89e1d>闪灵宗浪徒</color>","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_2"] = { id = 1001003, stage = 2, condition = 100102, deblock_skill_id = 0, limit_hero_lev = 40, limit_hero_skill_lev = 6, need_gold = 20000, need_item = {{20121,6,},{10334,10,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>4</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_3"] = { id = 1001003, stage = 3, condition = 100103, deblock_skill_id = 0, limit_hero_lev = 50, limit_hero_skill_lev = 7, need_gold = 30000, need_item = {{20122,3,},{10334,20,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>5</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_4"] = { id = 1001003, stage = 4, condition = 100104, deblock_skill_id = 0, limit_hero_lev = 60, limit_hero_skill_lev = 8, need_gold = 40000, need_item = {{20122,6,},{10334,30,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>6</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_5"] = { id = 1001003, stage = 5, condition = 100105, deblock_skill_id = 0, limit_hero_lev = 70, limit_hero_skill_lev = 9, need_gold = 50000, need_item = {{20123,3,},{10334,40,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>8</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001003_6"] = { id = 1001003, stage = 6, condition = 100106, deblock_skill_id = 0, limit_hero_lev = 80, limit_hero_skill_lev = 10, need_gold = 60000, need_item = {{20123,6,},{10334,50,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>10</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_0"] = { id = 1001005, stage = 0, condition = 0, deblock_skill_id = 0, limit_hero_lev = 20, limit_hero_skill_lev = 2, need_gold = 0, need_item = {}, stage_info = {},},
	["1001005_1"] = { id = 1001005, stage = 1, condition = 0, deblock_skill_id = 100509, limit_hero_lev = 30, limit_hero_skill_lev = 4, need_gold = 10000, need_item = {{20161,3,},{10336,3,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>2</color>级","解锁天赋<color=#e89e1d>闪灵宗浪徒</color>","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_2"] = { id = 1001005, stage = 2, condition = 100102, deblock_skill_id = 0, limit_hero_lev = 40, limit_hero_skill_lev = 6, need_gold = 20000, need_item = {{20161,6,},{10336,10,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>4</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_3"] = { id = 1001005, stage = 3, condition = 100103, deblock_skill_id = 0, limit_hero_lev = 50, limit_hero_skill_lev = 7, need_gold = 30000, need_item = {{20162,3,},{10336,20,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>5</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_4"] = { id = 1001005, stage = 4, condition = 100104, deblock_skill_id = 0, limit_hero_lev = 60, limit_hero_skill_lev = 8, need_gold = 40000, need_item = {{20162,6,},{10336,30,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>6</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_5"] = { id = 1001005, stage = 5, condition = 100105, deblock_skill_id = 0, limit_hero_lev = 70, limit_hero_skill_lev = 9, need_gold = 50000, need_item = {{20163,3,},{10336,40,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>8</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001005_6"] = { id = 1001005, stage = 6, condition = 100106, deblock_skill_id = 0, limit_hero_lev = 80, limit_hero_skill_lev = 10, need_gold = 60000, need_item = {{20163,6,},{10336,50,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>10</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_0"] = { id = 1001006, stage = 0, condition = 0, deblock_skill_id = 0, limit_hero_lev = 20, limit_hero_skill_lev = 2, need_gold = 0, need_item = {}, stage_info = {},},
	["1001006_1"] = { id = 1001006, stage = 1, condition = 0, deblock_skill_id = 100609, limit_hero_lev = 30, limit_hero_skill_lev = 4, need_gold = 10000, need_item = {{20131,3,},{10334,3,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>2</color>级","解锁天赋<color=#e89e1d>闪灵宗浪徒</color>","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_2"] = { id = 1001006, stage = 2, condition = 100102, deblock_skill_id = 0, limit_hero_lev = 40, limit_hero_skill_lev = 6, need_gold = 20000, need_item = {{20131,6,},{10334,10,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>4</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_3"] = { id = 1001006, stage = 3, condition = 100103, deblock_skill_id = 0, limit_hero_lev = 50, limit_hero_skill_lev = 7, need_gold = 30000, need_item = {{20132,3,},{10334,20,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>5</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_4"] = { id = 1001006, stage = 4, condition = 100104, deblock_skill_id = 0, limit_hero_lev = 60, limit_hero_skill_lev = 8, need_gold = 40000, need_item = {{20132,6,},{10334,30,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>6</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_5"] = { id = 1001006, stage = 5, condition = 100105, deblock_skill_id = 0, limit_hero_lev = 70, limit_hero_skill_lev = 9, need_gold = 50000, need_item = {{20133,3,},{10334,40,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>8</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
	["1001006_6"] = { id = 1001006, stage = 6, condition = 100106, deblock_skill_id = 0, limit_hero_lev = 80, limit_hero_skill_lev = 10, need_gold = 60000, need_item = {{20133,6,},{10334,50,},}, stage_info = {"技能等级上限提升至<color=#e89e1d>10</color>级","突破属性-暴击率<color=#e89e1d>+5%</color>",},},
}


return DataHeroStageUpgrade
