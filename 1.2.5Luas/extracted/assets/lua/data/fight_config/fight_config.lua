Config = Config or {}
Config.FightConfig = Config.FightConfig or {}
Config.FightConfig.Gravity = -20
local FightConfig = Config.FightConfig

FightConfig.SearchDegreeWeight = 
{
	{115, 0.07}, {125, 0.04}, {135, 0.01}
}

FightConfig.SearchDistanceWeight = 
{

}



-- 距离开方，36为6实际距离
FightConfig.SearchAimDistWeight = 
{
	{36, 0.3}, {10000000000, 1}
}

FightConfig.FontType =
{
	DAMAGE = 100,
	DAMAGE_TYPE1 = 101,
	DAMAGE_TYPE2 = 102,
	DAMAGE_TYPE3 = 103,
	DAMAGE_TYPE4 = 104,
	DAMAGE_TYPE5 = 105,
	DAMAGE_TYPE6 = 106,

	HEAL = 200, -- 治疗
}

FightConfig.FontInfo = 
{
	[FightConfig.FontType.DAMAGE_TYPE1] = {prefab = "dmg_type1", point = "HitCase", className = DmgType1FontAnimObj, },
	[FightConfig.FontType.DAMAGE_TYPE2] = {prefab = "dmg_type2", point = "HitCase", className = DmgType2FontAnimObj, wClassName = WDmgType2FontAnimObj},
	[FightConfig.FontType.DAMAGE_TYPE3] = {prefab = "dmg_type3", point = "HitCase", className = DmgType3FontAnimObj, wClassName = WDmgType3FontAnimObj},
	[FightConfig.FontType.DAMAGE_TYPE4] = {prefab = "dmg_type4", point = "HitCase", className = DmgType4FontAnimObj, wClassName = WDmgType4FontAnimObj},
	[FightConfig.FontType.DAMAGE_TYPE5] = {prefab = "dmg_type5", point = "HitCase", className = DmgType5FontAnimObj, wClassName = WDmgType5FontAnimObj},
	[FightConfig.FontType.DAMAGE_TYPE6] = {prefab = "dmg_type6", point = "HitCase", className = DmgType6FontAnimObj, wClassName = WDmgType6FontAnimObj},
	[FightConfig.FontType.HEAL] = {prefab = "dmg_type7", point = "HitCase", className = DmgType7FontAnimObj},
}

FightConfig.FontRangePosType = 
{
	PlayerDecHp = 1,
	MonsterDecHp = 2,
	AddHp = 3,
	Effect = 4,
}



FightConfig.EffectFontPoint = "HitCase"

FightConfig.EffectFont =
{
	[1] = {name = "毒"}, --中毒
	[2] = {name = "魅"}, --魅惑
	[3] = {name = "冻"}, --解冻
	[4] = {name = "烧"}, --燃烧
	[5] = {name = "虚"}, --虚弱
	[6] = {name = "不"}, --不屈
	[7] = {name = "护"}, --护佑
	[8] = {name = "专"}, --专注
	[9] = {name = "英"}, --英勇
	[10] = {name = "报"},--报复
	[11] = {name = "晕"},--报复
}

--与上一个飘字的最短距离，单位为米
FightConfig.FontMinDistance = 0.4



FightConfig.FontOffsetPos =
{
	[FightConfig.FontRangePosType.PlayerDecHp] = Vec3.New(0,0,0),
	[FightConfig.FontRangePosType.MonsterDecHp] = Vec3.New(0,0,0),
	[FightConfig.FontRangePosType.AddHp] = Vec3.New(0,0,0),
	[FightConfig.FontRangePosType.Effect] = Vec3.New(0,0,0),
}


--飘字的具体随机范围，单位为厘米
FightConfig.FontRangePos =
{
	[FightConfig.FontRangePosType.PlayerDecHp] = {rangeMinX = -50, rangeMaxX = 50, rangeMinY = -100, rangeMaxY = -50 },
	[FightConfig.FontRangePosType.MonsterDecHp] = {rangeMinX = -90, rangeMaxX = 90, rangeMinY = 50, rangeMaxY = 120},
	[FightConfig.FontRangePosType.AddHp] = {rangeMinX = -70, rangeMaxX = 70, rangeMinY = 40, rangeMaxY = 100},
	[FightConfig.FontRangePosType.Effect] = {rangeMinX = -50, rangeMaxX = 50, rangeMinY = 30, rangeMaxY = 60 },
}

FightConfig.SearchScreenWeight = 
{
	{0.25, 0.3}, {0.375, 0.2}, {0.5, 0.1}
}

function FightConfig.CalcSearchScreenParam(pos)
	pos = math.abs(pos - 0.5) 
	for _, v in ipairs(FightConfig.SearchScreenWeight) do
		if pos < v[1] then
			return v[2]
		end
	end

	return 0
end
