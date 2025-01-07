 Part = BaseClass("Part",PoolBaseClass)

local AttrType = EntityAttrsConfig.AttrType
local WeakEntityEffectId = 1000000005

function Part:__init()
	self.areaMap = {}
	self.enterArea = {}
	self.exitArea = {}
	self.colliderObjList = {}
	self.weakEffectEntities = {}
	self.collisionList = {}
	self.hpTriggerEvents = {}
end

function Part:Init(fight, entity, partComponent, config)
	self.fight = fight
	self.entity = entity
	self.partComponent = partComponent
	self.config = config
	-- 暂定部位名称就是影响的节点名称
	self.partName = config.Name
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

	if not config.lockTransformName or config.lockTransformName == "" then
		self.lockTransformName = "HitCase"
	else
		self.lockTransformName = config.lockTransformName
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

	self.clientTransformComponent = self.entity.clientEntity.clientTransformComponent
	
	for k, v in pairs(config.BoneColliders) do
		self:CreateCollision(v)
	end

	self.lockTransform = self.clientTransformComponent:GetTransform(self.lockTransformName)

	if self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player and not self.partComponent then
		self.collisionList[1]:AddTriggerCompment()
	end

	self.partType = config.PartType
	self.partWeakType = config.PartWeakType
	
	self:SetPartEnable(config.DefaultEnable == nil and true or config.DefaultEnable)
end

function Part:CreateCollision(config)
	local size = config.LocalScale
	local collision
	local transformComponent = {position = Vec3.New(), rotation = Quat.New()}
	local localPosition = config.LocalPosition
	local localOffsetX, localOffsetY, localOffsetZ = localPosition[1], localPosition[2], localPosition[3]

	if config.ShapeType == FightEnum.CollisionType.Sphere then
		collision = self.fight.objectPool:Get(SphereCollision)
		collision:Init(self.fight,transformComponent,size[1]/2,localOffsetX, localOffsetY, localOffsetZ)
	elseif config.ShapeType == FightEnum.CollisionType.Cube then
		collision = self.fight.objectPool:Get(CubeCollision)
		collision:Init(self.fight,transformComponent,size[1],size[2],size[3],localOffsetX, localOffsetY, localOffsetZ)
	elseif config.ShapeType == FightEnum.CollisionType.Cylinder then
		collision = self.fight.objectPool:Get(CylinderCollision)
		collision:Init(self.fight,transformComponent,size[1]/2,size[2]*2,localOffsetX, localOffsetY, localOffsetZ)
	end

	collision.colliderCfg = config
	local layer = self.partComponent and FightEnum.Layer.Entity or FightEnum.Layer.EntityCollision
	local colliderInstanceId = collision:CreateColliderObject(self.entity.instanceId, layer)	
	self.clientTransformComponent:SetTransformChild(collision.colliderTransform, config.ParentName, self.entity.instanceId)

	self.fight.entityManager:SetColliderEntity(colliderInstanceId, self.entity.instanceId)
	
	UnityUtils.SetLocalPosition(collision.colliderTransform, localOffsetX, localOffsetY, localOffsetZ )
	local localEuler = config.LocalEuler
	UnityUtils.SetLocalEulerAngles(collision.colliderTransform, localEuler[1], localEuler[2], localEuler[3])

	table.insert(self.collisionList, collision)
end

function Part:SetPartEnable(enable)
	if self.enable == enable then
		return 
	end
	
	self.enable = enable
	for k, collision in ipairs(self.collisionList) do
		collision:SetColliderEnable(enable)
	end
end

function Part:Update()
	UnityUtils.BeginSample("Part:UpdateCollisionListTransfrom")
	self:UpdateCollisionListTransfrom()
	UnityUtils.EndSample()
end

function Part:SetCollisionAttacked(collision)
	self.collisionAttacked = collision
end

function Part:UpdateCollisionListTransfrom()
	for k, v in pairs(self.collisionList) do
		self:UpdateCollisionTransform(v)
	end
end

function Part:GetCollisionList()
	return self.collisionList
end

function Part:UpdateCollisionTransform(collision)
	local x, y, z, rx, ry, rz, rw = CustomUnityUtils.GetTransformPosRotation(collision.colliderTransform)
	collision.transformComponent.position:Set(x, y, z)
	collision.transformComponent.rotation:Set(rx, ry, rz, rw)
end

function Part:CheckIsInArea(areaName, logicName)
	for k, v in pairs(self.areaMap) do
		if v.areaName == areaName and v.logicName == logicName then
			return true
		end
	end

	return false
end

function Part:Draw()
	for k, collision in ipairs(self.collisionList) do
		local r,g,b,a = 1,0,0,0.5
		if DebugClientInvoke.Cache.ShowCollider then
			r,g,b,a = 0,0,1,0.5
		end
		collision:SetDrawColor(r,g,b,a)
		collision:Draw()
	end
end

function Part:UpdateCollisonCollider()
	-- for k, collision in ipairs(self.collisionList) do
	-- 	if collision.transformComponent.position then
	-- 		collision:UpdateColliderObject()
	-- 	end
	-- end	
end

function Part:SetCollisionLayer(layer)
	for k, collision in ipairs(self.collisionList) do
		collision:SetColliderLayer(layer)
	end	
end

function Part:CheckAttachLayer(layer)
	for i = 1, #self.collisionList do
		local _, count = self.collisionList[i]:OverlapCollider(layer)
		if count > 0 then
			return true
		end
	end

	return false
end

function Part:OnCache()
	for k, v in pairs(self.collisionList) do
		v:OnCache()
	end
	self.collisionList = {}

	self.fight.objectPool:Cache(Part,self)
end

function Part:CheckHurtDamage()
	return self.dmgHurt
end

function Part:CheckPartHurtDamage()
	return self.dmgHurt and self.dmgPartHurt
end

function Part:HurtDamage(damage,attackEntity)
	if self.damageShield and self.damageShield >= 0 and self:CheckPartHurtDamage() then
		self.damageShield = self.damageShield - damage

		local attackType = 0
		local shakeStrenRatio = 0 
		if attackEntity then
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
	end
	
	return self.entity.clientEntity.clientTransformComponent:GetTransform(self.hitTransformName).position
end

function Part:IsPartLogicLock()
	if not self.logicVisible then
		return false
	end

	return self.logicLock
end

function Part:SetLogicLock(lock)
	self.logicLock = lock
end

function Part:IsPartLogicSearch()
	if not self.logicVisible then
		return false
	end

	return self.logicSearch
end

function Part:SetLogicSearch(search)
	self.logicSearch = search
end

function Part:SetLogicVisible(visible)
	self.logicVisible = visible

	if self.collisionList then
		for k, v in pairs(self.collisionList) do
			v.colliderObj:SetActive(visible)
		end
	end
end


function Part:IsDestroy()
	return self.damageShield and self.damageShield <= 0
end

function Part:CreateWeakEffectEntity()
	if next(self.weakEffectEntities) then
		return
	end

	if self.collisionList == nil then
		return
	end

	if self.weakTrasnforms then
		for k, v in pairs(self.weakTrasnforms) do
			local entity = self.fight.entityManager:CreateEntity(WeakEntityEffectId, self.entity) 
			local clientTransformComponent = entity.clientEntity.clientTransformComponent
			clientTransformComponent:SetBindTransform(v, true)
			clientTransformComponent.transform:SetActive(false)
			clientTransformComponent.transform:SetActive(true)
			table.insert(self.weakEffectEntities, entity)
		end
	end
end

function Part:DestroyWeakEffectEntity()
	if self.weakEffectEntities then
		for k, v in pairs(self.weakEffectEntities) do
			local clientTransformComponent = v.clientEntity.clientTransformComponent
			self.fight.entityManager:RemoveEntity(v.instanceId)
		end
		TableUtils.ClearTable(self.weakEffectEntities)
	end
end

function Part:IsWeakNess()
	return self.partType == FightEnum.PartType.Weak
end

function Part:DestroyCollider()
	if self.collisionList then
		local entityManager = self.fight.entityManager
		for k, v in pairs(self.collisionList) do
			entityManager:RemoveColliderEntity(v.colliderObjInsId, true)
			v:onCache()
		end
		TableUtils.ClearTable(self.collisionList)
	end

	if AimFSM.weakNess then
		self.weakNessDestroyEffect = self.fight.entityManager:CreateEntity(WeakEntityEffectId, self.entity) 
	end
end

function Part:__cache()
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
	
	
	TableUtils.ClearTable(self.areaMap)
	TableUtils.ClearTable(self.enterArea)
	TableUtils.ClearTable(self.exitArea)
	TableUtils.ClearTable(self.colliderObjList)
	TableUtils.ClearTable(self.weakEffectEntities)
	TableUtils.ClearTable(self.hpTriggerEvents)
end

function Part:__delete()

end


