JumpLandMachine = BaseClass("JumpLandMachine", MachineBase)

function JumpLandMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function JumpLandMachine:OnEnter()
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpLand]
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpLand)
    self.entity.stateComponent:SetSprintState(false)
end

function JumpLandMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.passDuration >= Config.EntityCommonConfig.JumpParam.JumpBreakTime then
        if self.fight.operationManager:CheckMove() and (not self.entity.handleMoveInputComponent or self.entity.handleMoveInputComponent.enabled) then
            self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
            self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
            return
        elseif self.fight.operationManager:CheckJump() then
            self.jumpFSM:Reset()
            self.jumpFSM:StartJump()
            return
        end
    end
    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function JumpLandMachine:CanMove()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.JumpBreakTime
end

function JumpLandMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.JumpBreakTime
end

function JumpLandMachine:CanLand()
    return false
end

function JumpLandMachine:CanDoubleJump()
    return false
end

function JumpLandMachine:CanProactiveDown()
    return false
end

function JumpLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function JumpLandMachine:OnCache()
    self.fight.objectPool:Cache(JumpLandMachine, self)
end