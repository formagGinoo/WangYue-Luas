JumpLandHardMachine = BaseClass("JumpLandHardMachine", MachineBase)

local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpLandHardMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0

    self.checkHardLandHurt = false
end

function JumpLandHardMachine:OnEnter()
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpLandHard]
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpLandHard)
    self.entity.stateComponent:SetSprintState(false)
    self.checkHardLandHurt = false
end

function JumpLandHardMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.passDuration >= JumpParam.LandHardBreakTime then
        if self.fight.operationManager:CheckMove() then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
            self.entity.stateComponent:SetSprintState(false)
            self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
            return
        elseif self.fight.operationManager:CheckJump() then
            self.jumpFSM:Reset()
            self.jumpFSM:StartJump()
            return
        end
    end

    if self.passDuration > 0.02 and not self.checkHardLandHurt then
        self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
        self.checkHardLandHurt = true
    end

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function JumpLandHardMachine:CanMove()
    return self.passDuration >= JumpParam.LandHardBreakTime
end

function JumpLandHardMachine:CanCastSkill()
    return self.passDuration >= JumpParam.LandHardBreakTime
end

function JumpLandHardMachine:CanLand()
    return false
end

function JumpLandHardMachine:CanDoubleJump()
    return false
end

function JumpLandHardMachine:CanProactiveDown()
    return false
end

function JumpLandHardMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function JumpLandHardMachine:OnCache()
    self.fight.objectPool:Cache(JumpLandHardMachine, self)
end