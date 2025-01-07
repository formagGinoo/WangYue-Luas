---@class HitComponent
HitComponent = BaseClass("HitComponent",PoolBaseClass)

local _random = math.random

function HitComponent:__init()
	self.boneShakeComponet = {}
end

function HitComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.stateComponent = self.entity.stateComponent
	
	self.forbiddenBoneShake = false
	self.animForbiddenBoneShake = false
end

function HitComponent:LateInit()
	self.tag = self.entity.tagComponent and self.entity.tagComponent.tag or 0
	self.gameObject = self.entity.clientEntity.clientTransformComponent:GetGameObject()
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
				self.entity.rotateComponent:LookAtTarget(attackComponent.entity.owner)
			end
		end
		
		self.fight.entityManager:CallBehaviorFun("BeforeHit",attackComponent.entity.owner.instanceId, self.entity.instanceId,attackConfig.HitType)
		if self.stateComponent then
			if self.stateComponent:IsState(FightEnum.EntityState.Skill) and hitTypeLen > 0 then
				self.entity.skillComponent:Break(attackComponent.entity.owner.instanceId)
			end
			if self.entity.instanceId == Fight.Instance.playerManager:GetPlayer().ctrlId then
				self.entity.timeComponent:RemoveCanBreakPauseFrame()
				self.fight.entityManager:RemoveCanBreakPauseFrame()
				BehaviorFunctions.RemoveBuffByKind(self.entity.instanceId, 1008)
			end
			if attackConfig.HitType > 0 and self.entity.animatorComponent then
				self.stateComponent:SetHitType(attackConfig,attackComponent.entity,headHit)
			end
		end
		
		self.fight.entityManager:CallBehaviorFun("Hit",attackComponent.entity.owner.instanceId, self.entity.instanceId,attackConfig.HitType)
		EventMgr.Instance:Fire(EventName.OnEntityHit, attackComponent.entity.owner.instanceId, self.entity.instanceId,attackConfig.HitType)
			
		if self.entity.clientEntity.clientSoundComponent then
			self.entity.clientEntity.clientSoundComponent:OnEvent(FightEnum.SoundEventType.Hit)
		end
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
	
	local clientTransformComponent = self.entity.clientEntity.clientTransformComponent
	if attackConfig.ShakeId > 0 then
		local rootTransform = clientTransformComponent.transform
		local boneList = clientTransformComponent:GetTransformGroup(attackConfig.BoneGroupShake)
		if boneList then
			for k, bone in pairs(boneList) do
				self:SetBoneShake(rootTransform, bone, attackConfig.ShakeId)
			end
		else
			-- 计算能抖动骨骼最近点
			local pos, rotation = collider:GetPosRotation() --[[collider:GetPosition(), collider:GetRotation()]]
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

	local clientTransformComponent = self.entity.clientEntity.clientTransformComponent
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
		if FightDebugManager.Instance.damagePause then
			Time.timeScale = 0
		end
	end
	local level = attackComponent:GetDefaultAttackLevel()
	
	local magicsByTarget = attackComponent.config.MagicsByTarget
	if beforeHit then
		magicsByTarget = attackComponent.config.MagicsByTargetBeforeHit
	end
	if magicsByTarget then
		for i, magicId in ipairs(magicsByTarget) do
			local ownerInstanceId
			if attackComponent.entity.owner.owner then
				ownerInstanceId = attackComponent.entity.owner.owner.instanceId
			end
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.owner.entityId, nil, ownerInstanceId)
			local buff = MagicConfig.GetBuff(magicId, attackComponent.entity.owner.entityId, nil, ownerInstanceId)
			if magic then
				self.fight.magicManager:DoMagic(magic,level,attackComponent.entity.owner,self.entity,false,magicId,nil,part,attackComponent.entity)
			elseif buff and attackComponent.entity.owner.buffComponent then
				self.entity.buffComponent:AddBuff(attackComponent.entity.owner, magicId, level, attackComponent.entity)
			end
		end
	end
	
	local magicsBySelf = attackComponent.config.MagicsBySelf
	if beforeHit then
		magicsBySelf = attackComponent.config.MagicsBySelfBeforeHit
	end
	if magicsBySelf then
		for i, magicId in ipairs(magicsBySelf) do
			local magic = MagicConfig.GetMagic(magicId, attackComponent.entity.owner.entityId)
			local buff = MagicConfig.GetBuff(magicId, attackComponent.entity.owner.entityId)
			if magic then
				self.fight.magicManager:DoMagic(magic, level, attackComponent.entity.owner,attackComponent.entity.owner,false, magicId)
			elseif buff and attackComponent.entity.owner.buffComponent then
				attackComponent.entity.owner.buffComponent:AddBuff(attackComponent.entity.owner, magicId, level, attackComponent.entity)
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
