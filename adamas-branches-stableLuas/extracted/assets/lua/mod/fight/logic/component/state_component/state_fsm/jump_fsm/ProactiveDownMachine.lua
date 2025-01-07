ProactiveDownMachine = BaseClass("ProactiveDownMachine", MachineBase)

local AnimatorNames = Config.EntityCommonConfig.AnimatorNames

function ProactiveDownMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM
end

-- 临时的动作
function ProactiveDownMachine:OnEnter()
    self.entity.animatorComponent:PlayAnimation(AnimatorNames.JumpDownLeft)
    self.jumpFSM.yMoveComponent:SetConfig({accelerationY = Config.EntityCommonConfig.JumpParam.ProactiveDownAcceleration})
end

function ProactiveDownMachine:Update()

end

function ProactiveDownMachine:OnLeave()

end

function ProactiveDownMachine:CanLand()
    return true
end

function ProactiveDownMachine:CanMove()
    return false
end

function ProactiveDownMachine:CanCastSkill()
    return false
end

function ProactiveDownMachine:CanDoubleJump()
    return false
end

function ProactiveDownMachine:CanProactiveDown()
    return false
end

function ProactiveDownMachine:OnCache()

end