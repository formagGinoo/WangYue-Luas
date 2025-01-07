HackingConfig = HackingConfig or {}

local Mode = FightEnum.HackMode
local DataRecruit = Config.DataRecruit.Find

local HackUIState = {
	HackNone = Mode.Hack,
	BuildNone = Mode.Build,
}

for k, v in pairs(FightEnum.HackingType) do
	local name = "Hack"..k
	HackUIState[name] = Mode.Hack + v

end
HackingConfig.HackUIState = HackUIState

--[[
轮盘数字顺序，空的保留位置
	1
4		2
	3
]]
--[[
	4 2 3 1
]]
HackingConfig.HackingKey = 
{
	Up = 1,
	Right = 2,
	Down = 3,
	Left = 4,
}

HackingConfig.NullHackButtonConfig = {icon = nil, Name = ""}

HackingConfig.ModeToIconConfig = {
	[Mode.Hack] = {
		[1] = {"hack_hijack", "StartHacking"},
	}
}

HackingConfig.HackingTypeToIconConfig = {
	[FightEnum.HackingType.Drone] = {
		[1] = {"ctrl_up", "ClickUp"},
		[2] = {"ctrl_right", "ClickRight"},
		[3] = {"ctrl_down", "ClickDown"},
		[4] = {"ctrl_left", "ClickLeft"}
	},
	[FightEnum.HackingType.Camera] = {
		[1] = {"ctrl_up", "ClickUp"},
	},
	[FightEnum.HackingType.Npc] = {
		[1] = {"ctrl_up", "ClickUp"},
		[3] = {"ctrl_down", "ClickDown"},
		[4] = {"hack_cancel", "ClickLeft"},
	},
	[FightEnum.HackingType.Box] = {
		[1] = {"ctrl_up", "ClickUp"},
	},
}


HackingConfig.CancelIcon = "hack_cancel"

HackingConfig.EffectType = 
{
	TaskTarget = "TaskTargetEffect",
	EnmityTarget = "EnmityTargetEffect",
	CanHackingTarget = "CanHackingTargetEffect",
	OtherTarget = "OtherTargetEffect",
}

-- 第一层是是否是npc， 第二层是是否选中
HackingConfig.TaskTargetEffect = 
{
	[true] = 
	{
		[true] = 200001127,
		[false] = 200001126,
	}, 
	[false] = 
	{
		[true] = 200001135,
		[false] = 200001134,
	},
}
HackingConfig.EnmityTargetEffect = 
{
	[true] = 
	{
		[true] = 200001129,
		[false] = 200001128,
	}, 
	[false] = 
	{
		[true] = 200001137,
		[false] = 200001136,
	},
}
HackingConfig.CanHackingTargetEffect = 
{
	[true] = 
	{
		[true] = 200001131,
		[false] = 200001130,
	}, 
	[false] = 
	{
		[true] = 200001139,
		[false] = 200001138,
	},
}
HackingConfig.OtherTargetEffect = 
{
	[true] = 
	{
		[true] = 200001133,
		[false] = 200001132,
	}, 
	[false] = 
	{
		[true] = 200001141,
		[false] = 200001140,
	},
}

function HackingConfig.GetOperateIcon(type)
	return HackingConfig.HackingTypeToIconConfig[type]
end

function HackingConfig.ConvertToState(mode, type)
	if mode == HackUIState.BuildNone then
		return HackUIState.BuildNone
	end

	return mode + (type or 0)
end

local GoldIconPath = "Textures/Icon/Single/Hacking/%s_g.png"
local WhiteIconPath = "Textures/Icon/Single/Hacking/%s_w.png"
local TipsTextIconPath = "Textures/Icon/Single/Hacking/%s_c.png"
local SelectedTipsTextIconPath = "Textures/Icon/Single/Hacking/%s_h.png"
function HackingConfig.GetIconAssetsPath(icon)
	return string.format(GoldIconPath, icon), 
			string.format(WhiteIconPath, icon),
			string.format(TipsTextIconPath, icon), 
			string.format(SelectedTipsTextIconPath, icon)
end

function HackingConfig.GetHackMailConfig(mailId)
	return Config.DataNpcMail.Find[mailId]
end

function HackingConfig.GetHackPhoneCallConfig(callId)
	return Config.DataNpcPhoneCall.Find[callId]
end

function HackingConfig.GetHackRecruitInfo(npcId)
	return DataRecruit[npcId]
end