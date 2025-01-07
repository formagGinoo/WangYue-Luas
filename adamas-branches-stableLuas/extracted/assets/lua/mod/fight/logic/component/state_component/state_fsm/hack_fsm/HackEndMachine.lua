HackEndMachine = BaseClass("HackEndMachine", MachineBase)

function HackEndMachine:__init()

end

function HackEndMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackEndMachine:OnEnter()
	self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.HackEnd)
	--BehaviorFunctions.SetCameraState(BehaviorFunctions.fight.hackManager.oldCameraState)
end

function HackEndMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	
	local moveEvent = self.fight.operationManager:GetMoveEvent()
	if self.time <= 0 or moveEvent then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end
end

function HackEndMachine:OnLeave()
end

function HackEndMachine:OnCache()

end

function HackEndMachine:__cache()

end

function HackEndMachine:__delete()

end