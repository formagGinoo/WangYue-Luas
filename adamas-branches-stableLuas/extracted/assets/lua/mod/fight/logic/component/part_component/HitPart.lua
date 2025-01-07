HitPart = BaseClass("HitPart", PartBase)

local AttrType = EntityAttrsConfig.AttrType
local WeakEntityEffectId = 1000000005

function HitPart:__init()
	self.weakEffectEntities = {}
	self.colliderList = {}
	self.hpTriggerEvents = {}
end

function HitPart:Init(fight, entity, config, isTrigger)
	self:BaseFunc("Init", fight, entity, config, isTrigger)

	self.partComponent = entity.partComponent
	-- 相机和搜索锁定
	self.logicLock = config.LogicLock

	self.logicSearch = config.LogicSearch

	self.dmgHurt = config.DmgHurtOpen
	self.dmgPartHurt = config.DmgPartHurtOpen

	self.logicVisible = true
	
	self.weakTrasnforms = config.WeakTrasnforms
	self.weakWeight = config.weakWeight or 1
	self.searchWeight = config.SearchWeight or 0
	self.lockWeight = config.LockWeight or 0
	self.hpEvents = config.HpEvents
	self.onlyHitAlarm = config.OnlyHitAlarm

	if not config.lockTransformName or config.lockTransformName == "" then
		self.lockTransformName = "HitCase"
	else
		self.lockTransformName = config.lockTransformName
	end
	self.lockTransform = self.clientTransformComponent:GetTransform(self.lockTransformName)

	if not self.lockTransform then
		print("self.lockTransformName null "..self.lockTransformName)
	end

	if not config.attackTransformName or config.attackTransformName == "" then
		self.attackTransformName = "HitCase"
	else
		self.attackTransformName = config.attackTransformName
	end

	if not config.hitTransformName or config.hitTransformName == "" then
		self.hitTransformName = "HitCase"
	else
		self.hitTransformName = config.hitTransformName
	end

	if config.Attr then
		local hp = entity.attrComponent:GetValue(AttrType.MaxLife)
		self.damageShield = hp * config.Attr.HpPercent * 0.0001
		self.damageShieldMax = self.damageShield
		self.damageShieldPercent = 10000
		self.damageParam = config.Attr.DamageParam * 0.0001
	end

	self.partType = config.PartType
	self.partWeakType = config.PartWeakType
end

function HitPart:InitCollider()
	--吹飞物件的碰撞盒监听实体的碰撞
	if self.entity.blowComponent then
		self.isTrigger = true
		self.triggerType = FightEnum.TriggerType.Fight
		self.checkLayer = FightEnum.LayerBit.Entity
	end
	
	for k, v in pairs(self.config.BoneColliders) do
		self:CreateCollider(v)
	end
end
function HitPart:SetCollisionAttacked(collision)
	self.collisionAttacked = collision
end

function HitPart:OnCache()
	for k, v in pairs(self.colliderList) do
		v:OnCache()
	end
	self.colliderList = {}

	self.fight.objectPool:Cache(HitPart,self)
end

function HitPart:CheckHurtDamage()
	return self.dmgHurt
end

function HitPart:CheckPartHurtDamage()
	return self.dmgHurt and self.dmgPartHurt
end

function HitPart:HurtDamage(damage,attackEntity)
	local attackType = 0
	local shakeStrenRatio = 0
	if self.damageShield and self.damageShield >= 0 and self:CheckPartHurtDamage() then
		self.damageShield = self.damageShield - damage
		if attackEntity and attackEntity.attackComponent then
			local attackConfig = attackEntity.attackComponent.config
			attackType = attackConfig.AttackType
			shakeStrenRatio = attackConfig.ShakeStrenRatio
		end
		self.fight.entityManager:CallBehaviorFun("PartHit", self.entity.instanceId, self.partName, self.damageShield, damage, attackType, shakeStrenRatio)

		if self.hpEvents then
			local shieldPercent = self.damageShield / self.damageShieldMax * 10000
			for k, v in ipairs(self.hpEvents) do
				if v.HpPercent <= self.damageShieldPercent and v.HpPercent > shieldPercent then
					if not self.hpTriggerEvents[v.EventId] or not v.RepeatType then
						self.fight.entityManager:CallBehaviorFun("PartDestroy", self.entity.instanceId, self.partName, v.EventId)
						self.hpTriggerEvents[v.EventId] = true
					end
				end
			end
			self.damageShieldPercent = shieldPercent
		end
	else
		self.fight.entityManager:CallBehaviorFun("PartHit", self.entity.instanceId, self.partName, 0, 0, attackType, 0)
	end

	return self.clientTransformComponent:GetTransform(self.hitTransformName).position
end

function HitPart:IsPartLogicLock()
	if not self.logicVisible then
		return false
	end

	return self.logicLock
end

function HitPart:SetLogicLock(lock)
	self.logicLock = lock
end

function HitPart:IsPartLogicSearch()
	if not self.logicVisible then
		return false
	end

	return self.logicSearch
end

function HitPart:SetLogicSearch(search)
	self.logicSearch = search
end

function HitPart:SetLogicVisible(visible)
	self.logicVisible = visible

	if self.colliderList then
		for k, v in pairs(self.colliderList) do
			v.colliderObj:SetActive(visible)
		end
	end
end


function HitPart:IsDestroy()
	return self.damageShield and self.damageShield <= 0
end

function HitPart:EnableWeakEffect(enable)
	self.enableWeakEffect = enable
end

function HitPart:CreateWeakEffectEntity()
	if next(self.weakEffectEntities) then
		return
	end

	if self.colliderList == nil then
		return
	end

	if self.weakTrasnforms then
		for k, v in pairs(self.weakTrasnforms) do
			local entity = self.fight.entityManager:CreateEntity(WeakEntityEffectId, self.entity)
			local clientTransformComponent = entity.clientTransformComponent
			clientTransformComponent:SetBindTransform(v, false, true)
			clientTransformComponent.transform:SetActive(false)
			clientTransformComponent.transform:SetActive(true)
			table.insert(self.weakEffectEntities, entity)
		end
	end
end

function HitPart:DestroyWeakEffectEntity()
	if self.weakEffectEntities then
		for k, v in pairs(self.weakEffectEntities) do
			local clientTransformComponent = v.clientTransformComponent
			self.fight.entityManager:RemoveEntity(v.instanceId)
		end
		TableUtils.ClearTable(self.weakEffectEntities)
	end
end

function HitPart:IsWeakNess()
	return self.partType == FightEnum.PartType.Weak
end

function HitPart:DestroyCollider()
	self:BaseFunc("DestroyCollider")

	--事件驱动
	if AimFSM.weakNess then
		self.weakNessDestroyEffect = self.fight.entityManager:CreateEntity(WeakEntityEffectId, self.entity)
	end
end

function HitPart:__cache()
	self:DestroyWeakEffectEntity()
	self:DestroyCollider()
	if self.weakNessDestroyEffect then
		self.fight.entityManager:RemoveEntity(self.weakNessDestroyEffect.instanceId)
		self.weakNessDestroyEffect = nil
	end

	self.fight = nil
	self.entity = nil
	self.collisionAttacked = nil
	self.damageShield = nil
	self.damageParam = nil
	self.lockTransform = nil

	TableUtils.ClearTable(self.weakEffectEntities)
	TableUtils.ClearTable(self.hpTriggerEvents)
end

function HitPart:__delete()

end



