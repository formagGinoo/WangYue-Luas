JumpDownMachine = BaseClass("JumpDownMachine", MachineBase)

function JumpDownMachine:__init()

end

function JumpDownMachine:Init(fight, entity, jumpFSM)
    self.fight = fight
    self.entity = entity
    self.jumpFSM = jumpFSM
end

function JumpDownMachine:LateInit()

end

function JumpDownMachine:OnEnter()
    local animatorNames = Config.EntityCommonConfig.AnimatorNames
    self.entity.animatorComponent:PlayAnimation(animatorNames.JumpDown)
    self.entity.moveComponent:DoMoveForward(0.1)--防止一直下落着地
    local kCCCharacterProxy = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxy
	if kCCCharacterProxy then
		kccLand = kCCCharacterProxy:SetFall()
	end
end

function JumpDownMachine:Update()

end

function JumpDownMachine:CanMove()
    return false
end

function JumpDownMachine:CanCastSkill()
    return false
end

function JumpDownMachine:CanLand()
    return true
end

function JumpDownMachine:CanDoubleJump()
    return true
end

function JumpDownMachine:CanProactiveDown()
    return true
end

function JumpDownMachine:OnLeave()

end

function JumpDownMachine:OnCache()
    self.fight.objectPool:Cache(JumpDownMachine, self)
end