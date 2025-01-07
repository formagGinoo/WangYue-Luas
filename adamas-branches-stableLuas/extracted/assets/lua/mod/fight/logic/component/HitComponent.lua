---@class HitComponent
HitComponent = BaseClass("HitComponent",PoolBaseClass)

local _random = math.random

function HitComponent:__init()
	self.boneShakeComponet = {}
end

function HitComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.hitConfig = entity:GetComponentConfig(FightEnum.ComponentType.Hit)
	self.hitModified = TableUtils.CopyTable(self.hitConfig.hitModified)
	self.stateComponent = self.entity.stateComponent
	
	self.forbiddenBoneShake = false
	self.animForbiddenBoneShake = false
end

function HitComponent:LateInit()
	self.tag = self.entity.tagComponent and self.entity.tagComponent.tag or 0
	self.gameObject = self.entity.clientTransformComponent:GetGameObject()
end

function HitComponent:Hit(part,attackComponent,collision)
	
	local attackConfig = attackComponent.config
	--头部受击，不同的受击表现
	local headHit = false
	if part.partWeakType and part.partWeakType == FightEnum.PartWeakType.Head and attackConfig.HeadHitTypeConfigList then
		headHit = true
	end

	local hitTypeConfigList = headHit and attackConfig.HeadHitTypeConfigList or attackConfig.HitTypeConfigList
	local hitTypeLen = hitTypeConfigList and #hitTypeConfigList or 0
	local hitTypeConfig = hitTypeLen > 0 and hitTypeConfigList[_random(hitTypeLen)] or nil
	attackConfig.HitType = hitTypeConfig and hitTypeConfig.HitType or 0
	local breakLieDown = hitTypeConfig and hitTypeConfig.BreakLieDown or false
	if self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneBreakLieDown) then
		breakLieDown = false
	end
	
	if self:CanHit(breakLieDown) then
		--self.fight.entityManager:CallBehaviorFun("BerforeHit", attackComponent.entity.instanceId, self.entity.instanceId)
		if self:CanRotate() then
			if attackConfig.LookatType == 1 then
				-- local rotation = attackComponent.entity.transformComponent.rotation
				-- self.entity.rotateComponent:SetRotation(rotation)
			elseif attackConfig.LookatType == 2 then
				self.entity.rotateComponent:LookAtTarget(attackComponent.entity)
			elseif attackConfig.LookatType == 3 then
				self.entity.rotateComponent:LookAtTarget(attackComponent.entity.parent)
			end
		end
		
		self.fight.entityManager:CallBehaviorFun("BeforeHit",attackComponent.entity.parent.instanceId, self.entity.instanceId,attackConfig.HitType)
		if self.stateComponent then
			if self.stateComponent:IsState(FightEnum.EntityState.Skill) and hitTypeLen > 0 then
				self.entity.skillComponent:Break(attackComponent.entity.parent.instanceId)
			end
			if self.entity.instanceId == Fight.Instance.playerManager:GetPlayer().ctrlId then
				self.entity.timeComponent:RemoveCanBreakPauseFrame()
				self.fight.entityManager.commonTimeScaleManager:RemoveCanBreakPauseFrame()
				BehaviorFunctions.RemoveBuffByKind(self.entity.instanceId, 1008)
			end
			if attackConfig.HitType > 0 and self.entity.animatorComponent then
				self.stateComponent:SetHitType(attackConfig,attackComponent.entity,headHit)
			end
		end

		if attackConfig.ImmuneHitMove then
			self.entity.moveComponent:SetAnimatorMoveState(false)
		end

		local atkEntity = attackComponent.entity
		local camp
		if self.entity.tagComponent then
			camp = self.entity.tagComponent.camp
		end

		local atkEntityIns = atkEntity.root and atkEntity.root.instanceId or atkEntity.instanceId

		self.fight.entityManager:CallBehaviorFun("Hit", atkEntityIns, 
		self.entity.instanceId, attackConfig.HitType, camp, atkEntity.instanceId)
		EventMgr.Instance:Fire(EventName.OnEntityHit, atkEntityIns, 
		self.entity.instanceId, attackConfig.HitType, camp, atkEntity.instanceId)
			
		if self.entity.clientEntity.clientSoundComponent then
			self.entity.clientEntity.clientSoundComponent:OnEvent(FightEnum.SoundEventType.Hit)
		end
	end
end

function HitComponent:ArmorHit(attackComponent)
	if self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneArmorMove) then
		return
	end
	if self.entity.moveComponent then 
		local attackConfig = attackComponent.config
		local pos1 = self.entity.transformComponent.position
		local pos2 
		local params = attackConfig.HitParams
		if attackConfig.LookatType == 1 then
			pos2 = attackComponent.entity.transformComponent.position
		elseif attackConfig.LookatType == 2 then
			pos2 = attackComponent.entity.transformComponent.position
		elseif attackConfig.LookatType == 3 then
			pos2 = attackComponent.entity.parent.transformComponent.position
		end
		local direction = Vec3.Normalize(pos1 - pos2)

		if params then
			
			local speedZ = (params.SpeedZArmor and self.hitModified) and params.SpeedZArmor * self.hitModified.SpeedZArmor or 0
			local speedZAcceleration = (params.SpeedZArmorAcceleration and self.hitModified) and params.SpeedZArmorAcceleration * self.hitModified.SpeedZArmorAcceleration or 0
			local speedZTime = params.SpeedZArmorTime or 0
			if self.entity.moveComponent.isFlyEntity then
				-- 霸体状态的飞行怪
				speedZ = params.FlyHitSpeedZArmor and params.FlyHitSpeedZArmor * (self.hitModified and self.hitModified.FlyHitSpeedZArmor or 1) or 0
				speedZAcceleration = params.FlyHitSpeedZArmorAcceleration and params.FlyHitSpeedZArmorAcceleration * (self.hitModified and self.hitModified.FlyHitSpeedZArmorAcceleration or 1) or 0
				speedZTime = params.FlyHitSpeedZArmorTime or 0
				local params = {
					speedY = params.FlyHitSpeedYArmor and params.FlyHitSpeedYArmor * (self.hitModified and self.hitModified.FlyHitSpeedYArmor or 1) or 0,
					accelerationY = params.FlyHitSpeedYArmorAcceleration and params.FlyHitSpeedYArmorAcceleration * (self.hitModified and self.hitModified.FlyHitSpeedYArmorAcceleration or 1) or 0,
					accelerationTime = params.FlyHitSpeedYArmorTime and params.FlyHitSpeedYArmorTime * (self.hitModified and self.hitModified.FlyHitSpeedYArmorTime or 1) or 0,
					gravity = Config.FightConfig.Gravity,
					maxFallSpeed = Config.EntityCommonConfig.JumpParam.MaxFallSpeed
				}
				self.entity.moveComponent.yMoveComponent:SetGravityState(true)
				self.entity.moveComponent.yMoveComponent:SetFlyConfig(params, true)
			end
			
			self.entity.moveComponent:ForcedMove(
				speedZ,
				speedZAcceleration,
				speedZTime,
				direction.x,
				direction.z
			)
		end
	end
end

function HitComponent:SetHitModified(type,param1,param2,param3)
	if not self.hitModified then return end
	if type == FightEnum.HitType.Ground then
		self.hitModified.SpeedZ = param1 or 1
		self.hitModified.SpeedZAcceleration = param2 or 1
	elseif type == FightEnum.HitType.Armor then
		self.hitModified.SpeedZArmor = param1 or 1
		self.hitModified.SpeedZArmorAcceleration = param2 or 1
	elseif type == FightEnum.HitType.HitFly then
		self.hitModified.SpeedY = param1 or 1
		self.hitModified.SpeedZHitFly = param2 or 1
		self.hitModified.SpeedYAcceleration = param3 or 1
	elseif type == FightEnum.HitType.Aloft then
		self.hitModified.SpeedYAloft = param1 or 1
		self.hitModified.SpeedZAloft = param2 or 1
		self.hitModified.SpeedYAloftAcceleration = param3 or 1
	end
end

function HitComponent:ReSetHitModified()
	for k, _ in pairs(self.hitModified) do
		self.hitModified[k] = self.hitConfig.hitModified[k]
	end
end

function HitComponent:SetForbiddenBoneShake(forbidden)
	self.forbiddenBoneShake = forbidden
	self:_CheckForbiddenBoneShake()
end

function HitComponent:SetAnimForbiddenBoneShake(forbidden)
	self.animForbiddenBoneShake = forbidden
	self:_CheckForbiddenBoneShake()
end

function HitComponent:_CheckForbiddenBoneShake()
	if self:ForbiddenBoneShake() and self.entity.clientEntity.clientIkComponent then
		self.entity.clientEntity.clientIkComponent:StopPlayShake()
	end
end

function HitComponent:ForbiddenBoneShake()
	return self.forbiddenBoneShake and self.forbiddenBoneShake or self.animForbiddenBoneShake
end

function HitComponent:SetEntityBoneShake(attackConfig, collider)
	if self:ForbiddenBoneShake() then
		return 
	end
	
	local clientTransformComponent = self.entity.clientTransformComponent
	if attackConfig.ShakeId > 0 then
		local rootTransform = clientTransformComponent.transform
		local boneList = clientTransformComponent:GetTransformGroup(attackConfig.BoneGroupShake)
		if boneList then
			for k, bone in pairs(boneList) do
				self:SetBoneShake(rootTransform, bone, attackConfig.ShakeId)
			end
		else
			-- 计算能抖动骨骼最近点
			local pos, rotation = collider:GetPosition(), collider:GetRotation()
			local offset = attackConfig.BoneEffectPos
			local boneEffectPos = pos + rotation * Vec3.New(offset[1], offset[2], offset[3])
			local bone = clientTransformComponent:GetShakeTransform(boneEffectPos)
			--if _G.ShowAttackCollider == 1 then
				--local shakeSpere = GameObject.CreatePrimitive(PrimitiveType.Sphere)
				--shakeSpere.transform.position = Vector3(boneEffectPos.x, boneEffectPos.y, boneEffectPos.z)
				--shakeSpere.transform.localScale = Vector3(0.2, 0.2, 0.2)
				--CustomUnityUtils.SetPrimitiveMaterialColor(shakeSpere, Color(0,0,0,1))
				--local collider = shakeSpere:GetComponent(SphereCollider)
				--collider.enabled = false

				--local callback = function ()
					--GameObject.Destroy(shakeSpere)
				--end
				--LuaTimerManager.Instance:AddTimer(1,2,callback)
			--end 

			if bone then
				self:SetBoneShake(rootTransform, bone, attackConfig.ShakeId)
			end
		end 
	end
end

function HitComponent:SetEntityBoneShakeB(shakeId, boneGroupShake)
	if self:ForbiddenBoneShake() then
		return 
	end

	local clientTransformComponent = self.entity.clientTransformComponent
	local rootTransform = clientTransformComponent.transform
	local boneList = clientTransformComponent:GetTransformGroup(boneGroupShake)
	if boneList then
		for k, bone in pairs(boneList) do
			self:SetBoneShake(rootTransform, bone, shakeId)
		end
	end
end

function HitComponent:SetBoneShake(rootTransform, bone, shakeId)
	local boneShakeComponet = self.boneShakeComponet[bone.name]
	if not boneShakeComponet then
		boneShakeComponet = bone.gameObject:GetComponent(BoneShake)
		if not boneShakeComponet then
			boneShakeComponet = bone.gameObject:AddComponent(BoneShake)
		end
		self.boneShakeComponet[bone.name] = boneShakeComponet
	end
			
	if boneShakeComponet then
		boneShakeComponet:SetShake(rootTransform, shakeId)  
	end
end

function HitComponent:ApplyMagic(part,attackComponent, beforeHit)

	if ctx.IsDebug then
		if DebugClientInvoke.Cache.damagePause then
			Time.timeScale = 0
		end
	end
	local level = attackComponent:GetDefaultAttackLevel()
	local isCanHitObj = self.entity.tagComponent:IsCanHitObj()

	local magicsByTarget = attackComponent.config.MagicsByTarget
	if beforeHit then
		magicsByTarget = attackComponent.config.MagicsByTargetBeforeHit
	end
	if magicsByTarget then
		for i, magicId in ipairs(magicsByTarget) do
			local ownerInstanceId = attackComponent.entity.parent and attackComponent.entity.parent.instanceId or nil
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.parent.entityId, nil, ownerInstanceId)
			local buff = MagicConfig.GetBuff(magicId, attackComponent.entity.parent.entityId, nil, ownerInstanceId)
			if isCanHitObj and (not magic or magic.Type ~= FightEnum.MagicType.DoDamage)then
				--可攻击物件仅受伤害magic影响，不吃其他magic和buff
				goto continue
			end
			if magic then
				self.fight.magicManager:DoMagic(magic,level,attackComponent.entity.parent,self.entity,false,magicId,
				nil,part,attackComponent.entity,nil, attackComponent:GetSkillType())
			elseif buff and attackComponent.entity.parent.buffComponent then
				self.entity.buffComponent:AddBuff(attackComponent.entity.parent, magicId, level, attackComponent.entity.parent, 
				nil, part, attackComponent:GetSkillType())
			end
			::continue::
		end
	end
	
	local magicsBySelf = attackComponent.config.MagicsBySelf
	if beforeHit then
		magicsBySelf = attackComponent.config.MagicsBySelfBeforeHit
	end
	if magicsBySelf then
		for i, magicId in ipairs(magicsBySelf) do
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.parent.entityId)
			local buff = MagicConfig.GetBuff(magicId, attackComponent.entity.parent.entityId)
			if magic then
				self.fight.magicManager:DoMagic(magic, level, attackComponent.entity.parent,attackComponent.entity.parent,
				false, magicId,nil,part,attackComponent.entity, nil, attackComponent:GetSkillType())
			elseif buff and attackComponent.entity.parent.buffComponent then
				attackComponent.entity.parent.buffComponent:AddBuff(attackComponent.entity.parent, magicId, level, 
				attackComponent.entity.parent, nil, part, attackComponent:GetSkillType())
			end
		end
	end

	if not beforeHit and attackComponent.config.SoundsByTarget then
		for _, soundEvent in ipairs(attackComponent.config.SoundsByTarget) do
			SoundManager.Instance:PlayObjectSound(soundEvent, self.gameObject)
		end

		local wwisePTRC = attackComponent.config.WwisePTRC
		if wwisePTRC then
			GameWwiseContext.SetRTPCValue(wwisePTRC.paramName, wwisePTRC.value, self.gameObject, wwisePTRC.time)
		end
	end
end

function HitComponent:CanHit(breakLieDown)
	if self.entity.stateComponent then
		if self.entity.stateComponent.backstage == FightEnum.Backstage.Background then
			return false
		end
		if self.stateComponent:IsState(FightEnum.EntityState.Hit) then
			return self.stateComponent.stateFSM.states[FightEnum.EntityState.Hit].hitFSM:CanHit() or breakLieDown
		end
		if self.stateComponent:IsState(FightEnum.EntityState.Death) then
			return false
		end
		local immuneHit = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit)
		local immnueStun = self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneStun) 
		if immuneHit and immnueStun then 
			return false
		end
	end
	return true
end

function HitComponent:CanRotate()
	if self.entity.stateComponent then
		if self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHitRotate) then
			return false
		end
	end
	return true
end

function HitComponent:OnCache()
	TableUtils.ClearTable(self.boneShakeComponet)
	self.fight.objectPool:Cache(HitComponent,self)
end

function HitComponent:__cache()
	self.fight = nil
	self.entity = nil
end

function HitComponent:__delete()
end
