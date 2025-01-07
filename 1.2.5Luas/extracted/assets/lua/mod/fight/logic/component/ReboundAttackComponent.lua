---@class ReboundAttackComponent
ReboundAttackComponent = BaseClass("ReboundAttackComponent",PoolBaseClass)

function ReboundAttackComponent:__init()
	self.reboundAttackList = {}
end

function ReboundAttackComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.remainFrame = 0

	
end

function ReboundAttackComponent:Update()
	if next(self.reboundAttackList) then
		for i = #self.reboundAttackList, 1, -1 do
			local reboundInfo = self.reboundAttackList[i]
			if reboundInfo.reboundEntityFrame > 0 then
				reboundInfo.reboundEntityFrame = reboundInfo.reboundEntityFrame - 1
				if reboundInfo.reboundEntityFrame < 0 then
					table.remove(self.reboundAttackList, i)
				end
			end
		end
	end

	if self.remainFrame <= 0 then
		return
	end

	self.remainFrame = self.remainFrame - 1
end

function ReboundAttackComponent:Start(reboundInfo)
	self.remainFrame = reboundInfo.ReboundFrame
	self.checkDegreeList = reboundInfo.ReboundDegrees
end

function ReboundAttackComponent:AddReboundAttack(attackEntity, reboundEntityId, reboundEntityFrame)
	if self.remainFrame <= 0 then
		return false
	end

	local pos = self.entity.transformComponent.position
	local rotation = self.entity.transformComponent.rotation
	local targetPos = attackEntity.transformComponent.position
	local degree = CustomUnityUtils.AngleSigned(rotation * Vec3.forward, targetPos - pos) % 360
	if degree > 180 then
		degree = degree - 360
	end

	for k, v in pairs(self.checkDegreeList) do
		if v.startDegree <= degree and degree <= v.endDegree then
			local reboundAttack = 
			{
				attackInstanceId = attackEntity.instanceId,
			 	reboundEntityId = reboundEntityId,
			 	reboundEntityFrame = reboundEntityFrame,
			}

			table.insert(self.reboundAttackList, reboundAttack)
			self.fight.entityManager:CallBehaviorFun("ReboundAttack", self.entity.instanceId, attackEntity.instanceId)
			return true
		end
	end
end

function ReboundAttackComponent:CheckReboundAttack(attackInstanceId, reboundEntityId)
	if self.remainFrame <= 0 then
		return false
	end

	for k, v in ipairs(self.reboundAttackList) do
		if v.attackInstanceId == attackInstanceId and v.reboundEntityId == reboundEntityId then
			table.remove(self.reboundAttackList, k)
			return true
		end
	end

	return false
end

function ReboundAttackComponent:DoReboundAttack(attackEntity)
	if self.remainFrame <= 0 then
		return false
	end

	local pos = self.entity.transformComponent.position
	local rotation = self.entity.transformComponent.rotation
	local targetPos = attackEntity.transformComponent.position
	local degree = CustomUnityUtils.AngleSigned(rotation * Vec3.forward, targetPos - pos) % 360
	if degree > 180 then
		degree = degree - 360
	end

	for k, v in pairs(self.checkDegreeList) do
		if v.startDegree <= degree and degree <= v.endDegree then
			self.fight.entityManager:CallBehaviorFun("ReboundAttack", self.entity.instanceId, attackEntity.instanceId)
			return true
		end
	end
end

function ReboundAttackComponent:OnCache()
	TableUtils.ClearTable(self.reboundAttackList)
	self.fight.objectPool:Cache(ReboundAttackComponent,self)
end

function ReboundAttackComponent:__cache()
	self.fight = nil
	self.entity = nil
	self.config = nil
end

function ReboundAttackComponent:__delete()

end