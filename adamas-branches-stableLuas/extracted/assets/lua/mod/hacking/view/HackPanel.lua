HackPanel = BaseClass("HackPanel",BasePanel, SystemView)

local HackUIState = HackingConfig.HackUIState
local HackMode = FightEnum.HackMode

local ScreenW = Screen.width * 0.5
local ScreenH = Screen.height * 0.5
local BuildLimitCondition = Config.DataCommonCfg.Find["BuildLimitCondition"].int_val

function HackPanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Hacking/HackMainWindow.prefab")

	self.loadDone = false
	self.inputManager = Fight.Instance.clientFight.inputManager
	self.hackManager = Fight.Instance.hackManager
	self.npcManager = Fight.Instance.entityManager.npcEntityManager

	self.operateButton = {}

	self.mainView = mainView
	
	self.tipsObj = nil

	self.initFovValue = 1
	self.isTouchEvent = false
	self.initDistance = 0

	self.msgTempPool = {}
	self.msgTempOnShow = {}
	self.operateShopTextItems = {}

	self.entityEffectMap = {}
end

function HackPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
	EventMgr.Instance:RemoveListener(EventName.ExitHackingMode, self:ToFunc("OnSwitchHackMode"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.EntityWillDie, self:ToFunc("OnEntityWillDie"))
	EventMgr.Instance:RemoveListener(EventName.OnEntitySwim, self:ToFunc("OnEntitySwim"))
	EventMgr.Instance:RemoveListener(EventName.HackStateChange, self:ToFunc("HackStateChange"))
	EventMgr.Instance:RemoveListener(EventName.HackMail, self:ToFunc("OnHackMail"))
	EventMgr.Instance:RemoveListener(EventName.HackPhoneCall, self:ToFunc("OnHackPhoneCall"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityEnable, self:ToFunc("HackEntityEnable"))
	EventMgr.Instance:RemoveListener(EventName.CreateEntity, self:ToFunc("OnCreateEntity"))
	EventMgr.Instance:RemoveListener(EventName.OnEnterStory, self:ToFunc("OnStoryDialogStart"))
	EventMgr.Instance:RemoveListener(EventName.HackBatteryLow, self:ToFunc("HackerBatteryLow"))

	--EventMgr.Instance:RemoveListener(EventName.HackOperateStateChange, self:ToFunc("HackOperateStateChange"))
	
	EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
	EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))

	EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))

	EventMgr.Instance:RemoveListener(EventName.HackEntityTaskEffectUpdate, self:ToFunc("OnEntityHackStateEffectUpdate"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityIsActiveStateUpdate, self:ToFunc("OnEntityHackActiveStateUpdate"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityHackButtonEnableUpdate, self:ToFunc("OnEntityHackButtonEnableUpdate"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityButtonInfoUpdate, self:ToFunc("OnHackEntityButtonInfoUpdate"))
	EventMgr.Instance:RemoveListener(EventName.ShowHackingRamTips, self:ToFunc("ShowHackRamTips"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityInformationUpdate, self:ToFunc("UpdateHackingEntityInfo"))
	EventMgr.Instance:RemoveListener(EventName.HackEntityEffectUpdate, self:ToFunc("UpdateOverrideEffect"))
	EventMgr.Instance:RemoveListener(EventName.PlayerRamChange, self:ToFunc("PlayerRamChange"))

	local id = self.hackManager:GetHackingId()
	if id then
		local hackComponent = self.hackManager:GetHackComponent(id)
		if hackComponent then
			hackComponent:StopHacking()
		end
	end
	
	self:UpdateHackEffect(false)
	self.hackManager:UpdateSelectedId()
	self.hackManager:SetHackMode()
	self.hackManager:SetHackingId()
end

function HackPanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
	self:AddSystemState(SystemStateConfig.StateType.Hack)
end

function HackPanel:__BindListener()
	--Event
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
	EventMgr.Instance:AddListener(EventName.ExitHackingMode, self:ToFunc("OnBack"))
	--骇入的建造物消失
	EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
	EventMgr.Instance:AddListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.EntityWillDie, self:ToFunc("OnEntityWillDie"))
	EventMgr.Instance:AddListener(EventName.OnEntitySwim, self:ToFunc("OnEntitySwim"))
	EventMgr.Instance:AddListener(EventName.HackStateChange, self:ToFunc("HackStateChange"))
	EventMgr.Instance:AddListener(EventName.HackMail, self:ToFunc("OnHackMail"))
	EventMgr.Instance:AddListener(EventName.HackPhoneCall, self:ToFunc("OnHackPhoneCall"))
	EventMgr.Instance:AddListener(EventName.HackEntityEnable, self:ToFunc("HackEntityEnable"))
	EventMgr.Instance:AddListener(EventName.CreateEntity, self:ToFunc("OnCreateEntity"))
	EventMgr.Instance:AddListener(EventName.OnEnterStory, self:ToFunc("OnStoryDialogStart"))
	EventMgr.Instance:AddListener(EventName.HackBatteryLow, self:ToFunc("HackerBatteryLow"))

	EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
	
	--EventMgr.Instance:AddListener(EventName.HackOperateStateChange, self:ToFunc("HackOperateStateChange"))
	
	EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
	EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
	EventMgr.Instance:AddListener(EventName.HackEntityTaskEffectUpdate, self:ToFunc("OnEntityHackStateEffectUpdate"))
	EventMgr.Instance:AddListener(EventName.HackEntityIsActiveStateUpdate, self:ToFunc("OnEntityHackActiveStateUpdate"))
	EventMgr.Instance:AddListener(EventName.HackEntityHackButtonEnableUpdate, self:ToFunc("OnEntityHackButtonEnableUpdate"))
	EventMgr.Instance:AddListener(EventName.ShowHackingRamTips, self:ToFunc("ShowHackRamTips"))
	EventMgr.Instance:AddListener(EventName.HackEntityInformationUpdate, self:ToFunc("UpdateHackingEntityInfo"))
	EventMgr.Instance:AddListener(EventName.HackEntityButtonInfoUpdate, self:ToFunc("OnHackEntityButtonInfoUpdate"))
	EventMgr.Instance:AddListener(EventName.HackEntityEffectUpdate, self:ToFunc("UpdateOverrideEffect"))
	EventMgr.Instance:AddListener(EventName.PlayerRamChange, self:ToFunc("PlayerRamChange"))

	self.HackMainWindow_Aim_miaozhun_Exit_hcb.HideAction:AddListener(self:ToFunc("AimSelectExitCallback"))
	
	self.HackMainWindow_Aim_miaozhun_Open_hcb.HideAction:AddListener(self:ToFunc("AimSelectEnterCallback"))
	
	--self.HackMainWindow_MessagePanel_Info_Exit_hcb.HideAction:AddListener(function()
			--self.playInfoExitAnim = false
			--UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Exit, false)
			--if self.playInfoEnterAnim then
				--UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Open, true)
			--end
		--end)

	--self.HackMainWindow_MessagePanel_Info_Open_hcb.HideAction:AddListener(function()
			--self.playInfoEnterAnim = false
			--UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Open, false)
			--if self.playAimExitAnim then
				--UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Exit, true)
			--end
		--end)

	--Button
	--self.BackBtn_btn.onClick:AddListener(self:ToFunc("OnBack"))

	self:BindCloseBtn(self.BackBtn_btn, self:ToFunc("ExitHack"))

	self.touchEvent = self.DragBg:GetComponent("UITouchEvent")
	self.touchEvent:SetTouchAction(self:ToFunc("OnTouchEvent"))

	self.cameraFovScroller = self.Scroller:GetComponent(Scrollbar)
	self.cameraFovScroller.onValueChanged:AddListener(self:ToFunc("OnCameraFovValueChange"))
	
	self.MiniTalkClose_btn.onClick:AddListener(self:ToFunc("StopHackMail"))
	self.MiniPhoneCallClose_btn.onClick:AddListener(self:ToFunc("StopHackPhoneCall"))
	
	self.DragBg:SetActive(true)
	self.DragBg_img.raycastTarget = false
	
	local bgdragBehaviour = self.DragBg:GetComponent(UIDragBehaviour) or self.DragBg:AddComponent(UIDragBehaviour)
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


	self.OperateShopCommitButton_btn.onClick:AddListener(self:ToFunc("OnClickOperateShopCommitButton"))
end


function HackPanel:CloseAllUI()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		--UtilsUI.SetActiveByScale(self.ModeSwitch,false)
		UtilsUI.SetActiveByScale(self.BackBtn,false)

		return
	else
		--UtilsUI.SetActiveByScale(self.ModeSwitch,true)
		UtilsUI.SetActiveByScale(self.BackBtn,true)
	end
end

function HackPanel:__Create()
	TableUtils.ClearTable(self.operateButton)
	for i = 1, 4 do
		self.operateButton[i] = {}
		
		local btn = self["HackOperationBtn"..i]
		self.operateButton[i].gameObject = btn
		self.operateButton[i].transform = btn.transform
		UtilsUI.GetContainerObject(btn.transform, self.operateButton[i])
		
		UtilsUI.SetInputImageChanger(self.operateButton[i].HackOperateBtnInputImage)

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
	UtilsUI.SetInputImageChanger(self.BackBtnInputImage)
	--UtilsUI.SetInputImageChanger(self.ModeSwitchInputImage)
	
	self.HackButtonInfoMap = {}
	for keyName, key in pairs(HackingConfig.HackingKey) do
		self.HackButtonInfoMap[key] = UtilsUI.GetContainerObject(self["HackButtonInfo" .. key])
		UtilsUI.SetInputImageChanger(self.HackButtonInfoMap[key].HackButtonInfoInputImage)
	end

	UtilsUI.SetActive(self.Aim, false)
	UtilsUI.SetActive(self.MessagePanel, false)
	UtilsUI.SetActive(self.Talk, false)
end

function HackPanel:__Show()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByPosition(self.gameObject, false)
	else
		UtilsUI.SetActiveByPosition(self.gameObject, true)
	end

	local isOpen = Fight.Instance.conditionManager:CheckConditionByConfig(BuildLimitCondition)
	self.BuildModeMask:SetActive(not isOpen)

	local mode = HackMode.Hack
	
	self:UpdateModeSelected(mode)
	self:UpdateOperateButton()
	self:InitTipsItem()

	self.uiFSM = Fight.Instance.objectPool:Get(HackUIFSM)
	self.uiFSM:Init(self)

	self.uiFSM:TrySwitchState(HackingConfig.ConvertToState(mode))
	self.loadDone = true
end

function HackPanel:__ShowComplete()
	
end

function HackPanel:__Hide()
	if self.hackRamTipsTimer then
		LuaTimerManager.Instance:RemoveTimer(self.hackRamTipsTimer)
		self.hackRamTipsTimer = nil
	end
end

function HackPanel:SafeSetAimEnable(enable)
	self.playAimEnterAnim = false
	self.playAimExitAnim = false
	
	UtilsUI.SetActive(self.HackMainWindow_Aim_miaozhun_Loop, false)
	UtilsUI.SetActive(self.HackMainWindow_Aim_miaozhun_Exit, false)
	UtilsUI.SetActive(self.HackMainWindow_Aim_miaozhun_Open, false)
	
	UtilsUI.SetActive(self.Aim, enable)
	UtilsUI.SetActive(self.HackMainWindow_Aim_Open, false)
	UtilsUI.SetActive(self.HackMainWindow_Aim_Open, true)

	UtilsUI.SetActive(self.SelectedPoint, enable)
	UtilsUI.SetActive(self.tipsObj.gameObject, enable)

end

function HackPanel:HackEntityEnable(instanceId, enable)
	if not self.hasEffect then
		return 
	end
	
	local id = self.hackManager:GetSelectedId()
	if not enable and id == instanceId then
		self:UpdateEffect(instanceId, enable, instanceId)
	else
		self:UpdateEffect(instanceId, enable)
	end
end

function HackPanel:Update()
	if not self.loadDone then
		return 
	end
	
	if self.uiFSM then
		self.uiFSM:Update()
	end
end

function HackPanel:InitTipsItem()
	local item = {}
	item.gameObject = GameObject.Instantiate(self.TipsItem)
	item.transform = item.gameObject.transform
	item.transform:SetParent(self.TipsGroup.transform)
	item.transform:ResetAttr()

	UtilsUI.GetContainerObject(item.transform, item)
	UtilsUI.SetActive(item.gameObject, false)
	
	self.tipsObj = item
	--table.insert(self.tipsObjList, item)
end

function HackPanel:UpdateTipsItem(id, transform)
	--local id = self.hackManager:GetSelectedId()
	--UtilsUI.SetActive(self.tipsObj.gameObject, id ~= nil)
	if not id then
		return
	end
	
	local npcId = BehaviorFunctions.GetEntityEcoId(id)
	local config = self.hackManager:GetHackConfig(id)
	local npcConfig = self.npcManager:GetNpcConfig(npcId)
	
	local name = npcConfig and npcConfig.name or config.Name

	local overrideInfo = self.hackManager:GetOverrideEntityHackInformation(id)

	if overrideInfo then
		name = overrideInfo.title or ""
	end

	if self.tipsObj and config then
		self.tipsObj.TipsText_txt.text = name or ""
	end
	
	--local transform = self.hackManager:GetEntityHackingTransform(id, "HackPoint")
	local pos = transform.position
	local sp = UtilsBase.WorldToUIPointBase(pos.x, pos.y, pos.z)
	if sp.z > 0 then
		UnityUtils.SetLocalPosition(self.tipsObj.transform, sp.x, sp.y + 45 , 0)
	end
end

-- 更新右边侧栏的UI
local ModeToSwitch = {
	[HackMode.Hack] = "HackModeBtn",
	[HackMode.Build] = "BuildModeBtn",
}

local SelectedAlpha = 1
local UnselectedAlpha = 0.5
function HackPanel:UpdateModeSelected(mode)
	local lastMode = self.hackManager:GetHackMode()
	if lastMode == mode then
		return 
	end
	
	self.hackManager:SetHackMode(mode)
	
	--更新模式面板
	local uiName = ModeToSwitch[mode]
	if uiName then
		UtilsUI.SetActive(self.Selected, true)

		local anchoredPosition = self[uiName.."_rect"].anchoredPosition
		UnityUtils.SetAnchoredPosition(self.Selected.transform, anchoredPosition.x, anchoredPosition.y)

		self[uiName.."_canvas"].alpha = SelectedAlpha
		for k, v in pairs(ModeToSwitch) do
			if k ~= mode then
				self[v.."_canvas"].alpha = UnselectedAlpha
			end
		end
	end
end

function HackPanel:GetIconByState(state, default)
	if not default or state == FightEnum.HackOperateState.Forbidden then
		return
	end
	
	if state == FightEnum.HackOperateState.Normal then
		return default[1]
	end

	if state == FightEnum.HackOperateState.Continue then
		return HackingConfig.CancelIcon
	end
end

function HackPanel:HackOperateStateChange(instanceId, state)
end

local btnFuncMap = 
{
	[1] = "ClickUp",
	[2] = "ClickRight",
	[3] = "ClickDown",
	[4] = "ClickLeft",
}

function HackPanel:UpdateOperateButton(id)
	local hackingInputHandleComponent = self.hackManager:GetHackComponent(id)

	if (not hackingInputHandleComponent) or (not hackingInputHandleComponent:HasUseButton()) then
		UtilsUI.SetActive(self.Operation, false)
		return
	end

	UtilsUI.SetActive(self.Operation, true)
	UtilsUI.SetActive(self.HackMainWindow_Operation_Open, true)

	local curRamValue, maxRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)
	for name, key in pairs(HackingConfig.HackingKey) do
		local btnNode = self.operateButton[key]
		local buttonConfig = hackingInputHandleComponent:GetButtonConfig(key)
		local isEmpty = ((not buttonConfig.icon) or buttonConfig.icon == "")
		local sIconPath, uIconPath
		if not isEmpty then
			sIconPath, uIconPath = HackingConfig.GetIconAssetsPath(buttonConfig.icon)
		end

		btnNode.invokeFunc = btnFuncMap[key]

		self:SetSingleOperateButton(btnNode, isEmpty, sIconPath, uIconPath, buttonConfig.Name, buttonConfig.hackingRam, curRamValue)
	end
end

function HackPanel:OnEntityHackActiveStateUpdate(instanceId)
	if self.hackManager:GetSelectedId() == instanceId then
		self:UpdateOperateButton(instanceId)
	end
end

function HackPanel:OnEntityHackButtonEnableUpdate(instanceId)
	if self.hackManager:GetSelectedId() == instanceId then
		self:UpdateOperateButton(instanceId)
	end
end

function HackPanel:OnHackEntityButtonInfoUpdate(instanceId)
	if self.hackManager:GetSelectedId() == instanceId then
		self:UpdateOperateButton(instanceId)
		self:UpdateHackinInfoPanel(instanceId, true)
	end
end

function HackPanel:SetSingleOperateButton(btnNode, empty, sIconPath, uIconPath, text, hackingRam, curRamValue)
	if empty then
		UtilsUI.SetActive(btnNode.RamLow, false)
		UtilsUI.SetActive(btnNode.RamPower, false)
		UtilsUI.SetActive(btnNode.ActionBtn, false)
		UtilsUI.SetActive(btnNode.Empty, true)
	else
		if curRamValue >= hackingRam then
			UtilsUI.SetActive(btnNode.RamLow, false)
			UtilsUI.SetActive(btnNode.RamPower, true)
			UtilsUI.SetActive(btnNode.ActionBtn, true)
		else
			UtilsUI.SetActive(btnNode.RamLow, true)
			UtilsUI.SetActive(btnNode.RamPower, false)
			UtilsUI.SetActive(btnNode.ActionBtn, false)
		end
		
		UtilsUI.SetActive(btnNode.Empty, false)
	end

	btnNode.RamLowButtonName_txt.text = text
	btnNode.RamButtonName_txt.text = text
	
	btnNode.RamLowNum_txt.text = hackingRam
	btnNode.RamNum_txt.text = hackingRam

	if not empty and uIconPath then
		SingleIconLoader.Load(btnNode.RamLowIcon, uIconPath)
		SingleIconLoader.Load(btnNode.RamIcon, uIconPath)
	end
end

function HackPanel:OnCreateEntity(instanceId)
	if self.hackManager:GetHackMode() ~= FightEnum.HackMode.Hack then
		return
	end
	self:UpdateEffect(instanceId, true)
end

local HackEffect = 200001002
--local BoxCanHackEffect = 200001003
local SelectedEffect = 200001004
function HackPanel:UpdateEffect(instanceId, add, selectedId)
	self.curSelectNpc = selectedId
	if not instanceId then
		return 
	elseif not BehaviorFunctions.CheckEntity(instanceId) then
		self.entityEffectMap[instanceId] = nil
		return 
	end

	if self.entityEffectMap[instanceId] then
		BehaviorFunctions.RemoveBuff(instanceId, self.entityEffectMap[instanceId])
		self.entityEffectMap[instanceId] = nil
	end

	if add then
		local hackEffect = self:GetEntityEffect(instanceId, selectedId == instanceId)
		if hackEffect then
			BehaviorFunctions.DoMagic(1, instanceId, hackEffect)
			self.entityEffectMap[instanceId] = hackEffect
		end
	end
end

function HackPanel:UpdateOverrideEffect(instanceId)
	local selectedId = self.hackManager:GetSelectedId()
	if self.entityEffectMap[instanceId] then
		BehaviorFunctions.RemoveBuff(instanceId, self.entityEffectMap[instanceId])
		self.entityEffectMap[instanceId] = nil
	end

	local hackEffect = self:GetEntityEffect(instanceId, selectedId == instanceId)
	if hackEffect then
		BehaviorFunctions.DoMagic(1, instanceId, hackEffect)
		self.entityEffectMap[instanceId] = hackEffect
	end
end

--BehaviorFunctions.DoMagic(1,1,200001001)   施加全黑效果
--BehaviorFunctions.RemoveBuff(1,200001001)  关闭全黑效果

--当前是否使用effect特效
function HackPanel:UpdateHackEffect(enter)
	--local list = self.hackManager:GetHackingTargetList()
	local id = self.hackManager:GetSelectedId()
	if enter and not self.hasEffect then
		BehaviorFunctions.DoMagic(1,1,200001001)
		local list = Fight.Instance.entityManager:GetEntites()
		local ignoreList = {}
		local playerList = Fight.Instance.playerManager:GetPlayerList()
		for k, player in pairs(playerList) do
			local entityList = player:GetEntityList()
			for k, entity in pairs(entityList) do
				ignoreList[entity.instanceId] = true
			end
		end
		local abilityEntity = mod.AbilityWheelCtrl:GetCurCtrlEntity()
		if abilityEntity then
			ignoreList[abilityEntity.instanceId] = true
		end
		
		for instancdId, entity in pairs(list) do
			if not ignoreList[instancdId] then
				self:UpdateEffect(entity.instanceId, true, id)
			end
		end
	elseif not enter and self.hasEffect then
		BehaviorFunctions.RemoveBuff(1,200001001)
		for instanceId, effect in pairs(self.entityEffectMap) do
			self:UpdateEffect(instanceId, false, id)
		end
		TableUtils.ClearTable(self.entityEffectMap)
	end
	self.hasEffect = enter
end

function HackPanel:UpdateSelectedEffect(id, lastId)
	self:UpdateEffect(id, false)
	self:UpdateEffect(lastId, false, lastId)
	
	self:UpdateEffect(lastId, true, id)
	self:UpdateEffect(id, true, id)
	
	if id then
		-- 选中Npc
		if not self.aimSelect then
			--self.AimAnimator_anim:Play("22140_Loop_miaozhun_vx")
		end
		self.aimSelect = true
	else
		-- 离开Npc
		if self.aimSelect then
			--self.AimAnimator_anim:Play("22140_Loop_miaozhun_Exit_vx")
		end
		self.aimSelect = false
	end
	
	
	--TODO:骇入特效
	local ctrlId = BehaviorFunctions.GetCtrlEntity()
	local partnerId = BehaviorFunctions.GetPartner(ctrlId)
	if partnerId and partnerId ~= 0 then
		local partnerEntity = BehaviorFunctions.GetEntity(partnerId)
	end
end

function HackPanel:GetEntityEffect(instanceId, isSelect)
	if not BehaviorFunctions.CheckEntity(instanceId) then
		return nil
	end

	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.buffComponent then
		return
	end

	local isNpc = false
	if entity.tagComponent and entity.tagComponent:IsNpc() then
		isNpc = true
	end

	isSelect = isSelect or false

	local overrideEffect = self.hackManager:GetOverrideEntityEffect(instanceId)

	if overrideEffect then
		return HackingConfig[overrideEffect][isNpc][isSelect]
	end

	if self.hackManager:CheckEntityIsTaskSign(instanceId) then
		--任务目标逻辑
		return HackingConfig.TaskTargetEffect[isNpc][isSelect]
	end

	if entity.tagComponent and not isNpc and entity.tagComponent.camp ~= FightEnum.EntityCamp.Camp1 then
		--敌对目标逻辑
		return HackingConfig.EnmityTargetEffect[isNpc][isSelect]
	end

	local npcId = BehaviorFunctions.GetEntityEcoId(instanceId)
	local recruitInfo = HackingConfig.GetHackRecruitInfo(npcId)
	if recruitInfo and not mod.HackingCtrl.tmprecodeNpc[instanceId] then
		--模拟经营类npc
		return recruitInfo.effect
	end

	if entity.hackingInputHandleComponent then
		--可骇入物逻辑
		return HackingConfig.CanHackingTargetEffect[isNpc][isSelect]
	end
	
	return
	--其他交互逻辑
	--return HackingConfig.OtherTargetEffect[isNpc][isSelect]
end

function HackPanel:AimSelectExitCallback()
end

function HackPanel:AimSelectEnterCallback()
end

function HackPanel:OnEntityHackStateEffectUpdate(instanceId)
	self:UpdateEffect(instanceId, true, self.hackManager:GetSelectedId())
end

--按钮
function HackPanel:OnBack()
	if not self.uiFSM:CloseToNone() then
		BehaviorFunctions.ExitHackingMode()
		return
	end
	
	self.uiFSM:TrySwitchState(HackUIState.HackNone)
end

function HackPanel:ExitHack()
	BehaviorFunctions.ExitHackingMode()
end

function HackPanel:OnSwitchHackMode()
	if self.uiFSM:TrySwitchState(HackUIState.HackNone) then
		self:UpdateModeSelected(HackMode.Hack)
		--UtilsUI.SetActive(self.HackMainWindow_ModeSwitch_BuildModeBtn_Exit, true)
		--UtilsUI.SetActive(self.HackMainWindow_ModeSwitch_HackModeBtn_Click, true)
	end
end

function HackPanel:HackStateChange(instanceId, hackingType, ...)
	local lastId = self.hackManager:GetHackingId()
	if lastId and lastId ~= instanceId then
		local hackComponent = self.hackManager:GetHackComponent(lastId)
		local selectedId = self.hackManager:GetSelectedId()
		if hackComponent then
			if selectedId == instanceId then
				hackComponent:StopHacking(selectedId)
			else
				hackComponent:StopHacking()
			end
		end
		if selectedId == instanceId then
			hackComponent:Hacking()
			self:UpdateOperateButton(selectedId)
		end
	end
	self.hackManager:SetHackingId(instanceId)
	
	local state = HackingConfig.ConvertToState(HackMode.Hack, hackingType)
	self.uiFSM:TrySwitchState(state, instanceId, ...)
end

function HackPanel:OnClickOperateBtn(idx, down, id)
	local hackComponent = self.hackManager:GetHackComponent(id)
	if not hackComponent then
		return 
	end

	local func = self.operateButton[idx].invokeFunc
	if func then
		local isActive, isCostRamSuccess = hackComponent[func](hackComponent, down)
	end
end

function HackPanel:UpdateHacking(id)
	self:UpdateHackinInfoPanel(id)
	self:UpdateOperateButton(id)
	
	local id, lastId = self.hackManager:GetSelectedId()
	if lastId then
		local hackComponent = self.hackManager:GetHackComponent(lastId)
		if hackComponent and hackComponent.entity.instanceId ~= self.hackManager:GetHackingId() then
			hackComponent:StopHacking(id)
		end
	end
	
	if id then
		local hackComponent = self.hackManager:GetHackComponent(id)
		if hackComponent.entity.instanceId ~= self.hackManager:GetHackingId() then
			hackComponent:Hacking()
		end
	end
end

function HackPanel:UpdateSelectedTarget(selectedRange, distance, locationPoint)
	--local id = self.hackManager:UpdateNearestHackingTarget(selectedRange, distance, locationPoint)
	--if not id then
	local id = self.hackManager:GetHackingTarget(selectedRange, distance, locationPoint)
	--end
	self.hackManager:UpdateSelectedId(id)
	local _, lastId = self.hackManager:GetSelectedId()

	UtilsUI.SetActive(self.SelectedPoint, id ~= nil)
	UtilsUI.SetActive(self.tipsObj.gameObject, id ~= nil)

	UtilsUI.SetActive(self.AimUnSelect, id == nil)
	UtilsUI.SetActive(self.AimSelect, id ~= nil)

	if id ~= lastId then
		self:UpdateSelectedEffect(id, lastId)
		self:UpdateHacking(id)
	end

	if id then
		local transform = self.hackManager:GetEntityHackingTransform(id, locationPoint)
		self:UpdateHackingSelectedPoint(id, transform)
		self:UpdateTipsItem(id, transform)
	end
end

-- 更新选中实体点在屏幕的位置
function HackPanel:UpdateHackingSelectedPoint(instanceId, locationTransform)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity then
		local position = locationTransform.position
		local sp = UtilsBase.WorldToUIPointBase(position.x, position.y, position.z)
		UnityUtils.SetLocalPosition(self.SelectedPoint.transform, sp.x, sp.y, 0)
		UnityUtils.SetLocalPosition(self.AimSelect_rect, sp.x, sp.y, 0)
	end
end

-- 更新信息面板
function HackPanel:UpdateHackinInfoPanel(id, fouseUpdate)
	if not fouseUpdate then
		local selectId, lastSelectId = self.hackManager:GetSelectedId()
		if lastSelectId == id then
			return 
		end
	end

	if not id then
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Open, false)
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Exit, true)
		UtilsUI.SetActive(self.Info, false)
		UtilsUI.SetActive(self.OperateShop, false)
		UtilsUI.SetActive(self.HackButtonInfo, false)
		return
	end

	local npcId = BehaviorFunctions.GetEntityEcoId(id)
	local config = self.hackManager:GetHackConfig(id)
	local npcConfig
	if npcId then
		npcConfig = self.npcManager:GetNpcConfig(npcId)
	end
	local recruitInfo = HackingConfig.GetHackRecruitInfo(npcId)
	
	local icon = nil
	if npcConfig and npcConfig.head_icon and npcConfig.head_icon ~= "" then
		icon = npcConfig.head_icon
	else
		icon = config.Icon
	end

	local name = ""
	local desc = ""
	local overrideInfo = self.hackManager:GetOverrideEntityHackInformation(id)

	if overrideInfo then
		name = overrideInfo.title or ""
		desc = overrideInfo.desc or ""
		icon = overrideInfo.icon
	else
		if npcConfig and npcConfig.name and npcConfig.name ~= "" then
			name = npcConfig.name
		else
			name = config.Name
		end
		if npcConfig and npcConfig.desc and npcConfig.desc ~= "" then
			desc = npcConfig.desc
		else
			desc = config.Desc
		end
	end

	if recruitInfo and not mod.HackingCtrl.tmprecodeNpc[id] then
		--经营店铺信息
		UtilsUI.SetActive(self.MessagePanel, true)
		UtilsUI.SetActive(self.Info, false)
		UtilsUI.SetActive(self.OperateShop, true)
		UtilsUI.SetActive(self.EvaluateText, true)
		UtilsUI.SetActive(self.HackButtonInfo, false)
		self.EvaluateText_txt.text = TI18N("评价") .. recruitInfo.evaluate
		self.OperateShopPopulationText_txt.text = recruitInfo.population
		self.OperateShopProfessionText_txt.text = recruitInfo.profession
		self.OperateShopAttitudeText_txt.text = recruitInfo.attitude
		self.OperateShopQualityText_txt.text = recruitInfo.quality
		self.RecruitmentExpensesText_txt.text = recruitInfo.cost

		self.OperateShopNpcName_txt.text = name
		self.OperateShopNpcDesc_txt.text = string.format(TI18N("职业: %s"), recruitInfo.job) 
		UtilsUI.SetActive(self.OperateShopIncome, npcConfig ~= nil)
		if npcConfig then
			if not npcConfig.income or npcConfig.income <= 0 then
				UtilsUI.SetActive(self.OperateShopIncome, false)
			else
				UtilsUI.SetActive(self.OperateShopIncome, true)
				self.OperateShopIncomeText_txt.text = npcConfig.income
			end
		end

		UtilsUI.SetActive(self.OperateShopHeadImg, icon ~= nil)
		if icon then
			SingleIconLoader.Load(self.OperateShopHeadImg, icon)
		end

		local abilityList = recruitInfo.ability_list
		local num
		if #abilityList > #self.operateShopTextItems then
			num = #abilityList
		else
			num = #self.operateShopTextItems
		end
		for i = 1, num do
			local textList = abilityList[i]
			if textList then
				if not self.operateShopTextItems[i] then
					local go = GameObject.Instantiate(self.OperateShopTextItem, self.OperateShopTextGroup_rect)
					local cont = UtilsUI.GetContainerObject(go)
					cont.gameObject = go
					self.operateShopTextItems[i] = cont
				end
				self.operateShopTextItems[i].Title_txt.text = TI18N(textList[1]) .. ":"
				self.operateShopTextItems[i].Context_txt.text = TI18N(textList[2])

				UtilsUI.SetActive(self.operateShopTextItems[i].gameObject, true)
			else
				UtilsUI.SetActive(self.operateShopTextItems[i].gameObject, false)
			end
		end
	else
		UtilsUI.SetActive(self.Info, true)
		UtilsUI.SetActive(self.MessagePanel, true)
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Exit, false)
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Open, true)
		UtilsUI.SetActive(self.OperateShop, false)

		if self.hackInstanceId == id then
			UtilsUI.SetActive(self.HackButtonInfo, false)
		else
			UtilsUI.SetActive(self.HackButtonInfo, true)
		end

		UtilsUI.SetActive(self.MsgHeadIcon, icon ~= nil)
		if icon then
			SingleIconLoader.Load(self.MsgHeadIcon, icon)
		end
	
		self.MsgNameText_txt.text = name
		self.MsgProfessionText_txt.text = desc
		
		UtilsUI.SetActive(self.Income, npcConfig ~= nil)
		if npcConfig then
			if not npcConfig.income or npcConfig.income <= 0 then
				UtilsUI.SetActive(self.Income, false)
			else
				UtilsUI.SetActive(self.Income, true)
				self.IncomeText_txt.text = npcConfig.income
			end
		end

		local entity = BehaviorFunctions.GetEntity(id)
		local hasButtonInfo = false
		--更新面板信息
		for keyName, key in pairs(HackingConfig.HackingKey) do
			local buttonConfig = entity.hackingInputHandleComponent:GetButtonConfig(key)
			if buttonConfig.icon and buttonConfig.icon ~= "" then
				--存在
				local sIconPath, uIconPath
				sIconPath, uIconPath = HackingConfig.GetIconAssetsPath(buttonConfig.icon)

				UtilsUI.SetActive(self["HackButtonInfo" .. key], true)
				local hackButtonInfoCont = self.HackButtonInfoMap[key]
				hackButtonInfoCont.HackButtonInfoText_txt.text = TI18N(buttonConfig.hackingDesc)
				SingleIconLoader.Load(hackButtonInfoCont.HackButtonInfoIcon, uIconPath)
				hasButtonInfo = true
			else
				--不存在
				UtilsUI.SetActive(self["HackButtonInfo" .. key], false)
			end
		end
		if not hasButtonInfo then
			UtilsUI.SetActive(self.HackButtonInfo, false)
		end

		UtilsUI.SetActive(self.EvaluateText, false)
	end
end

function HackPanel:PlayerRamChange()
	local instanceId = self.hackManager:GetSelectedId()
	if instanceId then
		local curRamValue, maxRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)

		local hackingInputHandleComponent = self.hackManager:GetHackComponent(instanceId)

		if (not hackingInputHandleComponent) or (not hackingInputHandleComponent:HasUseButton()) then
			return
		end
	
		for name, key in pairs(HackingConfig.HackingKey) do
			local btnNode = self.operateButton[key]
			local buttonConfig = hackingInputHandleComponent:GetButtonConfig(key)
			local isEmpty = ((not buttonConfig.icon) or buttonConfig.icon == "")

			if not isEmpty then
				local hackingRam = buttonConfig.hackingRam

				if curRamValue < hackingRam then
					--Ram不足
					UtilsUI.SetActive(btnNode.RamLow, true)
					UtilsUI.SetActive(btnNode.RamPower, false)
					UtilsUI.SetActive(btnNode.ActionBtn, false)
				else
					--Ram充足
					UtilsUI.SetActive(btnNode.RamLow, false)
					UtilsUI.SetActive(btnNode.RamPower, true)
					UtilsUI.SetActive(btnNode.ActionBtn, true)
				end
			end
		end

	end
end

function HackPanel:UpdateHackingEntityInfo(instanceId)
	local selectId, lastSelectId = self.hackManager:GetSelectedId()
	if instanceId ~= selectId then
		return
	end

	self:UpdateHackinInfoPanel(instanceId, true)
end

function HackPanel:OnClickOperateShopCommitButton()
	local npcId = BehaviorFunctions.GetEntityEcoId(self.curSelectNpc)
	local recruitInfo = HackingConfig.GetHackRecruitInfo(npcId)
	if recruitInfo then
		BehaviorFunctions.RemoveBuff(self.curSelectNpc, recruitInfo.effect)
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Open, false)
		UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Info_Exit, true)
		UtilsUI.SetActive(self.Info, false)
		UtilsUI.SetActive(self.OperateShop, false)
		mod.HackingCtrl:AddRecode(self.curSelectNpc)
		BehaviorFunctions.RemoveBuff(self.curSelectNpc, SelectedEffect)
	end

	MsgBoxManager.Instance:ShowTips(TI18N("已成功招募NPC"))
end

--骇入的实体消失,清除当前骇入对象
function HackPanel:OnRemoveEntity(instanceId)

end

---受伤时退出骇入状态
function HackPanel:OnEntityHit(atkInstanceId, hitInstanceId, hitType)
	if hitInstanceId == BehaviorFunctions.GetCtrlEntity() then
		MsgBoxManager.Instance:ShowTips(TI18N("骇入被打断"))
		BehaviorFunctions.ExitHackingMode(true)
	end
end

---死亡时退出骇入状态
function HackPanel:OnEntityWillDie(instanceId)
	if instanceId == BehaviorFunctions.GetCtrlEntity() then
		MsgBoxManager.Instance:ShowTips(TI18N("骇入被打断"))
		BehaviorFunctions.ExitHackingMode(true)
	end
end

---死亡时退出骇入状态
function HackPanel:OnEntitySwim(InstanceId)
	if InstanceId == BehaviorFunctions.GetCtrlEntity() then
		MsgBoxManager.Instance:ShowTips(TI18N("骇入被打断"))
		BehaviorFunctions.ExitHackingMode(true)
	end
end

function HackPanel:OnTouchEvent(isRelease, distance)
	if isRelease then
		self.isTouchEvent = false
		self.initDistance = 0
		return
	end

	local camera = CameraManager.Instance.states[FightEnum.CameraState.Monitor]
	self.isTouchEvent = true
	if self.initDistance == 0 then
		self.initDistance = distance
		self.initFovValue = camera.cinemachineCamera.m_Lens.FieldOfView / 45
	end

	local diff = self.initDistance - distance
	if math.abs(diff) <= 5 then
		return
	end

	diff = diff < 0 and diff + 5 or diff - 5
	local value = MathX.Clamp(self.initFovValue + (diff * 0.01), 0.33, 1)
    CinemachineInterface.ChangeFov(camera.camera, value * 45)
end

function HackPanel:OnCameraFovValueChange(value)
	local percent = (1 - value) * 1 / 3 + 0.66
	local fov = 45 * percent

	local camera = CameraManager.Instance.states[FightEnum.CameraState.Monitor]
	CinemachineInterface.ChangeFov(camera.camera, fov)
end

function HackPanel:Test()
	local curFrame = Fight.Instance.fightFrame
	local timerFunc = function()
		local frame = Fight.Instance.fightFrame
		local diff = frame - curFrame
		self:OnTouchEvent(diff == 30, diff * 0.1 + 5)
	end

	LuaTimerManager.Instance:AddTimer(30, 0.1, timerFunc)
end

function HackPanel:OnHackMail(instanceId, mailId, state)
	if self.hackMailId and state then
		self:StopHackMail()
	end

	if state then
		self.hackMailId = mailId
		self:StartHackMail()
	else
		self:StopHackMail()
	end
end

function HackPanel:StartHackMail()
	if not self.hackMailId then
		return
	end

	local id = self.hackManager:GetHackingId()
	local npcId = BehaviorFunctions.GetEntityEcoId(id)
	local mailConfig = HackingConfig.GetHackMailConfig(self.hackMailId)
	self.hackNpcId = npcId
	self.hackInstanceId = id
	
	if not next(mailConfig) then
		self:StopHackMail()
		return
	end

	self.mailList = mailConfig.mail_list
	self.mailStep = 1
	UtilsUI.SetActive(self.MessagePanel, true)
	UtilsUI.SetActive(self.Talk, true)
	UtilsUI.SetActive(self.HackButtonInfo, false)
	UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Talk_Exit, false)
	UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Talk_Open, true)
	
	local npcConfig = self.npcManager:GetNpcConfig(npcId)
	local name = npcConfig and npcConfig.name or ""
	if npcConfig and npcConfig.title ~= "" then
		name = string.format("%s%s", npcConfig.title, name)
	end
	self.MiniTalkName_txt.text = name
	self.hackNpcName = name
	Fight.Instance.entityManager:CallBehaviorFun("NpcHack", self.hackNpcId, FightEnum.NpcHackType.Mail, FightEnum.NpcHackState.Start)
	self:DoHackMailStep()
end

function HackPanel:DoHackMailStep()
	if not self.mailStep or self.mailStep > #self.mailList then
		self:StopHackMail()
		return
	end

	local msgTemp = self:GetMsgTemp()
	msgTemp.objectTransform:SetParent(self.TalkContent.transform)
	UnityUtils.SetLocalScale(msgTemp.objectTransform, 1, 1, 1)

	local isSend = self.mailList[self.mailStep][3]

	UtilsUI.SetActive(msgTemp.Send, self.mailList[self.mailStep][3])
	UtilsUI.SetActive(msgTemp.Recv, not self.mailList[self.mailStep][3])

	if isSend then
		UtilsUI.SetActive(msgTemp.Send, true)
		UtilsUI.SetActive(msgTemp.Recv, false)

		msgTemp.Name_txt.text = self.hackNpcName
		msgTemp.SendMsg_txt.text = self.mailList[self.mailStep][1]
		local lineWidth = msgTemp.SendMsg_txt.preferredWidth + 24
		local vGroup = msgTemp.object:GetComponent(VerticalLayoutGroup)
		vGroup.childAlignment = TextAnchor.UpperRight
		vGroup.padding.right = 10


		if lineWidth < (326 * 0.75) then
			UnityUtils.SetSizeDelata(msgTemp.Send_rect, lineWidth, msgTemp.SendMsg_rect.rect.height)
		else
			UnityUtils.SetSizeDelata(msgTemp.Send_rect, (350 * 0.75), msgTemp.SendMsg_rect.rect.height)
		end
		
		LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
			LayoutRebuilder.ForceRebuildLayoutImmediate(msgTemp.Send_rect)
		end)

	else
		UtilsUI.SetActive(msgTemp.Send, false)
		UtilsUI.SetActive(msgTemp.Recv, true)

		msgTemp.Name_txt.text = self.mailList[self.mailStep][4]
		msgTemp.RecvMsg_txt.text = self.mailList[self.mailStep][1]
		local lineWidth = msgTemp.RecvMsg_txt.preferredWidth + 30
		local vGroup = msgTemp.object:GetComponent(VerticalLayoutGroup)
		vGroup.childAlignment = TextAnchor.UpperLeft
		
		if lineWidth < (328.3 * 0.75) then
			UnityUtils.SetSizeDelata(msgTemp.Recv_rect, lineWidth, msgTemp.RecvMsg_rect.rect.height)
		else
			UnityUtils.SetSizeDelata(msgTemp.Recv_rect, (358.3 * 0.75), msgTemp.RecvMsg_rect.rect.height)
		end
	
		LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
			LayoutRebuilder.ForceRebuildLayoutImmediate(msgTemp.Recv_rect)
		end)
	end

	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.TalkContent_rect)
	end)
	
	UtilsUI.SetActive(msgTemp.object, true)

	local miniMsgTemp = self:GetMsgTemp()
	miniMsgTemp.objectTransform:SetParent(self.MiniTalkContent.transform)
	UnityUtils.SetLocalScale(miniMsgTemp.objectTransform, 1, 1, 1)

	if isSend then
		UtilsUI.SetActive(miniMsgTemp.Send, true)
		UtilsUI.SetActive(miniMsgTemp.Recv, false)

		miniMsgTemp.Name_txt.text = self.hackNpcName
		miniMsgTemp.SendMsg_txt.text = self.mailList[self.mailStep][1]
		local lineWidth = miniMsgTemp.SendMsg_txt.preferredWidth + 24
		local vGroup = miniMsgTemp.object:GetComponent(VerticalLayoutGroup)
		vGroup.childAlignment = TextAnchor.UpperRight
		vGroup.padding.right = 10


		if lineWidth < (326 * 0.75) then
			UnityUtils.SetSizeDelata(miniMsgTemp.Send_rect, lineWidth, miniMsgTemp.SendMsg_rect.rect.height)
		else
			UnityUtils.SetSizeDelata(miniMsgTemp.Send_rect, (350 * 0.75), miniMsgTemp.SendMsg_rect.rect.height)
		end
		
		LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
			LayoutRebuilder.ForceRebuildLayoutImmediate(miniMsgTemp.Send_rect)
		end)

	else
		UtilsUI.SetActive(miniMsgTemp.Send, false)
		UtilsUI.SetActive(miniMsgTemp.Recv, true)

		miniMsgTemp.Name_txt.text = self.mailList[self.mailStep][4]
		miniMsgTemp.RecvMsg_txt.text = self.mailList[self.mailStep][1]
		local lineWidth = miniMsgTemp.RecvMsg_txt.preferredWidth + 30
		local vGroup = miniMsgTemp.object:GetComponent(VerticalLayoutGroup)
		vGroup.childAlignment = TextAnchor.UpperLeft
		
		if lineWidth < (328.3 * 0.75) then
			UnityUtils.SetSizeDelata(miniMsgTemp.Recv_rect, lineWidth, miniMsgTemp.RecvMsg_rect.rect.height)
		else
			UnityUtils.SetSizeDelata(miniMsgTemp.Recv_rect, (358.3 * 0.75), miniMsgTemp.RecvMsg_rect.rect.height)
		end
	
		LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
			LayoutRebuilder.ForceRebuildLayoutImmediate(miniMsgTemp.Recv_rect)
		end)
	end
	UtilsUI.SetActive(miniMsgTemp.object, true)

	-- UtilsUI.SetActive(miniMsgTemp.Send, self.mailList[self.mailStep][3])
	-- UtilsUI.SetActive(miniMsgTemp.Recv, not self.mailList[self.mailStep][3])
	-- miniMsgTemp.RecvMsg_txt.text = self.mailList[self.mailStep][1]
	-- miniMsgTemp.SendMsg_txt.text = self.mailList[self.mailStep][1]
	-- UtilsUI.SetActive(miniMsgTemp.object, true)

	if self.mailTimer then
		LuaTimerManager.Instance:RemoveTimer(self.mailTimer)
		self.mailTimer = nil
	end

	self.mailTimer = LuaTimerManager.Instance:AddTimer(1, self.mailList[self.mailStep][2], self:ToFunc("DoHackMailStep"))
	self.mailStep = self.mailStep + 1
end

function HackPanel:StopHackMail()
	if not self.mailList or not next(self.mailList) then
		return
	end

	local state = self.mailStep > #self.mailList and FightEnum.NpcHackState.Finish or FightEnum.NpcHackState.UnFinish
	Fight.Instance.entityManager:CallBehaviorFun("NpcHack", self.hackNpcId, FightEnum.NpcHackType.Mail, state)
	self.mailList = nil
	self.mailStep = nil
	self.hackMailId = nil
	self.hackNpcId = nil
	self.hackInstanceId = nil

	if self.mailTimer then
		LuaTimerManager.Instance:RemoveTimer(self.mailTimer)
		self.mailTimer = nil
	end

	for i = #self.msgTempOnShow, 1, -1 do
		UtilsUI.SetActive(self.msgTempOnShow[i].object, false)
		local obj = table.remove(self.msgTempOnShow)
		table.insert(self.msgTempPool, obj)
	end

	self:HackStateChange()

	UtilsUI.SetActive(self.MiniTalk, false)
	--UtilsUI.SetActive(self.Talk, false)
	UtilsUI.SetActive(self.HackButtonInfo, true)

	UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Talk_Open, false)
	UtilsUI.SetActive(self.HackMainWindow_MessagePanel_Talk_Exit, true)
end

function HackPanel:GetMsgTemp()
	local obj
	if next(self.msgTempPool) then
		obj = table.remove(self.msgTempPool)
	else
		obj = self:PopUITmpObject("MsgTemp")
	end

	table.insert(self.msgTempOnShow, obj)

	return obj
end

function HackPanel:OnHackPhoneCall(instanceId, callId, state)
	if self.hackPhoneCallId and state then
		self:StopHackPhoneCall()
	end

	if state then
		self.hackPhoneCallId = callId
		self:StartHackPhoneCall()
	else
		self:StopHackPhoneCall()
	end
end

function HackPanel:StartHackPhoneCall()
	if not self.hackPhoneCallId then
		return
	end

	local id = self.hackManager:GetHackingId()
	local npcId = BehaviorFunctions.GetEntityEcoId(id)
	local pcConfig = HackingConfig.GetHackPhoneCallConfig(self.hackPhoneCallId)
	self.hackNpcId = npcId
	self.hackInstanceId = id

	if not next(pcConfig) then
		self:StopHackPhoneCall()
		return
	end

	self.phoneList = pcConfig.phone_call_list
	self.phoneStep = 1

	UtilsUI.SetActive(self.PhoneCall, true)
	UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_out, false)
	UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_in, true)
	UtilsUI.SetActive(self.PhoneCallCaption, true)

	local npcConfig = self.npcManager:GetNpcConfig(npcId)
	local name = npcConfig and npcConfig.name or ""
	if npcConfig and npcConfig.title ~= "" then
		name = string.format("%s%s", npcConfig.title, name)
	end
	self.MiniPhoneCallName_txt.text = name

	self.soundLoaded = 0
	local resList = {}
	table.insert(resList, {path = pcConfig.asset_bank, isSoundBank = true, holeTime = 5, priority = 2})
	local callBack = function()
		if not self.active then
			return
		end

		self.soundLoaded = self.soundLoaded + 1
		if self.soundLoaded == #resList then
			self:DoHackPhoneCallStep()
		end
	end

	Fight.Instance.entityManager:CallBehaviorFun("NpcHack", self.hackNpcId, FightEnum.NpcHackType.PhoneCall, FightEnum.NpcHackState.Start)
	self.assetLoader:AddListener(callBack, 2)
	self.assetLoader:LoadAll(resList)
	-- self:DoHackPhoneCallStep()
end

function HackPanel:HackPhoneOpenPhoneCall()
	UtilsUI.SetActive(self.MiniPhoneCall, false)
	--UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_out, false)
	--UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_in, true)

	self.PhoneCall_anim:Play("UI_HackMainWindow_MessagePanel_PhoneCall_in", 0, 0)
end

function HackPanel:HackPhoneOpenMiniPhoneCall()
	UtilsUI.SetActive(self.MiniPhoneCall, true)
end

function HackPanel:DoHackPhoneCallStep()
	if not self.phoneStep or self.phoneStep > #self.phoneList then
		self:StopHackPhoneCall()
		return
	end

	if self.phoneCallTimer then
		LuaTimerManager.Instance:RemoveTimer(self.phoneCallTimer)
		self.phoneCallTimer = nil
	end

	SoundManager.Instance:PlaySound(self.phoneList[self.phoneStep][1])
	self.Caption_txt.text = string.format("%s:<color=#FFFFFF>%s</color>", self.phoneList[self.phoneStep][4], self.phoneList[self.phoneStep][2])
	self.phoneCallTimer = LuaTimerManager.Instance:AddTimer(1, self.phoneList[self.phoneStep][3], self:ToFunc("DoHackPhoneCallStep"))
	self.phoneStep = self.phoneStep + 1
end

function HackPanel:StopHackPhoneCall()
	if not self.phoneList or not next(self.phoneList) then
		return
	end

	local state = self.phoneStep > #self.phoneList and FightEnum.NpcHackState.Finish or FightEnum.NpcHackState.UnFinish
	Fight.Instance.entityManager:CallBehaviorFun("NpcHack", self.hackNpcId, FightEnum.NpcHackType.PhoneCall, state)
	self.phoneList = nil
	self.phoneStep = nil
	self.hackPhoneCallId = nil

	if self.phoneCallTimer then
		LuaTimerManager.Instance:RemoveTimer(self.phoneCallTimer)
		self.phoneCallTimer = nil
	end

	self:HackStateChange()

	UtilsUI.SetActive(self.MiniPhoneCall, false)
	--UtilsUI.SetActive(self.PhoneCall, false)
	UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_in, false)
	UtilsUI.SetActive(self.UI_HackMainWindow_MessagePanel_PhoneCall_out, true)
	UtilsUI.SetActive(self.PhoneCallCaption, false)
end

--事件
function HackPanel:BGBeginDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
end

function HackPanel:BGDrag(data)
	FightMainUIView.bgInput.x = data.delta.x
	FightMainUIView.bgInput.y = data.delta.y
	self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenMove)
end

function HackPanel:BGEndDrag(data)
	FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
	self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenMove)
end

function HackPanel:BGDown()
	self.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
end

function HackPanel:BGUp()
	self.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
end

function HackPanel:OnStoryDialogStart()
	-- self:OnSwitchHackMode()
	-- BehaviorFunctions.ExitHackingMode()
end

function HackPanel:HackerBatteryLow(hackingKey)
	local effect = self.operateButton[hackingKey].HackOperationLowBatteryEffect
	local layer = WindowManager.Instance:GetCurOrderLayer()
	UtilsUI.SetEffectSortingOrder(effect, layer + 1)
	UtilsUI.SetActive(effect, true)
end

function HackPanel:ShowHackRamTips(isSuccess)
	if self.hackRamTipsTimer then
		LuaTimerManager.Instance:RemoveTimer(self.hackRamTipsTimer)
		self.hackRamTipsTimer = nil
	end
	
	if isSuccess then
		UtilsUI.SetActive(self.HackingRamLowTips, false)
		UtilsUI.SetActive(self.HackingRamSuccessTips, true)
		self.hackRamTipsTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
			UtilsUI.SetActive(self.HackingRamSuccessTips, false)
		end)
	else
		UtilsUI.SetActive(self.HackingRamLowTips, true)
		UtilsUI.SetActive(self.HackingRamSuccessTips, false)
		self.hackRamTipsTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
			UtilsUI.SetActive(self.HackingRamLowTips, false)
		end)
	end
end

function HackPanel:OnActionInputEnd(key, value)
	if key == FightEnum.KeyEvent.HackUpButton then
		self:OnClickOperateBtn(HackingConfig.HackingKey.Up, true)
	end
end

-- 监听InputSystem的事件
function HackPanel:OnActionInput(key, value)
	if key == FightEnum.KeyEvent.HackUpButton then
	elseif key == FightEnum.KeyEvent.HackDownButton then
		self:OnClickOperateBtn(HackingConfig.HackingKey.Down, true)
	elseif key == FightEnum.KeyEvent.HackLeftButton then
		self:OnClickOperateBtn(HackingConfig.HackingKey.Left, true)
	elseif key == FightEnum.KeyEvent.HackRightButton then
		self:OnClickOperateBtn(HackingConfig.HackingKey.Right, true)
	-- elseif key == FightEnum.KeyEvent.HackQuitMonitor and self.uiFSM:IsState(HackUIState.HackCamera) then
	-- 	self.uiFSM:CloseToNone()
	-- 	self.uiFSM:TrySwitchState(HackUIState.HackNone)
	elseif key == FightEnum.KeyEvent.MonitorZoom then
		if self.uiFSM:IsState(HackUIState.HackCamera) then
			local curValue = self.cameraFovScroller.value
			curValue = MathX.Clamp(curValue + (value.y / 1000.0), 0, 1)
			self.cameraFovScroller.value = curValue 
		end
	end
end