CameraBlend = BaseClass("CameraBlend")

function CameraBlend:__init(cameraManager)
	self.cameraManager = cameraManager
	self.blending = false
	self.cameraParent = cameraManager.camera.transform:Find("MixingCamera")
	self.cinemachineMix = CinemachineInterface.GetCinemachineMix(self.cameraParent)
	self.f = 1
end

function CameraBlend:SetBlendInfo(from,to,time)
	Log("from "..from..",to"..to)
	if from == to then
		return
	end
	self.from = from
	self.to = to
	self.blending = true
	self.curPosition = self.cameraManager.mainCamera.transform.position
	self.curEulerAngles = self.cameraManager.mainCamera.transform.rotation.eulerAngles
	self.toMachine = self.cameraManager.states[to]
	self.toMachine:OnEnter()
	--self.toMachine:OnLeave()
	self.fromMachine = self.cameraManager.states[from]
	--self.fromMachine:OnEnter()
	self.fromMachine:OnLeave()
	self.curTime = (1 - self.f) * time
	self.to = to
	self.time = time
end

function CameraBlend:Update()
	local targetPosition = self.toMachine.cinemachineCamera.transform.position
	local targetEulerAngles = self.toMachine.cinemachineCamera.transform.rotation.eulerAngles
	self.curTime = self.curTime + Time.deltaTime
	self.f = self.curTime / self.time
	self.f = self.f > 1 and 1 or self.f
	self.cinemachineMix:SetWeight(self.from - 1,1-self.f)
	self.cinemachineMix:SetWeight(self.to - 1,self.f)
	--local position = Vector3.Lerp(self.curPosition,targetPosition,f)
	--local eulerAngles = Vector3.Lerp(self.curEulerAngles,targetEulerAngles,f)
	--eulerAngles.z = 0
	--local rotation = Quaternion.Euler(eulerAngles)
	--self.toMachine.cinemachineCamera:ForceCameraPosition(position,rotation)
	----self.curPosition = position
	----self.curEulerAngles = eulerAngles
	if self.curTime > self.time then
		--self.cameraManager:SwitchState(self.to)
		self.blending = false
		self.f = 1
	end
end
	
function CameraBlend:__delete()
	
end