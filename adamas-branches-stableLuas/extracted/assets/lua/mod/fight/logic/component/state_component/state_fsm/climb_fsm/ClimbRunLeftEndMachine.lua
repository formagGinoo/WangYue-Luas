ClimbRunLeftEndMachine = BaseClass("ClimbRunLeftEndMachine",MachineBase)

function ClimbRunLeftEndMachine:__init()

end

function ClimbRunLeftEndMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbRunLeftEndMachine:OnEnter()
    self.entity.logicMove = false
    self.time = 20 * FightUtil.deltaTimeSecond      -- 动画帧数
    if self.entity.animatorComponent then
        self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRunLeftEnd)
        print("ClimbRunLeftEndMachine")
    end
end

function ClimbRunLeftEndMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(-1, 0, 0)
    if self.time <= 0 then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.Idle)
    end
end

function ClimbRunLeftEndMachine:OnLeave()
    self.entity.logicMove = true
end

function ClimbRunLeftEndMachine:OnCache()
    self.fight.objectPool:Cache(ClimbRunLeftEndMachine,self)
end

function ClimbRunLeftEndMachine:__cache()

end

function ClimbRunLeftEndMachine:__delete()

end