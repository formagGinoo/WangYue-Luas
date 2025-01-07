-- Automatically generated - do not edit.

Config = Config or {}
Config.DataSkill = Config.DataSkill or {}


local DataSkill = Config.DataSkill
DataSkill.FindLength = 52

DataSkill.FindbyRoleId = {
	[1001001] = { [100101] = 100101, [100102] = 100102, [100103] = 100103, [100104] = 100104, [100105] = 100105, [100106] = 100106, [100107] = 100107, [100108] = 100108, [100109] = 100109, [100151] = 100151, [100152] = 100152, [100153] = 100153, [100154] = 100154,},
	[1001002] = { [100201] = 100201, [100202] = 100202, [100203] = 100203, [100204] = 100204, [100205] = 100205, [100206] = 100206, [100207] = 100207, [100208] = 100208, [100209] = 100209, [100251] = 100251, [100252] = 100252, [100253] = 100253, [100254] = 100254,},
	[1001005] = { [100501] = 100501, [100502] = 100502, [100503] = 100503, [100504] = 100504, [100505] = 100505, [100506] = 100506, [100507] = 100507, [100508] = 100508, [100509] = 100509, [100551] = 100551, [100552] = 100552, [100553] = 100553, [100554] = 100554,},
	[1001006] = { [100601] = 100601, [100602] = 100602, [100603] = 100603, [100604] = 100604, [100605] = 100605, [100606] = 100606, [100607] = 100607, [100608] = 100608, [100609] = 100609, [100651] = 100651, [100652] = 100652, [100653] = 100653, [100654] = 100654,},
}

DataSkill.FindFightSkillsInfo = {
	[1001001] = { id = 100101,},
	[1001002] = { id = 100101,},
	[1001003] = { id = 100101,},
	[1001004] = { id = 100101,},
	[1001005] = { id = 100101,},
	[1001010] = { id = 100102,},
	[1001011] = { id = 100102,},
	[1001012] = { id = 100102,},
	[1001044] = { id = 100104,},
	[1001051] = { id = 100103,},
	[1001080] = { id = 100107,},
	[1001081] = { id = 100107,},
	[1001082] = { id = 100107,},
	[1002001] = { id = 100201,},
	[1002002] = { id = 100201,},
	[1002003] = { id = 100201,},
	[1002004] = { id = 100201,},
	[1002005] = { id = 100201,},
	[1002010] = { id = 100202,},
	[1002011] = { id = 100202,},
	[1002012] = { id = 100202,},
	[1002013] = { id = 100202,},
	[1002051] = { id = 100203,},
	[1002060] = { id = 100202,},
	[1002080] = { id = 100207,},
	[1002081] = { id = 100207,},
}

DataSkill.Find = {
	[100101] = { id = 100101, role_id = 1001001, desc_brief = "<color=#e89e1d>五段</color>近战攻击，手执利刃，左右手交替进行挥砍攻击；或双手组合，释放瞬身连斩，造成<color=#e89e1d>火属性伤害</color>。\n仍然被身体记得的战斗剑术，杀伐果断，属不留之剑。", fight_skills = {1001001,1001002,1001003,1001004,1001005,}, icon = "Textures/Icon/Single/SkillIcon/XumuR11Attack.png", level_limit = 10, name = "青乌剑伐", ui_type = 42, unlock_type = 1, video = "Prefabs/UI/Video/UIXumuAttack.prefab",},
	[100102] = { id = 100102, role_id = 1001001, desc_brief = "消耗<color=#e89e1d>日相/月相能量</color>，向目标释放突进斩，随手手执利刃高速回旋，造成<color=#e89e1d>火属性伤害</color>并<color=#e89e1d>点燃</color>目标。\n青乌术的起手式，简单的引火之术。", fight_skills = {1001010,1001011,1001012,}, icon = "Textures/Icon/Single/SkillIcon/XumuR11BlueSkill.png", level_limit = 10, name = "青乌术·起", ui_type = 41, unlock_type = 1, video = "Prefabs/UI/Video/UIXumuSkill.prefab",},
	[100103] = { id = 100103, role_id = 1001001, desc_brief = "敌人<color=#e89e1d>弱点槽</color>积累满时可释放。释放时，向前方放出<color=#e89e1d>坠火踏破</color>：对路径上的敌人造成<color=#e89e1d>火属性伤害</color>，持续时间结束时爆发，额外造成<color=#e89e1d>火属性范围伤害</color>。\n忘记了本来绝技，只能粗暴地将火焰乱作一团的战法。", fight_skills = {1001051,}, icon = "Textures/Icon/Single/SkillIcon/XumuR11UltimateSkill.png", level_limit = 10, name = "坠火踏破", ui_type = 32, unlock_type = 1, video = "Prefabs/UI/Video/UIXumuCriSkill.prefab",},
	[100104] = { id = 100104, role_id = 1001001, desc_brief = "战技命中敌人时获得一层<color=#e89e1d>炎印</color>，最多储存三层。可消耗三层<color=#e89e1d>炎印</color>，<color=#e89e1d>长按</color>普攻释放：造成<color=#e89e1d>火属性范围伤害</color>，随后遁入剑影，造成多段<color=#e89e1d>火属性伤害</color>，大幅增长敌人的<color=#e89e1d>弱点槽</color>。\n火光明灭，残芒寂日，这样的战斗方式似乎早已被铭刻在身体中。", fight_skills = {1001044,}, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 10, name = "青乌术·明灭", ui_type = 22, unlock_type = 1, video = "Prefabs/UI/Video/Guide_Core.prefab",},
	[100105] = { id = 100105, role_id = 1001001, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/XumuR11Attack.png", level_limit = 1, name = "青乌剑断", ui_type = 13, unlock_type = 1, video = "Prefabs/UI/Video/Guide_ReboundAttack.prefab",},
	[100106] = { id = 100106, role_id = 1001001, icon = "Textures/Icon/Single/SkillIcon/XumuR11Move.png", level_limit = 1, name = "念虚领域", ui_type = 12, unlock_type = 1, video = "Prefabs/UI/Video/Guide_Dodge2.prefab",},
	[100107] = { id = 100107, role_id = 1001001, fight_skills = {1001080,1001081,1001082,}, icon = "Textures/Icon/Single/SkillIcon/Jump.png", level_limit = 1, name = "青乌剑·荡决", ui_type = 11, unlock_type = 1, video = "Prefabs/UI/Video/Guide_jump.prefab",},
	[100108] = { id = 100108, role_id = 1001001, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "焚火相", ui_type = 23, unlock_type = 1,},
	[100109] = { id = 100109, role_id = 1001001, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "酉之余烬", ui_type = 43, unlock_type = 2,},
	[100151] = { id = 100151, role_id = 1001001, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "风", ui_type = 33, unlock_type = 3,},
	[100152] = { id = 100152, role_id = 1001001, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "花", ui_type = 31, unlock_type = 3,},
	[100153] = { id = 100153, role_id = 1001001, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "雪", ui_type = 33, unlock_type = 3,},
	[100154] = { id = 100154, role_id = 1001001, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "月", ui_type = 34, unlock_type = 3,},
	[100201] = { id = 100201, role_id = 1001002, desc_brief = "点按进行至多<color=#e89e1d>五段</color>远程射击，<color=#e89e1d>长按</color>进入<color=#e89e1d>瞄准状态</color>：视野发生变化，并可以看到<color=#e89e1d>怪物弱点</color>，向弱点射击可造成<color=#e89e1d>击破</color>，打断怪物技能，造成高额伤害。\n刻刻的战斗理念在于实用，射击无章法，故称自由。", fight_skills = {1002001,1002002,1002003,1002004,1002005,}, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 10, name = "自由射击", ui_type = 42, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeAttack.prefab",},
	[100202] = { id = 100202, role_id = 1001002, desc_brief = "消耗<color=#e89e1d>日相/月相能量</color>，先后向目标扔出两把手枪，命中目标时造成<color=#e89e1d>金元素伤害</color>。\n闪灵宗学徒级别的引雷术。", fight_skills = {1002010,1002011,1002012,1002013,1002060,}, icon = "Textures/Icon/Single/SkillIcon/KekeR21UltimateSkill.png", level_limit = 10, name = "闪灵乱击", ui_type = 41, unlock_type = 1,},
	[100203] = { id = 100203, role_id = 1001002, desc_brief = "敌人<color=#e89e1d>弱点槽</color>积累满时可释放。释放时，召唤跟随角色行动的<color=#e89e1d>绶印闪雷</color>，<color=#e89e1d>切换角色不会消失</color>，存在期间内，会持续对敌人降下<color=#e89e1d>雷棱</color>，造成<color=#e89e1d>金元素伤害</color>。\n刻刻在离开宗门之前，从师傅手上获得的绶印，以此来弥补自己不成器的能力。", fight_skills = {1002051,}, icon = "Textures/Icon/Single/SkillIcon/KekeR21BlueSkill.png", level_limit = 10, name = "绶印闪雷", ui_type = 32, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeCriSkill.prefab",},
	[100204] = { id = 100204, role_id = 1001002, desc_brief = "普攻<color=#e89e1d>第五段</color>命中后，下次释放战技强化，并且获得1/3<color=#e89e1d>意念槽</color>充能。充能满时，<color=#e89e1d>长按</color>普攻进入<color=#e89e1d>移动射击</color>状态：持续消耗<color=#e89e1d>意念槽</color>，可以在瞄准同时移动人物。", icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 10, name = "闪灵射术", ui_type = 22, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeSpeSkill.prefab",},
	[100205] = { id = 100205, role_id = 1001002, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "自由斗术", ui_type = 13, unlock_type = 1,},
	[100206] = { id = 100206, role_id = 1001002, icon = "Textures/Icon/Single/SkillIcon/KekeR21Move.png", level_limit = 1, name = "念虚领域", ui_type = 12, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeDodge.prefab",},
	[100207] = { id = 100207, role_id = 1001002, fight_skills = {1002080,1002081,}, icon = "Textures/Icon/Single/SkillIcon/Jump.png", level_limit = 1, name = "快速绶印", ui_type = 11, unlock_type = 1,},
	[100208] = { id = 100208, role_id = 1001002, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "闪金相", ui_type = 23, unlock_type = 1,},
	[100209] = { id = 100209, role_id = 1001002, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "闪灵宗浪徒", ui_type = 43, unlock_type = 2,},
	[100251] = { id = 100251, role_id = 1001002, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "天", ui_type = 33, unlock_type = 3,},
	[100252] = { id = 100252, role_id = 1001002, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "地", ui_type = 31, unlock_type = 3,},
	[100253] = { id = 100253, role_id = 1001002, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "人", ui_type = 33, unlock_type = 3,},
	[100254] = { id = 100254, role_id = 1001002, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "和", ui_type = 34, unlock_type = 3,},
	[100501] = { id = 100501, role_id = 1001005, desc_brief = "<color=#e89e1d>五段</color>近战攻击，手执利刃，左右手交替进行挥砍攻击；或双手组合，释放瞬身连斩，造成<color=#e89e1d>火属性伤害</color>。\n仍然被身体记得的战斗剑术，杀伐果断，属不留之剑。", icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 10, name = "自由射击", ui_type = 42, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeAttack.prefab",},
	[100502] = { id = 100502, role_id = 1001005, desc_brief = "消耗<color=#e89e1d>日相/月相能量</color>，向目标释放突进斩，随手手执利刃高速回旋，造成<color=#e89e1d>火属性伤害</color>并<color=#e89e1d>点燃</color>目标。\n青乌术的起手式，简单的引火之术。", icon = "Textures/Icon/Single/SkillIcon/KekeR21UltimateSkill.png", level_limit = 10, name = "闪灵乱击", ui_type = 41, unlock_type = 1,},
	[100503] = { id = 100503, role_id = 1001005, desc_brief = "敌人<color=#e89e1d>弱点槽</color>积累满时可释放。释放时，向前方放出<color=#e89e1d>坠火踏破</color>：对路径上的敌人造成<color=#e89e1d>火属性伤害</color>，持续时间结束时爆发，额外造成<color=#e89e1d>火属性范围伤害</color>。\n忘记了本来绝技，只能粗暴地将火焰乱作一团的战法。", icon = "Textures/Icon/Single/SkillIcon/KekeR21BlueSkill.png", level_limit = 10, name = "绶印闪雷", ui_type = 32, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeCriSkill.prefab",},
	[100504] = { id = 100504, role_id = 1001005, desc_brief = "战技命中敌人时获得一层<color=#e89e1d>炎印</color>，最多储存三层。可消耗三层<color=#e89e1d>炎印</color>，<color=#e89e1d>长按</color>普攻释放：造成<color=#e89e1d>火属性范围伤害</color>，随后遁入剑影，造成多段<color=#e89e1d>火属性伤害</color>，大幅增长敌人的<color=#e89e1d>弱点槽</color>。\n火光明灭，残芒寂日，这样的战斗方式似乎早已被铭刻在身体中。", icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 10, name = "闪灵射术", ui_type = 22, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeSpeSkill.prefab",},
	[100505] = { id = 100505, role_id = 1001005, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "自由斗术", ui_type = 13, unlock_type = 1,},
	[100506] = { id = 100506, role_id = 1001005, icon = "Textures/Icon/Single/SkillIcon/KekeR21Move.png", level_limit = 1, name = "念虚领域", ui_type = 12, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeDodge.prefab",},
	[100507] = { id = 100507, role_id = 1001005, icon = "Textures/Icon/Single/SkillIcon/Jump.png", level_limit = 1, name = "快速绶印", ui_type = 11, unlock_type = 1,},
	[100508] = { id = 100508, role_id = 1001005, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "闪金相", ui_type = 23, unlock_type = 1,},
	[100509] = { id = 100509, role_id = 1001005, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "闪灵宗浪徒", ui_type = 43, unlock_type = 2,},
	[100551] = { id = 100551, role_id = 1001005, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "天", ui_type = 33, unlock_type = 3,},
	[100552] = { id = 100552, role_id = 1001005, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "地", ui_type = 31, unlock_type = 3,},
	[100553] = { id = 100553, role_id = 1001005, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "人", ui_type = 33, unlock_type = 3,},
	[100554] = { id = 100554, role_id = 1001005, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "和", ui_type = 34, unlock_type = 3,},
	[100601] = { id = 100601, role_id = 1001006, desc_brief = "点按进行至多<color=#e89e1d>五段</color>远程射击，<color=#e89e1d>长按</color>进入<color=#e89e1d>瞄准状态</color>：视野发生变化，并可以看到<color=#e89e1d>怪物弱点</color>，向弱点射击可造成<color=#e89e1d>击破</color>，打断怪物技能，造成高额伤害。\n刻刻的战斗理念在于实用，射击无章法，故称自由。", icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 10, name = "自由射击", ui_type = 42, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeAttack.prefab",},
	[100602] = { id = 100602, role_id = 1001006, desc_brief = "消耗<color=#e89e1d>日相/月相能量</color>，先后向目标扔出两把手枪，命中目标时造成<color=#e89e1d>金元素伤害</color>。\n闪灵宗学徒级别的引雷术。", icon = "Textures/Icon/Single/SkillIcon/KekeR21UltimateSkill.png", level_limit = 10, name = "闪灵乱击", ui_type = 41, unlock_type = 1,},
	[100603] = { id = 100603, role_id = 1001006, desc_brief = "敌人<color=#e89e1d>弱点槽</color>积累满时可释放。释放时，召唤跟随角色行动的<color=#e89e1d>绶印闪雷</color>，<color=#e89e1d>切换角色不会消失</color>，存在期间内，会持续对敌人降下<color=#e89e1d>雷棱</color>，造成<color=#e89e1d>金元素伤害</color>。\n刻刻在离开宗门之前，从师傅手上获得的绶印，以此来弥补自己不成器的能力。", icon = "Textures/Icon/Single/SkillIcon/KekeR21BlueSkill.png", level_limit = 10, name = "绶印闪雷", ui_type = 32, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeCriSkill.prefab",},
	[100604] = { id = 100604, role_id = 1001006, desc_brief = "普攻<color=#e89e1d>第五段</color>命中后，下次释放战技强化，并且获得1/3<color=#e89e1d>意念槽</color>充能。充能满时，<color=#e89e1d>长按</color>普攻进入<color=#e89e1d>移动射击</color>状态：持续消耗<color=#e89e1d>意念槽</color>，可以在瞄准同时移动人物。", icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 10, name = "闪灵射术", ui_type = 22, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeSpeSkill.prefab",},
	[100605] = { id = 100605, role_id = 1001006, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "自由斗术", ui_type = 13, unlock_type = 1,},
	[100606] = { id = 100606, role_id = 1001006, icon = "Textures/Icon/Single/SkillIcon/KekeR21Move.png", level_limit = 1, name = "念虚领域", ui_type = 12, unlock_type = 1, video = "Prefabs/UI/Video/UIKekeDodge.prefab",},
	[100607] = { id = 100607, role_id = 1001006, icon = "Textures/Icon/Single/SkillIcon/Jump.png", level_limit = 1, name = "快速绶印", ui_type = 11, unlock_type = 1,},
	[100608] = { id = 100608, role_id = 1001006, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "闪金相", ui_type = 23, unlock_type = 1,},
	[100609] = { id = 100609, role_id = 1001006, icon = "Textures/Icon/Single/SkillIcon/XumuR11RedSkill.png", level_limit = 1, name = "闪灵宗浪徒", ui_type = 43, unlock_type = 2,},
	[100651] = { id = 100651, role_id = 1001006, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "天", ui_type = 33, unlock_type = 3,},
	[100652] = { id = 100652, role_id = 1001006, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "地", ui_type = 31, unlock_type = 3,},
	[100653] = { id = 100653, role_id = 1001006, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "人", ui_type = 33, unlock_type = 3,},
	[100654] = { id = 100654, role_id = 1001006, condition_id = 999, icon = "Textures/Icon/Single/SkillIcon/KekeR21Attack.png", level_limit = 1, name = "和", ui_type = 34, unlock_type = 3,},
}


return DataSkill
