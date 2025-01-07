HackStartMachine = BaseClass("HackStartMachine", MachineBase)

function HackStartMachine:__init()

end

function HackStartMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM
end

function HackStartMachine:OnEnter()
	local rotation = self.fight.clientFight.cameraManager:GetCameraRotaion()
	local dir = Quat.CreateByUnityQuat(rotation) * Vec3.forward
	dir = Vec3.ProjectOnPlane(dir, Vec3.up)
	self.entity.rotateComponent:SetRotation(Quat.LookRotation(dir))
	
	local clientTransformComponent = self.entity.clientTransformComponent
	clientTransformComponent:ClearMoveX()
	clientTransformComponent:Async()
	
	self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.HackStart)
	--BehaviorFunctions.SetCameraState(FightEnum.CameraState.Hacking)
	SystemStateMgr.Instance:SetCameraState(SystemStateConfig.StateType.Hack, FightEnum.CameraState.Hacking)
end

function HackStartMachine:Update()
	self.time = self.time - FightUtil.deltaTimeSecond
	
	local moveEvent = self.fight.operationManager:GetMoveEvent()
	if self.time <= 0 or moveEvent then
		self.hackFSM:SwitchState(FightEnum.HackState.Waiting)
	end
end

function HackStartMachine:OnLeave()

end

function HackStartMachine:OnCache()

end

function HackStartMachine:__cache()

end

function HackStartMachine:__delete()

end