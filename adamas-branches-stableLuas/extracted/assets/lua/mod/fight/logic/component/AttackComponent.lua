---@class AttackComponent
AttackComponent = BaseClass("AttackComponent",PoolBaseClass)
local AttrType = EntityAttrsConfig.AttrType
local _random = math.random
local EntityLayer = FightEnum.Layer.Entity
local EntityCollisionLayer = FightEnum.Layer.EntityCollision
local EntityBitLayer = FightEnum.LayerBit.Entity
local WaterLayer = FightEnum.Layer.Water
local TerrainCheckLayerBit = PhysicsTerrain.TerrainCheckLayer
local Layer2LayerBit = FightEnum.Layer2LayerBit
local IdToClass = BaseCollider.ID_2_CLASS

function AttackComponent:__init()
	self.colliderList = {}
	self.hitEnities = {}
	self.hitEntityColliders = {}
	self.hits = {}
	self.dodgeInvaild = false

	self.triggerType = FightEnum.TriggerType.Fight
end

function AttackComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Attack)
	if self.config.MaxAttackTimes then
		self.maxAttackTimes = self.config.MaxAttackTimes
	else
		self.maxAttackTimes = -1
	end
	self.curAttackTimes = 0
	self.transformComponent = self.entity.transformComponent
	self.intervalFrame = 0
	self.hitGroundCheckTime = 0

	self.hited = false
	self.firstHit = false
	self.firstHitFrame = {}
	self.initFrame = true
	self.enabled = false

	self.passFrame = 0
	self.reboundFrame = self.config.ReboundFrame or 0

	--检查/过滤列表，存在则按表进行检查
	self.checkList = nil
	self.filterList = nil

	self.triggerFrame = 0
	local AttackSkillType = self.config.AttackSkillType
	self.skillType = AttackSkillType or 0
	self.attackType = self.config.AttackType

	self.sleep = false
end

function AttackComponent:LateInit()
	if not self.config.Part or self.config.Part == "" then
		local x, y, z
		local shapeType = self.config.ShapeType
		if shapeType == FightEnum.CollisionType.Sphere then
			x = self.config.Radius
			self:CreateCollider(shapeType, x, y, z)
		elseif shapeType == FightEnum.CollisionType.Cube then
			x = self.config.Lenght
			y = self.config.Height
			z = self.config.Width
			self:CreateCollider(shapeType, x, y, z)
		elseif shapeType == FightEnum.CollisionType.Cylinder then
			x = self.config.Radius * 2
			y = self.config.Height
			z = self.config.Radius * 2
			self:CreateCollider(FightEnum.CollisionType.Cylinder, x, y, z)
		elseif self.config.ShapeType == FightEnum.CollisionType.Circle then
			y = self.config.Height

			local radius = self.config.circleStartRadius - self.config.circleRadius
			if radius >= 0 then
				self:CreateCollider(FightEnum.CollisionType.Cylinder, self.config.circleStartRadius, y, z)
			else
				radius = self.config.circleStartRadius
			end

			self:CreateCollider(FightEnum.CollisionType.Cylinder, radius, y, z)
		elseif self.config.ShapeType == FightEnum.CollisionType.Sector then
			y = self.config.Height
			z = self.config.SectorAngle
			self:CreateCollider(FightEnum.CollisionType.Sector, self.config.SectorRadius, y, z)

			local innerRadius = self.config.SectorInnerRadius
			if innerRadius > 0 then
				self:CreateCollider(FightEnum.CollisionType.Sector, innerRadius, y, z)
			end
		end
	else
		self.partComponent = self.entity.parent.partComponent
		self.partCollisionName = self.config.Part
	end
end

function AttackComponent:SetCameraShakeId(id)
	self.cameraShakeId = id
end

function AttackComponent:SetPauseFrameId(id)
	self.pauseFrameId = id
end

function AttackComponent:SetCheckList(idList)
	if not idList then
		self.checkList = nil
	else
		self.checkList = {}
		TableUtils.ClearTable(self.checkList)
		for k, v in pairs(idList) do
			self.checkList[v] = true
		end
	end
end

function AttackComponent:SetSkillType(skillType)
	if skillType and skillType ~= 0 then
		self.skillType = skillType
	end
end

function AttackComponent:GetSkillType()
	return self.skillType
end

function AttackComponent:SetFilterList(idList)
	if not idList then
		self.filterList = nil
	else
		self.filterList = {}
		TableUtils.ClearTable(self.filterList)
		for k, v in pairs(idList) do
			self.filterList[v] = true
		end
	end
end

function AttackComponent:CreateCollider(shapeType, x, y, z)
	local parent = self.entity.clientTransformComponent:GetTransform()
	local collider = BaseCollider.Create(shapeType, x, y, z, self.config.OffsetX, self.config.OffsetY, self.config.OffsetZ, FightEnum.Layer.Entity, parent, self.entity)

	if collider then
		local checkLayer = FightEnum.LayerBit.Entity
		if self.config.CanHitGround then
			checkLayer = checkLayer | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Default | FightEnum.LayerBit.Water
		end

		collider:AddTriggerComponent(self.triggerType, checkLayer, true)
		table.insert(self.colliderList, collider)
	end
end

function AttackComponent:GetColliderList()
	if not self.partCollisionName then
		return self.colliderList
	end

	local part = self.partComponent:GetPart(self.partCollisionName)
	return part:GetColliderList()
end

function AttackComponent:IsValid()
	if self.maxAttackTimes > 0 and self.curAttackTimes >= self.maxAttackTimes then
		return false
	end

	if not self:CheckEnable() then
		return false
	end
	if self.sleep then
		return false
	end

	if self.entity == nil then
		return false
	end

	return true
end

function AttackComponent:SetSleep(ison)
	self.sleep = ison
end

--local outCircleColor = Color(1, 0, 0, 0.5)
function AttackComponent:Update()
	-- 检测子弹合法性
	if not self:IsValid() then
		return
	end

	-- 子弹在不做攻击判断的时候也改变自己的状态
	local colliderList = self:GetColliderList()
	local timeScale = self.entity.timeComponent:GetTimeScale()
	self.passFrame = self.passFrame + (timeScale > 1 and 1 or timeScale)
	self:UpdateColliderList(colliderList)

	-- 检测是否在攻击CD内 不是就继续做攻击判断
	if not self:CheckInterval() then
		return
	end

	if self:CheckFirstEnable() and not self.enabled then
		self.enabled = true
		self:DoMagicsByFirstTriggerSingle()
		self.fight.entityManager:CallBehaviorFun("FirstTrigger",self.entity.parent.instanceId,self.entity.instanceId)
	end

	if DebugClientInvoke.Cache.ShowAttackCollider then
		local color
		--if self.config.ShapeType == FightEnum.CollisionType.Circle or
		--	self.config.ShapeType == FightEnum.CollisionType.Sector then
		--	color = outCircleColor
		--end
		for k, v in ipairs(colliderList) do
			v:Draw(color, true)
			color = nil
		end
	end

	if DebugClientInvoke.Cache.BulletProject then
		self:_DebugShowBulletProject()
	end

	--极限闪避失效效果仍检测地面和到达范围
	if self:CheckDodgeInvalid() then
		self.reboundFrame = self.reboundFrame - 1

		self:UpdateHitEntity()

		for instanceId, entity in pairs(self.hitEnities) do
			self:DoAttackCheck(entity, self.hitEntityColliders[instanceId])
			if self.maxAttackTimes > 0 and self.curAttackTimes >= self.maxAttackTimes then
				break
			end
		end

		local cantHit = self.maxAttackTimes < 0 or (self.maxAttackTimes > 0 and self.curAttackTimes >= self.maxAttackTimes)
		if self.config.RemoveAfterHit and self.hited and cantHit then
			if self.entity.timeoutDeathComponent then
				self.entity.timeoutDeathComponent:SetDeath()
			else
				self.fight.entityManager:RemoveEntity(self.entity.instanceId)
			end
		end
	end

	-- 重复触发的攻击如果需要多次触发回调的话
	if self.config.Repetition and self.config.RepeteHitCallBack then
		self.hited = false
	end

	-- 临时写一个命中水面的效果
	self:UpdateHitWater()
	if self:UpdateHitGround() then
		return
	end

	if self:UpdateReachRange() then
		return
	end

	if self.initFrame then
		self.initFrame = nil
	end
end

function AttackComponent:DoMagicsByFirstTriggerSingle()
	if self.config.TriggerEvents then
		for i, magicId in ipairs(self.config.TriggerEvents) do
			magicId = tonumber(magicId)
			local magic = MagicConfig.GetMagic(magicId, self.entity.parent.entityId)
			local buff = MagicConfig.GetBuff(magicId, self.entity.parent.entityId)
			local level = self:GetDefaultAttackLevel()
			if magic then
				self.fight.magicManager:DoMagic(magic, level, self.entity.parent,self.entity.parent,false, nil, nil, nil, nil, nil, self.skillType)
			elseif buff and self.entity.parent.buffComponent then
				self.entity.parent.buffComponent:AddBuff(self.entity.parent, magicId, level, nil, nil, nil, self.skillType)
			end
		end
	end
end

function AttackComponent:UpdateHitEntity()
	UnityUtils.BeginSample("UpdateHitEntity")
	TableUtils.ClearTable(self.hitEnities)
	if self.config.Repetition then
		TableUtils.ClearTable(self.hits)
	end
	TableUtils.ClearTable(self.hitEntityColliders)
	local colliderList = self:GetColliderList()
	if self.config.ShapeType == FightEnum.CollisionType.Circle then
		self:UpdateCircleHit(colliderList)
	elseif self.config.ShapeType == FightEnum.CollisionType.Sector then
		self:UpdateSectorHit(colliderList)
	else
		self:UpdateNormalHit(colliderList)
	end

	UnityUtils.EndSample()
end

function AttackComponent:UpdateEntityHit(entity, colliderInsId, attackCollider, hitEnities, hitEntityColliders)
	hitEnities = hitEnities or self.hitEnities
	hitEntityColliders = hitEntityColliders or self.hitEntityColliders

	if entity and self:NeedCheck(entity, colliderInsId) then
		local instanceId = entity.instanceId
		if not self:CheckSingleEntityInterval(instanceId) then
			return false
		end

		hitEnities[instanceId] = entity
		-- 仅多部位的才需要计算需要collider比较
		if #entity.partComponent.parts > 0 then
			local attackColliderPos = attackCollider:GetPosition()
			local hitColliderPos = nil
			hitColliderPos = IdToClass[colliderInsId]:GetPosition()
			hitEntityColliders[instanceId] = hitEntityColliders[instanceId] or {}
			local distance = Vec3.SquareDistance(attackColliderPos, hitColliderPos)
			table.insert(hitEntityColliders[instanceId], {
					distance = distance, colliderInsId = colliderInsId, attackCollision = attackCollider
				})
		end

		return true
	end

	return false
end

function AttackComponent:UpdateNormalHit(colliderList)
	local entityManager = self.fight.entityManager
	if self.config.PreciseDetection or self.initFrame then
		for k, v in pairs(colliderList) do
			local colliderIds, count = v:OverlapCollider(EntityBitLayer, true)
			for i = 0, count - 1 do
				local colliderInsId = colliderIds[i]
				if not colliderInsId then
					goto continue
				end

				local pass = self.config.ShapeType ~= FightEnum.CollisionType.Cylinder
				local hitCollider = IdToClass[colliderInsId]
				if not pass and hitCollider then
					local dis = Vec3.DistanceXZ(v.colliderTransform.position, hitCollider.colliderTransform.position) - hitCollider.radius
					pass = dis <= self.config.Radius
				end

				if not pass then
					goto continue
				end

				local entity = entityManager:GetColliderEntity(colliderInsId)
				self:UpdateEntityHit(entity, colliderInsId, v)
				::continue::
			end
		end
	else
		for _, v in pairs(colliderList) do
			local id = v.colliderObjInsId
			local triggerData = self.entity:GetTriggerData(self.triggerType, id)
			if triggerData then
				for colliderInsId, layer in pairs(triggerData) do
					if layer == EntityLayer then
						local hitEntity = entityManager:GetColliderEntity(colliderInsId)
						self:UpdateEntityHit(hitEntity, colliderInsId, v)
					end
				end
			end
		end
	end

end

-- 扇形命中判断
local HitTemp = {}
local HitColliderTemp = {}
function AttackComponent:UpdateSectorHit(colliderList)
	TableUtils.ClearTable(HitTemp)
	TableUtils.ClearTable(HitColliderTemp)
	local entityManager = self.fight.entityManager
	if self.config.PreciseDetection or self.initFrame then
		for k, v in pairs(colliderList) do
			local colliders, count = v:OverlapCollider(EntityBitLayer, true)
			local collisionHitTemp = {}
			local collidersHitTemp = {}
			for i = 0, count - 1 do
				local colliderInsId = colliders[i]
				if not colliderInsId then
					goto continue
				end

				local hitCollider = IdToClass[colliderInsId]
				local dir = hitCollider.colliderTransform.position - v.colliderTransform.position
				if dir.x == 0 and dir.y == 0 and dir.z == 0 then
					goto continue
				end

				local angle = Vec3.AngleSigned(v.colliderTransform.rotation * Vector3.forward, dir)
				if math.abs(angle) <= math.abs(self.config.SectorAngle / 2) then
					local entity = entityManager:GetColliderEntity(colliderInsId)
					self:UpdateEntityHit(entity, colliderInsId, v, collisionHitTemp, collidersHitTemp)
				end
				::continue::
			end

			table.insert(HitTemp, collisionHitTemp)
			table.insert(HitColliderTemp, collidersHitTemp)
		end
	else
		for _, v in pairs(colliderList) do
			local collisionHitTemp = {}
			local collidersHitTemp = {}

			local height = v.height
			local maxY = v.colliderTransform.position.y + height
			local minY = v.colliderTransform.position.y - height

			local id = v.colliderObjInsId
			local triggerData = self.entity:GetTriggerData(self.triggerType, id)
			if triggerData then
				for colliderInsId, layer in pairs(triggerData) do
					if layer == EntityLayer then
						local hitCollider = IdToClass[colliderInsId]
						local hitColliderBounds = hitCollider.colliderCmp.bounds
						local dir = hitCollider.colliderTransform.position - v.colliderTransform.position
						if dir.x ~= 0 or dir.y == 0 or dir.z == 0 then
							local angle = Vec3.AngleSigned(v.colliderTransform.rotation * Vector3.forward, dir)
							if math.abs(angle) <= math.abs(self.config.SectorAngle / 2) and
								hitColliderBounds.min.y <= maxY and hitColliderBounds.max.y >= minY then
								local hitEntity = entityManager:GetColliderEntity(colliderInsId)
								self:UpdateEntityHit(hitEntity, colliderInsId, v, collisionHitTemp, collidersHitTemp)
							end
						end

					end
				end
			end

			table.insert(HitTemp, collisionHitTemp)
			table.insert(HitColliderTemp, collidersHitTemp)
		end
	end

	for k, v in pairs(HitColliderTemp[1]) do
		if not HitColliderTemp[2] or not HitColliderTemp[2][k] then
			self.hitEntityColliders[k] = v
		else
			for _, hitData in pairs(HitColliderTemp[2][k]) do
				if hitData.distance > hitData.attackCollision.radius ^ 2 then
					self.hitEntityColliders[k] = self.hitEntityColliders[k] or {}
					table.insert(self.hitEntityColliders[k], hitData)
				end
			end
		end
	end

	for k, v in pairs(HitTemp[1]) do
		if self.hitEntityColliders[k] then
			self.hitEnities[k] = v
		end
	end

end

function AttackComponent:UpdateCircleHit(colliderList)
	TableUtils.ClearTable(HitTemp)
	TableUtils.ClearTable(HitColliderTemp)
	local entityManager = self.fight.entityManager
	if self.config.PreciseDetection or self.initFrame then
		for k, v in pairs(colliderList) do
			local colliders, count = v:OverlapCollider(EntityBitLayer, true)
			local collisionHitTemp = {}
			local collidersHitTemp = {}

			for i = 0, count - 1 do
				local colliderInsId = colliders[i]
				if not colliderInsId then
					goto continue
				end

				local entity = entityManager:GetColliderEntity(colliderInsId)
				self:UpdateEntityHit(entity, colliderInsId, v, collisionHitTemp, collidersHitTemp)
				::continue::
			end

			table.insert(HitTemp, collisionHitTemp)
			table.insert(HitColliderTemp, collidersHitTemp)
		end
	else
		for _, v in pairs(colliderList) do
			local collisionHitTemp = {}
			local collidersHitTemp = {}

			local height = v.height
			local maxY = v.colliderTransform.position.y + height
			local minY = v.colliderTransform.position.y - height

			local id = v.colliderObjInsId
			local triggerData = self.entity:GetTriggerData(self.triggerType, id)
			if triggerData then
				for colliderInsId, layer in pairs(triggerData) do
					if layer == EntityLayer then
						local hitCollider = IdToClass[colliderInsId]
						local hitColliderBounds = hitCollider.colliderCmp.bounds
						if hitColliderBounds.min.y <= maxY and hitColliderBounds.max.y >= minY then
							local hitEntity = entityManager:GetColliderEntity(colliderInsId)
							self:UpdateEntityHit(hitEntity, colliderInsId, v, collisionHitTemp, collidersHitTemp)
						end
					end
				end
			end

			table.insert(HitTemp, collisionHitTemp)
			table.insert(HitColliderTemp, collidersHitTemp)
		end
	end

	for k, v in pairs(HitColliderTemp[1]) do
		if not HitColliderTemp[2][k] then
			self.hitEntityColliders[k] = v
		else
			for _, hitData in pairs(HitColliderTemp[2][k]) do
				if hitData.distance > hitData.attackCollision.radius ^ 2 then
					self.hitEntityColliders[k] = self.hitEntityColliders[k] or {}
					table.insert(self.hitEntityColliders[k], hitData)
				end
			end
		end
	end

	for k, v in pairs(HitTemp[1]) do
		if self.hitEntityColliders[k] then
			self.hitEnities[k] = v
		end
	end
end

function AttackComponent:UpdateHitWater()
	if self.hitWater then
		return
	end

	local colliderList = self:GetColliderList()
	for _, v in pairs(colliderList) do
		local id = v.colliderObjInsId
		local triggerData = self.entity:GetTriggerData(self.triggerType, id)
		if triggerData then
			for hitId, layer in pairs(triggerData) do
				if layer == WaterLayer then
					local collider = IdToClass[id]
					self.hitWater = true
					local hitWaterPos = collider.colliderCmp:ClosestPointOnBounds(v.colliderTransform.position)
					local height, haveGround = BehaviorFunctions.CheckPosHeight(hitWaterPos, FightEnum.LayerBit.Water)
					if haveGround then
						hitWaterPos.y = hitWaterPos.y - height
					end
					local parent = self.entity.parent or self.entity
					local entityInstanceId = BehaviorFunctions.CreateEntity(200010001, parent.instanceId, hitWaterPos.x, hitWaterPos.y, hitWaterPos.z)
					local entity = BehaviorFunctions.GetEntity(entityInstanceId)
					entity:SetDefaultSkillLevel(self:GetDefaultAttackLevel())
					entity:SetDefaultSkillType(self:GetSkillType())
					break
				end
			end
		end
	end
end

function AttackComponent:UpdateHitGround()
	if not self.config.CanHitGround or self.curAttackTimes > 0 or self.hitGroundCheckTime < 0 then
		return false
	end

	-- 打到地面了
	local scale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	local time = FightUtil.deltaTime * scale
	self.hitGroundCheckTime = self.hitGroundCheckTime + time

	local colliderList = self:GetColliderList()
	for _, v in pairs(colliderList) do
		local id = v.colliderObjInsId
		local triggerData = self.entity:GetTriggerData(self.triggerType, id)
		if triggerData then
			for hitId, layer in pairs(triggerData) do
				if Layer2LayerBit[layer] & TerrainCheckLayerBit ~= 0 then
					local collider = IdToClass[id]
					self.hitGround = true
					self.hitGroundPos = collider.colliderCmp:ClosestPointOnBounds(v.colliderTransform.position)
					self.hitGroundRot = collider.colliderTransform.rotation

					--local height, haveGround = BehaviorFunctions.CheckPosHeight(self.hitGroundPos)
					--if haveGround then
						--self.hitGroundPos.y = self.hitGroundPos.y - height
					--end
				end
			end
		end
	end

	if self.hitGround and self.hitGroundCheckTime >= 0.1 then
		self:DealHitGround()
		self.hitGround = false
		self.hitGroundPos = nil
		self.hitGroundRot = nil
		self.hitGroundCheckTime = -1
		self.curAttackTimes = self.curAttackTimes + 1
		return true
	end

	return false
end

function AttackComponent:UpdateReachRange()
	if not self.config.RemoveAfterReach or self.curAttackTimes > 0 then
		return false
	end

	if not self.reachRangeTargetPos then
		if self.entity.skillComponent then
			self.reachRangeTargetPos = self.entity.skillComponent.targetPosition
		elseif self.entity.parent and self.entity.parent.skillComponent then
			self.reachRangeTargetPos = self.entity.parent.skillComponent.targetPosition
		end
	end

	if self.reachRangeTargetPos then
		local selfPos = self.transformComponent:GetPosition()
		local dis = Vec3.SquareDistance(self.reachRangeTargetPos, selfPos)
		if dis <= self.config.ReachRange^2 then
			self.hitGroundPos = selfPos
			self:DealReachRange()
			self.hitGroundPos = nil
			return true
		end
	end

	return false
end

function AttackComponent:UpdateColliderList(colliderList)
	if not colliderList or not next(colliderList) or self.passFrame > self.config.SpreadFrame then
		return
	end

	if self.config.ShapeType == FightEnum.CollisionType.Circle then
		local outRadius = self.config.circleStartRadius + (self.config.SpreadSpeed * self.passFrame)
		if outRadius >= self.config.circleRadius and #colliderList == 1 then
			self:CreateCollider(FightEnum.CollisionType.Cylinder, 0, self.config.Height)
			colliderList[1]:UpdateColliderTransform(outRadius)
		elseif #colliderList == 2 then
			colliderList[1]:UpdateColliderTransform(outRadius)
			colliderList[2]:UpdateColliderTransform(outRadius - self.config.circleRadius)
		end
	elseif self.config.ShapeType == FightEnum.CollisionType.Sphere and self.config.IsSpread then
		local radius = (self.config.FinalRadius - self.config.Radius) * (self.passFrame / self.config.SpreadFrame) + self.config.Radius
		colliderList[1]:UpdateColliderTransform(radius)
	end
end

function AttackComponent:DoAttackCheck(entity, colliderList)
	local part, collisionAttacked
	if self.hitEnities[entity.instanceId] then
		-- 子部位需比较距离
		local hitHead = self.config.HeadHitTypeConfigList
	 	part, collisionAttacked = entity.partComponent:PartsColliderCheckByAttack(self, colliderList, hitHead)
	end


	if entity and entity:HasSignState("OnParry") then
		self.fight.entityManager:CallBehaviorFun("BeforeParry",self.entity.parent.instanceId,entity.instanceId,self.entity.instanceId,self.config.AttackType or 0)
		if entity:HasSignState("ParrySuccess") then
			entity:RemoveSignState("ParrySuccess")
			self.fight.entityManager:CallBehaviorFun("Parry",self.entity.parent.instanceId,entity.instanceId,self.entity.instanceId,self.config.AttackType or 0)

			self.hits[entity.instanceId] = entity
			return
		end
	end

	if self:CheckDodge(entity) then
		if entity.dodgeComponent and entity.dodgeComponent:IsValid() then
			self:DealDodge(entity)
		 	return
		end
	end

	self.curAttackTimes = self.curAttackTimes + 1

	if part then
		local reboundAttackComponent = entity.reboundAttackComponent
		if reboundAttackComponent then
			local reboundAttack = false
			if self.reboundFrame > 0 then
				if self.config.ReboundTag and self.config.ReboundTag == FightEnum.ReboundTag.Mark  then
					reboundAttack = reboundAttackComponent:AddReboundAttack(self.entity.parent, self.config.ReboundEntityId, self.config.ReboundFrame)
				else
					reboundAttack = reboundAttackComponent:DoReboundAttack(self.entity.parent)
				end
			else
				reboundAttack = reboundAttackComponent:CheckReboundAttack(self.entity.parent.instanceId, self.entity.entityId)
			end

			if reboundAttack then
				if self.entity then
					if self.entity.timeoutDeathComponent then
						self.entity.timeoutDeathComponent:SetDeath()
					else
						self.fight.entityManager:RemoveEntity(self.entity.instanceId)
					end
				end
				return
			end
		end

		self:DealAttack(entity, part, collisionAttacked, colliderList)
	end
end

function AttackComponent:DealAttack(entity, part, collisionAttacked, colliderList)
	-- LogError("attack deal attack entityId = "..self.entity.entityId.." parent = "..self.entity.parent.entityId.." frame = "..self.entity.timeComponent.frame)
	local isCanHitObj = entity.tagComponent:IsCanHitObj()
	self:DealRepetitionHit(entity) 	--重复命中和首次命中判定
	if isCanHitObj then
		self:DealHitSceneObj(entity, part, collisionAttacked) --可攻击物件受击
	else
		self:DealHitEntity(entity, part, collisionAttacked)	--正常实体受击
	end

	self:DealCameraShake(entity)	--受击相机抖动
	self.hits[entity.instanceId] = entity
	self:DealHitEffect(entity, part, collisionAttacked, colliderList)	--受击特效
	self:DealHitCreateAttackEntities(entity)	--受击后创建实体
	if not isCanHitObj then
		self:DealHitBoneShake(entity)	--受击骨骼抖动
	end
	self:DealHitPostProcess()	--受击后处理效果
	self:DealPauseFrame(entity)	--受击顿帧
	self.hited = true
end

function AttackComponent:DealRepetitionHit(entity)
	---重复命中判定
	if self.config.Repetition then
		if self.config.RepeatType == FightEnum.AttackRepeatType.SingleHit and not self.firstHitFrame[entity.instanceId] then
			self.firstHitFrame[entity.instanceId] = self.entity.timeComponent.frame + self.config.IntervalFrame
		elseif self.config.RepeatType == FightEnum.AttackRepeatType.Hit and not self.firstHit then
			self.firstHit = true
			self.intervalFrame = self.entity.timeComponent.frame + self.config.IntervalFrame
		end
	end
	---首次命中回调
	if not self.hited then
		--首次命中
		-- self:DealPauseFrame()
		self:DoMagicsBySelfSingle()
		local attack = self.entity.parent
		local atkRoot = self.entity.root or self.entity
		local atkElement = FightEnum.ElementType.Phy
		if attack.elementStateComponent then
			atkElement = attack.elementStateComponent.config.ElementType
		elseif atkRoot.elementStateComponent then
			atkElement = atkRoot.elementStateComponent.config.ElementType
		end

		self.fight.entityManager:CallBehaviorFun("FirstCollide",self.entity.parent.instanceId,entity.instanceId,
				self.entity.instanceId,self.config.AttackType or 0, self.skillType, atkElement, atkRoot.instanceId)
	end
	--命中回调
	self.fight.entityManager:CallBehaviorFun("Collide", self.entity.parent.instanceId, entity.instanceId,
			self.entity.instanceId, self.config.ShakeStrenRatio, self.config.AttackType or 0, self.entity.tagComponent.camp, self.skillType)
end

function AttackComponent:DealHitSceneObj(entity, part, collisionAttacked)
	--免疫受击magic判定
	local immuneAttackMagic = false
	if entity.buffComponent then
		immuneAttackMagic = entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneAttackMagic)
	end

	--无免疫子弹受击magic
	if not immuneAttackMagic then
		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self, true)
		end
	end
	if entity.blowComponent then
		entity.blowComponent:Blow(part,collisionAttacked,self)
	end

	if not immuneAttackMagic then
		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self)
		end
	end
end

function AttackComponent:DealHitEntity(entity, part, collisionAttacked)
	--游泳和攀爬判定
	local enableEnterHit = true
	if entity.stateComponent then
		enableEnterHit = not entity.stateComponent:IsState(FightEnum.EntityState.Swim) and
				not entity.stateComponent:IsState(FightEnum.EntityState.Climb)
	end

	--免疫受击magic判定
	-- self.hited = true
	local immuneAttackMagic = false
	if entity.buffComponent then
		immuneAttackMagic = entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneAttackMagic)
	end
	local armorBefore
	if entity.attrComponent then
		armorBefore = entity.attrComponent:GetValue(AttrType.Armor) > 0
	end
	--无免疫子弹受击magic
	if not immuneAttackMagic then
		if entity.stateComponent and enableEnterHit then
			local hitStateMapping = entity:GetComponentConfig(FightEnum.ComponentType.State).HitStateRandomMapping
			local stateRandomMapping = hitStateMapping and hitStateMapping[Config.EntityCommonConfig.HitState[self.config.HitType]]
			local realHitType = stateRandomMapping and stateRandomMapping[math.random(#stateRandomMapping)] or self.config.HitType
			entity.stateComponent:SetIncomingHitType(realHitType)
		end

		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self, true)
		end
	end

	local attackHit = false
	local immuneHit = false
	if entity.buffComponent then
		immuneHit = entity.buffComponent:CheckState(FightEnum.EntityBuffState.AbsoluteImmuneHit) or
				(entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit) and
						not entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForbiddenImmuneHit))
	end

	if entity.blowComponent then
		entity.blowComponent:Blow(part,collisionAttacked,self)
	end

	if not immuneAttackMagic then
		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self)
		end
	end
	if not immuneHit and not armorBefore then
		self.fight.entityManager:CallBehaviorFun("BeforeAttack",self.entity.parent.instanceId, entity.instanceId)
		if entity.hitComponent and enableEnterHit then
			attackHit = true
			entity.hitComponent:Hit(part,self)
		end
		self.fight.entityManager:CallBehaviorFun("Attack",self.entity.parent.instanceId, entity.instanceId,self.entity.instanceId)
	else
		if entity.hitComponent then
			entity.hitComponent:ArmorHit(self)
		end
	end
	if not immuneAttackMagic then
		if entity.attrComponent then
			local armorAfter = entity.attrComponent:GetValue(AttrType.Armor) <= 0
			if not immuneHit and armorBefore and armorAfter then
				--头部受击，不同的受击表现
				local headHit = false
				if part.partWeakType and part.partWeakType == FightEnum.PartWeakType.Head and self.config.HeadHitTypeConfigList then
					headHit = true
				end
				local hitTypeConfigList = headHit and self.config.HeadHitTypeConfigList or self.config.HitTypeConfigList
				local hitTypeLen = hitTypeConfigList and #hitTypeConfigList or 0
				local hitTypeConfig = hitTypeLen > 0 and hitTypeConfigList[_random(hitTypeLen)] or nil
				self.config.HitType = hitTypeConfig and hitTypeConfig.HitType or 0
				--self.config.BreakLieDown = hitTypeConfig and hitTypeConfig.BreakLieDown or false

				attackHit = true
				entity.stateComponent:SetHitType(self.config,self.entity,headHit)--处理此次攻击清空霸体值的受击状态
			end
		end
	end
end

function AttackComponent:DealCameraShake(entity)
		--子弹攻击组件震屏参数生效条件：
		--1、当前操控的角色，攻击命中任意目标时
		--2、任意攻击命中当前被玩家操控的角色时
		--3、当前操控的角色控制月灵或者其他，攻击命中任意目标时
		local ctrlInstanceId = self.fight.playerManager:GetPlayer():GetCtrlEntity()
		local entityParent = self.entity.parent
		local entityRoot = self.entity.root
    if entityParent.instanceId == ctrlInstanceId or (entity.parent and entity.parent.instanceId == ctrlInstanceId)
            or (entityRoot and entityRoot.instanceId == ctrlInstanceId) then

        if self.config.UseCameraShake and self.config.CameraShakes then
            local cameraShakeId = self.cameraShakeId or -1
            if cameraShakeId ~= 0 then
                for k, v in pairs(self.config.CameraShakes) do
                    if k == cameraShakeId or cameraShakeId == -1 then
                        for _, params in pairs(v) do
                            self.fight.clientFight.cameraManager.cameraShakeManager:Shake(params, self.entity)
                        end
                        if cameraShakeId ~= -1 then
                            break
                        end
                    end
                end
            end
        end
    end
end

function AttackComponent:DealHitEffect(entity, part, collisionAttacked)
	if self.config.CreateHitEntities then
		for k, v in ipairs(self.config.CreateHitEntities) do
			local effectEntity = self.fight.entityManager:CreateEntity(v.EntityId, entity)
			if effectEntity.clientEntity.clientEffectComponent then
				local config = effectEntity.clientEntity.clientEffectComponent.config
				local lookEntity
				if v.LookatType == FightEnum.EntityLookAtType.Entity then
					lookEntity = self.entity
				elseif v.LookatType == FightEnum.EntityLookAtType.EntityOwner then
					lookEntity = self.entity.parent
				end
				if config.HitEffectBornType == FightEnum.HitEffectBornType.Bone then
					---命中部位
					effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked)
				elseif config.HitEffectBornType == FightEnum.HitEffectBornType.HitPos then
					---使用子弹本身位置
					effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked, self.transformComponent.position, lookEntity)
				elseif config.HitEffectBornType == FightEnum.HitEffectBornType.HitOffset then
					---XZ使用部位位置， Y轴使用逻辑攻击Y坐标，并受部位高度限制
					effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked, self.transformComponent.position, lookEntity)
				end
				if config.HitEffectBornType ~= FightEnum.HitEffectBornType.HitPos and lookEntity then
					effectEntity.rotateComponent:LookAtTarget(lookEntity)
				end
			end
			if effectEntity.rotateComponent then
				effectEntity.rotateComponent:Async()
			end
		end
	end
end

function AttackComponent:DealHitCreateAttackEntities(entity)
	if self.config.CreateAttackEntities then
		local position = self.entity.transformComponent.position
		local rotation = self.entity.transformComponent.rotation
		for k, entityId in ipairs(self.config.CreateAttackEntities) do
			local tempEntity = self.fight.entityManager:CreateEntity(entityId, self.entity.parent)
			tempEntity.transformComponent:SetPosition(position.x, position.y, position.z)
			tempEntity.transformComponent:SetStartRotate(rotation)
			tempEntity:SetDefaultSkillLevel(self:GetDefaultAttackLevel())
			tempEntity:SetDefaultSkillType(self:GetSkillType())
			if tempEntity.rotateComponent then
				tempEntity.rotateComponent:Async()
			end
			if tempEntity.moveComponent and tempEntity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
				tempEntity.moveComponent.moveComponent:SetTarget(entity)
			end
		end
	end
end

function AttackComponent:DealHitBoneShake(entity)
	if entity.hitComponent and not entity.hitComponent:ForbiddenBoneShake() then
		entity.hitComponent:SetEntityBoneShake(self.config, self.colliderList[1])

		if entity.clientIkComponent and self.config.ShakeStrenRatio > 0 then
			entity.clientEntity.clientIkComponent:AttackShake(self.config.ShakeDir, self.config.ShakeStrenRatio, self.entity.parent.instanceId)
		end
	end
end

function AttackComponent:DealHitPostProcess()
	if self.config.UsePostProcess then
		local postProcessManager = self.fight.clientFight.postProcessManager
		for _, v in pairs(self.config.PostProcessParamsList) do
			postProcessManager:AddPostProcess(v.PostProcessType, v, self.entity.parent)
		end
	end
end


function AttackComponent:DealDodge(entity,notJumpBeatBack)
	local isJumpDodge = entity.dodgeComponent and entity.dodgeComponent.isJumpDodge
	local notJumpBeatBack = self.config.NotJumpBeatBack
	--Log("DealDodge DealDodge "..self.entity.entityId)
 	local isLimit = entity.dodgeComponent:IsLimitState(DodgeComponent.LimitState.Enable)
	if isLimit and self.config.DodgeInvalidType == FightEnum.DodgeInvalidType.Forever then
		self.dodgeInvaild = true
	end

	if isJumpDodge then
		self.fight.entityManager:CallBehaviorFun("JumpDodge",self.entity.parent.instanceId,entity.instanceId,isLimit,notJumpBeatBack)
		self.fight.entityManager:CallBehaviorFun("JumpBeDodge",self.entity.parent.instanceId, entity.instanceId, isLimit, notJumpBeatBack)
	else
		self.fight.entityManager:CallBehaviorFun("BeforeDodge",self.entity.parent.instanceId,entity.instanceId,isLimit)
		self.fight.entityManager:CallBehaviorFun("BeforeBeDodge",self.entity.parent.instanceId, entity.instanceId, isLimit)
		self.fight.entityManager:CallBehaviorFun("Dodge",self.entity.parent.instanceId,entity.instanceId,isLimit)
		self.fight.entityManager:CallBehaviorFun("BeDodge",self.entity.parent.instanceId, entity.instanceId, isLimit)
	end

	EventMgr.Instance:Fire(EventName.OnDealDodge, entity.instanceId)

	self.hits[entity.instanceId] = entity
end

function AttackComponent:HitGround()
	self.hitGround = true
end

function AttackComponent:CheckDodge(entity)
	-- 先做攻击目标和阵营判断
	local target = self.config.Target
	local isSameCamp = self.entity.tagComponent.camp == entity.tagComponent.camp
	if target == FightEnum.AttackTarget.Ally and isSameCamp then
		return false
	elseif (target == FightEnum.AttackTarget.All or target == FightEnum.AttackTarget.Player) and self.config.IngoreDodge then
		return false
	end

	local isJumpDodge = entity.dodgeComponent and entity.dodgeComponent.isJumpDodge
	if isJumpDodge then
		if not self.config.NotJumpDodge and self.config.AttackType and self.config.AttackType == FightEnum.EAttackType.Low then
			return true
		end
		return false
	else
		if self.config.NotCheckDodge then
			return false
		end
		if self.config.AttackType and self.config.AttackType == FightEnum.EAttackType.Low then
			return false
		end
	end
	return true
end

function AttackComponent:DealHitGround()
	if self.config.HitGroundCreateEntity then
		for k, entityId in pairs(self.config.HitGroundCreateEntity) do
			local entity = self.fight.entityManager:CreateEntity(entityId, self.entity.parent)
			entity.transformComponent:SetPosition(self.hitGroundPos.x, self.hitGroundPos.y, self.hitGroundPos.z)
			entity:SetDefaultSkillLevel(self:GetDefaultAttackLevel())
			entity:SetDefaultSkillType(self:GetSkillType())
		end
	end

	self.fight.entityManager:CallBehaviorFun("HitGround",self.entity.parent.instanceId,self.entity.instanceId,
		self.hitGroundPos.x, self.hitGroundPos.y, self.hitGroundPos.z, self.hitGroundRot.x, self.hitGroundRot.y,
		self.hitGroundRot.z, self.hitGroundRot.w)

	if self.config.StopAfterHitGround then
		local moveComponent = self.entity.moveComponent
		if moveComponent and moveComponent.moveComponent and moveComponent.moveComponent.SetEnable then
			moveComponent.forceMoveOffset = false
			moveComponent.moveComponent:SetEnable(false, self.config.DelayFrameToStop)
		end
	else
		if self.entity.timeoutDeathComponent then
			self.entity.timeoutDeathComponent:SetDeath()
		else
			self.fight.entityManager:RemoveEntity(self.entity.instanceId)
		end
	end
end

function AttackComponent:DealReachRange()
	if self.config.HitGroundCreateEntity then
		for k, entityId in pairs(self.config.HitGroundCreateEntity) do
			local entity = self.fight.entityManager:CreateEntity(entityId, self.entity.parent)
			entity.transformComponent:SetPosition(self.hitGroundPos.x, self.hitGroundPos.y, self.hitGroundPos.z)
			entity:SetDefaultSkillLevel(self:GetDefaultAttackLevel())
			entity:SetDefaultSkillType(self:GetSkillType())
		end
	end

	if self.entity.timeoutDeathComponent then
		self.entity.timeoutDeathComponent:SetDeath()
	else
		self.fight.entityManager:RemoveEntity(self.entity.instanceId)
	end
end

function AttackComponent:DoMagicsBySelfSingle()
	if self.config.MagicsBySelfSingle then
		for i, magicId in ipairs(self.config.MagicsBySelfSingle) do
			local magic = MagicConfig.GetMagic(magicId, self.entity.parent.entityId)
			local buff = MagicConfig.GetBuff(magicId, self.entity.parent.entityId)
			local level = self:GetDefaultAttackLevel()
			if magic then
				self.fight.magicManager:DoMagic(magic, level, self.entity.parent,self.entity.parent,false, nil, nil, nil, nil, nil, self.skillType)
			elseif buff and self.entity.parent.buffComponent then
				self.entity.parent.buffComponent:AddBuff(self.entity.parent, magicId, level, nil, nil, nil, self.skillType)
			end
		end
	end
end

-- TODO 条件后续优化
function AttackComponent:DealPauseFrame(entity)
	if not self.config.HavePauseFrame then
		return
	end

	local pauseFrameParam
	-- -1表示每天，默认选第一个，0则不使用
	local pauseFrameId = self.pauseFrameId or -1
	if pauseFrameId == 0 then
		return
	end

	for k, params in pairs(self.config.PauseFrames) do
		if k == pauseFrameId or pauseFrameId == -1 then
			pauseFrameParam = params
			break
		end
	end

	if not pauseFrameParam then
		return
	end

	local timeComponent
	local entityId
	if not self.entity.parent or not self.entity.parent.timeComponent then
		timeComponent = self.entity.timeComponent
		entityId = self.entity.entityId
	else
		timeComponent = self.entity.parent.timeComponent
		entityId = self.entity.parent.entityId
	end

	if timeComponent then
		if pauseFrameParam.PFTimeScaleCurve and tonumber(pauseFrameParam.PFTimeScaleCurve) > 0 then
			timeComponent:AddTimeScaleCurve(entityId, tonumber(pauseFrameParam.PFTimeScaleCurve), pauseFrameParam.IsCanBreak, pauseFrameParam.PFFrame)
		elseif pauseFrameParam.PFTimeScale then
			timeComponent:AddTimeScale(pauseFrameParam.PFTimeScale, pauseFrameParam.PFFrame, pauseFrameParam.IsCanBreak)
		end

		if pauseFrameParam.PFMonsterSpeedCurve and tonumber(pauseFrameParam.PFMonsterSpeedCurve) > 0 then
			self.fight.entityManager.commonTimeScaleManager:AddEnemyCommonTimeScaleCurve(self.entity.parent, tonumber(pauseFrameParam.PFMonsterSpeedCurve), pauseFrameParam.IsCanBreak, self.entity)
		elseif pauseFrameParam.PFMonsterSpeed then
			self.fight.entityManager.commonTimeScaleManager:AddEnemyCommonTimeScale(pauseFrameParam.PFMonsterSpeed, pauseFrameParam.PFFrame, pauseFrameParam.IsCanBreak, self.entity)
		end
	end

	if entity.timeComponent then
		if pauseFrameParam.TargetPFTimeScaleCurve and tonumber(pauseFrameParam.TargetPFTimeScaleCurve) > 0 then
			entity.timeComponent:AddTimeScaleCurve(entityId, tonumber(pauseFrameParam.TargetPFTimeScaleCurve), pauseFrameParam.IsCanBreak, pauseFrameParam.PFFrame)
		elseif pauseFrameParam.TargetPFTimeScale then
			local duration = pauseFrameParam.PFFrame
			if pauseFrameParam.TargetPFFrame and pauseFrameParam.TargetPFFrame >= 0 then
				duration = pauseFrameParam.TargetPFFrame
			end
			entity.timeComponent:AddTimeScale(pauseFrameParam.TargetPFTimeScale, duration, pauseFrameParam.IsCanBreak)
		end
	end
end

function AttackComponent:CheckEnable()
	if self.config.DelayFrame then
		local curFrame = self.entity.timeComponent.frame
		if curFrame <= self.config.DelayFrame then
			return false
		end

		-- LogError("curFrame = "..curFrame.." other = "..self.config.DelayFrame + self.config.DurationFrame + 1)

		-- 因为timecomponent是先跑的 是从1开始算的 这里的持续帧数要+1才能对的上timecomponent的帧数
		return curFrame <= self.config.DelayFrame + self.config.DurationFrame + 1
	else
		return true
	end
end

function AttackComponent:CheckFirstEnable()
	local curFrame = self.entity.timeComponent.frame
	if self.config.DelayFrame then
		return curFrame == self.config.DelayFrame + 1
	else
		return curFrame == 1
	end
end

function AttackComponent:CheckInterval()
	if not self.config.Repetition or self.config.RepeatType == FightEnum.AttackRepeatType.SingleHit then
		return true
	end

	if self.config.RepeatType == FightEnum.AttackRepeatType.Hit and not self.firstHit then
		return true
	end

	-- 间隔2帧 第0帧开始触发的话 那么触发帧数是 0 - 3 - 6 - 9
	local curFrame = self.entity.timeComponent.frame
	if curFrame > self.intervalFrame then
		self.intervalFrame = curFrame + self.config.IntervalFrame
		return true
	end
	return false
end

function AttackComponent:CheckSingleEntityInterval(instanceId)
	if not self.config.Repetition or self.config.RepeatType ~= FightEnum.AttackRepeatType.SingleHit then
		return true
	end

	if not self.firstHitFrame[instanceId] then
		return true
	end

	local curFrame = self.entity.timeComponent.frame
	if curFrame >= self.firstHitFrame[instanceId] then
		self.firstHitFrame[instanceId] = curFrame + self.config.IntervalFrame
		return true
	end
	return false
end

function AttackComponent:CheckDodgeInvalid()
	if self.dodgeInvaild then
		return false
	end

	--策划说不区分玩家，所以配置了的话，玩家也会打不出伤害
	local player = self.fight.playerManager:GetPlayer()
	if not player.fightPlayer:InDodgeLimit() then
		return true
	end

	if self.config.DodgeInvalidType == FightEnum.DodgeInvalidType.Forever then
		self.dodgeInvaild = true
		return false
	elseif self.config.DodgeInvalidType == FightEnum.DodgeInvalidType.Duration then
		return false
	end

	return true
end

--是否需要检测
function AttackComponent:NeedCheck(entity, colliderInsId)
	if self.checkList and not self.checkList[entity.instanceId] then return false end
	if self.filterList and self.filterList[entity.instanceId] then return false end
	if self.hits[entity.instanceId] then return false end
	if entity.blowComponent then
		return  true
	end
	if entity.hitComponent == nil then return false end
	if entity.tagComponent == nil then return false end
	if entity.timeComponent and entity.timeComponent.frame <= 1 then return false end

	if entity.partComponent then
		if colliderInsId then
			local part = entity.partComponent:GetPartByColliderInsId(colliderInsId)
			if not part then
				return false
			end

			if part.onlyHitAlarm then
				self.fight.entityManager:CallBehaviorFun("BeforeCollide", self.entity.parent.instanceId,
					entity.instanceId, self.entity.instanceId, self.config.ShakeStrenRatio, self.config.AttackType or 0, self.skillType)
				return false
			end
		end
	else
		return false
	end

	if entity.stateComponent then
		if entity.stateComponent:IsState(FightEnum.EntityState.Death) then return false end
		if entity.stateComponent.backstage ~= FightEnum.Backstage.Foreground then return false end
	end

	if self.config.Target and not BehaviorFunctions.CheckIsTarget(self.entity.instanceId, entity.instanceId, self.config.Target) then
		return false
	elseif not self.config.Target and entity.tagComponent.camp == self.entity.tagComponent.camp then
		return false
	end

	if entity.tagComponent:IsNpc() then
		self.hits[entity.instanceId] = true
		self.fight.entityManager:CallBehaviorFun("OnAttackNpc",self.entity.parent.instanceId, entity.instanceId,
				self.entity.instanceId, self.config.AttackType or 0, self.skillType)
		return false
	end

	if self.config.ShapeType == FightEnum.CollisionType.Cylinder then
		local attackHeight = self.config.Height
		if entity.transformComponent and entity.collistionComponent and self.entity.transformComponent then
			local targetBotPosY = entity.transformComponent.position.y
			local targetTopPosY = targetBotPosY + entity.collistionComponent.height
			local attackPosY = self.entity.transformComponent.position.y
			local attackTopPosY = attackPosY + (attackHeight / 2)
			local attackBotPosY = attackPosY - (attackHeight / 2)
			return targetBotPosY < attackTopPosY or targetTopPosY > attackBotPosY
		else
			return false
		end
	end
	return true
end

function AttackComponent:GetCollisionHeight()
	if self.config.ShapeType == FightEnum.CollisionType.Cube or self.config.ShapeType == FightEnum.CollisionType.Cylinder then
		return self.config.Height
	elseif self.config.ShapeType == FightEnum.CollisionType.Sphere then
		return self.config.Radius * 2
	end
end

function AttackComponent:GetCollisionRadius()
	if self.config.ShapeType == FightEnum.CollisionType.Sphere or self.config.ShapeType == FightEnum.CollisionType.Cylinder then
		return self.config.Radius
	elseif self.config.ShapeType == FightEnum.CollisionType.Cube then
		return self.config.Width / 2
	end
end


function AttackComponent:GetDefaultAttackLevel()
	return self.entity:GetDefaultSkillLevel()
end

function AttackComponent:OnCache()
	for k, v in pairs(self.colliderList) do
		self.fight.entityManager:RemoveColliderEntity(v.colliderObjInsId, true)
		v:OnCache()
	end
	TableUtils.ClearTable(self.colliderList)


	self.fight.objectPool:Cache(AttackComponent,self)
end

function AttackComponent:__cache()
	TableUtils.ClearTable(self.hits)

	self.fight = nil
	self.entity = nil
	self.partComponent = nil
	self.initFrame = nil
	self.partCollisionName = nil
	self.reachRangeTargetPos = nil

	self.hitWater = false
	self.hitGround = false
	self.hitGroundCheckTime = 0
	self.dodgeInvaild = false

	self.cameraShakeId = nil
	self.pauseFrameId = nil

	self.checkList = nil
	self.filterList = nil

	if self.projectObj then
		GameObject.Destroy(self.projectObj)
		self.projectObj = nil
	end
end

function AttackComponent:__delete()
	if self.colliderList then
		for k, v in pairs(self.colliderList) do
			v:DeleteMe()
		end
		self.colliderList = nil
	end

	if self.projectObj then
		GameObject.Destroy(self.projectObj)
		self.projectObj = nil
	end
end

function AttackComponent:_DebugShowBulletProject()
	if not self.projectObj then
		self.projectObj = GameObject.CreatePrimitive(PrimitiveType.Cylinder)
		local collider = self.projectObj:GetComponent(Collider)
		collider.enabled = false

		self.projectObj.transform.localScale = Vector3(1, 0.1, 1)
	end

	if self.projectObj then
		local pos = self.entity.transformComponent.position
		local rot = self.entity.transformComponent.rotation
		local offset = Vec3.New(self.config.OffsetX, self.config.OffsetY, self.config.OffsetZ)
		offset = rot * offset
		local position = Vec3.New(pos.x, pos.y, pos.z)
		position:Add(offset)

		local check, x, y, z = UnityUtils.LineCast(position.x, position.y, position.z, position.x, position.y - 5, position.z)
		UnityUtils.SetActive(self.projectObj, check)
		if check then
			UnityUtils.SetPosition(self.projectObj.transform, x, y, z)
		end
	end
end