

FightMainUIView = BaseClass("FightMainUIView",BaseWindow)
FightMainUIView.bgInput = {x=0,y=0}
FightMainUIView.btnInput = {x=0,y=0}

local _deg2rad = math.pi / 180
local AttrType = EntityAttrsConfig.AttrType


local PlayerAttrChangeFuncs =
{
	[AttrType.Life] = function (self) self:UpdatePlayerHp() end,
	[AttrType.MaxLife] = function (self) self:UpdatePlayerHp() end,
	[AttrType.MaxLifePercent] = function (self) self:UpdatePlayerHp() end,
}

function FightMainUIView:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.fight_main_ui)
	self:SetCacheMode(UIDefine.CacheMode.hide)
	self.moveInput = {x=0,y=0}
	self.childViews = {}
	self.behaviorUIOper = {}
	self.behaviorUIState = {}
	self.effectCache = {}
	self.starSequence = {}
	self.nodeCacheByPlayer = {}
	self.targetLifeSequence = nil
	self.targetLifeTimer = nil
	self.targetLifeAnim = false
	self.batteryContinuousConsumptionCount = 0
	self.curRamItemContList = {}
	self.curShowRamIndex = 0
	self.batteryVisible = false
	self.batteryHideDelayFrame = 0
end

function FightMainUIView:__Hide()
	self.loadDone = false
	self.clientFight.inputManager:ClearAllInput()
	self:ClosePanel(TeachTipPanel)
end

function FightMainUIView:__TempHide()
	if self.growNotice then
		self.growNotice:WaitHide()
	end
end

function FightMainUIView:__delete()
	self:UpdatePlayerBindNode(true)
	self.loadDone = false
	if self.starSequence then
		for k, v in pairs(self.starSequence) do
			v:Kill(false)
		end
		self.starSequence = nil
	end

	if next(self.childViews) then
		for k, v in pairs(self.childViews) do
			v:Destroy()
		end
	end

	self:UnBindEvent()
	self:RemoveTimer()
	
	if self.guideMaskView then
		self.guideMaskView:Destroy()
	end

	if self.targetLifeSequence and self.targetLifeSequence.Destroy then
		self.targetLifeSequence:Kill()
		self.targetLifeSequence = nil
	end

	if self.targetLifeTimer then
		LuaTimerManager.Instance.RemoveTimer(self.targetLifeTimer)
		self.targetLifeTimer = nil
	end

	self.targetLifeAnim = false
end

function FightMainUIView:__ExtendView()
	self:ExtendView(FightUIActiveView)
	self:ExtendView(FightInteractTriggerView)

	self:ExtendView(FightLockView)
end

function FightMainUIView:__CacheObject()

end

function FightMainUIView:__BindEvent()
	EventMgr.Instance:AddListener(EventName.CancelJoystick, self:ToFunc("CancelJoystick"))
	--EventMgr.Instance:AddListener(EventName.OpenRemoteDialog, self:ToFunc("OpenRemoteDialog"))
	EventMgr.Instance:AddListener(EventName.OpenTalkDialog, self:ToFunc("OpenTalkDialog"))
	EventMgr.Instance:AddListener(EventName.SetNodeVisible, self:ToFunc("SetNodeVisible"))
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("UpdateEntityAttr"))
	EventMgr.Instance:AddListener(EventName.TargetUpdate, self:ToFunc("UpdateTarget"))
	EventMgr.Instance:AddListener(EventName.KeyAutoUp, self:ToFunc("KeyAutoUp"))
	EventMgr.Instance:AddListener(EventName.MainPanelPlayEffect, self:ToFunc("PlayEffect"))
	EventMgr.Instance:AddListener(EventName.MainPanelStopEffect, self:ToFunc("StopEffect"))
	EventMgr.Instance:AddListener(EventName.MainPanelShowTip, self:ToFunc("ShowTip"))
	EventMgr.Instance:AddListener(EventName.MainPanelHideTip, self:ToFunc("HideTip"))
	EventMgr.Instance:AddListener(EventName.MainPanelSetTipsGuide, self:ToFunc("SetTipsGuideState"))
	--EventMgr.Instance:AddListener(EventName.ShowCoopDisplay, self:ToFunc("ShowCoopDisplay"))
	EventMgr.Instance:AddListener(EventName.ShowFightDisplay, self:ToFunc("ShowFightDisplay"))
	EventMgr.Instance:AddListener(EventName.ShowFightMainUIDisplay, self:ToFunc("ShowFightMainUIDisplay"))
	--EventMgr.Instance:AddListener(EventName.ShowWeakGuide, self:ToFunc("ShowWeakGuide"))
	EventMgr.Instance:AddListener(EventName.PlayReviveMusic, self:ToFunc("PlayReviveMusic"))
	EventMgr.Instance:AddListener(EventName.SetCoreEffectVisible, self:ToFunc("SetCoreEffectVisible"))
	EventMgr.Instance:AddListener(EventName.MarkUpdate, self:ToFunc("RefreshMiniMap"))
	EventMgr.Instance:AddListener(EventName.SetCurEntity, self:ToFunc("ChangeCurUseRole"))
	EventMgr.Instance:AddListener(EventName.DodgeValueChange, self:ToFunc("ChangeDodgeValue"))
	EventMgr.Instance:AddListener(EventName.SetAimImage, self:ToFunc("SetAimImage"))
    EventMgr.Instance:AddListener(EventName.ShowGuideTips, self:ToFunc("ShowGuideTips"))
	EventMgr.Instance:AddListener(EventName.EnterMapArea, self:ToFunc("EnterMapArea"))
	EventMgr.Instance:AddListener(EventName.ExitMapArea, self:ToFunc("ExitMapArea"))
	EventMgr.Instance:AddListener(EventName.ChangeTitleTips, self:ToFunc("ChangeTitleTipsDesc"))
	EventMgr.Instance:AddListener(EventName.ChangeSubTips, self:ToFunc("ChangeSubTipsDesc"))
	EventMgr.Instance:AddListener(EventName.ShowTopTarget, self:ToFunc("ShowTopTarget"))
	EventMgr.Instance:AddListener(EventName.ChangeTopTargetDesc, self:ToFunc("ChangeTopTargetDesc"))
	EventMgr.Instance:AddListener(EventName.TopTargetFinish, self:ToFunc("TopTargetFinish"))
	EventMgr.Instance:AddListener(EventName.HideFightMainWindowPanel, self:ToFunc("HidePanel"))
	EventMgr.Instance:AddListener(EventName.TriggerTeachTip, self:ToFunc("TriggerTeachTip"))
	EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
	EventMgr.Instance:AddListener(EventName.HackBatteryLow, self:ToFunc("HackerBatteryLow"))
	EventMgr.Instance:AddListener(EventName.PlayerRamChange, self:ToFunc("PlayerRamChange"))
	-- EventMgr.Instance:AddListener(EventName.EnterAsset, self:ToFunc("EnterAsset"))
	-- EventMgr.Instance:AddListener(EventName.ExitAsset, self:ToFunc("ExitAsset"))
end

function FightMainUIView:UnBindEvent()
	EventMgr.Instance:RemoveListener(EventName.CancelJoystick, self:ToFunc("CancelJoystick"))
	--EventMgr.Instance:RemoveListener(EventName.OpenRemoteDialog, self:ToFunc("OpenRemoteDialog"))
	EventMgr.Instance:RemoveListener(EventName.OpenTalkDialog, self:ToFunc("OpenTalkDialog"))
	EventMgr.Instance:RemoveListener(EventName.SetNodeVisible, self:ToFunc("SetNodeVisible"))
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("UpdateEntityAttr"))
	EventMgr.Instance:RemoveListener(EventName.TargetUpdate, self:ToFunc("UpdateTarget"))
	EventMgr.Instance:RemoveListener(EventName.KeyAutoUp, self:ToFunc("KeyAutoUp"))
	EventMgr.Instance:RemoveListener(EventName.MainPanelPlayEffect, self:ToFunc("PlayEffect"))
	EventMgr.Instance:RemoveListener(EventName.MainPanelStopEffect, self:ToFunc("StopEffect"))
	EventMgr.Instance:RemoveListener(EventName.MainPanelShowTip, self:ToFunc("ShowTip"))
	EventMgr.Instance:RemoveListener(EventName.MainPanelHideTip, self:ToFunc("HideTip"))
	--EventMgr.Instance:RemoveListener(EventName.ShowCoopDisplay, self:ToFunc("ShowCoopDisplay"))
	EventMgr.Instance:RemoveListener(EventName.ShowFightDisplay, self:ToFunc("ShowFightDisplay"))
	EventMgr.Instance:RemoveListener(EventName.ShowFightMainUIDisplay, self:ToFunc("ShowFightMainUIDisplay"))
	--EventMgr.Instance:RemoveListener(EventName.ShowWeakGuide, self:ToFunc("ShowWeakGuide"))
	EventMgr.Instance:RemoveListener(EventName.PlayReviveMusic, self:ToFunc("PlayReviveMusic"))
	EventMgr.Instance:RemoveListener(EventName.SetCoreEffectVisible, self:ToFunc("SetCoreEffectVisible"))
	EventMgr.Instance:RemoveListener(EventName.MarkUpdate, self:ToFunc("RefreshMiniMap"))
	EventMgr.Instance:RemoveListener(EventName.SetCurEntity, self:ToFunc("ChangeCurUseRole"))
	EventMgr.Instance:RemoveListener(EventName.SetAimImage, self:ToFunc("SetAimImage"))
    EventMgr.Instance:RemoveListener(EventName.ShowGuideTips, self:ToFunc("ShowGuideTips"))
	EventMgr.Instance:RemoveListener(EventName.EnterMapArea, self:ToFunc("EnterMapArea"))
	EventMgr.Instance:RemoveListener(EventName.ExitMapArea, self:ToFunc("ExitMapArea"))
	EventMgr.Instance:RemoveListener(EventName.ChangeTitleTips, self:ToFunc("ChangeTitleTipsDesc"))
	EventMgr.Instance:RemoveListener(EventName.ChangeSubTips, self:ToFunc("ChangeSubTipsDesc"))
	EventMgr.Instance:RemoveListener(EventName.ShowTopTarget, self:ToFunc("ShowTopTarget"))
	EventMgr.Instance:RemoveListener(EventName.ChangeTopTargetDesc, self:ToFunc("ChangeTopTargetDesc"))
	EventMgr.Instance:RemoveListener(EventName.TopTargetFinish, self:ToFunc("TopTargetFinish"))
	EventMgr.Instance:RemoveListener(EventName.HideFightMainWindowPanel, self:ToFunc("HidePanel"))
	EventMgr.Instance:RemoveListener(EventName.TriggerTeachTip, self:ToFunc("TriggerTeachTip"))
	EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
	EventMgr.Instance:RemoveListener(EventName.HackBatteryLow, self:ToFunc("HackerBatteryLow"))
	EventMgr.Instance:RemoveListener(EventName.PlayerRamChange, self:ToFunc("PlayerRamChange"))
end

function FightMainUIView:CloseUI()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.PanelParent,false)
		UtilsUI.SetActiveByScale(self.Other, false)
		return
	else
		UtilsUI.SetActiveByScale(self.PanelParent,true)
		UtilsUI.SetActiveByScale(self.Other, true)
	end
end
function FightMainUIView:__BindListener()
	local bg = self.transform:Find("main_/BG_/Image")
	local bgdragBehaviour = bg.gameObject:GetComponent(UIDragBehaviour) or bg.gameObject:AddComponent(UIDragBehaviour)
	--bgdragBehaviour.ignorePass = true
	local onbgBeginDrag = function(data)
		self:BGBeginDrag(data)
	end
	bgdragBehaviour.onBeginDrag = onbgBeginDrag
	local cbbgOnDrag = function(data)
		self:BGDrag(data)
	end
	bgdragBehaviour.onDrag = cbbgOnDrag

	local cbbgOnEndDrag = function(data)
		self:BGEndDrag(data)
	end
	bgdragBehaviour.onEndDrag = cbbgOnEndDrag
	
	local onbgDown = function(data)
		self:BGDown(data)
	end
	bgdragBehaviour.onPointerDown = onbgDown
	local onbgUp = function(data)
		self:BGUp(data)
	end
	bgdragBehaviour.onPointerUp = onbgUp
	UtilsUI.SetHideCallBack(self.AimObj_in, self:ToFunc("AimObj_in_HideCallBack"))
	UtilsUI.SetHideCallBack(self.PanelParent, self:ToFunc("PanelParentHideCallBack"))
	UtilsUI.SetShowCallBack(self.PanelParent, self:ToFunc("PanelParentShowCallBack"))
end

function FightMainUIView:__Create()
	-- self.timer = LuaTimerManager.Instance:AddTimer(0, 0.01,self:ToFunc("Update"))
	self.updateTimer = LuaTimerManager.Instance:AddTimer(0,0.2,self:ToFunc("ShowFPS"))
	-- local operationPosPrama = 2 - Screen.width / Screen.height
	-- if operationPosPrama > 0 then
	-- 	local position = self.ButtomRight.transform.localPosition
	-- 	position.x = position.x + (operationPosPrama * 270)
	-- 	UnityUtils.SetLocalPosition(self.ButtomRight_rect, position.x, position.y, 0)
	-- end
	
	self:InitBattery()
	self:InitRam()
end

function FightMainUIView:__TempShow()
	self:CallActivePanelFunc("ForceRebuildLayout")
end

function FightMainUIView:__Show()
end

function FightMainUIView:__ShowComplete()
	self.clientFight = Fight.Instance.clientFight
	self.operationManager = Fight.Instance.operationManager
	self:InitOtherUI()
	self:AddLoadDoneCount()
	self:UpdatePlayer()
end

function FightMainUIView:PanelParentShowCallBack()
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	if panel then
		panel:ShowPanel()
	end
end

function FightMainUIView:PanelParentHideCallBack()
	local panel = PanelManager.Instance:GetPanel(FightCoreUIPanel)
	if panel then
		panel:HidePanel()
	end
end

function FightMainUIView:InitOtherUI()
	self.panelCount = 13 --12个Panel+自己

	if not self.panelList or not next(self.panelList) then
		self.guidePanel = self:OpenPanel(FightGuidePanel)
		self.gatherPanel = self:OpenPanel(FightGatherPanel)
		self.interactPanel = self:OpenPanel(FightInteractPanel)
		self.goodsInteractPanel = self:OpenPanel(FightGoodsInteractPanel)
		self.joyStickPanel = self:OpenPanel(FightJoyStickPanel)
		self.systemUIPanel = self:OpenPanel(FightSystemPanel)
		self.formationPanel = self:OpenPanel(FightFormationPanel)
		self.infoPanel = self:OpenPanel(FightInfoPanel)
		self.targetInfoPanel = self:OpenPanel(FightTargetInfoPanel)
		self.newSkillPanel = self:OpenPanel(FightNewSkillPanel)
		self.uidPanel = self:OpenPanel(UIDPanel)
		self.growNotice = self:OpenPanel(FightGrowNotice)
		self:OpenPanel(FightRightTipPanel)
	else
		self.panelCount = 1
	end

	local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
	if assetId then
		UtilsUI.SetActive(self.guidePanel.gameObject, false)
		self.guidePanel = self:OpenPanel(AssetCenterGuidePanel, {assetId = assetId})
	end
end

function FightMainUIView:AddLoadDoneCount()
	self.panelCount = self.panelCount - 1
	if self.panelCount == 0 then
		self:OnLoadDone()
	end
end

function FightMainUIView:OnLoadDone()
	self.loadDone = true
	--self:UpdatePlayer()
	self:ExecuteExtendFun("OnLoadDone", true)
end

function FightMainUIView:RemoveTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

local joyStickMoveSpeed = 10
function FightMainUIView:Update()
	if not self.loadDone then
		return
	end
	self.nowActive = UtilsUI.IsActiveInHierarchy(self.gameObject)
	for k, v in pairs(self.panelList) do
		if v:Active() and v.Update then
			v:Update()
		end
	end
	
	for k, v in pairs(self.extendViews) do
		if v:Active() and v.Update then
			v:Update()
		end
	end

	if self.batteryVisible then
		if BehaviorFunctions.GetPlayerAttrRatio(FightEnum.PlayerAttr.CurElectricityValue) == 10000 then
			self.batteryHideDelayFrame = self.batteryHideDelayFrame - 1
			if self.batteryHideDelayFrame == 0 then
				self:SetBatteryVisible(false)
			end
		else
			self.batteryHideDelayFrame = 60
			self:UpdateBattery()
		end
	else
		if BehaviorFunctions.GetPlayerAttrRatio(FightEnum.PlayerAttr.CurElectricityValue) < 10000 then
			self:SetBatteryVisible(true)
			self.batteryHideDelayFrame = 60
		end
	end

	if self.ramVisible then
		self:PlayerRamChange()
	end

	-- 测试屏幕点击范围
	if _G.PointRange then
		if Input.GetMouseButtonDown(0) then
			local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.transform, Vector2(Input.mousePosition.x, Input.mousePosition.y), ctx.UICamera)
			if not self.testPointImg then
		   		self.testPointImg = GameObject.Instantiate(self.imgCPoint)
		   		self.testPointImg:SetActive(true)
		   		self.testPointImg.transform:SetParent(self.transform)
		   	end
		   	local imgPoint_rect = self.testPointImg.transform:GetComponent(RectTransform)
		   	UnityUtils.SetLocalScale(imgPoint_rect, 2, 2, 1)
		    UnityUtils.SetLocalPosition(imgPoint_rect, pos.x, pos.y, 0)
		end
	end
end

function FightMainUIView:LowUpdate()
	-- self.systemUIPanel:LowUpdate()
end

function FightMainUIView:BeforeLogicUpdate()
	if self.joyStickPanel.drag then
		self.clientFight.inputManager:MoveInput(self.moveInput.x, self.moveInput.y)
	end
end

function FightMainUIView:LogicUpdate()
	if self.targetInfoPanel then
		self.targetInfoPanel:LogicUpdate()
	end

	if self.growNotice then
		self.growNotice:LogicUpdate()
	end
end

function FightMainUIView:SetBgInputValue(x, y)
	FightMainUIView.bgInput.x = x or 0
	FightMainUIView.bgInput.y = y or 0
end

function FightMainUIView:BGBeginDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
end

function FightMainUIView:BGDrag(data)
	FightMainUIView.bgInput.x = data.delta.x
	FightMainUIView.bgInput.y = data.delta.y
	--Log("x = "..data.delta.x)
	--Log("y = "..data.delta.y)
	self.clientFight.inputManager:KeyDown(FightEnum.KeyEvent.ScreenMove)
end

function FightMainUIView:BGEndDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
	self.clientFight.inputManager:KeyUp(FightEnum.KeyEvent.ScreenMove)
	-- Log("KeyUp ScreenPress")
end

function FightMainUIView:BGDown()
	self.clientFight.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
	--Log("KeyDown ScreenPress")
end

function FightMainUIView:BGUp()
	self.clientFight.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
	--Log("KeyUp ScreenPress")
end

function FightMainUIView:KeyDown(key)
	--LogError("KeyDown"..key)
	self.clientFight.inputManager:KeyDown(key)
end

function FightMainUIView:KeyAutoUp(key)
	self.clientFight.inputManager:KeyDown(key)
	self.clientFight.inputManager:SetNextFrameKeyUp(key)
end

function FightMainUIView:KeyUp(key)
	--LogError("KeyUp"..key)
	self.clientFight.inputManager:KeyUp(key)
end

function FightMainUIView:CancelJoystick()
	self.joyStickPanel:CancelJoystick()
end

-- TODO 无用预设，策划修改后删除
function FightMainUIView:OpenRemoteDialog(dialogId, isHideMain)
	LogError("接口FightMainUIView:OpenRemoteDialog已弃用")
-- 	if not self.childViews[RemoteDialogPanel] then
-- 		self.childViews[RemoteDialogPanel] = RemoteDialogPanel.New()
-- 		self.childViews[RemoteDialogPanel]:SetParent(self.transform)
-- 	end
-- 	local setting = { dialogId = dialogId, isHideMain = isHideMain }
-- 	self.childViews[RemoteDialogPanel]:Show(setting)
 end

function FightMainUIView:ShowTip(tipId, ...)
	local tipsConfig = Config.DataTips.data_tips[tipId]
	if not tipsConfig or not next(tipsConfig) then
		self.guidePanel:HideOldTips()
		return
	end
	
	if tipsConfig.type == FightEnum.FightTipsType.CurtainTips then
		-- if not CurtainManager.Instance then
		-- 	--CurtainManager.New()
		-- end
		CurtainManager.Instance:ShowBlackCurtainTips(tipsConfig, ...)
		return 
	end
	
	if tipsConfig.type ~= FightEnum.FightTipsType.GuideTips then
		local tips = tipsConfig.content
		if tipsConfig.is_format then
			tips = string.format(tips, ...)
		end
		MsgBoxManager.Instance:ShowTips(tips, tipsConfig.time, tipId)
	else
		self.guidePanel:SetTipsGuideDesc(tipsConfig, ...)
	end
end

function FightMainUIView:ChangeTitleTipsDesc(tipId, ...)
	self.guidePanel:ChangeTitleTipsDesc(tipId, ...)
end

function FightMainUIView:ChangeSubTipsDesc(index, tipId, ...)
	self.guidePanel:ChangeSubTipsDesc(index, tipId, ...)
end

function FightMainUIView:HideTip(tipId)
	local tipsConfig = Config.DataTips.data_tips[tipId]
	if tipsConfig and tipsConfig.type ~= FightEnum.FightTipsType.GuideTips then
		MsgBoxManager.Instance:HideTips(tipId)
	else
		self.guidePanel:HideOldTips()
	end
	if self.childViews[FightTipsView] and self.childViews[FightTipsView].active then
		self.childViews[FightTipsView]:HideTip(tipId)
	end
end

function FightMainUIView:SetTipsGuideState(state)
	self.guidePanel:SetTipGuideState(state)
end

function FightMainUIView:ShowGuideTips(tipId)
	if not self.guideMaskView then
		self.guideMaskView = GuideMaskView.New()
		self.guideMaskView:SetParent(UIDefine.canvasRoot.transform)
	end

	self.guideMaskView:ShowTips(tipId)
end

local EnterReactionArea = {
	[FightEnum.AreaType.Small] = true,
	[FightEnum.AreaType.Mid] = true,
	[FightEnum.AreaType.Level] = true,
}
function FightMainUIView:EnterMapArea(areaType, areaId, mapId)
	if not EnterReactionArea[areaType] then
		return
	end

	-- TODO 关卡区域不是一套逻辑
	if areaType == FightEnum.AreaType.Level then
		local levelConfig = Fight.Instance.levelManager:GetDuplicateCfg(areaId)
		if not levelConfig or not next(levelConfig) then
			return
		end

		self.panelList["FightSystemPanel"]:RefreshMapScale(levelConfig.map_scale)
		return
	end

	local areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(areaId, mapId)
	if not areaCfg then
		LogError("找不到areaConfig areaId = "..areaId)
		return
	end

	if areaCfg.condition and not Fight.Instance.conditionManager:CheckConditionByConfig(areaCfg.condition) then
		return
	end

	local changeScale = areaCfg.change_scale ~= 0 and areaCfg.change_scale or 3


	if areaType == FightEnum.AreaType.Mid then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.MapMidArea, areaCfg.name, true)
	else
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.MapSmallArea, areaCfg.name, true)
		self.panelList["FightSystemPanel"]:RefreshMapScale(changeScale)
	end
end

local ExitReactionArea = { [FightEnum.AreaType.Small] = true, [FightEnum.AreaType.Block] = true, [FightEnum.AreaType.Mid] = true, [FightEnum.AreaType.Level] = true }
function FightMainUIView:ExitMapArea(areaType, areaId, mapId)
	if not ExitReactionArea[areaType] then
		return
	end

	-- TODO 关卡区域不是同一套逻辑
	if areaType == FightEnum.AreaType.Level then
		self.panelList["FightSystemPanel"]:RefreshMapScale()
		return
	end

	local areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(areaId, mapId)
	if not Fight.Instance.conditionManager:CheckConditionByConfig(areaCfg.condition) then
		return
	end

	if areaType == FightEnum.AreaType.Small then
		self.panelList["FightSystemPanel"]:RefreshMapScale()
	end
end

function FightMainUIView:OpenTalkDialog(dialogId)
	if not self.childViews[FightTalkDialogPanel] then
		self.childViews[FightTalkDialogPanel] = FightTalkDialogPanel.New()
		self.childViews[FightTalkDialogPanel]:SetParent(self.transform)
	end
	self.childViews[FightTalkDialogPanel]:Show(dialogId)
end

-- TODO 无用预设，策划修改后删除
function FightMainUIView:ShowCoopDisplay(mainCharacter, subCharacter, blurRadius)
	LogError("接口FightMainUIView:ShowCoopDisplay已弃用")
-- 	if not self.childViews[CoopDisplayPanel] then
-- 		self.childViews[CoopDisplayPanel] = CoopDisplayPanel.New(self, blurRadius)
-- 	end

-- 	self.childViews[CoopDisplayPanel]:SetCacheMode(UIDefine.CacheMode.hide)
-- 	self.childViews[CoopDisplayPanel]:SetCoopCharacter(mainCharacter, subCharacter)
-- 	self.childViews[CoopDisplayPanel]:Show()
end

function FightMainUIView:ShowFightDisplay(show)
	--if self.gameObject.activeSelf ~= show then
		--self:CancelJoystick()
	--end
	
	if not show then
		self.clientFight.inputManager:ClearAllInput()
	end

	if not show then
		BehaviorFunctions.SetFightPanelVisible("10000")
		BehaviorFunctions.SetJoyStickVisibleByAlpha(100, false)
	else
		BehaviorFunctions.SetFightPanelVisible("-1")
		BehaviorFunctions.SetJoyStickVisibleByAlpha(100, true, true)
	end
	--self.gameObject:SetActive(show)
end

function FightMainUIView:ShowFightMainUIDisplay(show)
	if not show then
		self.clientFight.inputManager:ClearAllInput()
	end

	if self.active then
		UtilsUI.SetActiveByPosition(self.gameObject, show)
	end
end


function FightMainUIView:GetNode(node, uiContainNode)
	if self[node] then return self[node] end
	
	if self.newSkillPanel[node] then return self.newSkillPanel[node] end
	if self.newSkillPanel.btns and self.newSkillPanel.btns[uiContainNode] and self.newSkillPanel.btns[uiContainNode][node] then
		return self.newSkillPanel.btns[uiContainNode][node]
	end

	
	if self.infoPanel[node] then return self.infoPanel[node] end
	if self.formationPanel[node] then return self.formationPanel[node] end
	if self.formationPanel.nodes and self.formationPanel.nodes[uiContainNode] and self.formationPanel.nodes[uiContainNode][node] then
		return self.formationPanel.nodes[uiContainNode][node]
	end
	
	if self.systemUIPanel[node] then return self.systemUIPanel[node] end
	if self.joyStickPanel[node] then return self.joyStickPanel[node] end
	if self.guidePanel[node] then return self.guidePanel[node] end
	if self.targetInfoPanel[node] then return self.targetInfoPanel[node] end
end


-- 关卡和战斗都通过才显示，各自内部全票通过才显示
-- opType 第一优先级 判断具体调用类型
-- priority 第二优先级 是类型下的具体优先级 默认为最低1
function FightMainUIView:SetNodeVisible(opType, node, visible, priority, stopControl)
	if not self.behaviorUIOper[node] then
		self.behaviorUIOper[node] = {
			behavior = {},
			level = {},
		}
	end

	local priority = priority or 1
	local function checkIsVisible(list)
		local _priority = 9999
		local _visible = true
		for i, v in pairs(list) do
			if i < _priority then
				_visible = v and _visible -- 各自内部全票通过才显示
				_priority = i
			end
		end
		return _visible
	end

	if opType == FightEnum.BehaviorUIOpType.behavior then
		if stopControl then
			self.behaviorUIOper[node].behavior[priority] = nil
		else
			self.behaviorUIOper[node].behavior[priority] =  visible
		end
	else
		if stopControl then
			self.behaviorUIOper[node].level[priority] = nil
		else
			self.behaviorUIOper[node].level[priority] =  visible
		end
	end

	local behaviorVisible = checkIsVisible(self.behaviorUIOper[node].behavior)
	local levelVisible = checkIsVisible(self.behaviorUIOper[node].level)

	local realVisible
	if behaviorVisible ~= nil and levelVisible ~= nil then
		realVisible = behaviorVisible and levelVisible
	elseif behaviorVisible ~= nil then
		realVisible = behaviorVisible
	else
		realVisible = levelVisible
	end
	
	if realVisible == nil then
		return
	end

	local nodeObj = self:GetNode(node)

	if opType == FightEnum.BehaviorUIOpType.behavior and self.playerObject and next(self.playerObject) then
		local curPlayer = self.playerObject.entityId
		if not self.nodeCacheByPlayer[curPlayer] then
			self.nodeCacheByPlayer[curPlayer] = {}
		end

		if not self.nodeCacheByPlayer[curPlayer][node] then
			self.nodeCacheByPlayer[curPlayer][node] = { initState = nodeObj.activeSelf, curState = false}
		end
		self.nodeCacheByPlayer[curPlayer][node].curState = realVisible
	end

	if self.behaviorUIState[node] ~= nil and self.behaviorUIState[node] == realVisible then
		return
	else
		self.behaviorUIState[node] = realVisible
	end

	if nodeObj then
		local FightConfig = Config.FightConfig
		if FightConfig.NodeVisibleDefine[node] then
			if FightConfig.NodeVisibleDefine[node] == FightConfig.NodeVisibleType.Normal then
				UtilsUI.SetActive(nodeObj, realVisible)
			elseif FightConfig.NodeVisibleDefine[node] == FightConfig.NodeVisibleType.Position then
				UtilsUI.SetActiveByPosition(nodeObj, realVisible)
			elseif FightConfig.NodeVisibleDefine[node] == FightConfig.NodeVisibleType.Scale then
				UtilsUI.SetActiveByScale(nodeObj, realVisible)
			end
			return
		end
		UtilsUI.SetActive(nodeObj, realVisible)
	end
end

function FightMainUIView:UpdatePlayer()
	if self.playerObject and self.nodeCacheByPlayer[self.playerObject.entityId] then
		self:UpdatePlayerBindNode(true)
	end

	self.player = Fight.Instance.playerManager:GetPlayer()
	
	local playerObject = self.player:GetCtrlEntityObject()

	
	self.playerObject = playerObject
	if not self.playerObject then
		LogError("没有获取到前台角色")
		return
	end

	self.playerObjAttr = self.playerObject.attrComponent
	self.playerNpcConfig = self.playerObject.attrComponent.npcConfig

	for k, v in pairs(self.panelList) do
		if v.UpdatePlayer then
			v:UpdatePlayer()
		end
	end

	-- self.infoPanel:UpdatePlayer()
	-- self.targetInfoPanel:UpdatePlayer()
	-- self.formationPanel:UpdatePlayer()
	-- self.joyStickPanel:UpdatePlayer()
	
	self:UpdatePlayerHp()
	--self:UpdatePlayerEnergy()
	self:UpdatePlayerBindNode()
	--self:UpdatePlayerCommonAttr()
end

function FightMainUIView:UpdateEntityAttr(attrType, entity)
	UnityUtils.BeginSample("FightMainUIView:UpdateEntityAttr")
	if entity.tagComponent and entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		self:UpdatePlayerAttr(attrType)
	else
		self.targetInfoPanel:UpdateTargetAttr(attrType, entity)
	end
	UnityUtils.EndSample()
end

function FightMainUIView:UpdatePlayerAttr(attrType)
	if PlayerAttrChangeFuncs[attrType] then
		PlayerAttrChangeFuncs[attrType](self)
	end

	self.infoPanel:UpdatePlayerAttr(attrType)
end

function FightMainUIView:UpdatePlayerHp()
	self.infoPanel:UpdatePlayerHp()
end

--local position20003 = {-167,0,0}
function FightMainUIView:UpdatePlayerEnergy()
	self.infoPanel:UpdatePlayerEnergy()
end

function FightMainUIView:UpdatePlayerCommonAttr()
	local curValue = self.playerObjAttr:GetValue(AttrType.CommonAttr1)
	local maxValue = self.playerObjAttr:GetValue(AttrType.MaxCommonAttr1)
	self.CmAttrFill_img.fillAmount = curValue / maxValue
	self.CmAttrText_txt.text = curValue.."/"..maxValue
end

function FightMainUIView:UpdateTarget(instanceId)
	self.targetInfoPanel:UpdateTarget(instanceId)
end

function FightMainUIView:UpdateTargetAttr(attrType, target)
	self.targetInfoPanel:UpdateTargetAttr(attrType, target)
end

function FightMainUIView:UpdatePlayerBindNode(isReset)
	TableUtils.ClearTable(self.behaviorUIState)
	local curPlayer = self.playerObject.entityId
	if self.nodeCacheByPlayer[curPlayer] then
		for k, v in pairs(self.nodeCacheByPlayer[curPlayer]) do
			local nodeObj = self:GetNode(k)
			if nodeObj then
				if isReset then
					nodeObj:SetActive(v.initState)
				else
					nodeObj:SetActive(v.curState)
				end
			end
		end
	end
end

function FightMainUIView:PlayEffect(effectName, parentName, position, forcePlay, needRestart, uiContainName, scale, followEntityId)
	local name = uiContainName and uiContainName..parentName or parentName
	self.effectCache[name] = self.effectCache[name] or {}
	local effectInfo = self.effectCache[name][effectName]
	if not effectInfo then
		needRestart = false
		if not self[effectName] then
			LogError(" effectName error "..effectName)
		end

		local object = GameObject.Instantiate(self[effectName])
		local transform = object.transform
		local parent = self:GetNode(parentName, uiContainName)
		transform:SetParent(parent.transform)
		transform:ResetAttr()

		if position then
			CustomUnityUtils.SetLocalPosition(transform,position[1],position[2],position[3])
		end

		if followEntityId then
			local entity = Fight.Instance.entityManager:GetEntity(followEntityId)
			if entity then
				local targetTransform = entity.clientTransformComponent:GetTransform("HitCase")
				if targetTransform then
					local component = object:GetComponent(WorldToUIPoint)
					component:SetTargetTransform(targetTransform, ctx.UICamera)
				end
			end
		end
	
		effectInfo = {object = object, visible = true, followEntityId = followEntityId}
		self.effectCache[name][effectName] = effectInfo
	else
		if effectInfo.visible and not forcePlay then
			return
		end

		if followEntityId then
			local entity = Fight.Instance.entityManager:GetEntity(followEntityId)
			if entity then
				local targetTransform = entity.clientTransformComponent:GetTransform("HitCase")
				if targetTransform then
					local component = effectInfo.object:GetComponent(WorldToUIPoint)
					component:SetTargetTransform(targetTransform, ctx.UICamera)
				end
			end
		end
	end
	
	local toScale = scale or 1
	UnityUtils.SetLocalScale(effectInfo.object.transform,toScale,toScale,toScale)
	effectInfo.object:SetActive(true)
	effectInfo.visible = true
	effectInfo.followEntityId = followEntityId
	if needRestart then
		effectInfo.object:RestartAll()
	end
end

-- 之后优化
function FightMainUIView:PlayEffectWithTransform(effectName, parent, position, forcePlay, needRestart)
	local name = parent.gameObject.name
	self.effectCache[name] = self.effectCache[name]
	local effectInfo = self.effectCache[name][effectName]
	if not effectInfo then
		needRestart = false
		if not self[effectName] then
			LogError(" effectName error "..effectName)
		end

		local object = GameObject.Instantiate(self[effectName])
		local transform = object.transform
		transform:SetParent(parent.transform)
		transform:ResetAttr()

		if position then
			CustomUnityUtils.SetLocalPosition(transform,position[1],position[2],position[3])
		end
	
		effectInfo = {object = object, visible = true}
		self.effectCache[name][effectName] = effectInfo
	else
		if effectInfo.visible and not forcePlay then
			return
		end
	end

	effectInfo.object:SetActive(true)
	effectInfo.visible = true
	if needRestart then
		effectInfo.object:RestartAll()
	end
end

function FightMainUIView:StopEffect(effectName, parentName, uiContainName)
	local name = parentName
	if uiContainName then
		name = uiContainName..parentName
	end
	self.effectCache[name] = self.effectCache[name] or {}
	local effectInfo = self.effectCache[name][effectName]
	if not effectInfo then
		return
	end

	if not effectInfo.visible then
		return
	end

	if effectInfo.followEntityId then
		local component = effectInfo.object:GetComponent(WorldToUIPoint)
		component:ClearTarget()
	end

	effectInfo.object:SetActive(false)
	effectInfo.visible = false
	effectInfo.followEntityId = nil
end

function FightMainUIView:SetCoreEffectVisible(name, visible)
	self.infoPanel:SetCoreEffectVisible(name, visible)
end

function FightMainUIView:DrawRangePoints()
	local pointList = {}
	for i = 1, 720 do
		angle = i * 0.5
		local rad = angle * _deg2rad
        local x = guideMaxWidth * math.cos(rad)
        local y = guideMaxHeight * math.sin(rad)

	   	local imgPoint = GameObject.Instantiate(self.imgCPoint)
	   	imgPoint.name = "impoint"..i
	   	local imgPorint_rect = imgPoint.transform:GetComponent(RectTransform)
	   	imgPoint:SetActive(true)
	   	imgPoint.transform:SetParent(self.transform)
	   	imgPoint.transform:ResetAttr()
	    UnityUtils.SetLocalPosition(imgPorint_rect, x, y, 0)
	end
end

-- TODO 无用预设，策划修改后删除
function FightMainUIView:ShowWeakGuide(index, isHide)
	LogError("接口FightMainUIView:ShowWeakGuide已弃用")
	-- local panel = PanelManager.Instance:OpenPanel(WeakGuidePanel)
	-- panel:AddCommand(index, isHide)
end

function FightMainUIView:ShowTopTarget(configId)
	if not self.topTargetPanel then
		self.topTargetPanel = self:OpenPanel(FightTopTargetPanel, {configId})
		return
	end

	self.topTargetPanel:Show({configId})
end

function FightMainUIView:ChangeTopTargetDesc(index, desc)
	if not self.topTargetPanel then
		return
	end

	self.topTargetPanel:ChangeTargetDesc(index, desc)
end

function FightMainUIView:TopTargetFinish(index, forceClose)
	if not self.topTargetPanel then
		return
	end

	if forceClose then
		self.topTargetPanel:ClosePanel()
	else
		self.topTargetPanel:TargetFinish(index)
	end
end

function FightMainUIView:PlayReviveMusic()
	if not self.ReviveAudio then
		self.ReviveAudio = self.ReviveM:GetComponent(AudioSource)
	end

	self.ReviveAudio:PlayOneShot(self.ReviveAudio.clip, 1)
end

---comment
---@param refreshType number 刷新小地图类型(刷新，添加，移除)
---@param mark any 对应的标记
function FightMainUIView:RefreshMiniMap(refreshType, mark)
	if not self.systemUIPanel or not self.systemUIPanel.active then
		return
	end

	self.systemUIPanel:RefreshMiniMapMark(refreshType, mark)
end

function FightMainUIView:SetAimImage(aimType)
	if aimType == 0 then
		self.showAimImageType = nil
		return
	end

	if self.showAimImageType and self.showAimImageType == aimType then
		return
	end
	
	if not self.Aim.activeSelf then
		LuaTimerManager.Instance:AddTimer(1, 0.01, function() self:UpdateAimUI(aimType) end)
	else
		self:UpdateAimUI(aimType)
	end
end

function FightMainUIView:AimObj_in_HideCallBack()
	self.AimObj_loop:SetActive(true)
end

function FightMainUIView:UpdateAimUI(aimType)
	if self.showAimImageType and self.showAimImageType == aimType then
		return
	end
	if self.AimObj_ruodian.activeSelf == true then
		LuaTimerManager.Instance:AddTimer(1, 0.2, function ()
			self.AimObj_ruodianout:SetActive(true)
		end)
	end

	if self.AimObj_ruodian_1.activeSelf == true then
		LuaTimerManager.Instance:AddTimer(1, 0.2, function ()
			self.AimObj_ruodianout:SetActive(true)
		end)
	end
	if self.AimObj.activeSelf == false  then
		self.AimObj:SetActive(true)
	end

	if self.showAimImageType == FightEnum.AimImageType.PartWeak then
		-- 弱点瞄准->普通瞄准敌人
		if aimType == FightEnum.AimImageType.Part then
			self.AimObj_ruodianout_1:SetActive(true)
		end
		-- 弱点瞄准->取消瞄准敌人
		if aimType == FightEnum.AimImageType.None then
			self.AimObj_ruodianout:SetActive(true)
		end
	end

	if self.showAimImageType == FightEnum.AimImageType.Part then
		-- 普通瞄准敌人->弱点瞄准
		if aimType == FightEnum.AimImageType.PartWeak then
			self.AimObj_ruodian:SetActive(true)
		end
		-- 普通瞄准敌人->取消瞄准敌人
		if aimType == FightEnum.AimImageType.None then
			self.AimObj_miaozhunout:SetActive(true)
		end
	end


	if self.showAimImageType == FightEnum.AimImageType.None then
		--直接瞄准到弱点
		if aimType == FightEnum.AimImageType.PartWeak then
			self.AimObj_ruodian_1:SetActive(true)
		end
		--直接瞄准到敌人
		if aimType == FightEnum.AimImageType.Part then
			self.AimObj_miaozhun:SetActive(true)
		end
	end

	-- 第一次进入
	if not self.showAimImageType then
		if self.AimObj_in.activeSelf == false then
			self.AimObj_loop:SetActive(false)
			self.AimObj_in:SetActive(true)
		end
		-- 第一次进入就瞄准到弱点
		if aimType == FightEnum.AimImageType.PartWeak then
			self.AimObj_ruodian_1:SetActive(true)
		end
		--  第一次进入就普通瞄准敌人
		if aimType == FightEnum.AimImageType.Part then
			self.AimObj_miaozhun:SetActive(true)
		end
	end

	self.showAimImageType = aimType
end

-- 隐藏主界面上的panel
function FightMainUIView:HidePanel(panelName)
	if not self.panelList[panelName] or not self.panelList[panelName].active then
		return
	end

	if self.panelList[panelName].ClosePanel then
		self.panelList[panelName]:ClosePanel()
	else
		self:ClosePanel(self:GetPanelByName(panelName))
	end
end

function FightMainUIView:TriggerTeachTip(teachId, callBack)
	self:OpenPanel(TeachTipPanel, {teachId, callBack}, UIDefine.CacheMode.destroy)
end

function FightMainUIView:ShowSelf()
	for key, value in pairs(self.panelList) do
		if value.active and value.ShowSelf then
			value:ShowSelf()
		end
	end
end

function FightMainUIView:HideSelf(callBack)
	CurtainManager.Instance:EnterWait()
	BehaviorFunctions.Pause()
	InputManager.Instance.switchingActionMap = true
	for key, value in pairs(self.panelList) do
		if value.active and value.HideSelf then
			value:HideSelf()
		end
	end
	self.FightMainUI_Exit:SetActive(true)
	self.KeepOut:SetActive(true)
	local func = function ()
		CurtainManager.Instance:ExitWait()
		BehaviorFunctions.Resume()
		self.KeepOut:SetActive(false)
		if callBack then
			callBack()
		end
	end
	UtilsUI.SetHideCallBack(self.FightMainUI_Exit, func)
end

function FightMainUIView:InitBattery()
	UtilsUI.SetActive(self.Battery, false)
end

function FightMainUIView:InitRam()
	UtilsUI.SetActive(self.Ram, false)
	local curRamValue, maxRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)

	for i = 1, maxRamValue, 1 do
		local objectInfo = self:PopUITmpObject("RamItem", self.RamList_rect)
		if i > curRamValue then
			UtilsUI.SetActive(objectInfo.UnRam, true)
			UtilsUI.SetActive(objectInfo.Ram, false)
		else
			UtilsUI.SetActive(objectInfo.UnRam, false)
			UtilsUI.SetActive(objectInfo.Ram, true)
		end
		UtilsUI.SetActive(objectInfo.object, true)
		table.insert(self.curRamItemContList, objectInfo)
	end
	self.curShowRamIndex = curRamValue
	self.curShowRamMaxIndex = maxRamValue
end

function FightMainUIView:UpdateBattery()
	local curElectricityValue, maxElectricityValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurElectricityValue)
	self.BatteryCount_txt.text = string.format("%.0f", curElectricityValue)
	if maxElectricityValue > 0 then
		self.BatteryImage_img.fillAmount = curElectricityValue/ maxElectricityValue
	end
end

function FightMainUIView:SetBatteryVisible(visible)
	if self.batteryVisible == visible then
		return
	end
	self.batteryVisible = visible
	UtilsUI.SetActive(self.Battery, visible)
end

function FightMainUIView:SetRamVisible(visible)
	if self.ramVisible == visible then
		return 
	end
	self.ramVisible = visible
	UtilsUI.SetActive(self.Ram, visible)
end

function FightMainUIView:PlayerRamChange()
	local curRamValue, maxRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)

	if self.curShowRamMaxIndex ~= maxRamValue then
		if self.curShowRamMaxIndex > maxRamValue then
			for i = self.curShowRamMaxIndex, maxRamValue + 1, -1 do
				local objectInfo = self.curRamItemContList[i]
				self:PushUITmpObject("RamItem", objectInfo, self.RamList_rect)
				table.remove(self.curShowRamMaxIndex)
			end
		else
			for i = self.curShowRamMaxIndex + 1, maxRamValue, 1 do
				local objectInfo = self:PopUITmpObject("RamItem", self.RamList_rect)
				if i > curRamValue then
					UtilsUI.SetActive(objectInfo.UnRam, true)
					UtilsUI.SetActive(objectInfo.Ram, false)
				else
					UtilsUI.SetActive(objectInfo.UnRam, false)
					UtilsUI.SetActive(objectInfo.Ram, true)
				end
				UtilsUI.SetActive(objectInfo.object, true)
				table.insert(self.curRamItemContList, objectInfo)
			end
		end
		self.curShowRamMaxIndex = maxRamValue
	end

	if self.curShowRamIndex ~= curRamValue then
		if curRamValue > self.curShowRamIndex then
			for i = self.curShowRamIndex + 1, curRamValue, 1 do
				local objectInfo = self.curRamItemContList[i]
				UtilsUI.SetActive(objectInfo.UnRam, false)
				UtilsUI.SetActive(objectInfo.Ram, true)
			end
		else
			for i = self.curShowRamIndex, curRamValue + 1, -1 do
				local objectInfo = self.curRamItemContList[i]
				UtilsUI.SetActive(objectInfo.UnRam, true)
				UtilsUI.SetActive(objectInfo.Ram, false)
			end
		end
		self.curShowRamIndex = curRamValue
	end
	self.RamNum_txt.text = string.format("%d/%d", curRamValue, maxRamValue)
end

function FightMainUIView:ShortShutdownInBannerShow()
	self.shortShutdownGuidePanelActive = self.guidePanel.gameObject.activeSelf
	self.shortShutdownLeftPartActive = self.systemUIPanel.LeftPart.activeSelf
	UtilsUI.SetActive(self.guidePanel.gameObject, false)
	UtilsUI.SetActive(self.systemUIPanel.LeftPart, false)
end

function FightMainUIView:ReplyShutdownInBannerShow()
	UtilsUI.SetActive(self.guidePanel.gameObject, self.shortShutdownGuidePanelActive)
	UtilsUI.SetActive(self.systemUIPanel.LeftPart, self.shortShutdownLeftPartActive)
	self.shortShutdownGuidePanelActive = nil
	self.shortShutdownLeftPartActive = nil
end

function FightMainUIView:SetGoodsInteract(visible)
	UtilsUI.SetActive(self.goodsInteractPanel, visible)
end

function FightMainUIView:EnterAsset(assetId)
	self:ClosePanel(self.guidePanel)
	self.guidePanel = self:OpenPanel(AssetCenterGuidePanel,{assetId = assetId})
end

function FightMainUIView:ExitAsset(assetId)
	
end