WaitingHackMachine = BaseClass("WaitingHackMachine", MachineBase)

local MoveType = {
	Stand = "Stand2",
	Run = "Run",
	RunEnd = "RunEnd",	
}

function WaitingHackMachine:__init()

end

function WaitingHackMachine:Init(fight, entity, hackFSM)
    self.fight = fight
    self.entity = entity
    self.hackFSM = hackFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end

function WaitingHackMachine:OnEnter()
    local eulerAngles = self.fight.clientFight.cameraManager:GetCameraRotaion().eulerAngles
    eulerAngles.x = 0
    eulerAngles.z = 0
    self.entity.rotateComponent:SetRotation(Quat.Euler(eulerAngles))
	self.clientTransformComponent:ClearMoveX()
    self.clientTransformComponent:Async()

	self.moveType = MoveType.Stand
    self.entity.animatorComponent:PlayAnimation(self.moveType, 0, 0)
    --if self.moveDir == FightEnum.Direction.None then
        --self.animatorComponent:PlayAnimation(FightEnum.WalkDirAnim[self.moveDir], nil, self.walkLayer)
		--self.animatorComponent:Update()
    --end
    self.entity.logicMove = true

	self.startSpeed = self.entity.transformComponent:GetSpeed()
	self.stepFrame = 0
	self.changeFrame = 0
	
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Hacking)
    self:CameraAimStart(0.6, 1.5, -0.3)
end

function WaitingHackMachine:LateInit()
    self.clientTransformComponent = self.entity.clientEntity.clientTransformComponent
    self.clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent

    if self.clientAnimatorComponent then
        local animator = self.clientAnimatorComponent.animator
        self.aimLayer = animator:GetLayerIndex("AimLayer")
        self.walkLayer = animator:GetLayerIndex("AimWalkLayer")
    end

	if self.entity.attrComponent then
		self.speed = self.entity.attrComponent.attrs[EntityAttrsConfig.AttrType.RunSpeed]
	else
		self.speed = 0
	end

	if self.entity.aimComponent then
		self.aimConfig = self.entity.aimComponent.config
	end
	
end

function WaitingHackMachine:Update()
    if not self.hackFSM.canMove then
        return
    end

    local moveEvent = self.fight.operationManager:GetMoveEvent()
	local moveType = MoveType.Stand
	local speed = 0
    if moveEvent then
		moveType = MoveType.Run
		speed = self.speed
		self.entity.rotateComponent:SetVector(moveEvent.x,moveEvent.y)
    end
	
	if moveType ~= self.moveType then
		self.moveType = moveType
		self.animatorComponent:PlayAnimation(self.moveType)
		self.startSpeed = self.entity.transformComponent:GetSpeed()
		self.changeFrame = self.entity.animatorComponent.fusionFrame
		self.stepFrame = 0
	end
	
	if self.stepFrame < self.changeFrame then
		speed = self.startSpeed + (self.speed - self.startSpeed) * (self.stepFrame / self.changeFrame)
		self.stepFrame = self.stepFrame + 1
	end
	
	self.entity.moveComponent:DoMoveForward(speed * FightUtil.deltaTimeSecond)
end

function WaitingHackMachine:CameraAimStart(ctX, ctY, ctZ)
    if self.targetDotween then
        self.targetDotween:Kill()
        self.targetDotween = nil
    end

    if not self.cameraTargetOrginPos then
        self.cameraTarget = self.clientTransformComponent:GetTransform("CameraTarget")
        self.cameraTargetOrginPos = self.cameraTarget.localPosition
    end

    self.cameraAimStart = true
    --UnityUtils.SetLocalPosition(self.cameraTarget, ctX, ctY, ctZ)
end

function WaitingHackMachine:CameraAimEnd(time)
    if not self.cameraAimStart then
        return
    end

    if self.targetDotween then
        self.targetDotween:Kill()
        self.targetDotween = nil
    end

    self.cameraAimStart = false
    time = time or 0.2
    time = math.min(0.2, time)
    self.targetDotween = self.cameraTarget:DOLocalMove(self.cameraTargetOrginPos, time)
    InputManager.Instance:SetCameraMouseInput(false)
end

function WaitingHackMachine:OnLeave()
    self.entity.logicMove = false

    self:CameraAimEnd(0.2)
    if self.hackFSM.hackingType == FightEnum.HackingType.Camera then

    else
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    end
end

function WaitingHackMachine:OnCache()

end

function WaitingHackMachine:__cache()

end

function WaitingHackMachine:__delete()

end