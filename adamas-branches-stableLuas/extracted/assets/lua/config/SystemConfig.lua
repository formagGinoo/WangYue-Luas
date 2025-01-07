SystemConfig = SystemConfig or {}

--没用到过的是拼音临时命名,用到时和策划商量具体命名
SystemConfig.SystemOpenId = {
	Role = 101,	   --角色
	RoleUpgrade = 102,	   --角色升级
	RoleSkill = 103,	   --角色技能
	RoleMai = 104,	   --角色脉象
	RolePartner = 105,	   --角色月灵
	WeaponUpgrade = 201,	   --武器升级
	WeaponJingLian = 202,	   --武器精炼
	Partner = 301,	   --月灵
	PartnerUpgrade = 302,	   --月灵升级
	PartnerCompose = 303,	   --月灵合成
	PartnerNatural = 304,	   --月灵资质培养
	PartnerWork = 305,	   --月灵工作
	Formation = 401,	   --编队
	Bag = 501,	   --背包
	Map = 601,	   --地图
	Task = 701,	   --任务
	Teach = 801,	   --指南
	MaoXian = 901,	   --冒险
	WorldLevel = 902, --世界等级
	ShiMaiLieShou = 903,	--噬脉猎手
	DailyActive = 904,
	ResDuplicate = 905,
	Rogue = 906,   --肉鸽
	Nightmare = 907,  --梦魇终战
	CitySimulation = 908, --城市经营
	HuoDong = 1001,   --活动
	QianDao = 1002,   --签到
	XinShouRenWu = 1003,   --新手任务
	ShangCheng = 1101,   --商城
	ChongZhi = 1102, -- 充值
	LiBao = 1103, -- 礼包
	Monthcard = 1104,  -- 月卡
	Exchanage = 1105,  -- 兑换
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
	Identity = 2201,	-- 道途
	Message = 2301,    -- 短信
	AbilityWheel = 2401,    -- 能力轮盘
	PlayerInfo = 2501,		-- 个人信息
	MainMenu = 2502,		-- 菜单
	AssetCenter = 2601,	-- 资产中心
	DayNight = 2701, --昼夜系统
	AppStore = 2801, --APP商店
}


--#region 冒险系统
SystemConfig.AdventurePanelType = 
{
	WorldLevel = 1,
	MercenaryTask = 2,
	DailyActivity = 3,
	ResDuplicate = 4,
	CitySimulation = 5,
	NightMareDuplicate = 6,
}


SystemConfig.AdventureTypeToPanel = {
	[SystemConfig.AdventurePanelType.WorldLevel] = WorldLevelPanel,
	[SystemConfig.AdventurePanelType.MercenaryTask] = MercenaryHuntNewPanel,
	[SystemConfig.AdventurePanelType.DailyActivity] = DailyActivityPanel,
	[SystemConfig.AdventurePanelType.ResDuplicate] = ResDuplicatePanel,
	[SystemConfig.AdventurePanelType.CitySimulation] = EntrustmentEntryPanel,
	[SystemConfig.AdventurePanelType.NightMareDuplicate] = NightMareAdvPanel
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
			local cb = function ()
				parent.showPanel = parent:OpenPanel(MercenaryHuntNewPanel)
			end
			MercenaryHuntNewPanel.LoadShowModScene(cb)
        else
            parent:ClosePanel(MercenaryHuntNewPanel)
        end
    end},

	{type = SystemConfig.AdventurePanelType.DailyActivity, name = "每日活跃", systemId = SystemConfig.SystemOpenId.DailyActive,callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(DailyActivityPanel)
		else
			parent:ClosePanel(DailyActivityPanel)
		end
	end},

	{type = SystemConfig.AdventurePanelType.ResDuplicate, name = "资源副本", systemId = SystemConfig.SystemOpenId.ResDuplicate, callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(ResDuplicatePanel)
		else
			parent:ClosePanel(ResDuplicatePanel)
		end
	end},
	
	{type = SystemConfig.AdventurePanelType.CitySimulation, name = TI18N("城市经营"), systemId = SystemConfig.SystemOpenId.CitySimulation, callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(EntrustmentEntryPanel)
		else
			parent:ClosePanel(EntrustmentEntryPanel)
		end
	end},
	{type = SystemConfig.AdventurePanelType.NightMareDuplicate, name = "梦魇终战", systemId = SystemConfig.SystemOpenId.Nightmare, callback = function(parent, isSelect)
		if isSelect then
			parent.showPanel = parent:OpenPanel(NightMareAdvPanel)
		else
			parent:ClosePanel(NightMareAdvPanel)
		end
	end},
}

--#endregion

--#region 通用表格数据

function SystemConfig.GetIconConfig(key)
	return Config.DataCommonIcon.Find[key]
end

function SystemConfig.GetCommonValue(key)
	return Config.DataCommonCfg.Find[key]
end

--#endregion


--#region 加载页
local DataLoadingInfo = Config.DataLoadingInfo
local DataLoadingText = Config.DataLoadingText

--SystemConfig.AutoChangeTime() = SystemConfig.GetCommonValue("LoadImageInterval").int_val
function SystemConfig.AutoChangeTime()
	return SystemConfig.GetCommonValue("LoadImageInterval").int_val
end

SystemConfig.LoadingPageType = 
{
	Normal = 1,
	Login = 2,
}

function SystemConfig.GetRandomInfo(exclude)
	local info
	local count = 0
	repeat
		local random = math.random(DataLoadingInfo.FindLength - 2)
		random = random + 102
		info = DataLoadingInfo.Find[random]
		count = count + 1
		if count > 20 then
			return info
		end
    until info.id ~= (exclude or -1)
	return info
end

function SystemConfig.GetRandomText(id, exclude)
	local info = DataLoadingInfo.Find[id]
	local data
	local count = 0
	repeat
		local random = math.random(#info.infos)
		local groupData = DataLoadingText.FindbyGroup[info.infos[random]]
		random = math.random(#groupData)
		data = DataLoadingText.Find[groupData[random]]
		count = count + 1
		if count > 20 then
			return data
		end
    until data.id ~= (exclude or -1)
	return data
end

function SystemConfig.WaitProcessing(orderId, protoId, func)
	CurtainManager.Instance:EnterWait()
	mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function (noticeCode)
        CurtainManager.Instance:ExitWait()
		if func then func(noticeCode) end
    end)
end

--#endregion

SystemConfig.WaitType =
{
	Default = 10,--默认,等待一段时间后开始转圈
	NotLoading = 20, -- 不会转圈
	Immediately = 30, --进入即转圈
}

SystemConfig.KickOfflineType =
{
	Blocked = 1, --封号
	AssetUpdate = 2, --更新
	RepeatLogIn = 3, --顶号
	Maintain = 4, --维护
}

function SystemConfig.GetTipConfig(tipId)
	return tipId and Config.DataTips.data_tips[tipId]
end

function SystemConfig.GetLevelTipConfig(tipId)
	return Config.DataTips.data_lnstruction[tipId]
end

local DataTimeDurationShow = Config.DataTimeDurationShow.Find

function SystemConfig.GetTimeConfig(time)
	for i, v in ipairs(DataTimeDurationShow) do
		if v.time > time then
			return DataTimeDurationShow[i-1]
		end
	end
	return DataTimeDurationShow[#DataTimeDurationShow]
end