OpenDoorStartMachine = BaseClass("OpenDoorStartMachine", MachineBase)

function OpenDoorStartMachine:__init()

end

function OpenDoorStartMachine:Init(fight, entity, openDoorFSM)
    self.fight = fight
    self.entity = entity
    self.openDoorFSM = openDoorFSM
end

function OpenDoorStartMachine:OnEnter(callback,bip)
	self.entity.logicMove = false
	self.openDoorFSM:SetCanMove(false)
	self.callback = callback
	self.time = 2.5 
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.GetInCar)
	
	if bip then
		self.entity.clientIkComponent:SetGenericPoser(bip,true,0,1,self.time,Ease.InOutQuart)
	end
end

function OpenDoorStartMachine:Update()
	local timeScale = self.entity.timeComponent:GetTimeScale()
	self.time = (self.time - FightUtil.deltaTimeSecond) * timeScale
	if self.time <= 0 then
		if self.callback then
			self.callback()
			self.callback = nil 
		end
		self.openDoorFSM:SwitchState(FightEnum.OpenDoorState.Driving)
	end
end

function OpenDoorStartMachine:CanMove()
	return self.openDoorFSM.canMove
end

function OpenDoorStartMachine:CanCastSkill()
	return false
end

function OpenDoorStartMachine:CanJump()
	return false
end

function OpenDoorStartMachine:CanPush()
	return false
end

function OpenDoorStartMachine:CanChangeRole()
	return false
end

function OpenDoorStartMachine:CanHit()
	return false
end

function OpenDoorStartMachine:CanStun()
	return false
end

function OpenDoorStartMachine:OnLeave()
	if self.callback then
		self.callback()
		self.callback = nil
	end
end

function OpenDoorStartMachine:OnCache()
	self.fight.objectPool:Cache(OpenDoorStartMachine,self)
end

function OpenDoorStartMachine:__cache()

end

function OpenDoorStartMachine:__delete()

end