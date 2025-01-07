SystemConfig = SystemConfig or {}

--没用到过的是拼音临时命名,用到时和策划商量具体命名
SystemConfig.SystemOpenId = {
	Role = 101,	   --角色
	RoleUpgrade = 102,	   --角色升级
	RoleSkill = 103,	   --角色技能
	RoleMai = 104,	   --角色脉象
	RolePartner = 105,	   --角色佩从
	WeaponUpgrade = 201,	   --武器升级
	WeaponJingLian = 202,	   --武器精炼
	Partner = 301,	   --佩从
	PartnerUpgrade = 302,	   --佩从升级
	PartnerCompose = 303,	   --佩从合成
	PartnerNatural = 304,	   --佩从资质培养
	Formation = 401,	   --编队
	Bag = 501,	   --背包
	Map = 601,	   --地图
	Task = 701,	   --任务
	Teach = 801,	   --指南
	MaoXian = 901,	   --冒险
	WorldLevel = 902, --世界等级
	ShiMaiLieShou = 903,	--噬脉猎手
	DailyActive = 904,
	HuoDong = 1001,   --活动
	ShangCheng = 1101,   --商城
	QiYuan = 1201,   --祈愿
	JiXing = 1301,   --纪行
	Setting = 1401,   --设置
	EMail = 1501,   --邮件
	Announcement = 1601,   --公告
	Photos = 1701,   --拍照
	Friend = 1801,   --好友
	Collection = 1901,   --图鉴
	Achievement = 2001,   --成就
	Fly = 2101,   --飞行
}



SystemConfig.AdventurePanelType = 
{
	WorldLevel = 1,
	MercenaryTask = 2,
	DailyActivity = 3,

}

SystemConfig.AdventureMainToggleInfo = {
	{type = SystemConfig.AdventurePanelType.WorldLevel,  name = "世界等级", systemId = 902,callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(WorldLevelPanel)
		else
			parent:ClosePanel(WorldLevelPanel)
		end
	end},
    {type = SystemConfig.AdventurePanelType.MercenaryTask, name = "噬脉猎手", systemId = 903,callback = function(parent, isSelect)
        if isSelect then
            parent.showPanel = parent:OpenPanel(MercenaryTaskPanel)
        else
            parent:ClosePanel(MercenaryTaskPanel)
        end
    end},
	{type = SystemConfig.AdventurePanelType.DailyActivity, name = "每日活跃", systemId = SystemConfig.SystemOpenId.DailyActive,callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(DailyActivityPanel)
		else
			parent:ClosePanel(DailyActivityPanel)
		end
	end},
}

function SystemConfig.GetIconConfig(key)
	return Config.DataCommonIcon.Find[key]
end
