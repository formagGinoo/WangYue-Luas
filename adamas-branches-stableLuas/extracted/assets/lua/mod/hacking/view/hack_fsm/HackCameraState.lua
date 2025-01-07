HackCameraState = BaseClass("HackCameraState", HackBaseState)

function HackCameraState:__init()

end

function HackCameraState:Init(mainView, fight, fsm)
	self:BaseFunc("Init", mainView, fight, fsm)
	
	self.locationPoint = "HackPoint"
	self.hackingSelectedRange = 0.1 + 0.0001
end

function HackCameraState:OnEnter(id)
	self.instanceId = id

	BehaviorFunctions.SetFightPanelVisible("100000000")
	UnityUtils.SetActive(self.mainView.CameraMode, true)
	UnityUtils.SetActive(self.mainView.DragBg, false)
	UnityUtils.SetActive(self.mainView.HackMainWindow_CameraMode_Exit, false)
	UnityUtils.SetActive(self.mainView.HackMainWindow_CameraMode_Open, true)
	UnityUtils.SetActive(self.mainView.SelectedPoint, true)
	
	self.mainView.DragBg_img.raycastTarget = true
	
	local hackComponent = self.hackManager:GetHackComponent(id)
	local cameraConfig = hackComponent.inputHandle.cameraCfg
	
	self.hackingDistance = cameraConfig and cameraConfig.hack_radius or
	 BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
end

function HackCameraState:Update()
	self.mainView:UpdateSelectedTarget(self.hackingSelectedRange, self.hackingDistance, self.locationPoint)
end

function HackCameraState:OnLeave()
	local hackComponent = self.hackManager:GetHackComponent(self.instanceId)
	if hackComponent then
		hackComponent:StopHacking()
	end
	
	self.instanceId = nil
	self.hackManager:SetHackingId()
	
	BehaviorFunctions.SetFightPanelVisible("100010000")
	UnityUtils.SetActive(self.mainView.HackMainWindow_CameraMode_Open, false)
	UnityUtils.SetActive(self.mainView.HackMainWindow_CameraMode_Exit, true)
	UnityUtils.SetActive(self.mainView.SelectedPoint, false)
	
	self.mainView.DragBg_img.raycastTarget = false

	UnityUtils.SetActive(self.mainView.DragBg, true)
end

function HackCameraState:CloseToNone()
	return true
end

function HackCameraState:OnSwitchEnd()
end

function HackCameraState:OnCache()
end

function HackCameraState:__cache()
	self.fight.objectPool:Cache(HackCameraState, self)
end

function HackCameraState:__delete()

end