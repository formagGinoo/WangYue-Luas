-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataSystemOpen = Config.DataSystemOpen or {}


local DataSystemOpen = Config.DataSystemOpen
DataSystemOpen.data_system_open_length = 32
DataSystemOpen.data_system_open = {
	[101] = {id = 101, name = "角色", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[102] = {id = 102, name = "角色升级", condition = 210102, is_notice = true, notice_priority = 997, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Role_1.png", notice_desc1 = "消耗残念和金币，提升角色等级，获得属性", notice_desc2 = "吸收残念就可以强化自身，真是太简单了。——司命"},
	[103] = {id = 103, name = "角色技能", condition = 210103, is_notice = true, notice_priority = 994, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Role_1.png", notice_desc1 = "消耗技能纹章和金币，提升技能等级，增强技能效果", notice_desc2 = "对于你来说，升级技能其实是回忆的一部分，尽快记起自己拯救世界的使命吧。——司命"},
	[104] = {id = 104, name = "角色脉象", condition = 210104, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[105] = {id = 105, name = "角色佩从", condition = 210105, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[201] = {id = 201, name = "武器升级", condition = 210201, is_notice = true, notice_priority = 998, notice_icon = "Textures/Icon/Single/FuncIcon/TabSelect_Role_2.png", notice_desc1 = "使用矿石，强化武器等级，获得属性加成", notice_desc2 = "就由我来教你怎么打造一把绝世神兵吧。——司命"},
	[202] = {id = 202, name = "武器精炼", condition = 210202, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[301] = {id = 301, name = "佩从", condition = 210301, is_notice = false, notice_priority = 996, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Partner_1.png", notice_desc1 = "佩戴捕获的佩从，可召唤其协助战斗和探索", notice_desc2 = "意志与欲望的冲突体，那就是所谓的佩从。——司命"},
	[302] = {id = 302, name = "佩从升级", condition = 210302, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[303] = {id = 303, name = "佩从合成", condition = 210303, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[304] = {id = 304, name = "佩从资质培养", condition = 210304, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[401] = {id = 401, name = "编队", condition = 210401, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[501] = {id = 501, name = "背包", condition = 210501, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[601] = {id = 601, name = "地图", condition = 210601, is_notice = true, notice_priority = 994, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Map_1.png", notice_desc1 = "地图中可查看各类世界上的信息，进行追踪和传送", notice_desc2 = "探索未知世界，发现奇妙之旅。"},
	[701] = {id = 701, name = "任务", condition = 1, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[801] = {id = 801, name = "教学目录", condition = 210801, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[901] = {id = 901, name = "冒险", condition = 210901, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[902] = {id = 902, name = "世界等级", condition = 210902, is_notice = true, notice_priority = 993, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Adventure_1.png", notice_desc1 = "突破青乌等级，冒险中奖励将更加丰厚。相应的，敌人将更加强大", notice_desc2 = "这个世界会对青乌你的力量产生对抗心理，真是叛逆呢。——司命"},
	[903] = {id = 903, name = "噬脉猎手", condition = 210903, is_notice = true, notice_priority = 991, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Adventure_1.png", notice_desc1 = "冒险旅途中，所有挫败悬天的行为，都将悬天将发出密令，对青乌进行追猎。", notice_desc2 = "那什么，每天前四次打败猎手会有对应的报酬，我们去剿灭恶势力吧，嘻嘻。——司命"},
	[904] = {id = 904, name = "每日活跃", condition = 210904, is_notice = true, notice_priority = 992, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Adventure_1.png", notice_desc1 = "完成每日任务可以获得活跃度奖励，活跃度累计到一定值可以获得丰厚奖励", notice_desc2 = "为了拯救世界，每天我都会给你安排一些项目，闲的话就试试吧。——司命"},
	[1001] = {id = 1001, name = "活动", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1101] = {id = 1101, name = "商城", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1201] = {id = 1201, name = "祈愿", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1301] = {id = 1301, name = "纪行", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1401] = {id = 1401, name = "设置", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1501] = {id = 1501, name = "邮件", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1601] = {id = 1601, name = "公告", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1701] = {id = 1701, name = "拍照", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1801] = {id = 1801, name = "好友", condition = 0, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[1901] = {id = 1901, name = "图鉴", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[2001] = {id = 2001, name = "成就", condition = 999, is_notice = false, notice_priority = 0, notice_icon = "", notice_desc1 = "", notice_desc2 = ""},
	[2101] = {id = 2101, name = "滑翔伞", condition = 212101, is_notice = true, notice_priority = 995, notice_icon = "Textures/Icon/Single/FuncIcon/SysOpen_Fly_1.png", notice_desc1 = "在空中点击跳跃按钮，将使用羽鸢进行滑翔", notice_desc2 = "从高处跳下去然后跳一下，就能展开羽鸢。——司命"},
}
	
