OpenDoorEndMachine = BaseClass("OpenDoorEndMachine", MachineBase)

function OpenDoorEndMachine:__init()

end

function OpenDoorEndMachine:Init(fight, entity, openDoorFSM)
    self.fight = fight
    self.entity = entity
    self.openDoorFSM = openDoorFSM
end

function OpenDoorEndMachine:OnEnter(callback,bip)
    self.callback = callback
    self.time = 2.5
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GetOffCar)
    self.openDoorFSM:SetCanMove(false)
    
	if bip then
		self.entity.clientIkComponent:SetGenericPoser(bip,true,1,0,self.time,Ease.OutQuint)
	end
end

function OpenDoorEndMachine:Update()
    local timeScale = self.entity.timeComponent:GetTimeScale()
    self.time = (self.time - FightUtil.deltaTimeSecond) * timeScale

    --local moveEvent = self.fight.operationManager:GetMoveEvent()
    if self.time <= 0 then
        if self.callback then
            self.callback()
            self.callback = nil
        end
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function OpenDoorEndMachine:OnLeave()
    if self.callback then
        self.callback()
        self.callback = nil
    end
end

function OpenDoorEndMachine:CanMove()
    return self.openDoorFSM.canMove
end

function OpenDoorEndMachine:OnCache()
    self.fight.objectPool:Cache(OpenDoorEndMachine,self)
end

function OpenDoorEndMachine:__cache()

end

function OpenDoorEndMachine:__delete()

end