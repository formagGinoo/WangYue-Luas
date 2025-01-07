JumpUpMachine = BaseClass("JumpUpMachine", MachineBase)

local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpUpMachine:__init()

end

function JumpUpMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function JumpUpMachine:LateInit()

end

function JumpUpMachine:OnEnter()
    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpUp]
    local value = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.JumpCost)
    BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, value)
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.JumpUp)
end

function JumpUpMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.jumpFSM.isStandJump and self.fight.operationManager:CheckMove() then
        local moveEvent = self.fight.operationManager:GetMoveEvent()
        local rotate = Quat.LookRotationA(moveEvent.x, 0, moveEvent.y)
        self.entity.rotateComponent:SetRotation(rotate)
        self.jumpFSM.speedZ = JumpParam.StandJumpPlaneSpeed
    end

    if self.duration <= 0 then
        if self.jumpFSM.yMoveComponent:GetSpeed() > 0 then
            -- 预留向上循环接口
        else
            self.jumpFSM:SwitchState(FightEnum.EntityJumpState.JumpDown)
        end
    end
end

function JumpUpMachine:CanMove()
    return false
end

function JumpUpMachine:CanCastSkill()
    return false
end

function JumpUpMachine:CanLand()
    return true
end

function JumpUpMachine:CanDoubleJump()
    return true
end

function JumpUpMachine:CanProactiveDown()
    return self.passDuration >= JumpParam.ProactiveJumpDownTime
end

function JumpUpMachine:CanChangeRole()
    return self.passDuration >= JumpParam.JumpUpChangeRoleTime
end

function JumpUpMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
end

function JumpUpMachine:OnCache()
    self.fight.objectPool:Cache(JumpUpMachine, self)
end