HackingConfig = HackingConfig or {}

HackingConfig.Mode = {
	Hack = 1,
	Build = 2,
	Hacking = 3,
}

--[[
轮盘数字顺序，空的保留位置
	1
4		2
	3
]]

HackingConfig.ModeToIconConfig = {
	[HackingConfig.Mode.Hack] = {
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
		[4] = {"hack_cancel", "ClickLeft"},
	},
	[FightEnum.HackingType.Box] = {
		[1] = {"ctrl_up", "ClickUp"},
	},
}

local cacheVec = Vec3.New()

function HackingConfig.GetOperateIcon(mode, type)
	if mode ~= HackingConfig.Mode.Hacking then
		return HackingConfig.ModeToIconConfig[mode]
	else
		return HackingConfig.HackingTypeToIconConfig[type]
	end
end

local GoldIconPath = "Textures/Icon/Single/Hacking/%s_g.png"
local WhiteIconPath = "Textures/Icon/Single/Hacking/%s_w.png"
function HackingConfig.GetIconAssetsPath(icon)
	return string.format(GoldIconPath, icon), string.format(WhiteIconPath, icon)
end

local TargetList = {}
function HackingConfig.GetHackingTargetList()
	TableUtils.ClearTable(TargetList)
	local entities = Fight.Instance.entityManager:GetEntites()
	for _, v in pairs(entities) do
		if v.hackingInputHandleComponent then
			table.insert(TargetList, v)
		end
	end
	
	return TargetList
end

function HackingConfig.GetPlayerLocationPosition(boneName)
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local transform = player.clientEntity.clientTransformComponent:GetTransform(boneName)
	if not transform then
		transform = player.clientEntity.clientTransformComponent:GetTransform()
	end
	return transform.position
end

local ViewportCenter = {0.5, 0.5}
function HackingConfig.GetNearestHackingTarget(viewPortRange, worldRange, boneName, targetList)
	targetList = targetList or HackingConfig.GetHackingTargetList()

	local nearestEntity
	local nearestSquareDis = viewPortRange^2
	local worldSquareRange = worldRange^2
	local calcTransform
	for _, v in pairs(targetList) do
		local clientTransformComponent = v.clientEntity.clientTransformComponent
		if clientTransformComponent then
			local transform = clientTransformComponent:GetTransform(boneName)
			if not transform then
				transform = clientTransformComponent:GetTransform()
			end
			local pos = transform.position
			--local viewPortWorldX, viewPortWorldY, viewPortWorldZ = CustomUnityUtils.ViewportToWorldPoint(ViewportCenter[1], ViewportCenter[2], 0)
			--cacheVec:Set(viewPortWorldX, viewPortWorldY, viewPortWorldZ)
			--if Vec3.SquareDistance(pos, cacheVec) <= worldSquareRange then
			
			local playerPosition = HackingConfig.GetPlayerLocationPosition(boneName)
			if Vec3.SquareDistance(pos, playerPosition) <= worldSquareRange then
				local ingScreen, viewX, viewY = CustomUnityUtils.CheckWorldPosIngScreen(pos.x, pos.y, pos.z)
				if ingScreen then
					local squareDis = (viewX - ViewportCenter[1])^2 + (viewY - ViewportCenter[2])^2
					if nearestSquareDis > squareDis then
						nearestSquareDis = squareDis
						nearestEntity = v
						calcTransform = transform
					end
				end
			end
		end
	end

	return nearestEntity, calcTransform
end

--获取能源数量
function HackingConfig.GetPowerCount()
	local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
	for k, info in pairs(currency) do
		if info.template_id == 8 then
			return info.count or 0
		end
	end
	return 0
end