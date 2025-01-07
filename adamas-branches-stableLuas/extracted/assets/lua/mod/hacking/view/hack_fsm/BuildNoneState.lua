BuildNoneState = BaseClass("BuildNoneState", HackBaseState)

function BuildNoneState:Init(mainView, fight, fsm, state)
	self:BaseFunc("Init", mainView, fight, fsm, state)
end

function BuildNoneState:OnEnter()
	self.fightMainUI = self.mainView.mainView
	BehaviorFunctions.SetCameraState(FightEnum.CameraState.Building)
	local ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	CameraManager.Instance.statesMachine:SetMainTarget(ctrlEntity.clientTransformComponent:GetTransform("CameraTarget"))
	self.hackManager:OpenBuildPanel()
	
	self.mainView:UpdateHackEffect(false)
	self.hackManager:UpdateSelectedId()
	
	BehaviorFunctions.SetBatteryVisible(false)
	UnityUtils.SetActive(self.mainView.Operation, false)
	UnityUtils.SetActive(self.mainView.MessagePanel, false)
end

function BuildNoneState:Update()
	local a = 1

end

function BuildNoneState:OnLeave()
	BehaviorFunctions.SetBatteryVisible(true)
	--UnityUtils.SetActive(self.mainView.Operation, true)
	
	self.hackManager:CloseBuildPanel()
	BehaviorFunctions.SetCameraState(FightEnum.CameraState.Hacking)
end

function BuildNoneState:OnCache()
end

function BuildNoneState:__cache()
	self.fight.objectPool:Cache(BuildNoneState, self)
end

function BuildNoneState:__delete()

end