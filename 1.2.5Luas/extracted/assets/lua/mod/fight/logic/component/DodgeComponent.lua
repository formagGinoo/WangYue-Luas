---@class DodgeComponent
DodgeComponent = BaseClass("DodgeComponent",PoolBaseClass)

DodgeComponent.LimitState =
{
	Enable  = 1,
	Disable = 2,
	Cooling = 3,
}

function DodgeComponent:__init()
	self.frame = 0
	self.lastFrame = 0
	self.config = nil
	self.transInfos = {}

	self.triggerType = FightEnum.TriggerType.Fight
	self.limitState = DodgeComponent.LimitState.Enable
	self.limNowCoolingTime = 0
	self.limMaxCoolingTime = 0
	
	self.cachePart = {}
end

function DodgeComponent:__delete()
end

function DodgeComponent:OnCache()
	self.limitState = DodgeComponent.LimitState.Enable
	self.limNowCoolingTime = 0
	self.limMaxCoolingTime = 0
	TableUtils.ClearTable(self.transInfos)
	self:RemoveCheckCollider()

	self.fight.objectPool:Cache(DodgeComponent,self)
end

function DodgeComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Dodge)
end

function DodgeComponent:Update()
	self:UpdateDodge()
	self:UpdateLimitState()
end

function DodgeComponent:UpdateDodge()
	if self.lastFrame <= 0 then
		return
	end

	if self.frame >= self.lastFrame then
		self.lastFrame = 0
		self.transInfos = {}
		self:RemoveCheckCollider()
		self.count = 0
		self.curCount = 0
		return
	end

	self.frame = self.frame + 1
	--self:AddTransInfo()
	UnityUtils.BeginSample("CreateCheckCollider")
	self:CreateCheckCollider()
	UnityUtils.EndSample()

	-- 遍历所有攻击是否触发闪避
	--local entites = self.fight.entityManager:GetEntites()
	--for k, entity in pairs(entites) do
		--local attackComponent = entity.attackComponent
		--if attackComponent and attackComponent:IsValid() and attackComponent:CheckDodge(self.entity)
			--and attackComponent:NeedCheck(self.entity) then
			--if self.entity.partComponent:PartsColliderCheckByDodge(attackComponent) then
				--attackComponent:DealDodge(self.entity)
			--end
		--end
	--end
	
	UnityUtils.BeginSample("DealDodge")
	for _, v in pairs(self.cachePart) do
		for _, vv in pairs(v) do
			local entites = vv:GetTriggerEntity()
			for k, entity in pairs(entites) do
				local attackComponent = entity.attackComponent
				if attackComponent and attackComponent:IsValid() and attackComponent:CheckDodge(self.entity)
					and attackComponent:NeedCheck(self.entity) then
					attackComponent:DealDodge(self.entity)
				end
			end
		end
	end
	UnityUtils.EndSample()
end

function DodgeComponent:ActiveDodge(frame,ringCount,isJumpDodge)
	self.frame = 0
	self.ringCount = ringCount == 0 and 1 or ringCount
	self.lastFrame = frame or 1
	self.curCount = 1
	self.isJumpDodge = isJumpDodge
	--self:AddTransInfo()
	
	self:RemoveCheckCollider()
	if self.frame ~= 0 then
		self:CreateCheckCollider()
	end
end

function DodgeComponent:RemoveCheckCollider()
	for _, v in pairs(self.cachePart) do
		for _, vv in pairs(v) do
			vv:OnCache()
		end
	end
	TableUtils.ClearTable(self.cachePart)
end

function DodgeComponent:CreateCheckCollider()
	if not self.entity.partComponent then
		return 
	end
	
	local transformComponent = self.entity.transformComponent
	local transformPos = transformComponent.position
	local transformRotation = transformComponent.rotation
	
	local index = self.curCount
	while index > self.ringCount do
		index = index - self.ringCount
	end

	if self.cachePart[index] then
		for _, v in pairs(self.cachePart[index]) do
			v:OnCache()
		end
	end
	
	self.cachePart[index] = {}
	local partList = self.entity.partComponent.partConfig.PartList
	for k, v in ipairs(partList) do
		local part = self.fight.objectPool:Get(DodgePart)
		part:Init(self.fight, self.entity, v)
		table.insert(self.cachePart[index], part)
	end
	
	self.curCount = self.curCount + 1
end

function DodgeComponent:AddTransInfo()
	--TODO:定点数
	local transformComponent = self.entity.transformComponent
	local transformPos = transformComponent.position
	local transformRotation = transformComponent.rotation

	for i,v in ipairs(self.transInfos) do
		if transformPos == v.position and transformRotation == v.rotation then
			return
		end
	end

	local pos = Vec3.New(transformPos.x,transformPos.y,transformPos.z)
	local rotation = Quat.New(transformRotation.x,transformRotation.y,transformRotation.z,transformRotation.w)
	local index = self.curCount
	while index > self.ringCount do
		index = index - self.ringCount
	end
	
	--table.insert(self.transInfos,index,{position = pos,rotation = rotation})
	self.transInfos[index] = {position = pos,rotation = rotation}
	self.curCount = self.curCount + 1
end

function DodgeComponent:IsValid()
	return self.lastFrame > 0
end

function DodgeComponent:UpdateLimitState()
	if self.limitState == DodgeComponent.LimitState.Cooling then
		self.limNowCoolingTime = self.limNowCoolingTime - FightUtil.deltaTimeSecond
		
		if self.limNowCoolingTime <= 0 then
			self.limitState = DodgeComponent.LimitState.Enable
		end
		EventMgr.Instance:Fire(EventName.DodgeValueChange)
	end
end

function DodgeComponent:SetLimitState(limitState)
	self.limitState = limitState
	if ctx then
		EventMgr.Instance:Fire(EventName.DodgeValueChange)
	end
end

function DodgeComponent:GetLimitState()
	return self.limitState
end

function DodgeComponent:IsLimitState(limitState)
	return self.limitState == limitState
end

function DodgeComponent:SetLimitCoolingTime(nowCoolingTime,maxCoolingTime)
	if maxCoolingTime ~= -1 then
		self.limMaxCoolingTime = maxCoolingTime
	else
		self.limMaxCoolingTime = self.config._debugLimitCoolingTime
	end

	if nowCoolingTime ~= -1 then
		self.limNowCoolingTime = nowCoolingTime
	else
		self.limNowCoolingTime = self.limMaxCoolingTime
	end
end

function DodgeComponent:GetCoolingPercent()
	if self.limNowCoolingTime and self.limMaxCoolingTime and self.limMaxCoolingTime ~= 0 then
		return (self.limNowCoolingTime / self.limMaxCoolingTime)
	end
end