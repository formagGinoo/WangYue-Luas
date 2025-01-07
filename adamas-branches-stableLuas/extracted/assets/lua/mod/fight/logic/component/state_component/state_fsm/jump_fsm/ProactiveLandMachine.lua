ProactiveLandMachine = BaseClass("ProactiveLandMachine", MachineBase)

local AnimatorTimes = Config.EntityCommonConfig.AnimatorTimes
local AnimatorNames = Config.EntityCommonConfig.AnimatorNames

function ProactiveLandMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function ProactiveLandMachine:OnEnter()
    self.duration = AnimatorTimes[FightEnum.EntityJumpState.JumpLandHard]
    self.entity.stateComponent:SetSprintState(false)
    self.entity.animatorComponent:PlayAnimation(AnimatorNames.JumpLandHard)
end

function ProactiveLandMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function ProactiveLandMachine:CanMove()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.ProactiveLandBreakTime
end

function ProactiveLandMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.ProactiveLandBreakTime
end

function ProactiveLandMachine:CanLand()
    return false
end

function ProactiveLandMachine:CanDoubleJump()
    return false
end

function ProactiveLandMachine:CanProactiveDown()
    return false
end

function ProactiveLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function ProactiveLandMachine:OnCache()
    self.fight.objectPool:Cache(ProactiveLandMachine, self)
end