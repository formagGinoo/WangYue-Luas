---@class ClientCameraComponent
ClientCameraComponent = BaseClass("ClientCameraComponent",PoolBaseClass)

function ClientCameraComponent:__init()

end

function ClientCameraComponent:Update()

end

function ClientCameraComponent:Init(clientFight,clientEntity,info)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
end

function ClientCameraComponent:LateInit()
	self.cinemachineCamera = self.clientEntity.clientTransformComponent.gameObject:GetComponentInChildren(Cinemachine.CinemachineVirtualCamera)
end

function ClientCameraComponent:SetLockTarget(clientTransformComponent,name)
	if not clientTransformComponent then
		self.cinemachineCamera.m_LookAt = nil
		return
	end
	local target = clientTransformComponent:GetTransform(name)
	self.cinemachineCamera.m_LookAt = target
	CameraManager.Instance:EnableCameraComponentCamera()
end

function ClientCameraComponent:SetFollowTarget(clientTransformComponent,name)
	if not clientTransformComponent then
		self.cinemachineCamera.m_Follow = nil
		return
	end
	local target = clientTransformComponent:GetTransform(name)
	self.cinemachineCamera.m_Follow = target
	CameraManager.Instance:EnableCameraComponentCamera()
end


function ClientCameraComponent:OnCache()
	self.cinemachineCamera.m_LookAt = nil
	self.cinemachineCamera.m_Follow = nil
	self.clientFight.fight.objectPool:Cache(ClientCameraComponent,self)
	CameraManager.Instance:DisableCameraComponent()
end

function ClientCameraComponent:__cache()
	--self.clientFight.assetsPool:Cache(self.path,self.animatorController)
end

function ClientCameraComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end