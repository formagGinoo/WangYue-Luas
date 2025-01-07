-- Automatically generated - do not edit.

Config = Config or {}
Config.DataPartnerSkill = Config.DataPartnerSkill or {}


local DataPartnerSkill = Config.DataPartnerSkill
DataPartnerSkill.FindLength = 33

DataPartnerSkill.FindbyPartnerId = {
}

DataPartnerSkill.Find = {
	[10112] = { id = 10112, type = 1, desc_brief = "可<color=#e89e1d>解锁</color>建筑物门锁、宝箱锁，用于打开通道、获得奖励等。\n提升佩从技能等级可以增加开锁时倒计时时间。", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/UnLockSkill.png", name = "开锁", priority = 998,},
	[10113] = { id = 10113, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11UltimateSkill.png", name = "隐身防御", priority = 997,},
	[10211] = { id = 10211, type = 1, desc_brief = "携带<color=#e89e1d>尾狐</color>时，可对范围内最近的一名敌人释放<color=#e89e1d>【魅惑】</color>，被魅惑的敌人<color=#e89e1d>失去行动能力</color>。\n脱战时释放能魅惑<color=#e89e1d>更长时间</color>。", fight_skills = {600060005,}, icon = "Textures/Icon/Single/SkillIcon/PartnerCharm.png", name = "心迷目眩", priority = 999,},
	[20111] = { id = 20111, type = 1, desc_brief = "<color=#e89e1d>脱战时</color>：携带<color=#e89e1d>石龙</color>，释放<color=#e89e1d>【潜行】</color>后角色变为石龙<color=#e89e1d>潜入地下</color>，<color=#e89e1d>无法被敌人察觉</color>。潜地期间再次释放或持续时间结束后，石龙破土而出并对周围的敌人<color=#e89e1d>造成范围伤害</color>。\n<color=#e89e1d>战斗中</color>：召唤<color=#e89e1d>石龙</color>向敌人发起<color=#e89e1d>【冲刺升龙】</color>，击飞敌人并造成伤害。", fight_skills = {610025011,610025002,}, icon = "Textures/Icon/Single/SkillIcon/PartnerHideDown.png", name = "潜行", priority = 999,},
	[20112] = { id = 20112, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11BlueSkill.png", name = "背部抵抗", priority = 998,},
	[20113] = { id = 20113, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", name = "消声", priority = 996,},
	[20211] = { id = 20211, type = 1, desc_brief = "携带<color=#e89e1d>精英从士</color>并处于战斗中时，释放<color=#e89e1d>【狂暴之怒】</color>后，<color=#e89e1d>携带角色</color>的攻击力提高", fight_skills = {61004006,}, icon = "Textures/Icon/Single/SkillIcon/PartnerGrowlSkill.png", name = "狂暴之怒", priority = 999,},
	[20212] = { id = 20212, type = 2, desc_brief = "", fight_skills = {61004005,}, icon = "Textures/Icon/Single/SkillIcon/PartnerSmashing.png", name = "闪避召唤", priority = 998,},
	[20341] = { id = 20341, type = 1, desc_brief = "携带<color=#e89e1d>箴石之劣</color>并处于脱战状态下，释放<color=#e89e1d>【骇入】</color>时，可骇入周遭环境的<color=#e89e1d>可交互物件</color>，拥有丰富的效果。\n可骇入的范围包括<color=#e89e1d>飞行器、怪物、人物</color>等，多多尝试或许会发现奇妙的用法。", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerHacking.png", name = "骇入", priority = 999,},
	[20342] = { id = 20342, type = 1, desc_brief = "携带<color=#e89e1d>箴石之劣</color>并处于脱战状态下，释放【骇入】时可切换至<color=#e89e1d>【建筑】</color>页签，可以在周边消耗<color=#e89e1d>【建造能源】</color>建造多样的建筑，可以多多尝试探索不同建筑的效果。", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerBuilddemo.png", name = "建造", priority = 999,},
	[30111] = { id = 30111, type = 1, desc_brief = "<color=#e89e1d>脱战时</color>：携带<color=#e89e1d>离歌</color>，在敌人背后且满足暗杀距离，可对敌人释放<color=#e89e1d>【刺杀】</color>，敌人血条<color=#e89e1d>红色部分</color>代表刺杀技能的<color=#e89e1d>最大伤害</color>\n白圈收缩到<color=#e89e1d>红色范围内</color>点击QTE按钮可释放<color=#e89e1d>完美刺杀</color>，造成最大伤害。\n<color=#e89e1d>战斗中</color>：召唤<color=#e89e1d>离歌</color>向敌人发起<color=#e89e1d>【冲刺上挑】</color>，击飞敌人并造成伤害。", fight_skills = {62001008,62001009,62001004,}, icon = "Textures/Icon/Single/SkillIcon/AssassinSkill.png", name = "刺杀", priority = 999,},
	[30112] = { id = 30112, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11BlueSkill.png", name = "背部抵抗", priority = 998,},
	[30113] = { id = 30113, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11UltimateSkill.png", name = "闷棍", priority = 997,},
	[30114] = { id = 30114, type = 2, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", name = "消声", priority = 996,},
	[40101] = { id = 40101, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill101.png", name = "元素爆发", priority = 991,},
	[40102] = { id = 40102, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill102.png", name = "物爆", priority = 990,},
	[40103] = { id = 40103, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill103.png", name = "闪爆", priority = 989,},
	[40104] = { id = 40104, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill104.png", name = "灵犀", priority = 988,},
	[40105] = { id = 40105, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill105.png", name = "穿透", priority = 987,},
	[40106] = { id = 40106, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill106.png", name = "追击", priority = 986,},
	[40201] = { id = 40201, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill201.png", name = "厚甲", priority = 985,},
	[40202] = { id = 40202, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill202.png", name = "体质", priority = 984,},
	[40203] = { id = 40203, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill203.png", name = "心炎", priority = 983,},
	[40204] = { id = 40204, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill204.png", name = "不屈", priority = 982,},
	[40205] = { id = 40205, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill205.png", name = "幸运", priority = 981,},
	[40206] = { id = 40206, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill206.png", name = "护佑", priority = 980,},
	[40207] = { id = 40207, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/PartnerSkill206.png", name = "报复", priority = 980,},
	[40301] = { id = 40301, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", name = "神农", priority = 979,},
	[40302] = { id = 40302, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", name = "专注", priority = 978,},
	[40303] = { id = 40303, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", name = "英勇", priority = 977,},
	[40304] = { id = 40304, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", name = "清心", priority = 976,},
	[40401] = { id = 40401, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", name = "施毒", priority = 976,},
	[40501] = { id = 40501, type = 3, desc_brief = "", fight_skills = {}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", name = "祛毒", priority = 976,},
}


return DataPartnerSkill
