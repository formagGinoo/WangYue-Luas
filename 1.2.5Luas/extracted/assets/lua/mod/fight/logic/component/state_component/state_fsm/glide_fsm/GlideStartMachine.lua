GlideStartMachine = BaseClass("GlideStartMachine", MachineBase)

function GlideStartMachine:Init(fight, entity, glideFSM)
    self.fight = fight
    self.entity = entity
    self.glideFSM = glideFSM
end

function GlideStartMachine:OnEnter()
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GlideStart)

    local gliderAnimator = self.glideFSM.gliderGo:GetComponentInChildren(Animator)
    gliderAnimator:Play(Config.EntityCommonConfig.AnimatorNames.GlideStart)

    self.duration = 1.8

	self.moveComponent = self.entity.moveComponent
	self.yMoveComponent = self.moveComponent.yMoveComponent
	local paramTable = {
		speedY = -self.moveComponent.config.GlideDownSpeed,
		gravity = 0,
		accelerationY = 0,
		maxFallSpeed = -self.moveComponent.config.GlideDownSpeed,
	}
	self.yMoveComponent:SetConfig(paramTable, true)
end

function GlideStartMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time

    if self.duration <= 0 then
        self.glideFSM:SwitchState(FightEnum.GlideState.GlideLoop)
    end
end

function GlideStartMachine:CanMove()
    return false
end

function GlideStartMachine:CanCastSkill()
    return false
end

function GlideStartMachine:CanLand()
    return true
end

function GlideStartMachine:CanDoubleJump()
    return true
end

function GlideStartMachine:OnLeave()

end

function GlideStartMachine:OnCache()

end