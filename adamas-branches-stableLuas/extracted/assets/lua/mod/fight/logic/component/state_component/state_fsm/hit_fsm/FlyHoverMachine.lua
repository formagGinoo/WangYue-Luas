FlyHoverMachine = BaseClass("FlyHoverMachine",MachineBase)

function FlyHoverMachine:__init()

end

function FlyHoverMachine:Init(fight,entity,hitFSM)
	self.fight = fight
	self.entity = entity
	self.hitFSM = hitFSM
	self.hitTime = hitFSM.hitTime
	self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitFlyHover]
end

function FlyHoverMachine:OnEnter()
	self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitFlyHover].Time
	self.entity.animatorComponent:PlayAnimation(self.hitName)

	local pivot = 0
	local animY = 0
	local moveComponent = self.entity.moveComponent
	local animatorComponent = self.entity.animatorComponent
	if animatorComponent and moveComponent and moveComponent.config.MoveType == FightEnum.MoveType.AnimatorMoveData then
		pivot = moveComponent.config.pivot
		local layer = self.entity.animatorComponent.animatorLayer
		if moveComponent.moveComponent.animationPivotYs and animatorComponent.lastAnimationName and moveComponent.moveComponent.animationPivotYs[layer][animatorComponent.lastAnimationName] then
			local lastCfg = moveComponent.moveComponent.animationPivotYs[layer][animatorComponent.lastAnimationName]
			pivot = lastCfg[#lastCfg]
		end

		if moveComponent.moveComponent.animationPositionYs then
			local layer = self.entity.animatorComponent.animatorLayer
			local config = moveComponent.moveComponent.animationPositionYs[layer]["HitFlyHover"]
			if config then
				animY = config[1]
			else
				animY = 0
				LogError("找不到PositionY 配置 "..self.entity.entityId)
			end
			
		end
	end

	self.entity.clientTransformComponent:DoAnimationYFusion(pivot - animY, 0.1)
end

function FlyHoverMachine:Update()
	local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
	self.remainChangeTime = self.remainChangeTime - time
	--if self.hitFSM.speedY > 0 then
		--self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyUpLoop)
	--else
		--self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFallLoop)
	--end
	if self.entity.moveComponent and not self.entity.moveComponent.isAloft then
		self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyLand)
	elseif self.remainChangeTime <= 0 then
		-- self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFallLoop)
		-- self.hitFSM:SwitchState(FightEnum.EntityHitState.HitFlyFall)
	end
end

function FlyHoverMachine:OnLeave()
	-- self.entity.clientTransformComponent:DoAnimationYFusion()
end

function FlyHoverMachine:CanMove()
	return false
end

function FlyHoverMachine:CanHit()
	return true
end

function FlyHoverMachine:CanCastSkill()
	return false
end

function FlyHoverMachine:CanChangeRole()
	return false
end

function FlyHoverMachine:OnCache()
	self.fight.objectPool:Cache(FlyHoverMachine,self)
end

function FlyHoverMachine:__cache()

end

function FlyHoverMachine:__delete()

end