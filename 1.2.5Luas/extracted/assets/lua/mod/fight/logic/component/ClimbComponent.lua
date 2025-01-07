---@class ClimbComponent
ClimbComponent = BaseClass("ClimbComponent",PoolBaseClass)
local Vec3 = Vec3
local UpDir = Vec3.New(0, 1, 0)

function ClimbComponent:__init()
	self.moveVector = Vec3.New()
	self.forceCheckDir = Vec3.New()
end

function ClimbComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Climb)
	self.transformComponent = self.entity.transformComponent
	self.stateComponent = self.entity.stateComponent
	self.strideOverY = 0
	
	self.climbToStrideOver = false
	self.inRoom = false

	EventMgr.Instance:AddListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:AddListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ClimbComponent:TryStartClimb()
	if not self.stateComponent:CanClimb() or self.inRoom then
		return false
	end
	
	if self:TryStrideOver() then
		return true
	end

	local dodgeValue = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue)
	if dodgeValue < 50 then
		return 
	end
	
	--TODO: 临时数据，得改。切换状态前试图向上检测一步，如果走不动，就不切了
	local offset = Vec3.New(0, 25 * FightUtil.deltaTimeSecond, 0)
	if self.fight.physicsTerrain:Climb(self.entity, offset, UpDir, true) == Vec3.zero then
		return false
	end

	self.stateComponent:SetState(FightEnum.EntityState.Climb)
	return true
end

function ClimbComponent:TryStrideOver(heightOffset, climbToStrideOver)
	self.climbToStrideOver = climbToStrideOver or false
	local canStrideOver, toPos, strideOverY, strideOverZ = self.fight.physicsTerrain:StrideOver(self.entity, heightOffset)
	if canStrideOver then
		self.strideOverY = strideOverY
		self.strideOverZ = strideOverZ
		self.entity.moveComponent.yMoveComponent:OnLand()
		
		if toPos.x ~= 0 or toPos.y ~= 0 or toPos.z ~= 0 then
			self.transformComponent:SetPositionOffset(toPos.x,toPos.y,toPos.z)
		end
		self.stateComponent:SetState(FightEnum.EntityState.StrideOver)
	else
		self.climbToStrideOver = false
	end
	
	return canStrideOver
end

function ClimbComponent:GetStrideOverOffset()
	return self.strideOverY, self.strideOverZ
end

function ClimbComponent:UpdateRotAndPos(heightCheck)
	local dir, offsetPos = self.fight.physicsTerrain:UpdateClimbRotAndPos(self.entity, heightCheck)
	
	if offsetPos ~= Vec3.zero then
		self.entity.transformComponent:SetPositionOffset(offsetPos.x, offsetPos.y, offsetPos.z)
	end
	
	if dir == Vec3.zero then
		self.stateComponent:SetState(FightEnum.EntityState.Idle)
		return
	end
	
	local rotation = Quat.LookRotationA(dir.x, dir.y, dir.z)
	self.entity.transformComponent:SetRotation(rotation)
end

function ClimbComponent:DoMoveUp(speed)
	local up = self.transformComponent.rotation * Vec3.up
	self:SetPositionOffset(up.x * speed,up.y * speed,up.z * speed)
end

function ClimbComponent:DoMoveRight(speed)
	local right = self.transformComponent.rotation * Vec3.right
	self:SetPositionOffset(right.x * speed,right.y * speed,right.z * speed)
end

function ClimbComponent:SetForceCheckDirection(x, y, z)
	self.forceCheckDir:Set(x, y, z)
end

function ClimbComponent:SetPositionOffset(x,y,z)
	self.moveVector.x = self.moveVector.x + x
	self.moveVector.y = self.moveVector.y + y
	self.moveVector.z = self.moveVector.z + z
end

function ClimbComponent:SetAdjustCheckOffset(offset)
	local checkOffset = offset or self.entity.collistionComponent.height * 0.3
	self.adjustCheckOffset = checkOffset
end

function ClimbComponent:Update()
	--local input = Fight.Instance.inputManager:GetRecodeMove()
	--pritn(input)
end

function ClimbComponent:AfterUpdate()
	if not self.stateComponent:IsState(FightEnum.EntityState.Climb) then
		self.moveVector:Set(0, 0, 0)
		self.forceCheckDir:Set(0, 0, 0)
		return 
	end
	
	local offset = self.moveVector
	if offset ~= Vec3.zero then
		self:UpdateRotAndPos(self.adjustCheckOffset or 0)
		offset = self.fight.physicsTerrain:Climb(self.entity, offset, self.forceCheckDir, false)
		--self.transformComponent:SetPositionOffset(offset.x,offset.y,offset.z) --放这里会抖动
	end
	
	self.transformComponent:SetPositionOffset(offset.x,offset.y,offset.z)
	
	self.moveVector:Set(0, 0, 0)
	self.forceCheckDir:Set(0, 0, 0)
end

function ClimbComponent:OnEnterTriggerLayer(instanceId, layer)
	if layer ~= FightEnum.Layer.InRoom or instanceId ~= self.entity.instanceId then
		return
	end

	self.inRoom = true
end

function ClimbComponent:OnExitTriggerLayer(instanceId, layer)
	if layer ~= FightEnum.Layer.InRoom or instanceId ~= self.entity.instanceId then
		return
	end

	self.inRoom = false
end

function ClimbComponent:ApplyAnimation()
end

function ClimbComponent:OnCache()
	self.fight.objectPool:Cache(ClimbComponent,self)
end

function ClimbComponent:__cache()
	self.inRoom = false
	self.moveVector:Set(0,0,0)
	self.forceCheckDir:Set(0,0,0)

	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end

function ClimbComponent:__delete()
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
	EventMgr.Instance:RemoveListener(EventName.ExitTriggerLayer, self:ToFunc("OnExitTriggerLayer"))
end