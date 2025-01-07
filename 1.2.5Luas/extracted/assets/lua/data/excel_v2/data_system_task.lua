-- Automatically generated - do not edit.

Config = Config or {}
Config.DataSystemTask = Config.DataSystemTask or {}


local DataSystemTask = Config.DataSystemTask
DataSystemTask.FindLength = 61

DataSystemTask.FindbyGroup = {
	[101] = { [1010001] = 1010001, [1010002] = 1010002, [1010003] = 1010003, [1010004] = 1010004, [1010005] = 1010005, [1010006] = 1010006, [1010007] = 1010007,},
	[102] = { [1020001] = 1020001, [1020002] = 1020002, [1020003] = 1020003, [1020004] = 1020004, [1020005] = 1020005, [1020006] = 1020006, [1020007] = 1020007, [1020008] = 1020008,},
	[103] = { [1030001] = 1030001, [1030002] = 1030002, [1030003] = 1030003, [1030004] = 1030004, [1030005] = 1030005, [1030006] = 1030006, [1030007] = 1030007, [1030008] = 1030008, [1030009] = 1030009,},
	[104] = { [1040001] = 1040001, [1040002] = 1040002, [1040003] = 1040003, [1040004] = 1040004, [1040005] = 1040005, [1040006] = 1040006, [1040007] = 1040007, [1040008] = 1040008, [1040009] = 1040009,},
	[105] = { [1050001] = 1050001, [1050002] = 1050002, [1050003] = 1050003, [1050004] = 1050004, [1050005] = 1050005, [1050006] = 1050006, [1050007] = 1050007, [1050008] = 1050008, [1050009] = 1050009,},
	[106] = { [1060001] = 1060001, [1060002] = 1060002, [1060003] = 1060003, [1060004] = 1060004, [1060005] = 1060005, [1060006] = 1060006, [1060007] = 1060007, [1060008] = 1060008, [1060009] = 1060009,},
	[201] = { [2010001] = 2010001, [2010002] = 2010002, [2010003] = 2010003, [2010004] = 2010004,},
	[202] = { [2020001] = 2020001, [2020002] = 2020002, [2020003] = 2020003,},
	[203] = { [2030001] = 2030001, [2030002] = 2030002,},
	[204] = { [2040001] = 2040001,},
}

DataSystemTask.Find = {
	[1010001] = { id = 1010001, condition = 1010001, desc = "冒险等级达到10级", group = 101, jump_id = 0, name = "世界等级任务", order = 999, reward = 1010001, reward_source = 42,},
	[1010002] = { id = 1010002, condition = 1010002, desc = "完成主线第一章", group = 101, jump_id = 0, name = "世界等级任务", order = 998, reward = 1010002, reward_source = 42,},
	[1010003] = { id = 1010003, condition = 1010003, desc = "将任意一个角色提升到20级", group = 101, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1010003, reward_source = 42,},
	[1010004] = { id = 1010004, condition = 1010004, desc = "将任意一把武器强化到20级", group = 101, jump_id = 1102, name = "世界等级任务", order = 995, reward = 1010004, reward_source = 42,},
	[1010005] = { id = 1010005, condition = 1010005, desc = "使用离歌完美刺杀3次", group = 101, jump_id = 0, name = "世界等级任务", order = 994, reward = 1010005, reward_source = 42,},
	[1010006] = { id = 1010006, condition = 1010006, desc = "将任意一个仲魔提升到4级", group = 101, jump_id = 1103, name = "世界等级任务", order = 993, reward = 1010006, reward_source = 42,},
	[1010007] = { id = 1010007, condition = 1010007, desc = "激活1个传送悬钟", group = 101, jump_id = 0, name = "世界等级任务", order = 997, reward = 1010007, reward_source = 42,},
	[1020001] = { id = 1020001, condition = 1020001, desc = "冒险等级达到20级", group = 102, jump_id = 0, name = "世界等级任务", order = 999, reward = 1020001, reward_source = 42,},
	[1020002] = { id = 1020002, condition = 1020002, desc = "完成主线第二章", group = 102, jump_id = 0, name = "世界等级任务", order = 998, reward = 1020002, reward_source = 42,},
	[1020003] = { id = 1020003, condition = 1020003, desc = "将任意一个角色提升到30级", group = 102, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1020003, reward_source = 42,},
	[1020004] = { id = 1020004, condition = 1020004, desc = "将任意二个角色突破到1阶", group = 102, jump_id = 1101, name = "世界等级任务", order = 995, reward = 1020004, reward_source = 42,},
	[1020005] = { id = 1020005, condition = 1020005, desc = "将任意一把武器强化到30级", group = 102, jump_id = 1102, name = "世界等级任务", order = 994, reward = 1020005, reward_source = 42,},
	[1020006] = { id = 1020006, condition = 1020006, desc = "将任意二把武器突破到1阶", group = 102, jump_id = 1102, name = "世界等级任务", order = 993, reward = 1020006, reward_source = 42,},
	[1020007] = { id = 1020007, condition = 1020007, desc = "将任意一个仲魔提升到4级", group = 102, jump_id = 1103, name = "世界等级任务", order = 992, reward = 1020007, reward_source = 42,},
	[1020008] = { id = 1020008, condition = 1020008, desc = "激活2个传送悬钟", group = 102, jump_id = 0, name = "世界等级任务", order = 997, reward = 1020008, reward_source = 42,},
	[1030001] = { id = 1030001, condition = 1030001, desc = "冒险等级达到30级", group = 103, jump_id = 0, name = "世界等级任务", order = 999, reward = 1030001, reward_source = 42,},
	[1030002] = { id = 1030002, condition = 1030002, desc = "完成主线第三章", group = 103, jump_id = 0, name = "世界等级任务", order = 998, reward = 1030002, reward_source = 42,},
	[1030003] = { id = 1030003, condition = 1030003, desc = "将任意一个角色提升到40级", group = 103, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1030003, reward_source = 42,},
	[1030004] = { id = 1030004, condition = 1030004, desc = "将任意二个角色突破到2阶", group = 103, jump_id = 1101, name = "世界等级任务", order = 995, reward = 1030004, reward_source = 42,},
	[1030005] = { id = 1030005, condition = 1030005, desc = "将任意一把武器强化到40级", group = 103, jump_id = 1102, name = "世界等级任务", order = 994, reward = 1030005, reward_source = 42,},
	[1030006] = { id = 1030006, condition = 1030006, desc = "将任意二把武器突破到2阶", group = 103, jump_id = 1102, name = "世界等级任务", order = 993, reward = 1030006, reward_source = 42,},
	[1030007] = { id = 1030007, condition = 1030007, desc = "将任意一个仲魔提升到8级", group = 103, jump_id = 1103, name = "世界等级任务", order = 992, reward = 1030007, reward_source = 42,},
	[1030008] = { id = 1030008, condition = 1030008, desc = "将任意二个仲魔提升到4级", group = 103, jump_id = 1103, name = "世界等级任务", order = 991, reward = 1030008, reward_source = 42,},
	[1030009] = { id = 1030009, condition = 1030009, desc = "激活3个传送悬钟", group = 103, jump_id = 0, name = "世界等级任务", order = 997, reward = 1030009, reward_source = 42,},
	[1040001] = { id = 1040001, condition = 1040001, desc = "冒险等级达到35级", group = 104, jump_id = 0, name = "世界等级任务", order = 999, reward = 1040001, reward_source = 42,},
	[1040002] = { id = 1040002, condition = 1040002, desc = "完成主线第四章", group = 104, jump_id = 0, name = "世界等级任务", order = 998, reward = 1040002, reward_source = 42,},
	[1040003] = { id = 1040003, condition = 1040003, desc = "将任意一个角色提升到50级", group = 104, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1040003, reward_source = 42,},
	[1040004] = { id = 1040004, condition = 1040004, desc = "将任意二个角色突破到3阶", group = 104, jump_id = 1101, name = "世界等级任务", order = 995, reward = 1040004, reward_source = 42,},
	[1040005] = { id = 1040005, condition = 1040005, desc = "将任意一把武器强化到50级", group = 104, jump_id = 1102, name = "世界等级任务", order = 994, reward = 1040005, reward_source = 42,},
	[1040006] = { id = 1040006, condition = 1040006, desc = "将任意二把武器突破到3阶", group = 104, jump_id = 1102, name = "世界等级任务", order = 993, reward = 1040006, reward_source = 42,},
	[1040007] = { id = 1040007, condition = 1040007, desc = "将任意一个仲魔提升到12级", group = 104, jump_id = 1103, name = "世界等级任务", order = 992, reward = 1040007, reward_source = 42,},
	[1040008] = { id = 1040008, condition = 1040008, desc = "将任意二个仲魔提升到8级", group = 104, jump_id = 1103, name = "世界等级任务", order = 991, reward = 1040008, reward_source = 42,},
	[1040009] = { id = 1040009, condition = 1040009, desc = "激活4个传送悬钟", group = 104, jump_id = 0, name = "世界等级任务", order = 997, reward = 1040009, reward_source = 42,},
	[1050001] = { id = 1050001, condition = 1050001, desc = "冒险等级达到40级", group = 105, jump_id = 0, name = "世界等级任务", order = 999, reward = 1050001, reward_source = 42,},
	[1050002] = { id = 1050002, condition = 1050002, desc = "完成主线第五章", group = 105, jump_id = 0, name = "世界等级任务", order = 998, reward = 1050002, reward_source = 42,},
	[1050003] = { id = 1050003, condition = 1050003, desc = "将任意一个角色提升到60级", group = 105, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1050003, reward_source = 42,},
	[1050004] = { id = 1050004, condition = 1050004, desc = "将任意二个角色突破到4阶", group = 105, jump_id = 1101, name = "世界等级任务", order = 995, reward = 1050004, reward_source = 42,},
	[1050005] = { id = 1050005, condition = 1050005, desc = "将任意一把武器强化到60级", group = 105, jump_id = 1102, name = "世界等级任务", order = 994, reward = 1050005, reward_source = 42,},
	[1050006] = { id = 1050006, condition = 1050006, desc = "将任意二把武器突破到4阶", group = 105, jump_id = 1102, name = "世界等级任务", order = 993, reward = 1050006, reward_source = 42,},
	[1050007] = { id = 1050007, condition = 1050007, desc = "将任意一个仲魔提升到16级", group = 105, jump_id = 1103, name = "世界等级任务", order = 992, reward = 1050007, reward_source = 42,},
	[1050008] = { id = 1050008, condition = 1050008, desc = "将任意二个仲魔提升到12级", group = 105, jump_id = 1103, name = "世界等级任务", order = 991, reward = 1050008, reward_source = 42,},
	[1050009] = { id = 1050009, condition = 1050009, desc = "激活5个传送悬钟", group = 105, jump_id = 0, name = "世界等级任务", order = 997, reward = 1050009, reward_source = 42,},
	[1060001] = { id = 1060001, condition = 1060001, desc = "冒险等级达到45级", group = 106, jump_id = 0, name = "世界等级任务", order = 999, reward = 1060001, reward_source = 42,},
	[1060002] = { id = 1060002, condition = 1060002, desc = "完成主线第六章", group = 106, jump_id = 0, name = "世界等级任务", order = 998, reward = 1060002, reward_source = 42,},
	[1060003] = { id = 1060003, condition = 1060003, desc = "将任意一个角色提升到70级", group = 106, jump_id = 1101, name = "世界等级任务", order = 996, reward = 1060003, reward_source = 42,},
	[1060004] = { id = 1060004, condition = 1060004, desc = "将任意二个角色突破到5阶", group = 106, jump_id = 1101, name = "世界等级任务", order = 995, reward = 1060004, reward_source = 42,},
	[1060005] = { id = 1060005, condition = 1060005, desc = "将任意一把武器强化到70级", group = 106, jump_id = 1102, name = "世界等级任务", order = 994, reward = 1060005, reward_source = 42,},
	[1060006] = { id = 1060006, condition = 1060006, desc = "将任意二把武器突破到5阶", group = 106, jump_id = 1102, name = "世界等级任务", order = 993, reward = 1060006, reward_source = 42,},
	[1060007] = { id = 1060007, condition = 1060007, desc = "将任意一个仲魔提升到20级", group = 106, jump_id = 1103, name = "世界等级任务", order = 992, reward = 1060007, reward_source = 42,},
	[1060008] = { id = 1060008, condition = 1060008, desc = "将任意二个仲魔提升到16级", group = 106, jump_id = 1103, name = "世界等级任务", order = 991, reward = 1060008, reward_source = 42,},
	[1060009] = { id = 1060009, condition = 1060009, desc = "激活6个传送悬钟", group = 106, jump_id = 0, name = "世界等级任务", order = 997, reward = 1060009, reward_source = 42,},
	[2010001] = { id = 2010001, condition = 2010001, desc = "击杀4个敌人", group = 201, jump_id = 0, name = "每日活跃任务", order = 998, reward = 2010001, reward_source = 53,},
	[2010002] = { id = 2010002, condition = 2010002, desc = "完成3次闪避或跳反", group = 201, jump_id = 0, name = "每日活跃任务", order = 997, reward = 2010001, reward_source = 53,},
	[2010003] = { id = 2010003, condition = 2010003, desc = "击破一次弱点槽", group = 201, jump_id = 0, name = "每日活跃任务", order = 996, reward = 2010001, reward_source = 53,},
	[2010004] = { id = 2010004, condition = 2010004, desc = "使用5次佩从技能", group = 201, jump_id = 0, name = "每日活跃任务", order = 995, reward = 2010001, reward_source = 53,},
	[2020001] = { id = 2020001, condition = 2020001, desc = "升级一次佩从", group = 202, jump_id = 1103, name = "每日活跃任务", order = 994, reward = 2010001, reward_source = 53,},
	[2020002] = { id = 2020002, condition = 2020002, desc = "升级一次角色", group = 202, jump_id = 1101, name = "每日活跃任务", order = 993, reward = 2010001, reward_source = 53,},
	[2020003] = { id = 2020003, condition = 2020003, desc = "强化一次脉者武器", group = 202, jump_id = 1102, name = "每日活跃任务", order = 992, reward = 2010001, reward_source = 53,},
	[2030001] = { id = 2030001, condition = 2030001, desc = "使用2次回血类药物", group = 203, jump_id = 1501, name = "每日活跃任务", order = 991, reward = 2010001, reward_source = 53,},
	[2030002] = { id = 2030002, condition = 2030002, desc = "采集4个采集物", group = 203, jump_id = 0, name = "每日活跃任务", order = 990, reward = 2010001, reward_source = 53,},
	[2040001] = { id = 2040001, condition = 2040001, desc = "完成2次噬脉猎手", group = 204, jump_id = 1701, name = "每日活跃任务", order = 999, reward = 2010002, reward_source = 53,},
}


return DataSystemTask
