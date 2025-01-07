---@class TimeoutDeathComponent
TimeoutDeathComponent = BaseClass("TimeoutDeathComponent",PoolBaseClass)

function TimeoutDeathComponent:__init()
	self.hideTransformList = {}
end



function TimeoutDeathComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.TimeoutDeath)

	self.remainingFrame = self.config.Frame
	self.lastRemainingFrame = self.remainingFrame
	self.scaleFrame = 0
	self.removeDelayFrame = self.config.RemoveDelayFrame or 0
end

function TimeoutDeathComponent:SetDeath()
	if self.removeDelayFrame == 0 then
		self.fight.entityManager:RemoveEntity(self.entity.instanceId)
		return
	end

	self.remainingFrame = 1
	self:AfterUpdate()
end

function TimeoutDeathComponent:Update()

end

function TimeoutDeathComponent:AfterUpdate()
	local timescale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	self.scaleFrame = self.scaleFrame + timescale
	if self.scaleFrame < 1 then
		return 
	end
	self.scaleFrame = self.scaleFrame - 1
	if self.remainingFrame <= 0 then
		if self.lastRemainingFrame > 0 then
			EventMgr.Instance:Fire(EventName.OnEntityTimeoutDeath, self.entity.instanceId)
			if self.removeDelayFrame <= 0 then
				self.fight.entityManager:RemoveEntity(self.entity.instanceId)
			else
				if self.config.RemoveDelayHideList and next(self.config.RemoveDelayHideList) then
					local clientTransformComponent = self.entity.clientEntity.clientTransformComponent
					for k, v in pairs(self.config.RemoveDelayHideList) do
						local transform = clientTransformComponent:GetTransform(v)
						if not transform then
							LogError("transform nil " .. v)
						else
							transform:SetActive(false)
							table.insert(self.hideTransformList, transform)
						end
					end
				end
				-- 延迟销毁表现，先销毁部分逻辑组件
				self:DestroyCompment()
			end
		end

		if self.remainingFrame < 0 and self.removeDelayFrame > 0 then
			self.removeDelayFrame = self.removeDelayFrame - 1
			if self.removeDelayFrame <= 0 then
				self.fight.entityManager:RemoveEntity(self.entity.instanceId)
			end
		end
	end
	self.lastRemainingFrame = self.remainingFrame
	self.remainingFrame = self.remainingFrame - 1
end

function TimeoutDeathComponent:DestroyCompment()
	if self.entity.moveComponent then
		self.entity.moveComponent:OnCache()
		self.entity.moveComponent = nil
	end

	self.entity:RemoveComponent(FightEnum.ComponentType.Attack)
	self.entity.transformComponent.lastPosition:SetA(self.entity.transformComponent.position)
	self.entity.clientEntity.clientTransformComponent:Async()
end

function TimeoutDeathComponent:OnCache()
	for k, v in pairs(self.hideTransformList) do
		v:SetActive(true)
	end
	TableUtils.ClearTable(self.hideTransformList)
	
	self.fight.objectPool:Cache(TimeoutDeathComponent,self)
end

function TimeoutDeathComponent:__cache()
	self.fight = nil
	self.entity = nil
end

function TimeoutDeathComponent:__delete()
	
end


