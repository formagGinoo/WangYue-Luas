GlideLandMachine = BaseClass("GlideLandMachine", MachineBase)

function GlideLandMachine:Init(fight, entity, glideFsm)
    self.fight = fight
    self.entity = entity
    self.glideFSM = glideFsm

    self.duration = 0
    self.passDuration = 0
end

function GlideLandMachine:OnEnter()
    -- 临时
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpLand)
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpLand]
end

function GlideLandMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    self.entity.rotateComponent:DoModelXZRotate(0, 0)
    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function GlideLandMachine:CanMove()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.JumpBreakTime
end

function GlideLandMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.JumpBreakTime
end

function GlideLandMachine:CanLand()
    return false
end

function GlideLandMachine:CanDoubleJump()
    return false
end

function GlideLandMachine:CanProactiveDown()
    return false
end

function GlideLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function GlideLandMachine:OnCache()
    self.fight.objectPool:Cache(GlideLandMachine, self)
end