HackMainWindow = BaseClass("HackMainWindow",BasePanel)

local ModeToSwitch = {
	[HackingConfig.Mode.Hack] = "HackModeBtn",	
	[HackingConfig.Mode.Build] = "BuildModeBtn",	
}

local ScreenW = Screen.width * 0.5
local ScreenH = Screen.height * 0.5

function HackMainWindow:__init(mainView)
	self:SetAsset("Prefabs/UI/Hacking/HackMainWindow.prefab")
	
	self.mode = nil
	self.loadDone = false
	self.inputManager = Fight.Instance.clientFight.inputManager
	
	self.operateButton = {}
	
	self.mainView = mainView
end

function HackMainWindow:__delete()
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
	EventMgr.Instance:RemoveListener(EventName.ExitHackingMode, self:ToFunc("OnSwitchHackMode"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityDeath, self:ToFunc("OnEntityDeath"))
end

function HackMainWindow:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function HackMainWindow:__BindListener()
	--Event
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:AddListener(EventName.ExitHackingMode, self:ToFunc("OnSwitchHackMode"))
	--骇入的建造物消失
	EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
	EventMgr.Instance:AddListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.OnEntityDeath, self:ToFunc("OnEntityDeath"))

	--Button
	self.BackBtn_btn.onClick:AddListener(self:ToFunc("OnBack"))
	self.BuildModeBtn_btn.onClick:AddListener(self:ToFunc("OnSwitchBuildMode"))
	self.HackModeBtn_btn.onClick:AddListener(self:ToFunc("OnSwitchHackMode"))
	
	--Drag
	self.DragBg:SetActive(false)
	--local bgdragBehaviour = self.DragBg:GetComponent(UIDragBehaviour) or self.DragBg:AddComponent(UIDragBehaviour)
	
	--local onbgBeginDrag = function(data)
		--self:BGBeginDrag(data)
	--end
	--bgdragBehaviour.onBeginDrag = onbgBeginDrag
	--local cbbgOnDrag = function(data)
		--self:BGDrag(data)
	--end
	--bgdragBehaviour.onDrag = cbbgOnDrag

	--local cbbgOnEndDrag = function(data)
		--self:BGEndDrag(data)
	--end
	--bgdragBehaviour.onEndDrag = cbbgOnEndDrag

	--local onbgDown = function(data)
		--self:BGDown(data)
	--end
	--bgdragBehaviour.onPointerDown = onbgDown
	--local onbgUp = function(data)
		--self:BGUp(data)
	--end
	--bgdragBehaviour.onPointerUp = onbgUp
end

function HackMainWindow:__Create()
	--self.joyStickPanel = self:OpenPanel(FightJoyStickPanel)
	
	TableUtils.ClearTable(self.operateButton)
	for i = 1, 4 do
		self.operateButton[i] = {}
		
		local btn = self["HackOperationBtn"..i]
		self.operateButton[i].gameObject = btn
		self.operateButton[i].transform = btn.transform
		UtilsUI.GetContainerObject(btn.transform, self.operateButton[i])
		
		--local btn = self.operateButton[i].ActionBtn_btn
		--local clickFunc = function()
			--self:OnClickOperateBtn(i)
		--end
		
		--btn.onClick:RemoveAllListeners()
		--btn.onClick:AddListener(clickFunc)
		local btnGb = self.operateButton[i].ActionBtn
		local behavior = btnGb:GetComponent(UIDragBehaviour) or btnGb:AddComponent(UIDragBehaviour)
		
		local onDown = function(data)
			self:OnClickOperateBtn(i, true)
		end
		behavior.onPointerDown = onDown
		local onUp = function(data)
			self:OnClickOperateBtn(i, false)
		end
		behavior.onPointerUp = onUp
	end

	UnityUtils.SetActive(self.Aim, false)
	UnityUtils.SetActive(self.MessagePanel, false)
	UnityUtils.SetActive(self.Talk, false)
end

function HackMainWindow:__Show(args)
	local mode = args and args.mode or HackingConfig.Mode.Hack
	self:UpdateModeSetting(mode)
	self.loadDone = true
end

function HackMainWindow:__ShowComplete()
	EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function HackMainWindow:__Hide()
	EventMgr.Instance:Fire(EventName.ShowCursor, false)
	self.mode = nil
end

function HackMainWindow:AddLoadDoneCount()
	--self:UpdatePlayer()
	self.loadDone = true
	
	--因为加载过 一次joystick，整个流程一帧内处理完，还没赋值给joyStickPanel
	--self.panelList["FightJoyStickPanel"]:UpdatePlayer()
end

function HackMainWindow:UpdatePlayer()
	if not self.loadDone then
		return 
	end
	--self.joyStickPanel:UpdatePlayer()
end

function HackMainWindow:Update()
	if not self.loadDone then
		return 
	end
	--self.joyStickPanel:Update()
	
	if self.mode == HackingConfig.Mode.Hack or (self.mode == HackingConfig.Mode.Hacking and self.hackingType == FightEnum.HackingType.Camera) then
		local entityChange, locationTransform = self:UpdateHackingTarget()
		if entityChange then
			self:UpdateHackingMessagePanel()
		end
		self:UpdateHackingSelectedPoint(locationTransform)
	end
end

local SelectedAlpha = 1
local UnselectedAlpha = 0.5
function HackMainWindow:UpdateModeSetting(mode, config)
	if mode == self.mode and self.hackingType ~= FightEnum.HackingType.Camera then
		return
	end
	
	local hackingType = config and config.HackingType
	self:ClearModeDataBeforeSwitch(mode, hackingType)
	self.mode = mode
	self.hackingType = hackingType

	--更新模式面板
	local uiName = ModeToSwitch[mode]
	if uiName then
		UnityUtils.SetActive(self.Selected, true)
		
		local anchoredPosition = self[uiName.."_rect"].anchoredPosition
		UnityUtils.SetAnchoredPosition(self.Selected.transform, anchoredPosition.x, anchoredPosition.y)
		
		self[uiName.."_canvas"].alpha = SelectedAlpha
		for k, v in pairs(ModeToSwitch) do
			if k ~= mode then
				self[v.."_canvas"].alpha = UnselectedAlpha
			end
		end
	end

	--更新操作面板
	--骇入模式下,允许自定义操作面板
	local iconConfigs
	if config and config.UseSelfIcon then
		iconConfigs = {}
		if config.UpButton and config.UpButton ~= "" then
			iconConfigs[1] = {config.UpButton, "ClickUp"}
		end
		if config.RightButton and config.RightButton ~= "" then
			iconConfigs[2] = {config.RightButton, "ClickRight"}
		end
		if config.DownButton and config.DownButton ~= "" then
			iconConfigs[3] = {config.DownButton, "ClickDown"}
		end
		if config.LeftButton and config.LeftButton ~= "" then
			iconConfigs[4] = {config.LeftButton, "ClickLeft"}
		end
	else
		iconConfigs = HackingConfig.GetOperateIcon(mode, self.hackingType)
	end

	if hackingType ~= FightEnum.HackingType.Camera then
		self:UpdateOperateButton(iconConfigs)
	else
		
	end

	self:InitModeDataAfterSwitch()
	
	local showAim = mode == HackingConfig.Mode.Hack or (mode == HackingConfig.Mode.Hacking and hackingType == FightEnum.HackingType.Npc)
	UnityUtils.SetActive(self.Aim, showAim)

	UnityUtils.SetActive(self.CameraMode, mode == HackingConfig.Mode.Hacking and self.hackingType == FightEnum.HackingType.Camera)
end

function HackMainWindow:UpdateOperateButton(iconConfigs)
	if not iconConfigs then
		UnityUtils.SetActive(self.Operation, false)
		return
	end
	UnityUtils.SetActive(self.Operation, true)
	
	for i = 1, 4 do
		local btnNode = self.operateButton[i]
		local iconConfig = iconConfigs[i]
		local sIconPath, uIconPath
		
		btnNode.invokeFunc = nil
		if iconConfig then
			sIconPath, uIconPath = HackingConfig.GetIconAssetsPath(iconConfig[1])
			btnNode.invokeFunc = iconConfig[2]
		end
		
		self:SetSingleOperateButton(btnNode, iconConfig == nil, sIconPath, uIconPath)
	end
end

function HackMainWindow:SetSingleOperateButton(btnNode, empty, sIconPath, uIconPath, text)
	UnityUtils.SetActive(btnNode.Selected, false)
	UnityUtils.SetActive(btnNode.Unselected, not empty)
	UnityUtils.SetActive(btnNode.ActionBtn, not empty)
	UnityUtils.SetActive(btnNode.Empty, empty)
	
	if not empty and sIconPath and uIconPath then
		SingleIconLoader.Load(btnNode.SelectedIcon, sIconPath)
		SingleIconLoader.Load(btnNode.UnselectedIcon, uIconPath)
	end
	
	if not empty and text then
		UnityUtils.SetActive(btnNode.NameText, true)
		btnNode.NameText_txt.text = text
	else
		UnityUtils.SetActive(btnNode.NameText, false)
	end
end

--状态切换前的清理(这些都能以重写方式来处理)
function HackMainWindow:ClearModeDataBeforeSwitch(newMode, newHackingType)
	if not newMode or newMode == HackingConfig.Mode.Build or
		(newMode == HackingConfig.Mode.Hacking and newHackingType ~= FightEnum.HackingType.Npc) then
		self:UpdateHackEffect(false)
	end
	
	if self.mode == HackingConfig.Mode.Hack then
		if newMode == HackingConfig.Mode.Build then
			self.curSelectedEntity = nil
			self.locationTransform = nil
		end
		
		UnityUtils.SetActive(self.Aim, false)
		UnityUtils.SetActive(self.SelectedPoint, false)
		UnityUtils.SetActive(self.MessagePanel, false)
		
	elseif self.mode == HackingConfig.Mode.Hacking then
		if self.hackingType ~= FightEnum.HackingType.Camera then
			self.hackingComponent = nil
		end
		self.curSelectedEntity = nil
		self.locationTransform = nil
		self.hackingType = nil
		
		self.BuildModeBtn_btn.enabled = true
		self.HackModeBtn_btn.enabled = true
		UnityUtils.SetActive(self.MessagePanel, false)
		UnityUtils.SetActive(self.Talk, false)
		UnityUtils.SetActive(self.ModeSwitch, true)
	end
end

--状态切换后的初始化
function HackMainWindow:InitModeDataAfterSwitch(newMode)
	if self.mode == HackingConfig.Mode.Hack then
		UnityUtils.SetActive(self.Aim, true)
		self:UpdateHackEffect(true)

	elseif self.mode == HackingConfig.Mode.Hacking then
		
		if self.hackingType == FightEnum.HackingType.Npc then
			UnityUtils.SetActive(self.MessagePanel, true)
			UnityUtils.SetActive(self.Talk, true)
			self.BuildModeBtn_btn.enabled = false
			self.HackModeBtn_btn.enabled = false
		else
			UnityUtils.SetActive(self.ModeSwitch, false)
		end
	end
end

local NpcHackEffect = 1000076
local BoxCanHackEffect = 1000077
local BoxReadyHackEffect = 1000078
function HackMainWindow:UpdateEffect(entity, add)
	if not entity or not entity.buffComponent then
		return
	end

	local hackingType = entity.hackingInputHandleComponent.config.HackingType
	local hackEffect = hackingType == FightEnum.HackingType.Npc and NpcHackEffect or BoxCanHackEffect
	if self.curSelectedEntity and entity.instanceId == self.curSelectedEntity.instanceId
		and hackingType ~= FightEnum.HackingType.Npc then
		hackEffect = BoxReadyHackEffect
	end

	BehaviorFunctions.RemoveBuffByKind(entity.instanceId, 1010)
	if add then
		BehaviorFunctions.DoMagic(1,entity.instanceId,hackEffect)
	else
		BehaviorFunctions.RemoveBuff(entity.instanceId,hackEffect)
	end
end

function HackMainWindow:UpdateHackEffect(enter)
	local list = HackingConfig.GetHackingTargetList()
	if enter and not self.hasEffect then
		BehaviorFunctions.DoMagic(1,1,1000075)
		for _, v in pairs(list) do
			self:UpdateEffect(v, true)
		end
	elseif not enter and self.hasEffect then
		BehaviorFunctions.RemoveBuff(1,1000075)
		for _, v in pairs(list) do
			self:UpdateEffect(v, false)
		end
	end
	self.hasEffect = enter
end

function HackMainWindow:UpdateSelectedEntity(entity)
	local lastSelected = self.curSelectedEntity
	self:UpdateEffect(self.curSelectedEntity, false)
	self:UpdateEffect(entity, false)
	
	self.curSelectedEntity = entity
	
	self:UpdateEffect(lastSelected, true)
	self:UpdateEffect(entity, true)
end

--按钮
function HackMainWindow:OnBack()
	if self.mode == HackingConfig.Mode.Hacking then
		self:OnSwitchHackMode()
	else
		self:ClearModeDataBeforeSwitch()
		BehaviorFunctions.ExitHackingMode()
		--WindowManager.Instance:CloseWindow(HackMainWindow)
	end
end

function HackMainWindow:OnSwitchBuildMode()
	if self.mode == HackingConfig.Mode.Hacking then
		return 
	end
	self.mainView.buildPanel = self.mainView:OpenPanel(BuildPreviewPanel)
	self:UpdateModeSetting(HackingConfig.Mode.Build)
end

function HackMainWindow:OnSwitchHackMode()
	if self.hackingComponent then
		self.hackingComponent:StopHacking()
	end

	if self.mode == HackingConfig.Mode.Build then
		self.mainView:ClosePanel(self.mainView.buildPanel)
		self.mainView.buildPanel = nil
	end

	self:UpdateModeSetting(HackingConfig.Mode.Hack)
end

function HackMainWindow:OnSwitchHackingMode()
	self.hackingComponent:Hacking()
	
	local config = self.hackingComponent:GetConfig()
	self:UpdateModeSetting(HackingConfig.Mode.Hacking, config)
end

function HackMainWindow:OnClickOperateBtn(idx, down)
	if self.mode == HackingConfig.Mode.Hack then
		local func = self.operateButton[idx].invokeFunc
		if not down and func then
			self[func](self)
		end
		return
	end
	
	if self.mode == HackingConfig.Mode.Hacking then
		if not self.hackingComponent then
			return 
		end

		if self.hackingType == FightEnum.HackingType.Camera then
			local func = self.operateButton[idx].invokeFunc
			if not down and func then
				self[func](self)
			end
			return
		end
		
		local func = self.operateButton[idx].invokeFunc
		if func then
			self.hackingComponent[func](self.hackingComponent, down)
		end
	end
end

--事件
function HackMainWindow:BGBeginDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
end

function HackMainWindow:BGDrag(data)
	FightMainUIView.bgInput.x = data.delta.x
	FightMainUIView.bgInput.y = data.delta.y
	--Log("x = "..data.delta.x)
	--Log("y = "..data.delta.y)
	self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenMove)
end

function HackMainWindow:BGEndDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
	self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenMove)
	--Log("KeyUp ScreenPress")

	--if self.mode == HackingConfig.Mode.Hack then
		--BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Hacking]:SetLookAtTarget(self.locationTransform)
		----self.transformComponent:SetRotation(Quat.RotateTowards(self.transformComponent.rotation, self.lookAtRotate, rotateSpeed))
	--end
end

function HackMainWindow:BGDown()
	self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
	--Log("KeyDown ScreenPress")
end

function HackMainWindow:BGUp()
	self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
	--Log("KeyUp ScreenPress")
end

--骇入前
local LocationPoint = "HackPoint"
local HackingSelectedRange = 0.1 + 0.0001
function HackMainWindow:UpdateHackingTarget()
	local HackingDistance = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
	local nearestEntity, locationTransform = HackingConfig.GetNearestHackingTarget(HackingSelectedRange, HackingDistance, LocationPoint)
	if self.curSelectedEntity == nearestEntity then
		return false, locationTransform
	end
	
	self:UpdateSelectedEntity(nearestEntity)
	UnityUtils.SetActive(self.SelectedPoint, nearestEntity ~= nil)
	
	return true, locationTransform
end

function HackMainWindow:StartHacking()
	if not self.curSelectedEntity then
		return 
	end
	
	if self.hackingType == FightEnum.HackingType.Camera then
		self.hackingComponent:StopHacking()
	end
	
	self.hackingComponent = self.curSelectedEntity.hackingInputHandleComponent
	self:OnSwitchHackingMode()
end

function HackMainWindow:UpdateHackingSelectedPoint(locationTransform)
	if self.curSelectedEntity then
		local position = locationTransform.position
		local sp = UtilsBase.WorldToUIPointBase(position.x, position.y, position.z)
		UnityUtils.SetLocalPosition(self.SelectedPoint.transform, sp.x, sp.y, 0)
	end
	
	self.locationTransform = locationTransform
end

function HackMainWindow:UpdateHackingMessagePanel()
	UnityUtils.SetActive(self.MessagePanel, self.curSelectedEntity ~= nil)
	
	if not self.curSelectedEntity then
		return 
	end
	
	local config = self.curSelectedEntity.hackingInputHandleComponent:GetConfig()
	
	UnityUtils.SetActive(self.MsgHeadIcon, config.Icon ~= nil)
	if config.Icon then
		SingleIconLoader.Load(self.MsgHeadIcon, config.Icon)
	end
	
	UnityUtils.SetActive(self.MsgNameText, config.Name ~= nil)
	self.MsgNameText_txt.text = config.Name or ""
	
	UnityUtils.SetActive(self.MsgNameText, config.Desc ~= nil)
	self.MsgProfessionText_txt.text = config.Desc or ""
	
	--有收入配置再显示
	UnityUtils.SetActive(self.Income, false)
end

--骇入的实体消失
function HackMainWindow:OnRemoveEntity(instanceId)
	if self.mode == HackingConfig.Mode.Hacking and self.curSelectedEntity.instanceId == instanceId then
		MsgBoxManager.Instance:ShowTips("骇入已断开")
		self:OnSwitchHackMode()
		
		self:ClearModeDataBeforeSwitch()
		BehaviorFunctions.ExitHackingMode()
	end
end

---受伤时退出骇入状态
function HackMainWindow:OnEntityHit(atkInstanceId, hitInstanceId, hitType)
	if hitInstanceId == BehaviorFunctions.GetCtrlEntity() then
		MsgBoxManager.Instance:ShowTips("骇入被打断")
		self:OnSwitchHackMode()
		self:ClearModeDataBeforeSwitch()
		BehaviorFunctions.ExitHackingMode()
	end
end

---死亡时退出骇入状态
function HackMainWindow:OnEntityDeath(InstanceId, reason)
	if InstanceId == BehaviorFunctions.GetCtrlEntity() then
		MsgBoxManager.Instance:ShowTips("骇入被打断")
		self:OnSwitchHackMode()
		self:ClearModeDataBeforeSwitch()
		BehaviorFunctions.ExitHackingMode()
	end
end