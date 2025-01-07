---@class TriggerComponent
TriggerComponent = BaseClass("TriggerComponent",PoolBaseClass)

local InCacheTable = {}
local OutCacheTable = {}

function TriggerComponent:__init()
	self.inCollider = nil
	self.outCollider = nil
end

function TriggerComponent:__delete()

end

function TriggerComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Trigger)
	self.shapeType = self.config.ShapeType or FightEnum.CollisionType.Sphere
	
	self.enabled = true
	self.triggerEntities = {}

	EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
end

function TriggerComponent:LateInit()
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
	local parent = self.entity.clientEntity.clientTransformComponent:GetTransform()
	local collider = BaseCollider.Create(shape, x, y, z, offsetX, offsetY, offsetZ, FightEnum.Layer.IgonreRayCastLayer, parent, self.entity)
	if collider then
		collider:AddTriggerComponent(triggerType, 1 << FightEnum.Layer.EntityCollision)
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
	local playerId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if id == playerId then
		local funcName = enter and EnterStr or ExitStr
		self.fight.entityManager:CallBehaviorFun(funcName,self.entity.instanceId,self.entity.entityId, id)
	else
		local funcName = enter and ExtraEnterStr or ExtraExitStr
		self.fight.entityManager:CallBehaviorFun(funcName,self.entity.instanceId,self.entity.entityId, id)
	end
end

function TriggerComponent:Update()
	if not self.enabled then
		return 
	end

	local inArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.InteractIn, self.inCollider.colliderObjInsId, InCacheTable)
	local outArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.InteractOut, self.outCollider.colliderObjInsId, OutCacheTable)
	for _, v in pairs(self.triggerEntities) do
		local out = true
		for _, vv in pairs(outArea) do
			if vv == v then
				out = false
				break
			end
		end
		
		if out then
			self:InvokeEvent(false, v)
			self.triggerEntities[v] = nil
		elseif self.config.EnterBehaviorAlways then
			self:InvokeEvent(true, v)
		end
	end

	for _, v in pairs(inArea) do
		if not self.triggerEntities[v] then
			self:InvokeEvent(true, v)
			self.triggerEntities[v] = v
		end
	end

end

function TriggerComponent:OnCache()
	EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
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

function TriggerComponent:OnRemoveEntity(instanceId)
	if instanceId ~= self.entity.instanceId then
		return
	end
	
	for _, v in pairs(self.triggerEntities) do
		self.fight.entityManager:CallBehaviorFun("ExitTrigger",self.entity.instanceId,self.entity.entityId,v)
	end
	self.triggerEntities = {}
end