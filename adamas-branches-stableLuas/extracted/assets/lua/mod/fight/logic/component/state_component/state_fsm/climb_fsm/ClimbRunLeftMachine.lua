ClimbRunLeftMachine = BaseClass("ClimbRunLeftMachine",MachineBase)

function ClimbRunLeftMachine:__init()

end

function ClimbRunLeftMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunLeftMachine:OnEnter()
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunLeft)
    end
end

function ClimbRunLeftMachine:Update()
    local speed = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ClimbRunSpeed)
    self.entity.climbComponent:SetForceCheckDirection(-1, 0, 0)
    self.entity.climbComponent:DoMoveLeft(speed * FightUtil.deltaTimeSecond)
end

function ClimbRunLeftMachine:OnLeave()
end

function ClimbRunLeftMachine:CanChangeRole()
    return true
end

function ClimbRunLeftMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunLeftMachine,self)
end

function ClimbRunLeftMachine:__cache()

end

function ClimbRunLeftMachine:__delete()

end