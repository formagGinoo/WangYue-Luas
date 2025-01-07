RunStartLandMachine = BaseClass("RunStartLandMachine", MachineBase)

function RunStartLandMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function RunStartLandMachine:OnEnter()
    local animationNames = Config.EntityCommonConfig.AnimatorNames

    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.RunStartLand]
    self.entity.animatorComponent:PlayAnimation(animationNames.RunStartLand)

    self.checkHardLandHurt = false
end

function RunStartLandMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    -- if self.passDuration > 0.02 and not self.checkHardLandHurt then
    --     self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
    --     self.checkHardLandHurt = true
    --     if self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
    --         return
    --     end
    -- end

    if self.duration <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
        self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StartMove()
    end

    if not self.fight.operationManager:CheckMove() then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
        self.entity.stateComponent.stateFSM.states[FightEnum.EntityState.Move].moveFSM:StopMove()
        return
    elseif self.fight.operationManager:CheckJump() and self.passDuration >= Config.EntityCommonConfig.JumpParam.RunStartLandBreakTime then
        self.jumpFSM:Reset()
        self.jumpFSM:StartJump()
        return
    end

    local moveEvent = self.fight.operationManager:GetMoveEvent()
    if moveEvent then
        self.entity.rotateComponent:SetVector(moveEvent.x,moveEvent.y)
    end
end

function RunStartLandMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0

    -- if not self.checkHardLandHurt then
    --     self.entity.moveComponent.yMoveComponent:OnHardLandHurt()
    --     self.checkHardLandHurt = true
    -- end
end

function RunStartLandMachine:CanLand()
    return false
end

function RunStartLandMachine:CanMove()
    return false
end

function RunStartLandMachine:CanCastSkill()
    return self.passDuration >= Config.EntityCommonConfig.JumpParam.RunStartLandBreakTime
end

function RunStartLandMachine:CanDoubleJump()
    return false
end

function RunStartLandMachine:OnCache()
    self.fight.objectPool:Cache(RunStartLandMachine, self)
end