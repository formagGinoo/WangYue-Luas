ClimbRunRightMachine = BaseClass("ClimbRunRightMachine",MachineBase)

function ClimbRunRightMachine:__init()

end

function ClimbRunRightMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunRightMachine:OnEnter()
    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunRight)
    end
end

function ClimbRunRightMachine:Update()
    local speed = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ClimbRunSpeed)
    self.entity.climbComponent:SetForceCheckDirection(1, 0, 0)
    self.entity.climbComponent:DoMoveRight(speed * FightUtil.deltaTimeSecond)
end

function ClimbRunRightMachine:OnLeave()
end

function ClimbRunRightMachine:CanChangeRole()
    return true
end

function ClimbRunRightMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunRightMachine,self)
end

function ClimbRunRightMachine:__cache()

end

function ClimbRunRightMachine:__delete()

end