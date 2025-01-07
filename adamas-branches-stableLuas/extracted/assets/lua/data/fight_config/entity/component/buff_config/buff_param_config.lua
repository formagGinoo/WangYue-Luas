Config = Config or {}
Config.BuffParamConfig = Config.BuffParamConfig or {}

Config.BuffParamConfig[2001] = {
	Groups = {1,2,3},
	Kind = 2,
	Duration = 500,
	MagicId = 12001,
}

--标准化Buff
Config.BuffParamConfig[1000000] = { --角色闪避期间无敌效果
	Groups = {1,2,3},
	Kind = 1000000,
	Duration = 5000,
	MagicId = 1000001,
}
Config.BuffParamConfig[1000002] = { --非极限闪避对怪对角色减速Buff
	Groups = {1,2,3},
	Kind = 1000002,
	Duration = 1700,
	MagicId = 1000003,
}
Config.BuffParamConfig[1000004] = { --极限闪避对怪减速Buff
	Groups = {1,2,3},
	Kind = 1000004,
	Duration = 30000,
	MagicId = 1000005,
}
Config.BuffParamConfig[1000006] = { --极限闪避后2秒内免疫子弹受击 Magic / Buff
	Groups = {1,2,3},
	Kind = 1000006,
	Duration = 30000,
	MagicId = 1000007,
}
Config.BuffParamConfig[1000008] = { --极限闪避时间内怪物逻辑和实体时间暂停，免疫受击
	Groups = {1,2,3},
	Kind = 1000008,
	Duration = 30000,
	MagicId = 1000009,
}
Config.BuffParamConfig[1000012] = { --死亡切换人暂时免疫伤害和受击
	Groups = {1,2,3},
	Kind = 1000012,
	Duration = 20000,
	MagicId = 1000013,
}




Config.BuffParamConfig[1001001] = {
	Groups = {1,2,3},
	Kind = 2,
	Duration = 1500,
	MagicId = 1001002,
}

Config.BuffParamConfig[1001003] = {
	Groups = {1,2,3},
	Kind = 2,
	Duration = 400,
	MagicId = 1001004,
}

Config.BuffParamConfig[1001005] = {
	Groups = {1,2,3},
	Kind = 2,
	Duration = 600,
	MagicId = 1001006,
}


--叙慕Buff配置
Config.BuffParamConfig[1003030] = {--角色闪避期间无敌效果1
	Groups = {1,2,3},
	Kind = 1003030,
	Duration = 4000,
	MagicId = 1003031,
}
Config.BuffParamConfig[1003032] = {--角色闪避期间无敌效果2
	Groups = {1,2,3},
	Kind = 1003032,
	Duration = 5000,
	MagicId = 1003031,
}
Config.BuffParamConfig[1003043] = { --核心技能免疫受击
	Groups = {1,2,3},
	Kind = 1003043,
	Duration = 8000,
	MagicId = 1003044,
}
Config.BuffParamConfig[1003045] = { --核心被动武器特效1
	Groups = {1,2,3},
	Kind = 1003045,
	Duration = 99990000,
	Effect = "Character/Role/XumuR11/Common/Effect/XumuR11FxPassiveBuffwuqi_001.prefab",
	EffectBone = "wuqi_001",
	EffectKind = 1003045,
}
Config.BuffParamConfig[1003047] = { --核心被动武器特效2
	Groups = {1,2,3},
	Kind = 1003047,
	Duration = 99990000,
	Effect = "Character/Role/XumuR11/Common/Effect/XumuR11FxPassiveBuffwuqi_003.prefab",
	EffectBone = "wuqi_003",
	EffectKind = 1003048,
}
Config.BuffParamConfig[1003050] = { --闪避反击免疫受击
	Groups = {1,2,3},
	Kind = 1003050,
	Duration = 15330,
	MagicId = 1003051,
}
Config.BuffParamConfig[1003060] = { --QTE免疫受击
	Groups = {1,2,3},
	Kind = 1003060,
	Duration = 11000,
	MagicId = 1003061,
}
Config.BuffParamConfig[1003070] = { --大招无敌buff
	Groups = {1,2,3},
	Kind = 1003070,
	Duration = 30000,
	MagicId = 1003071,
}
Config.BuffParamConfig[1003080] = { --红色技能顿帧
	Groups = {1,2,3},
	Kind = 1003080,
	Duration = 1200,
	MagicId = 1003081,
}
Config.BuffParamConfig[1003087] = { --核心技能免疫碰撞
	Groups = {1,2,3},
	Kind = 1003087,
	Duration = 3000,
	MagicId = 1003088,
}
Config.BuffParamConfig[1003089] = { --核心攻击残影顿帧1
	Groups = {1,2,3},
	Kind = 1003089,
	Duration = 400,
	MagicId = 1003090,
}
Config.BuffParamConfig[1003092] = { --核心技能隐藏骨骼
	Groups = {1,2,3},
	Kind = 1003092,
	Duration = 700,
	MagicId = 1003093,
}
Config.BuffParamConfig[1003094] = { --核心攻击残影顿帧2
	Groups = {1,2,3},
	Kind = 1003094,
	Duration = 1000,
	MagicId = 1003090,
}
Config.BuffParamConfig[1003095] = { --核心攻击残影顿帧3
	Groups = {1,2,3},
	Kind = 1003095,
	Duration = 1300,
	MagicId = 1003090,
}
Config.BuffParamConfig[1003098] = { --全屏特效
	Groups = {1,2,3},
	Kind = 1003098,
	Duration = 150000,
	MagicId = 1003099,
}






--刻刻Buff配置
Config.BuffParamConfig[1004003] = { --角色闪避期间无敌效果1
	Groups = {1,2,3},
	Kind = 1000000, --同通用角色闪避无敌
	Duration = 4000,
	MagicId = 1004004,
}
Config.BuffParamConfig[1004005] = { --角色闪避期间无敌效果2
	Groups = {1,2,3},
	Kind = 1000000, --同通用角色闪避无敌
	Duration = 6000,
	MagicId = 1004004,
}
Config.BuffParamConfig[1004005] = { --角色闪避期间无敌效果2
	Groups = {1,2,3},
	Kind = 1000000, --同通用角色闪避无敌
	Duration = 6000,
	MagicId = 1004004,
}
Config.BuffParamConfig[1004012] = { --红色技能免疫受击
	Groups = {1,2,3},
	Kind = 1004012,
	Duration = 6000,
	MagicId = 1004013,
}
Config.BuffParamConfig[1004023] = { --蓝色技能武器特效1
	Groups = {1,2,3},
	Kind = 1004023,
	Duration = 99990000,
	Effect = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk020PistolR1M1.prefab",
	EffectBone = "PistolR1M1",
	EffectKind = 1004023,
}
Config.BuffParamConfig[1004025] = { --蓝色技能武器特效2
	Groups = {1,2,3},
	Kind = 1004025,
	Duration = 99990000,
	Effect = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk020PistolR1M11.prefab",
	EffectBone = "PistolR1M11",
	EffectKind = 1004025,
}
Config.BuffParamConfig[1004041] = { --核心技能状态且隐藏骨骼
	Groups = {1,2,3},
	Kind = 1004041,
	Duration = 90000,
	MagicId = 1004042,
}
Config.BuffParamConfig[1004045] = { --核心技能状态免疫受击
	Groups = {1,2,3},
	Kind = 1004045,
	Duration = 100000,
	MagicId = 1004046,
}
Config.BuffParamConfig[1004053] = { --闪避反击免疫受击
	Groups = {1,2,3},
	Kind = 1004053,
	Duration = 13000,
	MagicId = 1004054,
}
Config.BuffParamConfig[1004060] = { --QTE反击免疫受击
	Groups = {1,2,3},
	Kind = 1004060,
	Duration = 12000,
	MagicId = 1004061,
}
Config.BuffParamConfig[1004070] = { --大招状态特效
	Groups = {1,2,3},
	Kind = 1004070,
	Duration = 108000,
	Effect = "Character/Role/KekeR21/Common/Effect/KekeR21FxAtk070Bip001.prefab",
	EffectBone = "HitCase",
	EffectKind = 1004070,
}
Config.BuffParamConfig[1004073] = { --大招无敌buff
	Groups = {1,2,3},
	Kind = 1004073,
	Duration = 8000,
	MagicId = 1004074,
}
Config.BuffParamConfig[1004082] = { --全屏特效
	Groups = {1,2,3},
	Kind = 1004082,
	Duration = 150000,
	MagicId = 1004082,
}





--维修机器人
Config.BuffParamConfig[9001003] = { --免疫受击
	Groups = {1,2,3},
	Kind = 9001003,
	Duration = 99990000,
	MagicId = 9001004,
}




--蜥蜴人Buff配置
Config.BuffParamConfig[900020001] = { --石头显示
	Groups = {1,2,3},
	Kind = 900020001,
	Duration = 1,
	MagicId = 900020002,
}

--主线关卡Buff配置
Config.BuffParamConfig[200100101002] = { --主线关卡第一关时间暂停
	Groups = {1,2,3},
	Kind = 200100101002,
	Duration = 9999999999999,
	MagicId = 200100101001,
}

Config.BuffParamConfig[200100101004] = { --主线关卡第一关暂停角色行为树
	Groups = {1,2,3},
	Kind = 200100101004,
	Duration = 9999999999999,
	MagicId = 200100101003,
}

Config.BuffParamConfig[200100101006] = { --测试怪无敌
	Groups = {1,2,3},
	Kind = 200100101006,
	Duration = 9999999999999,
	MagicId = 200100101005,
}

--蜥蜴人精英怪Buff
Config.BuffParamConfig[910025001] = { --钻地期间无敌
	Groups = {1,2,3},
	Kind = 910025001,
	Duration = 9999999999999,
	MagicId = 1000001,
}
--怪物通用免疫受击
Config.BuffParamConfig[900000001] = { --免疫受击
	Groups = {1,2,3},
	Kind = 900000001,
	Duration = 9999999999999,
	MagicId = 900000001,
}
--怪物通用韧性破除眩晕（临时测试）
Config.BuffParamConfig[900000002] = {
	Groups = {1,2,3},
	Kind = 900000002,
	Duration = 50000,
	MagicId = 900000004,
	Effect = "Effect/CommonBuff/FxDazed.prefab",
	Offset = {x=0,y=2.2,z=0},
	EffectKind = 900000002,
}
--韧性破除顿帧
Config.BuffParamConfig[900000003] = { 
	Groups = {1,2,3},
	Kind = 900000003,
	Duration = 4000,
	MagicId = 900000006,
}
