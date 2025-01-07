GlideLandRollMachine = BaseClass("GlideLandRollMachine", MachineBase)

function GlideLandRollMachine:Init(fight, entity, glideFsm)
    self.fight = fight
    self.entity = entity
    self.glideFsm = glideFsm

    self.duration = 0
    self.passDuration = 0
end

function GlideLandRollMachine:OnEnter()
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpLandRoll]
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpLandRoll)

	local moveVector = self.fight.operationManager:GetMoveEvent()
	local rotate = Quat.LookRotationA(moveVector.x,0,moveVector.y)
	self.entity.rotateComponent:SetRotation(rotate)
end

function GlideLandRollMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime then
        if self.fight.operationManager:CheckMove() then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
            self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
            return
        end
    end

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function GlideLandRollMachine:CanMove()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime
end

function GlideLandRollMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.LandRollBreakTime
end

function GlideLandRollMachine:CanLand()
    return false
end

function GlideLandRollMachine:CanDoubleJump()
    return false
end

function GlideLandRollMachine:CanProactiveDown()
    return false
end

function GlideLandRollMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function GlideLandRollMachine:OnCache()
    self.fight.objectPool:Cache(GlideLandRollMachine, self)
end