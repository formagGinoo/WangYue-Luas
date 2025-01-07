---@class TriggerComponent
TriggerComponent = BaseClass("TriggerComponent",PoolBaseClass)

local InCacheTable = {}
local OutCacheTable = {}

function TriggerComponent:__init()
	self.notUpdate = false
	self.inCollider = nil
	self.outCollider = nil
	self.checkLayer = FightEnum.LayerBit.Default | FightEnum.LayerBit.Wall | FightEnum.LayerBit.NoClimbing
	self.triggeCenter = Vec3.New()
end

function TriggerComponent:__delete()

end

function TriggerComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Trigger)
	self.shapeType = self.config.ShapeType or FightEnum.CollisionType.Sphere

	self.enabled = true
	self.activeEnter = true
	self.triggerEntities = {}
	self.blockEntities = {}

	self.defaultIcon = nil
	self.defaultDesc = nil
end

function TriggerComponent:LateInit()
	self.entityTransform = self.entity.clientTransformComponent:GetTransform()
	self.defaultIcon = self.config.TriggerIcon
	self.defaultDesc = self.config.TriggerText
	self.defaultType = self.config.TriggerType
	self.durationTime = self.config.DurationTime
	self.canBlockWall = self.config.BlockWall or false
	self.canOutScreen = self.config.OutScreen or false
	self.blockWallOffectHight = self.config.BlockWallOffectHight or 1
	self.nowDurationTime = self.durationTime ~= -1 and self.durationTime
	local normalOffset = self.config.Offset
	local outOffset = self.config.SetOutOffset and self.config.OutOffset or self.config.Offset
	if self.shapeType == FightEnum.CollisionType.Sphere then
		local radius = self.config.Radius
		local radiusOut = self.config.RadiusOut or radius
		self:InitTrigger(self.shapeType, radius, nil, nil, radiusOut, nil, nil, self.config.SetOutOffset, normalOffset, outOffset)
	elseif self.shapeType == FightEnum.CollisionType.Cube then
		local size = self.config.CubeIng
		local sizeOut = self.config.CubeOut or size
		self:InitTrigger(self.shapeType, size[1], size[2], size[3], sizeOut[1], sizeOut[2], sizeOut[3], self.config.SetOutOffset, normalOffset, outOffset)
	elseif self.shapeType == FightEnum.CollisionType.Cylinder then
		-- 因为圆柱的高度是一半 所以这里要 乘2
		local radius = self.config.Radius
		local outRadius = self.config.RadiusOut or radius
		local height = self.config.EnterHeight * 2
		local outHeight = self.config.LeftHeight and self.config.LeftHeight * 2 or height
		self:InitTrigger(self.shapeType, radius, height, nil, outRadius, outHeight, nil, self.config.SetOutOffset, normalOffset, outOffset)
	end
end

function TriggerComponent:InitTrigger(shape, inRangeX, inRangeY, inRangeZ, outRangeX, outRangeY, outRangeZ, differentOffset, offset, outOffset)
	local sameCollider = false
	if inRangeX and inRangeX ~= 0 then
		local triggerType = FightEnum.TriggerType.InteractIn
		if outRangeX == inRangeX and outRangeY == inRangeY and outRangeZ == inRangeZ and not differentOffset then
			triggerType = triggerType | FightEnum.TriggerType.InteractOut
			sameCollider = true
		end

		local collider = self:CreateCollider(shape, triggerType, inRangeX, inRangeY, inRangeZ, offset[1], offset[2], offset[3])
		self.inCollider = collider
		if sameCollider then
			self.outCollider = collider
		end
	end

	if not sameCollider and outRangeX and outRangeX ~= 0 then
		local collider = self:CreateCollider(shape, FightEnum.TriggerType.InteractOut, outRangeX, outRangeY, outRangeZ, outOffset[1], outOffset[2], outOffset[3])
		self.outCollider = collider
	end
end

function TriggerComponent:CreateCollider(shape, triggerType, x, y, z, offsetX, offsetY, offsetZ)
	local parent = self.entity.clientTransformComponent:GetTransform()
	local collider = BaseCollider.Create(shape, x, y, z, offsetX, offsetY, offsetZ, FightEnum.Layer.IgnoreRayCastLayer, parent, self.entity)
	if collider then
		collider:AddTriggerComponent(triggerType, 1 << FightEnum.Layer.Entity)
	end

	return collider
end

-- 在初始化的基础上额外添加检测触发的层级
function TriggerComponent:ExtraAddTriggerLayer(layer)
	if self.inCollider then
		self.inCollider:ExtraAddCheckTriggerLayer(1 << layer)
	end

	if self.outCollider then
		self.outCollider:ExtraAddCheckTriggerLayer(1 << layer)
	end
end

local EnterStr = "EnterTrigger"
local ExitStr = "ExitTrigger"
local ExtraEnterStr = "ExtraEnterTrigger"
local ExtraExitStr = "ExtraExitTrigger"
function TriggerComponent:InvokeEvent(enter, id)
	local entityInfo = Fight.Instance.playerManager:GetPlayer():GetEntityInfo(id)
	if enter and (self.blockWall or self.outScreen) then
		return
	end
	if entityInfo then
		local funcName = enter and EnterStr or ExitStr
		local ecoCfg = Config.DataEcogoods.data_ecogoods[self.entity.sInstanceId]
		if ecoCfg then 
			if enter then 
				EventMgr.Instance:Fire(EventName.ActiveGoodsInteract, ecoCfg, self.entity.instanceId)
			else 
				EventMgr.Instance:Fire(EventName.RemoveGoodsInteract, ecoCfg, self.entity.instanceId)
			end
			return 
		end
		self.fight.entityManager:CallBehaviorFun(funcName,self.entity.instanceId,self.entity.entityId, id)
	else
		local funcName = enter and ExtraEnterStr or ExtraExitStr
		self.fight.entityManager:CallBehaviorFun(funcName,self.entity.instanceId,self.entity.entityId, id)
	end
end

function TriggerComponent:Update()
	if not self.enabled or not self.entity.updateComponentEnable then
		if not self.notUpdate then
			self:RemoveAllTriggerEvent()
			self.notUpdate = true
		end
		return
	end

	self.notUpdate = false
	if self.nowDurationTime and self.nowDurationTime >=  0 then
		self.nowDurationTime = self.nowDurationTime - 1
	end
	-- 持续时间结束
	if self.nowDurationTime and self.nowDurationTime < 0 then
		self.enabled = false
		local playerId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
		local interactItem = self.entity:GetInteractItem()
		if self.defaultInteractId then
			self.entity:RemoveInteractItem(self.defaultInteractId)
			self.defaultInteractId = nil
		end
		self:ExitAreaEvent(playerId)
		self:InvokeEvent(false, playerId)
		self.triggerEntities[playerId] = nil
		return
	end

	local inArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.InteractIn, self.inCollider.colliderObjInsId, InCacheTable)
	local outArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.InteractOut, self.outCollider.colliderObjInsId, OutCacheTable)
	local playerId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	for _, v in pairs(self.triggerEntities) do
		local out = true
		for _, vv in pairs(outArea) do
			if vv == v then
				out = false
				break
			end
		end

		if out then
			local interactItem = self.entity:GetInteractItem()
			if interactItem[self.defaultInteractId] and v == playerId then
				self.entity:RemoveInteractItem(self.defaultInteractId)
				self.defaultInteractId = nil
			end
			self:ExitAreaEvent(v)
			self:InvokeEvent(false, v)
			self.triggerEntities[v] = nil
		elseif self.config.EnterBehaviorAlways then
			self:TriggerEvent(v, playerId)
		end
	end
	if self.activeEnter then
		for _, v in pairs(inArea) do
			if not self.triggerEntities[v] then
				self:TriggerEvent(v, playerId)
				self.triggerEntities[v] = v
			end
		end
	end
	if self.canBlockWall and not self.canOutScreen then
		return
	end

	-- TODO 大悬钟是LOD资源 资源不在实体内部 所以先过滤掉
	if self.entity.entityId == 2020105 then
		return
	end

	UnityUtils.BeginSample("TriggerComponent:BlockUpdate")

	-- TODO 这里计算性能低 要优化掉
	self.playerCameraTarget = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().clientTransformComponent:GetTransform("CameraTarget")
	-- local distance = Vec3.Distance(self.entityTransform.position, self.playerCameraTarget.position)
	local distance = BehaviorFunctions.GetDistanceFromPos(self.entityTransform.position, self.playerCameraTarget.position)
	if distance < (self.config.RadiusOut or self.config.Radius) then
		local CenterPos = self.entity.transformComponent.position
		if self.canOutScreen then
			local x, y, z = CustomUnityUtils.WorldToViewportPoint(CenterPos.x, CenterPos.y, CenterPos.z)
			self.outScreen = not (z > 0 and x > -0.1 and x < 1.1 and y > -0.1 and y < 1.1) and true or false
		else
			self.outScreen = false
		end

		if not self.canBlockWall then
			local pos = self.playerCameraTarget.position
			self.triggeCenter:Set(0, self.blockWallOffectHight, 0)
			self.triggeCenter:Add(self.entityTransform.position)
			local forward = self.triggeCenter - self.playerCameraTarget.position
			local go = CS.PhysicsTerrain.GetRayCastObject(pos.x,pos.y,pos.z,forward.x,forward.y,forward.z, distance, self.checkLayer)
			if go then
				while go and go.name ~= "FightRoot" and go.name ~= self.entityTransform.name do
					go = go.transform.parent
				end
				if go then
					go = go.name == "FightRoot" and go or nil
				end
			end
			self.blockWall = go and true or false
			if self.outScreen or go then
				CS.UnityEngine.Debug.DrawRay(pos, forward, Color.red)
			else
				CS.UnityEngine.Debug.DrawRay(pos, forward, Color.green)
			end
		else
			self.blockWall = false
		end
		
		if distance < self.config.Radius then
			if not self.blockWall and not self.outScreen then
				for _, v in pairs(self.triggerEntities) do
					if self.blockEntities[v] == nil or self.blockEntities[v] == true then
						self.blockEntities[v] = false
						self.fight.entityManager:ChangeTriggerEntityStateById(self.entity.instanceId, true)
					end
				end
			end
		end
		if self.blockWall or self.outScreen then
			for _, v in pairs(self.triggerEntities) do
				if self.blockEntities[v] == nil or self.blockEntities[v] == false then
					self.blockEntities[v] = true
					self.fight.entityManager:ChangeTriggerEntityStateById(self.entity.instanceId, false)
				end
				
			end
		end
	end

	UnityUtils.EndSample()
end

function TriggerComponent:CheckTriggerEntityOut(instanceId)
	for _, v in pairs(self.triggerEntities) do
		local interactItem = self.entity:GetInteractItem()
		if interactItem[self.defaultInteractId] and v == instanceId then
			self.entity:RemoveInteractItem(self.defaultInteractId)
			self.defaultInteractId = nil
		end
		self:ExitAreaEvent(v)
		self:InvokeEvent(false, v)
		self.triggerEntities[v] = nil
	end
	self.entity:RemoveTrigger()
end

function TriggerComponent:TriggerEvent(insId, playerId)
	self:AddDefaultInteractItem(insId, playerId)
	self:EnterAreaEvent(insId)
	self:InvokeEvent(true, insId)
end

function TriggerComponent:AddDefaultInteractItem(insId, playerId)
	if insId ~= playerId or (self.blockEntities and self.blockEntities[insId]) then
		return
	end

	if not self.defaultDesc and not self.defaultIcon then
		return
	end

	local interactItem = self.entity:GetInteractItem()
	local interactItemState = self.entity:GetInteractItemState()
	if not interactItemState or interactItem[self.defaultInteractId] then
		return
	end
	self.defaultInteractId = self.entity:AddInteractItem(self.defaultType, self.defaultIcon, self.defaultDesc, nil, nil)
end

function TriggerComponent:EnterAreaEvent(instanceId)
	self:MagicEvent(true, instanceId)
end

function TriggerComponent:MagicEvent(isEnter, instanceId)
	local magicList = self.config.EnterMagicList or {}
	for k, v in pairs(magicList) do
		if not v.Target or BehaviorFunctions.CheckIsTarget(self.entity.instanceId, instanceId, v.Target) then
			local parentInstanceId = self.entity.parent and self.entity.parent.instanceId or nil
			local buffCfg = MagicConfig.GetBuff(v.MagicId, self.entity.entityId, nil, parentInstanceId)
			if isEnter then
				BehaviorFunctions.DoMagic(self.entity.instanceId, instanceId, v.MagicId)
			elseif buffCfg and v.RemoveWhenLeft then
				BehaviorFunctions.RemoveBuff(instanceId, v.MagicId)
			end
		end
	end

	if not isEnter then
		magicList = self.config.LeftMagicList or {}
		for k, v in pairs(magicList) do
			if not v.Target or BehaviorFunctions.CheckIsTarget(self.entity.instanceId, instanceId, v.Target) then
				BehaviorFunctions.DoMagic(self.entity.instanceId, instanceId, v.MagicId)
			end
		end
	end
end

function TriggerComponent:ExitAreaEvent(instanceId)
	self:MagicEvent(false, instanceId)
end

function TriggerComponent:ChangeDefaultInfo(icon, desc)
	self.defaultIcon = icon and icon or self.defaultIcon
	self.defaultDesc = desc and desc or self.defaultDesc
end

function TriggerComponent:OnCache()
	self:RemoveAllTriggerEvent()
	if self.inCollider then
		self.inCollider:OnCache()
	end

	if self.outCollider and self.outCollider ~= self.inCollider then
		self.outCollider:OnCache()
	end

	self.enabled = true
	self.inCollider = nil
	self.outCollider = nil
	self.fight.objectPool:Cache(TriggerComponent,self)
end

function TriggerComponent:RemoveAllTriggerEvent()
	for _, v in pairs(self.triggerEntities) do
		self:ExitAreaEvent(v)
		self.fight.entityManager:CallBehaviorFun("ExitTrigger",self.entity.instanceId,self.entity.entityId,v)
	end
	
	local interactItem = self.entity:GetInteractItem()
	for k, v in pairs(interactItem) do
		if interactItem[k] then
			self.entity:RemoveInteractItem(k)
		end
	end
	self.triggerEntities = {}
end