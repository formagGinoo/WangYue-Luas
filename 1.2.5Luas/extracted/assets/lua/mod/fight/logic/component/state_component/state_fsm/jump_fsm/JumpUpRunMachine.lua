JumpUpRunMachine = BaseClass("JumpUpRunMachine", MachineBase)

local JumpParam = Config.EntityCommonConfig.JumpParam

function JumpUpRunMachine:__init()

end

function JumpUpRunMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM

    self.duration = 0
    self.passDuration = 0
end

function JumpUpRunMachine:LateInit()

end

function JumpUpRunMachine:OnEnter()
	self.entity.logicMove = true
    local animationNames = Config.EntityCommonConfig.AnimatorNames

    self.duration = Config.EntityCommonConfig.AnimatorTimes[FightEnum.EntityJumpState.JumpUpRun]
    BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue, -75)
    self.entity.animatorComponent:PlayAnimation(animationNames.JumpUpRun)
end

function JumpUpRunMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.duration = self.duration - time
    self.passDuration = self.passDuration + time

    if self.duration <= 0 then
        if self.jumpFSM.yMoveComponent:GetSpeed() > 0 then
            -- 预留向上循环接口
        else
            self.jumpFSM:SwitchState(FightEnum.EntityJumpState.JumpDown)
        end
    end
end

function JumpUpRunMachine:CanMove()
    return false
end

function JumpUpRunMachine:CanCastSkill()
    return false
end

function JumpUpRunMachine:CanLand()
    return true
end

function JumpUpRunMachine:CanDoubleJump()
    return true
end

function JumpUpRunMachine:CanProactiveDown()
    return self.passDuration >= JumpParam.ProactiveJumpDownTime
end

function JumpUpRunMachine:CanChangeRole()
    return self.passDuration >= JumpParam.JumpUpChangeRoleTime
end

function JumpUpRunMachine:OnLeave()
    self.duration = 0
    self.passDuration = 0
	self.entity.logicMove = false
end

function JumpUpRunMachine:OnCache()
    self.fight.objectPool:Cache(JumpUpRunMachine, self)
end