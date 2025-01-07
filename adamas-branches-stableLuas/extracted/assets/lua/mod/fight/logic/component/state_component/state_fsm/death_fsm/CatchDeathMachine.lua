CatchDeathMachine = BaseClass("CatchDeathMachine", MachineBase)

function CatchDeathMachine:__init()

end

function CatchDeathMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
	self.deathFSM = deathFSM
	self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).DyingTime
end

function CatchDeathMachine:OnEnter()
	self.remainChangeTime = self.changeTime
    -- TODO 还有特效
    print("进入了捕捉动画播放逻辑，暂时没有动作")
    --if self.entity.animatorComponent then
		--self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Drowning)
	--end

	self.isUpdate = false
	self.effectInsId = nil
	-- 第一步，播放捕捉开始的特效
	local bone = self.entity.clientTransformComponent:GetTransform()
	local position = bone.position
	self.entityPos = position
	self.effectInsId = BehaviorFunctions.CreateEntity(1000000025, nil, position.x, position.y + 1, position.z)

	-- 开始执行交互
	EventMgr.Instance:Fire(EventName.EntityHit, self.entity.instanceId, true)
end

function CatchDeathMachine:Update()
	if not self.isUpdate then return end
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTime / 10000 * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 then
		self.fight.partnerManager:CheckShowTipQueue()
		self.fight.entityManager:CallBehaviorFun("ConcludePartnerSuc", self.entity.instanceId)
		Fight.Instance.entityManager:RemoveEntity(self.entity.instanceId,true)

		if self.effectInsId then
			BehaviorFunctions.RemoveEntity(self.effectInsId)
			self.effectInsId = nil
		end
	end
end

function CatchDeathMachine:CatchEffect(isSuc)
	self.isUpdate = true
	if self.effectInsId then
		local entity = BehaviorFunctions.GetEntity(self.effectInsId)
		if entity then
			BehaviorFunctions.RemoveEntity(self.effectInsId)
		end
		self.effectInsId = nil
	end
	local entityId = isSuc and 1000000026 or 1000000027
	self.effectInsId = BehaviorFunctions.CreateEntity(entityId, nil, self.entityPos.x, self.entityPos.y + 1, self.entityPos.z)

	local entity = 	BehaviorFunctions.GetEntity(self.effectInsId)
	local timeOutComp = entity.timeoutDeathComponent
	if not timeOutComp then
		self.remainChangeTime = 20 * FightUtil.deltaTimeSecond
		return
	end

	local delayTime = timeOutComp.remainingFrame + timeOutComp.removeDelayFrame
	delayTime = delayTime * FightUtil.deltaTimeSecond
	self.remainChangeTime = delayTime
end

function CatchDeathMachine:OnLeave()

end

function CatchDeathMachine:CanHit()
	return false
end

function CatchDeathMachine:CanMove()
	return false
end

function CatchDeathMachine:CanCastSkill()
	return false
end
 
function CatchDeathMachine:CanJump()
	return false
end

function CatchDeathMachine:OnCache()
	self.fight.objectPool:Cache(CatchDeathMachine,self)
end

function CatchDeathMachine:__cache()

end

function CatchDeathMachine:__delete()

end