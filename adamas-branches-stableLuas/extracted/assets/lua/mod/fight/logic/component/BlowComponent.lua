---@class BlowComponent
BlowComponent = BaseClass("BlowComponent",PoolBaseClass)
local Vec3 = Vec3
local UpDir = Vec3.New(0, 1, 0)
local _abs = math.abs
local _random = math.random
local _sqrt = math.sqrt
local _max = math.max

local EntityLayer = FightEnum.Layer.Entity

function BlowComponent:__init()
end

BlowComponent.Const_StandardMass = 10
BlowComponent.Const_DefaultSpeed = 10
BlowComponent.Const_DefaultBreakSpeed = 1
BlowComponent.Const_ParentName = "BlowParent"

function BlowComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Blow)
	self.transformComponent = self.entity.transformComponent
	self.timeComponent = self.entity.timeComponent
	self.parts = self.entity.partComponent and self.entity.partComponent.parts or nil
	self.PartStaminaConfig = self.config.PartStamina or {}


	self.Mass = self.config.Mass
	self.PiecesMass = self.config.PiecesMass or self.config.Mass/2
	self.BreakSpeed = self.config.BreakSpeed or 1
	self.PhysicType = self.config.PhysicType
	self.PartStamina = {}
	self.PartCloseCdCount = {}
	self.BlowBoneGroupList = {}

	self.CreateHitEntities = self.config.CreateHitEntities or {}
	self.CreateBreakEntities = self.config.CreateBreakEntities or {}
	self.CreateDisappearEntities = self.config.CreateDisappearEntities or {}

	self.CloseColliderTime = self.config.CloseColliderTime or -1
	self.DisappearTime = self.config.DisappearTime or -1
	
end
function BlowComponent:LateInit()
	if self.entity and self.entity.partComponent then
		local tempRootList = {}
		for k, v in pairs(self.entity.partComponent.parts) do
			local blowRoot = v.partName
			table.insert(tempRootList,blowRoot)
		end

		for i, v in ipairs(tempRootList) do
			for j, w in ipairs(self.PartStaminaConfig) do
				if w.TransformName == v then
					self.PartStamina[v] = w.Stamina
					table.insert(self.BlowBoneGroupList,w.BlowBoneGroup)
				end
			end
		end
		
		for k, v in pairs(self.PartStamina) do
			self.PartCloseCdCount[k] = self.CloseColliderTime
		end
	end
	self.transform = self.entity.clientTransformComponent.transform
end

function BlowComponent:HasBlow()
	return self.Stamina == 0 
end
function BlowComponent:Blow(part,collisionAttacked,attackComponent)
	
	local attackPosition = nil

	-- 绑定的攻击视为来自角色方向的攻击，防止因为站的太近，吹飞物件被夹在人和攻击实体间导致往背后吹飞
	if attackComponent.entity.moveComponent and attackComponent.entity.moveComponent:IsBindMoveType() and attackComponent.entity.parent then
		attackPosition = attackComponent.entity.parent.transformComponent.position
	else
		attackPosition = attackComponent.entity.transformComponent.position
	end
	
	local attackConfig = attackComponent.config
	local params = attackConfig.HitParams
	local blowSpeed = params and params.BlowSpeed or BlowComponent.Const_DefaultSpeed

	local blowRoot = part.partName
	if not self.PartStamina[blowRoot] then
		return
	end

	-- 破碎
	if self.PartStamina[blowRoot] > 0 then
		local stamina = self.PartStamina[blowRoot]

		self.PartStamina[blowRoot]  = stamina - self:GetAttackStamina(attackComponent)
		
		if self.PartStamina[blowRoot] <= 0 then
			-- 破碎特效
			self:CreatEffect(self.CreateBreakEntities,part,collisionAttacked,attackComponent)

			self:DoBlow(attackPosition,blowSpeed,part,self:GetBlowDirect(attackComponent))

			-- 破碎音效
			if self.entity.clientEntity.clientSoundComponent then
				self.entity.clientEntity.clientSoundComponent:OnEvent(FightEnum.SoundEventType.BreakBlow)
			end
		end
		
		-- 打击特效
		self:CreatEffect(self.CreateHitEntities,part,collisionAttacked,attackComponent)

		-- 打击音效
		if self.entity.clientEntity.clientSoundComponent then
			self.entity.clientEntity.clientSoundComponent:OnEvent(FightEnum.SoundEventType.HitBlow)
		end
	end

end

function BlowComponent:GetAttackStamina(attackComponent)
	
	local level = attackComponent:GetDefaultAttackLevel()
	local magicsByTarget = attackComponent.config.MagicsByTargetBeforeHit
	
	local totalDmg = 0
	if magicsByTarget then
		for i, magicId in ipairs(magicsByTarget) do
			local ownerInstanceId = attackComponent.entity.parent and attackComponent.entity.parent.instanceId or nil
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.parent.entityId, nil, ownerInstanceId)
			if magic and magic.Type == FightEnum.MagicType.DoDamage then
				local magicType = FightEnum.MagicFuncName[magic.Type]
				local param = MagicManager.GetMagicParam(magicType, magic, level)
				local skillBaseDmg = param.SkillParam or 0
				totalDmg = skillBaseDmg + totalDmg
			end
		end
	end
	
	magicsByTarget = attackComponent.config.MagicsByTarget
	
	if magicsByTarget then
		for i, magicId in ipairs(magicsByTarget) do
			local ownerInstanceId = attackComponent.entity.parent and attackComponent.entity.parent.instanceId or nil
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.parent.entityId, nil, ownerInstanceId)
			if magic and magic.Type == FightEnum.MagicType.DoDamage then
				local magicType = FightEnum.MagicFuncName[magic.Type]
				local param = MagicManager.GetMagicParam(magicType, magic, level)
				local skillBaseDmg = param.SkillParam or 0
				totalDmg = skillBaseDmg + totalDmg
			end
		end
	end
	
	return totalDmg
end

-- 如果攻击组件配置了击飞，会额外修改吹飞方向
function BlowComponent:GetBlowDirect(attackComponent)
	local extraDirect = nil
	local hitTypeConfigList = attackComponent.config.HitTypeConfigList
	local hitTypeLen = hitTypeConfigList and #hitTypeConfigList or 0
	if hitTypeLen > 0 then
		for i, v in ipairs(hitTypeConfigList) do
			if v.HitType == 7 then
				extraDirect = Vec3.New(0,attackComponent.config.HitParams.SpeedY ,attackComponent.config.HitParams.SpeedZHitFly)
				return extraDirect:ToUnityVec3()
			end
		end
	end
	return Vector3(0,0,0)
end

-- 执行吹飞
function BlowComponent:DoBlow(attackPosition,blowSpeed,part,offsetDirect)
	self.Stamina = 0
	--设置脏标记,让缓存池复制该资源时调用重置
	self.entity.clientTransformComponent:MarkGameObjectDirty()
	
	self.blowEffect = self.entity.clientTransformComponent.gameObject:GetComponentInChildren(BlowEffect, true)
	if not self.blowEffect then
		self.blowEffect = self.entity.clientTransformComponent.gameObject:AddComponent(BlowEffect)
	end

	self.blowEffect:InitParam(self.PhysicType, self.entity.entityId, self.Mass, self.PiecesMass,self.BlowBoneGroupList)

	
	local blowBoneGroup = self:GetBlowBoneGroup(part.partName)
	if blowBoneGroup then
		
		self.blowEffect:Blow(attackPosition,blowSpeed,blowBoneGroup,offsetDirect)
		--关闭部位盒子
		part:SetPartEnable(false)
	end

end

function BlowComponent:Update()
	
	if not self:HasBlow() and self.parts then
		local entityManager = self.fight.entityManager
		local triggerDatas = self.entity:GetTriggerData(FightEnum.TriggerType.Fight)
		if triggerDatas then
			for k, triggerData in pairs(triggerDatas) do
				for colliderInsId, layer in pairs(triggerData) do
					if layer == EntityLayer then
						local entity = entityManager:GetColliderEntity(colliderInsId)
						if entity then
							if entity.stateComponent and entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
								--self:DoBlow(entity.transformComponent:GetPosition(),1)
							elseif  entity.moveComponent and entity.moveComponent.yMoveComponent then
								local BreakSpeed = self.BreakSpeed or BlowComponent.Const_DefaultBreakSpeed 
								if entity.moveComponent.yMoveComponent.speed and _abs( entity.moveComponent.yMoveComponent.speed) > BreakSpeed then
									--self:DoBlow(entity.transformComponent:GetPosition(),1)
								end
							end
						end
					end
				end
			end
		end
	end

end
-- 关闭吹飞点下碎片的物理碰撞
function BlowComponent:CloseColliderBlowRoot(blowRoot)
	self.blowEffect:CloseColliderBlowRoot(self:GetBlowBoneGroup(blowRoot))
end


function BlowComponent:GetBlowBoneGroup(blowRoot)
	local blowBoneGroup
	for j, w in ipairs(self.PartStaminaConfig) do
		if w.TransformName == blowRoot then
			blowBoneGroup = w.BlowBoneGroup
		end
	end
	return blowBoneGroup
end

function BlowComponent:DisappearTimeEnd()
	if next(self.CreateDisappearEntities) then
		local creatEffectList = self:CreatEffect(self.CreateDisappearEntities)
		-- 跟消失特效绑定生命
		if creatEffectList[1] then
			creatEffectList[1]:AddChild(self.entity)
		end
	else
		self.fight.entityManager:RemoveEntity(self.entity.instanceId)
	end
end

function BlowComponent:AfterUpdate()
	
    local time = FightUtil.deltaTimeSecond

	local blowedAll = true
	for i, v in pairs(self.PartStamina) do
		local isBlowed = v <= 0
		if isBlowed then
			if self.PartCloseCdCount[i] and  self.PartCloseCdCount[i] ~= -1 then
				if self.PartCloseCdCount[i] <= 0 then
					self.PartCloseCdCount[i] = nil
					self:CloseColliderBlowRoot(i)
				else
					self.PartCloseCdCount[i] = math.max(0,self.PartCloseCdCount[i] - time) 
				end

			end
		else
			blowedAll = false
		end
	end
	if blowedAll and self.DisappearTime ~= -1 then
		if self.DisappearTime <= 0 then
			self:DisappearTimeEnd()
			self.DisappearTime = -1
		else
			self.DisappearTime = math.max(0, self.DisappearTime - time)
		end
	end
end
function BlowComponent:ResetBlow(trans)
	if self:HasBlow() then
		self.blowEffect:ResetBlow(self.entity.entityId,trans,self.BlowBoneGroupList,self.PhysicType)
	end
end

-- 创建碰撞特效
function BlowComponent:CreatEffect(creatList,part,collisionAttacked,attackComponent)
	if creatList then
		local creatEffectList = {}
		for k, v in ipairs(creatList) do
			
			local pos = self.entity.transformComponent.position
			local effectEntityId = BehaviorFunctions.CreateEntity(v.EntityId, nil, pos.x, pos.y, pos.z)
			local effectEntity =self.fight.entityManager:GetEntity(effectEntityId)
			table.insert(creatEffectList,effectEntity)

			if effectEntity.clientEntity.clientEffectComponent then
				local config = effectEntity.clientEntity.clientEffectComponent.config
				local lookEntity
				if v.LookatType == FightEnum.EntityLookAtType.Entity then
					lookEntity = self.entity
				elseif v.LookatType == FightEnum.EntityLookAtType.EntityOwner then
					lookEntity = self.entity.parent
				end
				if part then
					if config.HitEffectBornType == FightEnum.HitEffectBornType.Bone then
						---命中部位
						effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked)
					elseif config.HitEffectBornType == FightEnum.HitEffectBornType.HitPos then
						---使用子弹本身位置
						effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked, attackComponent.transformComponent.position, lookEntity)
					elseif config.HitEffectBornType == FightEnum.HitEffectBornType.HitOffset then
						---XZ使用部位位置， Y轴使用逻辑攻击Y坐标，并受部位高度限制
						effectEntity.clientEntity.clientEffectComponent:SetHitPart(part, collisionAttacked, attackComponent.transformComponent.position, lookEntity)
					end
					if config.HitEffectBornType ~= FightEnum.HitEffectBornType.HitPos and lookEntity then
						effectEntity.rotateComponent:LookAtTarget(lookEntity)
					end
				end
			end
			if effectEntity.rotateComponent then
				effectEntity.rotateComponent:Async()
			end
		end
		
		return creatEffectList
	end
end

function BlowComponent:OnCache()
	self:ResetBlow(self.transform)
	TableUtils.ClearTable(self.PartStamina)
	TableUtils.ClearTable(self.BlowBoneGroupList)
	TableUtils.ClearTable(self.PartCloseCdCount)
	self.fight.objectPool:Cache(BlowComponent,self)
end

function BlowComponent:__cache()
end

function BlowComponent:__delete()
end