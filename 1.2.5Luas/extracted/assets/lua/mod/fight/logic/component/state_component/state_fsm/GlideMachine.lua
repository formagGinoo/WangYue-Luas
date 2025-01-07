GlideMachine = BaseClass("GlideMachine", MachineBase)

function GlideMachine:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.glideFSM = self.fight.objectPool:Get(GlideFSM)
    self.glideFSM:Init(fight, entity)
end

function GlideMachine:OnEnter(ingoreStart)
    self.entity.rotateComponent:SetRotateSpeed(self.entity.moveComponent.config.GlideRotationSpeed)
    local gliderGo = self.entity.clientEntity.clientTransformComponent:BindGlider()
    if ingoreStart then
        self.glideFSM:BindGliderGo(gliderGo)
        self.glideFSM:SwitchState(FightEnum.GlideState.GlideLoop)
        return
    end

    self.glideFSM:StartGlide(gliderGo)
end

function GlideMachine:OnLeave()
    self.glideFSM:Reset()
    self.entity.rotateComponent:SetRotateSpeed()
end

function GlideMachine:Update()
    self.glideFSM:Update()
end

function GlideMachine:CanMove()
    return self.glideFSM:CanMove()
end

function GlideMachine:CanJump()
    return self.glideFSM:CanJump()
end

function GlideMachine:CanCastSkill()
    return self.glideFSM:CanCastSkill()
end

function GlideMachine:CanClimb()
	return self.glideFSM:CanClimb()
end

function GlideMachine:CanPush()
	return self.glideFSM:CanPush()
end

function GlideMachine:CanChangeRole()
    return self.glideFSM:CanChangeRole()
end

function GlideMachine:OnCache()
    if self.glideFSM then
		self.glideFSM:OnCache()
		self.glideFSM = nil
	end
	self.fight.objectPool:Cache(GlideMachine, self)
end

function GlideMachine:__delete()
    if self.glideFSM then
        self.glideFSM:DeleteMe()
        self.glideFSM = nil
    end
end