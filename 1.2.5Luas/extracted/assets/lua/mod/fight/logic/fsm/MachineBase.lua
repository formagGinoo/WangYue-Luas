MachineBase = BaseClass("MachineBase",PoolBaseClass)

function MachineBase:__init()
	
end

function MachineBase:Init()

end

function MachineBase:OnEnter()

end

function MachineBase:OnLeave()

end

function MachineBase:Update()

end

function MachineBase:OnCache()

end

function MachineBase:CanCastSkill()
	return true
end

function MachineBase:CanStun()
	return true
end

function MachineBase:CanJump()
	return true
end

function MachineBase:CanClimb()
	return false
end

function MachineBase:CanPush()
	return false
end

function MachineBase:OnSwitchEnd()

end

function MachineBase:__cache()

end

function MachineBase:__delete()

end