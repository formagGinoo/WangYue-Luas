HackInputMachine = BaseClass("HackInputMachine", MachineBase)

function HackInputMachine:__init()

end

function HackInputMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackInputMachine:OnEnter(animationName)
    self.time = self.entity.animatorComponent:PlayAnimation(animationName)
end

function HackInputMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond

    local moveEvent = self.fight.operationManager:GetMoveEvent()
    if self.time <= 0 or moveEvent then
        self.hackFSM:SwitchState(FightEnum.HackState.Waiting)
    end
end

function HackInputMachine:OnLeave()

end

function HackInputMachine:OnCache()

end

function HackInputMachine:__cache()

end

function HackInputMachine:__delete()

end