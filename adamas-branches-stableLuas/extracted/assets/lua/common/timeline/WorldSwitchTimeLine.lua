
WorldSwitchTimeLine = SingleClass("WorldSwitchTimeLine")
WorldSwitchTimeLine.New()

function WorldSwitchTimeLine.EnterMap(enterId)
	WorldSwitchTimeLine.Instance:OnEnter(enterId)
end

function WorldSwitchTimeLine:__init()

end

function WorldSwitchTimeLine:OnEnter(enterId)
	self.switchStart = true
	local curMapId = Fight.Instance:GetFightMap()
	self.dataConfig = Config.DataWorldAnimSwitch[curMapId][enterId]
	self.enterSceneId = self.dataConfig.EnterSceneId

	WindowManager.Instance:CloseAllWindow(true)
	PanelManager.Instance:CloseAllPanel(true)

	local parent = Fight.Instance.clientFight.fightRoot.parent
	self.camera = CameraManager.Instance.cameraRoot
	CameraManager.Instance.mainCameraComponent.depth = 100
	self.camera.transform:SetParent(parent)
	GameObject.Destroy(self.camera.transform:Find("CameraCommon(Clone)").gameObject)

	self.timeLine = TimeLine.New()
	local startCallback = function ()
		local pos = self.dataConfig.StartPos
		local rt = self.dataConfig.StartRotate
		local transform = self.timeLine.timeLineObject.transform
		UnityUtils.SetPosition(transform, pos.x, pos.y, pos.z)
		UnityUtils.SetEulerAngles(transform, rt.x, rt.y, rt.z)
	end
	self.timeLine:Play(self.dataConfig.EnterTimeLineId, startCallback, self:ToFunc("_Loading"))
	SceneUnitManager.Instance:SetTargetTransform(Camera.main.transform)
end

function WorldSwitchTimeLine:_Loading()
	mod.WorldMapFacade:SendMsg("map_enter", self.enterSceneId, self.dataConfig.RolePos.x, self.dataConfig.RolePos.y, self.dataConfig.RolePos.z, 0, self.dataConfig.RoleRotateY, 0)
end

function WorldSwitchTimeLine:OnFightStart()
	GameObject.Destroy(self.camera)

	CustomUnityUtils.SetCameraVolumeTrigger(CameraManager.Instance.mainTarget, FightEnum.CameraTriggerLayer)
	GraphicsManagerSingleton.Instance.GraphicMSetting:UpdateGraphicSetting()

	local oldTimeLine = self.timeLine 
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local callBack = function ()
		entity.clientTransformComponent:SetActivity(false)
		GameObject.Destroy(oldTimeLine.timeLineObject)
		SceneUnitManager.Instance:SetTargetTransform(Camera.main.transform)
	end
	self.timer = LuaTimerManager.Instance:AddTimer(1, 2, callBack)

	local startCallback = function ()
		local pos = self.dataConfig.EndPos
		local rt = self.dataConfig.EndRotate
		local transform = self.timeLine.timeLineObject.transform
		UnityUtils.SetPosition(transform, pos.x, pos.y, pos.z)
		UnityUtils.SetEulerAngles(transform, rt.x, rt.y, rt.z)
	end

	self.timeLine = TimeLine.New()
	self.timeLine:Play(self.dataConfig.ExitTimeLineId, startCallback, self:ToFunc("_End"))
end

function WorldSwitchTimeLine:_End()
	self.switchStart = false
	local fight = Fight.Instance
	if self.timer then
		self.timer = nil
    	LuaTimerManager.Instance:RemoveTimer(self.timer)
    	
    	fight.clientFight:ShowUI()
		fight.fightBtnManager:InitPlane()
		local entity = fight.playerManager:GetPlayer():GetCtrlEntityObject()
		entity.clientTransformComponent:SetActivity(true)
    end

	GameObject.Destroy(self.timeLine.timeLineObject)

	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local transform = entity.clientTransformComponent.transform
	entity.rotateComponent:SetEuler(0, self.dataConfig.RoleRotateY, 0)
	entity.rotateComponent:Async()
	
	SceneUnitManager.Instance:SetTargetTransform(transform)
end