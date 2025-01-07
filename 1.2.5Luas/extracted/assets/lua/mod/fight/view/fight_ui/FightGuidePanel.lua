FightGuidePanel = BaseClass("FightGuidePanel", BasePanel)

local GuideTypeToPointer = {
	[FightEnum.GuideType.FightTarget] = "FightTarget",
	[FightEnum.GuideType.TreasureBox] = "TreasureBox",
	[FightEnum.GuideType.Transport] = "Transport",
}

local FightTargetEffect = "22024"

function FightGuidePanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightGuidePanel.prefab")
	self.mainView = mainView

	self.taskGuideId = 0
	self.taskGuidePointer = {}

	self.cachePointer = {}
	self.idToPointer = {}
	self.parentGroup = {}

	self.hideGuides = {}
	self.hideDisGuides = {}
	self.curGuideTaskProgress = nil

	-- 给策划调用的时候 强制屏蔽任务的指引
	self.forceTipsGuide = false

	-- tips子节点
	self.subTipsOnShow = {}
	self.subTipsCaches = {}

	self.titleTimer = nil
	self.subTipsTimer = {}
end

function FightGuidePanel:__BindEvent()
	EventMgr.Instance:AddListener(EventName.SetTaskGuideDisState, self:ToFunc("SetTaskGuideDisState"))
	EventMgr.Instance:AddListener(EventName.SetGuideState, self:ToFunc("SetGuideState"))
	EventMgr.Instance:AddListener(EventName.SetForceGuideState, self:ToFunc("SetForceGuideState"))
	EventMgr.Instance:AddListener(EventName.AddGuidePointer, self:ToFunc("AddGuidePointer"))
	EventMgr.Instance:AddListener(EventName.RemoveGuidePointer, self:ToFunc("RemoveGuidePointer"))
	EventMgr.Instance:AddListener(EventName.GuideTaskChange, self:ToFunc("GuideTaskChange"))
	EventMgr.Instance:AddListener(EventName.GuideDelayAnim, self:ToFunc("DelayAnim"))
	EventMgr.Instance:AddListener(EventName.UpdateMercenaryGuid, self:ToFunc("UpdateMercenaryGuid"))
	EventMgr.Instance:AddListener(EventName.UpdateMainId, self:ToFunc("ShowMercenaryGuid"))
end

function FightGuidePanel:__BindListener()
	self.TipPart_btn.onClick:AddListener(self:ToFunc("OnClickShowGuide"))
	self.MercenaryGuid_btn.onClick:AddListener(self:ToFunc("OnClickMercenaryGuid"))
	EventMgr.Instance:AddListener(EventName.OnCastSkill, self:ToFunc("OnEnemyCastSkill"))
end

function FightGuidePanel:__Create()
	self.textWidth = 195
	self.subTextWidth = 143
end

function FightGuidePanel:__Show()
	-- UtilsUI.SetEffectSortingOrder(self["21056"], self.canvas.sortingOrder + 1)
	if self.idToPointer and next(self.idToPointer) then
		self:RemoveAllGuidePointer()
	end
end

function FightGuidePanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()

	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	self.TipPart:SetActive(guideTask ~= nil)
	self.LogicGuide:SetActive(true)

	self:ShowMercenaryGuid()

	self.fightGuidePointerManager = self.mainView.clientFight.fightGuidePointerManager
	local keys = self.fightGuidePointerManager:GetAllPointerKey()
	for key, value in pairs(keys) do
		self:AddGuidePointer(value)
	end
end

function FightGuidePanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.SetTaskGuideDisState, self:ToFunc("SetTaskGuideDisState"))
	EventMgr.Instance:RemoveListener(EventName.SetGuideState, self:ToFunc("SetGuideState"))
	EventMgr.Instance:RemoveListener(EventName.SetForceGuideState, self:ToFunc("SetForceGuideState"))
	EventMgr.Instance:RemoveListener(EventName.AddGuidePointer, self:ToFunc("AddGuidePointer"))
	EventMgr.Instance:RemoveListener(EventName.RemoveGuidePointer, self:ToFunc("RemoveGuidePointer"))
	EventMgr.Instance:RemoveListener(EventName.GuideTaskChange, self:ToFunc("GuideTaskChange"))
	EventMgr.Instance:RemoveListener(EventName.GuideDelayAnim, self:ToFunc("DelayAnim"))
	EventMgr.Instance:RemoveListener(EventName.UpdateMercenaryGuid, self:ToFunc("UpdateMercenaryGuid"))
	EventMgr.Instance:RemoveListener(EventName.UpdateMainId, self:ToFunc("ShowMercenaryGuid"))
end

function FightGuidePanel:__Hide()
	self.curGuideTaskProgress = nil
	self:RemoveAllGuidePointer()
	self:RemoveAllTimer()

	for k, v in pairs(self.subTipsOnShow) do
		local temp = table.remove(self.subTipsOnShow)
		table.insert(self.subTipsCaches, temp)
	end

	if self.hunterProgressBar then
	 	self.hunterProgressBar:OnCache()
		self.hunterProgressBar = nil
	end
end

function FightGuidePanel:Update()
	if not self.fightGuidePointerManager.curEntity then
		return
	end
	for guideType, v in pairs(self.idToPointer) do
		self:UpdateGuidePointers(v, guideType)

		if self.hideGuides and self.hideGuides[guideType] and self.parentGroup[guideType] then
			self.parentGroup[guideType]:SetActive(false)
		elseif self.parentGroup[guideType] then
			self.parentGroup[guideType]:SetActive(true)
		end

		-- if not self.hideGuides or not self.hideGuides[guideType] then
		-- 	self:UpdateGuidePointers(v, guideType)
		-- else
		-- 	for index, pointer in pairs(v) do
		-- 		UtilsUI.SetActive(pointer.object, false)
		-- 	end
		-- end
	end

	if self.waitChangeTaskGuide and (self.active and self.mainView and self.mainView.active) then
		self.waitChangeTaskGuide = false
		self:GuideTaskChange()
	end
end

function FightGuidePanel:UpdateGuidePointers(pointers, guideType)
	local taskGuideDis
	for index, pointer in pairs(pointers) do
		local showType, pos, showDistance, disDesc = self.fightGuidePointerManager:CalaPointerPos(index, guideType)
		if showType ~= FightEnum.PointerShowType.Hide then
			UnityUtils.SetLocalPosition(pointer.objectTransform, pos.x, pos.y, pos.z)

			if showType ~= FightEnum.PointerShowType.ShowAndHideArrow then
				local rot = Quat.AngleAxis(Vector2.SignedAngle(Vector2.right, Vector2(pos.x, pos.y)), Vec3.forward)
				local arrow = guideType ~= FightEnum.GuideType.FightTarget and pointer.Arrow.transform or pointer.FightTarget.transform
				UnityUtils.SetRotation(arrow, rot.x, rot.y, rot.z, rot.w)
			end

			if guideType ~= FightEnum.GuideType.FightTarget then
				self:UpdateGuideDistance(pointer, showDistance, disDesc)
			end
		end
		
		if pointer.object.activeSelf and guideType == FightEnum.GuideType.FightTarget and 
			pointer.playEffect and showType == FightEnum.PointerShowType.Hide then
			pointer.readyHide = true
		else
			UtilsUI.SetActive(pointer.object, showType ~= FightEnum.PointerShowType.Hide)
		end
		
		UtilsUI.SetActive(pointer.Arrow, showType ~= FightEnum.PointerShowType.ShowAndHideArrow and guideType ~= FightEnum.GuideType.FightTarget)

		if guideType == FightEnum.GuideType.Task then
			if not self.curGuideTaskProgress then
				self:GuideTaskChange()
			end
			if self.curGuideTaskProgress and pointer.config.progress == self.curGuideTaskProgress then
				taskGuideDis = disDesc
			end
		end
		
		if guideType == FightEnum.GuideType.FightTarget then
			if not pointer.object.activeSelf then
				pointer.FightTargetArrow_anim.enabled = false
				pointer.FightTargetArrow_img.color = Color(1, 1, 1)
				if pointer.FightTargetEffect.activeSelf then
					pointer.FightTargetEffect:SetActive(false)
				end
			elseif pointer.readyHide then
				if not pointer.playEffect then
					pointer.readyHide = false
					UtilsUI.SetActive(pointer.object, false)
				end
			elseif pointer.playEffect then
				pointer.FightTargetArrow_anim.enabled = true
				pointer.FightTargetArrow_anim:Play("FightTarget_")
			end
		end
	end

	self:UpdateTaskInfo(taskGuideDis)
end

function FightGuidePanel:UpdateGuideDistance(pointer, showDistance, disDesc)
	UtilsUI.SetActive(pointer.GuideDis, showDistance)
	if showDistance then
		pointer.GuideDis_txt.text = disDesc
	end
end

function FightGuidePanel:UpdateTaskInfo(disDesc)
	if self.forceTipsGuide or not disDesc or not self.TipPart.activeSelf then
		return
	end

	self.TaskTipDis_txt.text = disDesc
end

function FightGuidePanel:AddGuidePointer(index)
	if not self.active then
		return
	end

	local config = self.fightGuidePointerManager:GetPointer(index)
	if not config then
		return
	end

	local pointer = self:GetPointer()
	pointer.config = config
	pointer.FightTarget:SetActive(config.guideType == FightEnum.GuideType.FightTarget)
	pointer.PointerEffect:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget)
	pointer.IconBg:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget)
	pointer.Arrow:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget)
	if config.guideType ~= FightEnum.GuideType.FightTarget then
		if config.guideType == FightEnum.GuideType.Task then
			self:OnClickShowGuide()
		end
		SingleIconLoader.Load(pointer.GuideIcon, self.fightGuidePointerManager:GetPointerIcon(index))
	end

	if not self.idToPointer[config.guideType] then
		local go = GameObject.Instantiate(self.TypeNode)
		go.name = tostring(config.guideType)
		go.transform:SetParent(self.PointerParent_rect)
		go.transform:ResetAttr()
		self.parentGroup[config.guideType] = go.transform
		self.idToPointer[config.guideType] = {}
	end
	pointer.objectTransform:SetParent(self.parentGroup[config.guideType])
	UnityUtils.SetLocalScale(pointer.objectTransform, 1,1,1)
	self.idToPointer[config.guideType][index] = pointer
end

function FightGuidePanel:RemoveGuidePointer(index)
	local config = self.fightGuidePointerManager:GetPointer(index)
	if not config then
		return
	end
	
	local pointer = TableUtils.GetParam(self.idToPointer, nil, config.guideType, index)
	if not pointer then
		return
	end
	
	UnityUtils.SetActive(pointer.object, false)
	-- pointer.object:SetActive(false)
	pointer.config = nil
	pointer.showTask = false
	table.insert(self.cachePointer, pointer)
	self.idToPointer[config.guideType][index] = nil
end

function FightGuidePanel:RemoveAllGuidePointer()
	if not self.idToPointer or not next(self.idToPointer) then
		return
	end

	for type, pointers in pairs(self.idToPointer) do
		for k, v in pairs(pointers) do
			v.object:SetActive(false)
			v.config = nil
			v.showTask = false
			table.insert(self.cachePointer, v)
			pointers[k] = nil
		end

		TableUtils.ClearTable(self.idToPointer[type])
	end
end

function FightGuidePanel:GuideTaskChange()
	if not self.active or not self.mainView or not self.mainView.active then
		self.waitChangeTaskGuide = true
		return
	end

	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	UtilsUI.SetActive(self.TipPart, guideTask and next(guideTask))
	if guideTask and next(guideTask) then
		if not self.forceTipsGuide then
			self.TaskTip_txt.text = mod.TaskCtrl:GetGuideTaskDesc()[1]
		end

		self.curGuideTaskProgress = guideTask.guideProgress
		local icon = AssetConfig.GetTaskTypeIcon(guideTask.taskConfig.type)
		SingleIconLoader.Load(self.TaskIcon, icon)
	else
		self.curGuideTaskProgress = nil
	end
end

function FightGuidePanel:OnClickShowGuide()
	self.mainView:KeyAutoUp(FightEnum.KeyEvent.Common3)
	if not self.idToPointer or not self.idToPointer[FightEnum.GuideType.Task] then
		return
	end

	local showGuide = not self.forceHideGuides or not self.forceHideGuides[type]

	if showGuide then
		self:SetGuideState(FightEnum.GuideType.Task, false)
		self:Update()--确保重新激活播放特效
		self:SetGuideState(FightEnum.GuideType.Task, true)
	end

	self:SetTaskGuideDisState(true)
end

function FightGuidePanel:OnClickMercenaryGuid()
	WindowManager.Instance:OpenWindow(AdvMainWindowV2,{type = SystemConfig.AdventurePanelType.MercenaryTask})
end

function FightGuidePanel:SetGuideState(type, state)
	if not self.active or not self.mainView or not self.mainView.active then
		return
	end

	if self.forceHideGuides and self.forceHideGuides[type] and state then
		return
	end

	self.hideGuides[type] = not state
end

-- 策划接口调用的 强制屏蔽pointer
function FightGuidePanel:SetForceGuideState(type, state)
	if not self.active or not self.mainView or not self.mainView.active then
		return
	end

	if not self.forceHideGuides then
		self.forceHideGuides = {}
	end

	self.forceHideGuides[type] = not state
	self:SetGuideState(type, state)
end

function FightGuidePanel:SetTaskGuideDisState(state)
	if not self.active then
		return
	end

	self.TaskTipDis:SetActive(state)
end

function FightGuidePanel:GetPointer()
	if self.cachePointer and next(self.cachePointer) then
		return table.remove(self.cachePointer)
	end

	local pointer = self:PopUITmpObject("GuidePointer")
	UtilsUI.GetContainerObject(pointer.objectTransform, pointer)
	
	pointer.FightTargetEffect = pointer.FightTargetArrow.transform:Find(FightTargetEffect).gameObject
	pointer.FightTargetArrow_anim.enabled = false

	--pointer.objectTransform:SetParent(self.PointerParent.transform)
	--pointer.objectTransform.localScale = Vector3(1, 1, 1)
	pointer.object:SetActive(true)
	return pointer
end

function FightGuidePanel:DelayAnim(anim, showTip)
	if showTip ~= nil then
		self.TipPart:SetActive(showTip)
	end

	local widthScale = self.TaskTip_rect.sizeDelta.x / self.subTextWidth
	UnityUtils.SetLocalScale(self.effect_rect, widthScale, 1.4, 1)
	UnityUtils.SetLocalScale(self.GuideEffect_rect, widthScale, 1.4, 1)
	UnityUtils.SetActive(self.GuideEffect, false)

	if anim then
		self.TaskGuide_ShowNode:SetActive(anim)
	else
		local timerFunc = function ()
			UnityUtils.SetActive(self.GuideEffect, true)

			LuaTimerManager.Instance:RemoveTimer(self.titleTimer)
			self.titleTimer = nil
		end

		if self.titleTimer then
			LuaTimerManager.Instance:RemoveTimer(self.titleTimer)
			self.titleTimer = nil
		end

		self.titleTimer = LuaTimerManager.Instance:AddTimer(1, 0.03, timerFunc)
	end
end

function FightGuidePanel:OnEnemyCastSkill(instanceId, play)
	local pointers = self.idToPointer[FightEnum.GuideType.FightTarget]
	if not pointers then
		return 
	end
	for index, pointer in pairs(pointers) do
		local alarm = self.fightGuidePointerManager:CheckPointerAttackAlarm(index, instanceId)
		if alarm then
			pointer.playEffect = play
			if pointer.object.activeSelf then
				if play then
					pointer.FightTargetArrow_anim.enabled = true
					pointer.FightTargetArrow_anim:Play("FightTarget_")
				else
					pointer.FightTargetArrow_anim.enabled = false
					if pointer.FightTargetEffect.activeSelf then
						pointer.FightTargetEffect:SetActive(false)
					end
					pointer.FightTargetArrow_img.color = Color(1, 1, 1)
				end
			end
		end
	end
end

function FightGuidePanel:CheckFightTargetArrowEffect(instanceId)
	local pointers = self.idToPointer[FightEnum.GuideType.FightTarget]
	if not pointers then
		return
	end
	for index, pointer in pairs(pointers) do
		local alarm = self.fightGuidePointerManager:CheckPointerAttackAlarm(index, instanceId)
		if alarm then
			return pointer.playEffect or false
		end
	end

	return false
end

function FightGuidePanel:SetTipGuideState(state)
	UtilsUI.SetActive(self.TipPart, state)
end

function FightGuidePanel:SetTipsGuideDesc(tipsConfig, ...)
	-- 如果没有显示指引子目标 也没有tipsConfigs就返回
	if not self.forceTipsGuide and (not tipsConfig or not next(tipsConfig)) then
		return
	end

	-- 先回收一下之前的tips 以及停掉对应的timer
	for k, v in pairs(self.subTipsTimer) do
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[k])
		self.subTipsTimer[k] = nil
	end

	for i = #self.subTipsOnShow, 1, -1 do
		local temp = table.remove(self.subTipsOnShow)
		temp.object:SetActive(false)
		table.insert(self.subTipsCaches, temp)
	end

	local layerOutFunc = function()
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipPart.transform)
	end

	self.forceTipsGuide = (tipsConfig ~= nil and next(tipsConfig))
	if not self.forceTipsGuide then
		local guideTask = Fight.Instance.taskManager:GetGuideTask()
		UtilsUI.SetActive(self.SubTipsGroup, false)
		UtilsUI.SetActive(self.TraceIcon, false)
		UtilsUI.SetActive(self.TaskIcon, true)
		UtilsUI.SetActive(self.TaskTipDis, true)
		self.TipPart_btn.interactable = true
		local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
		if isOpen then
			UtilsUI.SetActive(self.MercenaryGuid, true)
		end
		UtilsUI.SetActive(self.TipPart, guideTask ~= nil)
		if guideTask and next(guideTask) then
			self.TaskTip_txt.text = mod.TaskCtrl:GetGuideTaskDesc()[1]
			local icon = AssetConfig.GetTaskTypeIcon(guideTask.taskConfig.type)
			SingleIconLoader.Load(self.TaskIcon, icon)
		end
		LuaTimerManager.Instance:AddTimer(1, 0.01, layerOutFunc)
		return
	end

	if not self.TipPart.activeSelf then
		UtilsUI.SetActive(self.TipPart, true)
	end

	UtilsUI.SetActive(self.SubTipsGroup, true)
	UtilsUI.SetActive(self.TraceIcon, true)
	UtilsUI.SetActive(self.TaskIcon, false)
	UtilsUI.SetActive(self.TaskTipDis, false)
	
	self.TipPart_btn.interactable = false

	UtilsUI.SetActive(self.MercenaryGuid, false)

	self.TaskTip_txt.text = string.format(tipsConfig.content, ...)
	for i = 1, #tipsConfig.sub_content do
		local obj = self:GetSubTipsTemp()
		obj.SubTipsTemp_txt.text = tipsConfig.sub_content[i]
		obj.object:SetActive(true)

		table.insert(self.subTipsOnShow, obj)
	end
	LuaTimerManager.Instance:AddTimer(1, 0.01, layerOutFunc)
	local timerFunc = function()
		self:DelayAnim(true)

		LuaTimerManager.Instance:RemoveTimer(self.titleTimer)
		self.titleTimer = nil
	end

	if self.titleTimer then
		LuaTimerManager.Instance:RemoveTimer(self.titleTimer)
		self.titleTimer = nil
	end

	self.titleTimer = LuaTimerManager.Instance:AddTimer(1, 0.03, timerFunc)
end

function FightGuidePanel:GetSubTipsTemp()
	if self.subTipsCaches and next(self.subTipsCaches) then
		return table.remove(self.subTipsCaches)
	end

	local obj = self:PopUITmpObject("SubTipsTemp")
	UtilsUI.GetContainerObject(obj.objectTransform, obj)
	obj.objectTransform:SetParent(self.SubTipsGroup.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function FightGuidePanel:ShowMercenaryGuid()
	self.mainId = mod.MercenaryHuntCtrl:GetMainId()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
	UtilsUI.SetActive(self.MercenaryGuid,isOpen)
	if isOpen and self.mainId > 0 then
		self:InitMercenaryBar()
		self:UpdateMercenaryGuid()
	end
end

function FightGuidePanel:UpdateMercenaryGuid(tipsId)
	self:InitMercenaryBar()
	local reward_count = MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId) and MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId).reward_count or 4
    self.DailyProgressText_txt.text = TI18N("每日奖励") .. mod.MercenaryHuntCtrl:GetRewardTime() .. "/" .. reward_count
	if not Fight.Instance.mercenaryHuntManager:CheckNearbyMercenary() then
		self.hunterProgressBar:SetLoopEffect(false)
	else
		self.hunterProgressBar:SetLoopEffect(true)
	end
	if tipsId and tipsId > 0 then
		local timerFunc = function()
			LuaTimerManager.Instance:RemoveTimer(self.tipsTimer)
			self.tipsTimer = nil
			self:UpdateMercenaryGuid()
		end
		UtilsUI.SetActive(self.DescText,true)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(tipsId).tip
		self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, 3, timerFunc)
		return
	end
	if self.tipsTimer ~= nil then return end
    if Fight.Instance.mercenaryHuntManager:CheckNearbyMercenary() then
		UtilsUI.SetActive(self.DescText,true)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(4).tip
    elseif mod.MercenaryHuntCtrl:CheckHasMercenaryChase() then
		UtilsUI.SetActive(self.DescText,true)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(6).tip
	else
		UtilsUI.SetActive(self.DescText,false)
    end
end

function FightGuidePanel:InitMercenaryBar()
	if self.hunterProgressBar == nil then
		self.hunterProgressBar = Fight.Instance.objectPool:Get(HunterProgressBar)
    	self.hunterProgressBar:init(self.HunterProgress)
	end
end

function FightGuidePanel:ChangeTitleTipsDesc(tipId, ...)
	if not self.forceTipsGuide then
		return
	end

	local tipsConfig = Config.DataTips.data_tips[tipId]
	if not tipsConfig or not next(tipsConfig) then
		return
	end

	local desc = tipsConfig.content
	desc = string.format(desc, ...)
	self.TaskTip_txt.text = desc

	self:DelayAnim(false)
end

function FightGuidePanel:ChangeSubTipsDesc(index, tipId, ...)
	if not self.forceTipsGuide or not self.subTipsOnShow[index] then
		return
	end

	local tipsConfig = Config.DataTips.data_tips[tipId]
	if not tipsConfig or not next(tipsConfig) then
		return
	end

	local desc = tipsConfig.sub_content[index]
	desc = string.format(desc, ...)
	self.subTipsOnShow[index].SubTipsTemp_txt.text = desc

	local timerFunc = function()
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil

		if not self.subTipsOnShow[index] then
			return
		end

		local length = self.subTipsOnShow[index].SubTipsTemp_rect.sizeDelta.x / self.subTextWidth
		UnityUtils.SetLocalScale(self.subTipsOnShow[index].SubTipsEffect_rect, length, 1, 1)
		UnityUtils.SetActive(self.subTipsOnShow[index].SubTipsEffect, true)
	end

	if self.subTipsTimer[index] then
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil
	end

	UnityUtils.SetActive(self.subTipsOnShow[index].SubTipsEffect, false)
	local timer = LuaTimerManager.Instance:AddTimer(1, 0.03, timerFunc)
	self.subTipsTimer[index] = timer
end

function FightGuidePanel:RemoveAllTimer()
	for k, v in pairs(self.subTipsTimer) do
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[k])
		self.subTipsTimer[k] = nil
	end

	if self.titleTimer then
		LuaTimerManager.Instance:RemoveTimer(self.titleTimer)
		self.titleTimer = nil
	end
end