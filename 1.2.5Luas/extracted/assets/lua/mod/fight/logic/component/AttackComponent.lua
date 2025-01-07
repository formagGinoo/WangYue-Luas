---@class AttackComponent
AttackComponent = BaseClass("AttackComponent",PoolBaseClass)
local AttrType = EntityAttrsConfig.AttrType
local _random = math.random
local EntityBitLayer = FightEnum.LayerBit.Entity

function AttackComponent:__init()
	self.collisionList = {}
	self.hitEnities = {}
	self.hitEntityColliders = {}
	self.hits = {}
	self.dodgeInvaild = false
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
	self.passFrame = 0
	if not self.config.Part or self.config.Part == "" then
		local offsetX = self.config.OffsetX
		local offsetY = self.config.OffsetY
		local offsetZ = self.config.OffsetZ
		local collision
		if self.config.ShapeType == FightEnum.CollisionType.Sphere then
			collision = self.fight.objectPool:Get(SphereCollision)
			collision:Init(fight,self.transformComponent,self.config.Radius,offsetX,offsetY,offsetZ)
		elseif self.config.ShapeType == FightEnum.CollisionType.Cube then
			collision = self.fight.objectPool:Get(CubeCollision)
			local x = self.config.Lenght
			local y = self.config.Height
			local z = self.config.Width
			collision:Init(fight,self.transformComponent,x,y,z,offsetX,offsetY,offsetZ)
		elseif self.config.ShapeType == FightEnum.CollisionType.Cylinder then
			collision = self.fight.objectPool:Get(CylinderCollision)
			collision:Init(fight,self.entity.transformComponent,self.config.Radius,self.config.Height,offsetX,offsetY,offsetZ)
		elseif self.config.ShapeType == FightEnum.CollisionType.Circle then
			local radius = self.config.circleStartRadius - self.config.circleRadius
			if radius >= 0 then
				local outCollision = self.fight.objectPool:Get(CylinderCollision)
				outCollision:Init(fight, self.entity.transformComponent, self.config.circleStartRadius, self.config.Height, offsetX, offsetY, offsetZ)
				outCollision.color = Color(0,0,1,1)
				table.insert(self.collisionList, outCollision)
			else
				radius = self.config.circleStartRadius
			end

			collision = self.fight.objectPool:Get(CylinderCollision)
			collision:Init(fight, self.entity.transformComponent, radius, self.config.Height, offsetX, offsetY, offsetZ)
			collision.color = Color(1,0,0,0.5)
		end

		table.insert(self.collisionList, collision)

		if self.config.CanHitGround then
			self.hitLayer = FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Defalut
		end
	else
		self.partComponent = self.entity.owner.partComponent
		self.partCollisionName = self.config.Part
	end


	self.hited = false

	self.reboundFrame = self.config.ReboundFrame or 0
	self.defaultAttackLevel = 1
end

function AttackComponent:LateInit()
	local offsetX = self.config.OffsetX
	local offsetY = self.config.OffsetY
	local offsetZ = self.config.OffsetZ
	
	for _, v in pairs(self.collisionList) do
		local colliderInstanceId = v:CreateColliderObject(self.entity.instanceId, FightEnum.Layer.Entity)
		self.entity.clientEntity.clientTransformComponent:SetTransformChild(v.colliderTransform, "", self.entity.instanceId)
		self.fight.entityManager:SetColliderEntity(colliderInstanceId, self.entity.instanceId)
		UnityUtils.SetLocalPosition(v.colliderTransform, offsetX, offsetY, offsetZ)
	end
end

function AttackComponent:GetCollisionList()
	if not self.partCollisionName then
		return self.collisionList
	end

	local part = self.partComponent:GetPart(self.partCollisionName)
	return part:GetCollisionList()
end

function AttackComponent:IsValid()
	if self.maxAttackTimes > 0 and self.curAttackTimes >= self.maxAttackTimes then
		return false
	end

	if not self:CheckEnable() then
		return false
	end

	if not self:CheckInterval() then
		return false
	end

	if not self:CheckDodgeInvalid() then
		return false
	end

	if self.entity == nil then
		return false
	end

	return true
end

function AttackComponent:Update()
	--do return end
	if not self:IsValid() then
		return
	end

	local collisionList = self:GetCollisionList()
	if DebugClientInvoke.Cache.ShowAttackCollider then
		for k, v in ipairs(collisionList) do
			v:Draw()
		end
	end
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

	if self.config.ShapeType == FightEnum.CollisionType.Circle and self.passFrame < self.config.SpreadFrame and collisionList and next(collisionList) then
		self.passFrame = self.passFrame + 1
		local outRadius = self.config.circleStartRadius + (self.config.SpreadSpeed * self.passFrame)
		if outRadius >= self.config.circleRadius and #collisionList == 1 then
			local collision = self.fight.objectPool:Get(CylinderCollision)
			collision:Init(self.fight, self.entity.transformComponent, 0, self.config.Height, self.config.OffsetX, self.config.OffsetY, self.config.OffsetZ)
			collision.color = Color(0,0,1,1)
			table.insert(self.collisionList, collision)

			collisionList[1]:ChangeRadius(outRadius)
		elseif #collisionList == 2 then
			collisionList[1]:ChangeRadius(outRadius)
			collisionList[2]:ChangeRadius(outRadius - self.config.circleRadius)
		end
	end

	if self:UpdateHitGround() then
		return
	end

	if self:UpdateReachRange() then
		return
	end
end

function AttackComponent:UpdateHitEntity()
	UnityUtils.BeginSample("UpdateHitEntity")
	TableUtils.ClearTable(self.hitEnities)
	TableUtils.ClearTable(self.hitEntityColliders)
	local collisionList = self:GetCollisionList()
	if self.config.ShapeType == FightEnum.CollisionType.Circle then
		self:UpdateCircleHit(collisionList)
	else
		self:UpdateNormalHit(collisionList)
	end

	UnityUtils.EndSample()
end

function AttackComponent:UpdateNormalHit(collisionList)
	for k, v in pairs(collisionList) do
		local colliders, count = v:OverlapCollider(EntityBitLayer)
		local attackColliderPos

		for i = 0, count - 1 do
			local collider = colliders[i]
			if not collider then
				goto continue
			end

			local gameObject = collider.gameObject
			local colliderInsId = gameObject:GetInstanceID()
			local instanceId = tonumber(gameObject.name)
			local entity = self.fight.entityManager:GetEntity(instanceId)
			if entity and self:NeedCheck(entity, colliderInsId) then
				self.hitEnities[instanceId] = entity
				-- 仅多部位的才需要计算需要collider比较
				if #entity.partComponent.parts > 0 then
					attackColliderPos = attackColliderPos or v:GetPosition()
					self.hitEntityColliders[instanceId] = self.hitEntityColliders[instanceId] or {}
					local distance = Vec3.SquareDistance(attackColliderPos, collider.transform.position)
					table.insert(self.hitEntityColliders[instanceId], {
							distance = distance, colliderInsId = colliderInsId, attackCollision = v
							})
				end
			end

			::continue::
		end
	end
end

function AttackComponent:UpdateCircleHit(collisionList)
	local hitTemp = {}
	local hitCollidersTemp = {}

	for k, v in pairs(collisionList) do
		local colliders, count = v:OverlapCollider(EntityBitLayer)
		local attackColliderPos
		local collisionHitTemp = {}
		local collidersHitTemp = {}

		for i = 0, count - 1 do
			local collider = colliders[i]
			if not collider then
				goto continue
			end

			local gameObject = collider.gameObject
			local colliderInsId = gameObject:GetInstanceID()
			local instanceId = tonumber(gameObject.name)
			local entity = self.fight.entityManager:GetEntity(instanceId)
			if entity and self:NeedCheck(entity, colliderInsId) then
				collisionHitTemp[instanceId] = entity
				if #entity.partComponent.parts > 0 then
					attackColliderPos = attackColliderPos or v:GetPosition()
					collidersHitTemp[instanceId] = collidersHitTemp[instanceId] or {}
					local distance = Vec3.SquareDistance(attackColliderPos, collider.transform.position)
					table.insert(collidersHitTemp[instanceId], {distance = distance, colliderInsId = colliderInsId, attackCollision = v})
				end
			end

			::continue::
		end

		table.insert(hitTemp, collisionHitTemp)
		table.insert(hitCollidersTemp, collidersHitTemp)
	end

	for k, v in pairs(hitTemp[1]) do
		if not hitTemp[2][k] then
			self.hitEnities[k] = v
		end
	end

	for k, v in pairs(hitCollidersTemp[1]) do
		if not hitCollidersTemp[2][k] then
			self.hitEntityColliders[k] = v
		end
	end
end

function AttackComponent:UpdateHitGround()
	if not self.config.CanHitGround or self.curAttackTimes > 0 then
		return false
	end

	-- 打到地面了
	local scale = self.entity.timeComponent and self.entity.timeComponent:GetTimeScale() or 1
	local time = FightUtil.deltaTime * scale
	self.hitGroundCheckTime = self.hitGroundCheckTime + time

	local collisionList = self:GetCollisionList()
	for k, v in pairs(collisionList) do
		local isHit, hitPointX, hitPointY, hitPointZ = v:OverlapColliderNearPos(self.hitLayer)
		if isHit then
			local position = self.entity.transformComponent.position
			self.hitGround = true
			self.hitGroundPos = Vec3.New(hitPointX, hitPointY, hitPointZ)
			self.entity.moveComponent:SetForcePositionOffset(hitPointX - position.x, hitPointY - position.y, hitPointZ - position.z)
		end
	end

	if self.hitGround and self.hitGroundCheckTime >= 0.1 then
		self:DealHitGround()
		self.hitGround = false
		self.hitGroundPos = nil
		self.hitGroundCheckTime = 0
		return true
	end
	
	return false
end

function AttackComponent:UpdateReachRange()
	if not self.config.RemoveAfterReach or self.curAttackTimes > 0 then
		return false
	end
	
	local targetPosition
	if self.entity.skillComponent then
		targetPosition = self.entity.skillComponent.targetPosition
	elseif self.entity.owner and self.entity.owner.skillComponent then
		targetPosition = self.entity.owner.skillComponent.targetPosition
	end
	
	if targetPosition then
		local selfPos = self.transformComponent:GetPosition()
		local dis = Vec3.Distance(targetPosition, selfPos)
		if dis <= self.config.ReachRange then
			self.hitGroundPos = selfPos
			self:DealHitGround()
			self.hitGroundPos = nil
			return true
		end
	end
	
	return false
end

function AttackComponent:DoAttackCheck(entity, colliderList)
	local part, collisionAttacked
	if self.hitEnities[entity.instanceId] then
		-- 子部位需比较距离
		local hitHead = self.config.HeadHitTypeConfigList
	 	part, collisionAttacked = entity.partComponent:PartsColliderCheckByAttack(self, colliderList, hitHead)
	end

	if self:CheckDodge(entity) then
		if entity.dodgeComponent and entity.dodgeComponent:IsValid() then
			self:DealDodge(entity)
		 	return
		end
	end

	self.curAttackTimes = self.curAttackTimes + 1
	--受击时重置攻击间隔
	if self.config.Repetition then
		self.intervalFrame = self.entity.timeComponent.frame + self.config.IntervalFrame
	end

	if part then
		local reboundAttackComponent = entity.reboundAttackComponent
		if reboundAttackComponent then
			local reboundAttack = false
			if self.reboundFrame > 0 then
				if self.config.ReboundTag and self.config.ReboundTag == FightEnum.ReboundTag.Mark  then
					reboundAttack = reboundAttackComponent:AddReboundAttack(self.entity.owner, self.config.ReboundEntityId, self.config.ReboundFrame)
				else
					reboundAttack = reboundAttackComponent:DoReboundAttack(self.entity.owner)
				end
			else
				reboundAttack = reboundAttackComponent:CheckReboundAttack(self.entity.owner.instanceId, self.entity.entityId)
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

		self:DealAttack(entity, part, collisionAttacked)
	end
end

function AttackComponent:DealAttack(entity, part, collisionAttacked)
	-- LogError("attack deal attack entityId = "..self.entity.entityId.." owner = "..self.entity.owner.entityId)
	self:DealPauseFrame(entity)
	if not self.hited then
		--首次命中
		-- self:DealPauseFrame()
		self:DoMagicsBySelfSingle()
		self.fight.entityManager:CallBehaviorFun("FirstCollide",self.entity.owner.instanceId,entity.instanceId,self.entity.instanceId,self.config.AttackType or 0)
	end
	--碰撞命中
	self.fight.entityManager:CallBehaviorFun("Collide",self.entity.owner.instanceId,entity.instanceId,self.entity.instanceId, self.config.ShakeStrenRatio,self.config.AttackType or 0)
	self.fight.taskManager:CallBehaviorFun("Collide",self.entity.owner.instanceId,entity.instanceId,self.entity.instanceId)

	self.hited = true
	local immuneAttackMagic = entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneAttackMagic)
	local armorBefore
	if entity.attrComponent then
		armorBefore = entity.attrComponent:GetValue(AttrType.Armor) > 0
	end
	
	if not immuneAttackMagic then
		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self, true)
		end
	end

	local attackHit = false
	local immuneHit = entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit) and
					not entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForbiddenImmuneHit)
	if not immuneHit and not armorBefore then
		self.fight.entityManager:CallBehaviorFun("BeforeAttack",self.entity.owner.instanceId, entity.instanceId)
		if entity.hitComponent then
			attackHit = true
			entity.hitComponent:Hit(part,self)
		end
		self.fight.entityManager:CallBehaviorFun("Attack",self.entity.owner.instanceId, entity.instanceId,self.entity.instanceId)
	end
	if not immuneAttackMagic then
		if entity.hitComponent then
			entity.hitComponent:ApplyMagic(part,self)
		end

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

	if ctx then
		--子弹攻击组件震屏参数生效条件：
		--1、当前操控的角色，攻击命中任意目标时
		--2、任意攻击命中当前被玩家操控的角色时
		if self.entity.owner.instanceId == self.fight.playerManager:GetPlayer():GetCtrlEntity()
			or (entity.owner and entity.owner.instanceId == self.fight.playerManager:GetPlayer():GetCtrlEntity()) then
			if self.config.UseCameraShake and self.config.CameraShake then
				for k, params in pairs(self.config.CameraShake) do
					self.fight.clientFight.cameraManager.cameraShakeManager:Shake(params.ShakeType,
						params.StartAmplitude,params.StartFrequency,params.TargetAmplitude,params.TargetFrequency,
						params.AmplitudeChangeTime,params.FrequencyChangeTime,params.DurationTime,params.Sign,params.DistanceDampingId,params.StartOffset,params.Random)
				end
			end
		end
	end

	if not self.config.Repetition then
		self.hits[entity.instanceId] = entity
	end


	if self.config.CreateHitEntities then
		for k, v in ipairs(self.config.CreateHitEntities) do
			local effectEntity = self.fight.entityManager:CreateEntity(v.EntityId, entity)
			if effectEntity.clientEntity.clientEffectComponent then
				local config = effectEntity.clientEntity.clientEffectComponent.config
				local lookEntity
				if v.LookatType == FightEnum.EntityLookAtType.Entity then
					lookEntity = self.entity
				elseif v.LookatType == FightEnum.EntityLookAtType.EntityOwner then
					lookEntity = self.entity.owner
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
		end
	end

	if self.config.CreateAttackEntities then
		local position = self.entity.transformComponent.position
		local rotation = self.entity.transformComponent.rotation
		for k, entityId in ipairs(self.config.CreateAttackEntities) do
			local tempEntity = self.fight.entityManager:CreateEntity(entityId, self.entity.owner)
			tempEntity.transformComponent:SetPosition(position.x, position.y, position.z)
			tempEntity.transformComponent:SetStartRotate(rotation)
			if tempEntity.moveComponent and tempEntity.moveComponent.config.MoveType == FightEnum.MoveType.Track then
				tempEntity.moveComponent.moveComponent:SetTarget(entity)
			end
		end
	end

	if not entity.hitComponent:ForbiddenBoneShake() then
		entity.hitComponent:SetEntityBoneShake(self.config, self.collisionList[1])

		if entity.clientEntity.clientIkComponent and self.config.ShakeStrenRatio > 0 then
			entity.clientEntity.clientIkComponent:AttackShake(self.config.ShakeDir, self.config.ShakeStrenRatio, self.entity.owner.instanceId)
		end
	end

	if self.config.UsePostProcess then
		local postProcessManager = self.fight.clientFight.postProcessManager
		for _, v in pairs(self.config.PostProcessParamsList) do
			postProcessManager:AddPostProcess(v.PostProcessType, v, self.entity.owner)
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
		self.fight.entityManager:CallBehaviorFun("JumpDodge",self.entity.owner.instanceId,entity.instanceId,isLimit,notJumpBeatBack)
		self.fight.entityManager:CallBehaviorFun("JumpBeDodge",self.entity.owner.instanceId, entity.instanceId, isLimit, notJumpBeatBack)
	else
		self.fight.entityManager:CallBehaviorFun("BeforeDodge",self.entity.owner.instanceId,entity.instanceId,isLimit)
		self.fight.entityManager:CallBehaviorFun("BeforeBeDodge",self.entity.owner.instanceId, entity.instanceId, isLimit)
		self.fight.entityManager:CallBehaviorFun("Dodge",self.entity.owner.instanceId,entity.instanceId,isLimit)
		self.fight.entityManager:CallBehaviorFun("BeDodge",self.entity.owner.instanceId, entity.instanceId, isLimit)
	end
	
	EventMgr.Instance:Fire(EventName.OnDealDodge, entity.instanceId)

	if not self.config.Repetition then
		self.hits[entity.instanceId] = entity
	end
end

function AttackComponent:HitGround()
	self.hitGround = true
end

function AttackComponent:CheckDodge(entity)
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
			local entity = self.fight.entityManager:CreateEntity(entityId, self.entity.owner)
			entity.transformComponent:SetPosition(self.hitGroundPos.x, self.hitGroundPos.y, self.hitGroundPos.z)
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
			local magic = MagicConfig.GetMagic(magicId, self.entity.owner.entityId)
			local buff = MagicConfig.GetBuff(magicId, self.entity.owner.entityId)
			local level = self:GetDefaultAttackLevel()
			if magic then
				self.fight.magicManager:DoMagic(magic, level, self.entity.owner,self.entity.owner,false)
			elseif buff and self.entity.owner.buffComponent then
				self.entity.owner.buffComponent:AddBuff(self.entity.owner, magicId, level)
			end
		end
	end
end

-- TODO 条件后续优化
function AttackComponent:DealPauseFrame(entity)
	if not self.config.HavePauseFrame then
		return
	end

	local timeComponent
	local entityId
	if not self.entity.owner or not self.entity.owner.timeComponent then
		timeComponent = self.entity.timeComponent
		entityId = self.entity.entityId
	else
		timeComponent = self.entity.owner.timeComponent
		entityId = self.entity.owner.entityId
	end

	if timeComponent then
		if self.config.PFTimeScaleCurve and tonumber(self.config.PFTimeScaleCurve) > 0 then
			timeComponent:AddTimeScaleCurve(entityId, tonumber(self.config.PFTimeScaleCurve), self.config.IsCanBreak, self.config.PFFrame)
		elseif self.config.PFTimeScale then
			timeComponent:AddTimeScale(self.config.PFTimeScale, self.config.PFFrame, self.config.IsCanBreak)
		end

		if self.config.PFMonsterSpeedCurve and tonumber(self.config.PFMonsterSpeedCurve) > 0 then
			self.fight.entityManager:AddEnemyCommonTimeScaleCurve(self.entity.owner, tonumber(self.config.PFMonsterSpeedCurve), self.config.IsCanBreak)
		elseif self.config.PFMonsterSpeed then
			self.fight.entityManager:AddEnemyCommonTimeScale(self.config.PFMonsterSpeed, self.config.PFFrame, self.config.IsCanBreak)
		end
	end

	if entity.timeComponent then
		if self.config.TargetPFTimeScaleCurve and tonumber(self.config.TargetPFTimeScaleCurve) > 0 then
			entity.timeComponent:AddTimeScaleCurve(entityId, tonumber(self.config.TargetPFTimeScaleCurve), self.config.IsCanBreak, self.config.PFFrame)
		elseif self.config.TargetPFTimeScale then
			entity.timeComponent:AddTimeScale(self.config.TargetPFTimeScale, self.config.PFFrame, self.config.IsCanBreak)
		end
	end
end

function AttackComponent:CheckEnable()
	if self.config.DelayFrame then
		local curFrame = self.entity.timeComponent.frame
		if curFrame <= self.config.DelayFrame then
			return false
		end
		return curFrame <= self.config.DelayFrame + self.config.DurationFrame
	else
		return true
	end
end

function AttackComponent:CheckInterval()
	if self.config.Repetition then
		local curFrame = self.entity.timeComponent.frame
		if curFrame > self.intervalFrame then
			--self.intervalFrame = curFrame + self.config.IntervalFrame
			return true
		end
		return false
	else
		return true
	end
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
	if entity.hitComponent == nil then return false end
	if entity.campComponent == nil then return false end
	if entity.partComponent == nil or (colliderInsId and not entity.partComponent:GetPartByColliderInsId(colliderInsId)) then return false end
	if entity.stateComponent then
		if entity.stateComponent:IsState(FightEnum.EntityState.Death) then return false end
		if entity.stateComponent.backstage ~= FightEnum.Backstage.Foreground then return false end
	end

	if entity.campComponent.camp == self.entity.campComponent.camp then return false end
	if self.hits[entity.instanceId] then return false end
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

function AttackComponent:SetDefaultAttackLevel(level)
	self.defaultAttackLevel = level
end

function AttackComponent:GetDefaultAttackLevel()
	return self.defaultAttackLevel or 1
end

function AttackComponent:OnCache()
	for k, v in pairs(self.collisionList) do
		self.fight.entityManager:RemoveColliderEntity(v.colliderObjInsId, true)
		v:OnCache()
	end
	TableUtils.ClearTable(self.collisionList)


	self.fight.objectPool:Cache(AttackComponent,self)
end

function AttackComponent:__cache()
	TableUtils.ClearTable(self.hits)

	self.fight = nil
	self.entity = nil
	self.partComponent = nil
	self.partCollisionName = nil

	self.hitGround = false
	self.hitGroundCheckTime = 0
	self.dodgeInvaild = false
end

function AttackComponent:__delete()
	if self.collisionList then
		for k, v in pairs(self.collisionList) do
			v:DeleteMe()
		end
		self.collisionList = nil
	end
end