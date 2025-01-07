FightGuidePanel = BaseClass("FightGuidePanel", BasePanel)


--todo 240522:记录
--[[
1.正常任务
2.猎手（隐藏
2.挑战玩法
3.多任务(隐藏
4.占用
5.章节奖励（隐藏）
]] 
local GuideTypeToPointer = {
	[FightEnum.GuideType.FightTarget] = "FightTarget",
	[FightEnum.GuideType.TreasureBox] = "TreasureBox",
	[FightEnum.GuideType.Transport] = "Transport",
}

local FightTargetEffect = "22024"

function FightGuidePanel:__init(mainView)
	self:SetAsset("Prefabs/UI/Fight/FightGuidePanel.prefab")
	self.mainView = mainView

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
	EventMgr.Instance:AddListener(EventName.UpdatePromoteInfo, self:ToFunc("UpdateMercenaryGuid"))
	EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
	EventMgr.Instance:AddListener(EventName.LeaveDuplicate, self:ToFunc("LeaveDuplicate"))
	EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("UpdateMulTargetsTask"))
	EventMgr.Instance:AddListener(EventName.OutPrison, self:ToFunc("OutPrison"))
	EventMgr.Instance:AddListener(EventName.MulTaskChange, self:ToFunc("ChangeTask"))
	EventMgr.Instance:AddListener(EventName.ShowLevelOccupancyTips, self:ToFunc("ShowLevelOccupancyTips"))
	EventMgr.Instance:AddListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end

function FightGuidePanel:__BindListener()
	self.TipPart_btn.onClick:AddListener(self:ToFunc("OnClickShowGuide"))
	self.MercenaryGuid_btn.onClick:AddListener(self:ToFunc("OnClickMercenaryGuid"))
	self.Box_btn.onClick:AddListener(self:ToFunc("OnClickOpenTaskChapterWindow"))
	self.ChangeTaskBtn_btn.onClick:AddListener(self:ToFunc("OnClickChangeTask"))--切换任务
	self.LevelPart_btn.onClick:AddListener(self:ToFunc("OnClickLevelPart"))
	EventMgr.Instance:AddListener(EventName.OnCastSkill, self:ToFunc("OnEnemyCastSkill"))
end

function FightGuidePanel:__Create()
	self.textWidth = 195
	self.subTextWidth = 143
end

function FightGuidePanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightGuidePanel:__Show()
	self.playableDirector = self.TaskGuide_ShowNode:GetComponent(PlayableDirector)
	if self.idToPointer and next(self.idToPointer) then
		self:RemoveAllGuidePointer()
	end
end

function FightGuidePanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()

	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	self:SetTipGuideState(guideTask ~= nil and not mod.CrimeCtrl:CheckInPrison())
	self.LogicGuide:SetActive(true)

	self:ShowMercenaryGuid()
	self:GuideTaskChange()
	
	self.fightGuidePointerManager = self.mainView.clientFight.fightGuidePointerManager
	local keys = self.fightGuidePointerManager:GetAllPointerKey()
	for key, value in pairs(keys) do
		self:AddGuidePointer(value)
	end

	if guideTask and guideTask.taskConfig then
		local taskConfigMap = guideTask.taskConfig.map_id
		local mapId = Fight.Instance:GetFightMap()

		-- 显示导航点在其他区域
		if taskConfigMap ~= mapId then
			self:UpdateTaskInfo("")

			self:UpdateTaskInfo()
			if #self.subTipsOnShow == 0 then
				local obj = self:GetSubTipsTemp()
				obj.object:SetActive(true)
				self.subTipsOnShow[1] = { obj = obj }
			end
			self.subTipsOnShow[1].obj.SubTipsTemp_txt.text = TI18N(string.format("目标在%s地区！",Config.DataMap.data_map[taskConfigMap].name))
			UtilsUI.SetActive(self.subTipsOnShow[1].obj.FinishIcon, false)
			UtilsUI.SetTextColor(self.subTipsOnShow[1].obj.SubTipsTemp_txt, "#ffffff")
		end
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
	EventMgr.Instance:RemoveListener(EventName.UpdatePromoteInfo, self:ToFunc("UpdateMercenaryGuid"))
	EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
	EventMgr.Instance:RemoveListener(EventName.LeaveDuplicate, self:ToFunc("LeaveDuplicate"))
	EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("UpdateMulTargetsTask"))
	EventMgr.Instance:RemoveListener(EventName.MulTaskChange, self:ToFunc("ChangeTask"))
	EventMgr.Instance:RemoveListener(EventName.ShowLevelOccupancyTips, self:ToFunc("ShowLevelOccupancyTips"))
	EventMgr.Instance:RemoveListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end

function FightGuidePanel:__Hide()
	self.curGuideTaskProgress = nil
	self:RemoveAllGuidePointer()
	self:RemoveAllTimer()
	self:ClearSubTipsTemp()

	if self.hunterProgressBar then
	 	self.hunterProgressBar:OnCache()
		self.hunterProgressBar = nil
	end
end

function FightGuidePanel:CloseUI()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.TipsGuide,false)
		UtilsUI.SetActiveByScale(self.LogicGuide,false)
		return
	else
		UtilsUI.SetActiveByScale(self.TipsGuide,true)
		UtilsUI.SetActiveByScale(self.LogicGuide,true)
	end
end

function FightGuidePanel:Update()
	if not self.fightGuidePointerManager.curEntity then
		return
	end

	if not self.TaskGuide_ShowNode.activeSelf and self.playableDirector.time > 0 then 
		UtilsUI.SetActive(self.TaskGuide_ShowNode,true)
		self.playableDirector.time = 0.02
	elseif not self.TaskGuide_ShowNode.activeSelf then
		self.playableDirector:Stop()
	end

	for guideType, v in pairs(self.idToPointer) do
		self:UpdateGuidePointers(v, guideType)

		if self.hideGuides and self.hideGuides[guideType] and self.parentGroup[guideType] then
			self.parentGroup[guideType]:SetActive(false)
		elseif self.parentGroup[guideType] then
			self.parentGroup[guideType]:SetActive(true)
		end
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
			taskGuideDis = disDesc
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
	pointer.PointerEffect:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget and config.guideType ~= FightEnum.GuideType.SummonCar)
	pointer.IconBg:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget and config.guideType ~= FightEnum.GuideType.SummonCar)
	pointer.Arrow:SetActive(config.guideType ~= FightEnum.GuideType.FightTarget and config.guideType ~= FightEnum.GuideType.SummonCar)
	pointer.SummonCar:SetActive(config.guideType == FightEnum.GuideType.SummonCar)
	if config.guideType ~= FightEnum.GuideType.FightTarget and config.guideType ~= FightEnum.GuideType.SummonCar then
		if config.guideType == FightEnum.GuideType.Task then
			self:OnClickShowGuide()
		end
		local pointerIcon =  self.fightGuidePointerManager:GetPointerIcon(index)
		if pointerIcon and pointerIcon ~= "" then
			SingleIconLoader.Load(pointer.GuideIcon, pointerIcon)
		end
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

function FightGuidePanel:GuideTaskChange(taskId)
	if self.forceTipsGuide then
		return
	end
	if not self.active or not self.mainView or not self.mainView.active then
		self.waitChangeTaskGuide = true
		return
	end

	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	UtilsUI.SetActive(self.SubTipsGroup, guideTask and guideTask.taskConfig)
	--是否显示左侧任务栏
	local result = guideTask and next(guideTask) and guideTask.taskConfig or mod.TaskCtrl:CheckTaskIsMultarget(taskId)
	UtilsUI.SetActive(self.TipsGuide, result)
	UtilsUI.SetActive(self.TipPart, result)
	self:ClearSubTipsTemp()
	if guideTask and guideTask.taskConfig then
		if not self.forceTipsGuide then
			local taskConfig = mod.TaskCtrl:GetGuideTaskConfig()
			UtilsUI.SetActive(self.TaskEffect,true)
			self.TaskTip_txt.text = taskConfig.task_name
			SoundManager.Instance:PlaySound("UIMissionObjectiveChange")

			local obj = self:GetSubTipsTemp()
			obj.SubTipsTemp_txt.text = taskConfig.task_goal
			UtilsUI.SetActive(obj.FinishIcon, false)
			UtilsUI.SetTextColor(obj.SubTipsTemp_txt, "#ffffff")
			obj.object:SetActive(true)
			table.insert(self.subTipsOnShow, { obj = obj })
		end
		local taskType = mod.TaskCtrl:GetTaskType(guideTask.taskId)
		if taskType then
			local icon = AssetConfig.GetTaskTypeIcon(taskType)
		    SingleIconLoader.Load(self.TaskIcon, icon)
		end
	else
		
	end
	if not taskId and guideTask then
		taskId = guideTask.taskId
	end
	if #self.subTipsOnShow > 0 then
		if self.subTipsOnShow[1].config and self.subTipsOnShow[1].config.id == taskId then
			return
		else
			self:ShowMulTargetsTask(taskId)
		end
	else
		self:ShowMulTargetsTask(taskId)
	end
	
end

function FightGuidePanel:RefreshBox(isInLevel)
	if isInLevel or mod.DuplicateCtrl:GetDuplicateId() then --处于关卡或者副本中，不显示
		self.rewardBox.transform:SetActive(false)
		return
	end

	local guideTaskId = mod.TaskCtrl:GetGuideTaskId()
	local isShow = mod.TaskCtrl:CheckTaskInChapterProgress(guideTaskId)
	self.rewardBox.transform:SetActive(isShow or false)

	if not isShow then
		return
	end
	--获取文本的长度
	local width = self.TaskTip_txt.preferredWidth
	--刷新下宝箱的位置
	if width > 178 then
		UnityUtils.SetLocalPosition(self.rewardBox.transform, width + 10, 16, 0)
	else
		UnityUtils.SetLocalPosition(self.rewardBox.transform, 188, 16, 0)
	end 
		
	local taskRewardInfo = TaskConfig.GetTaskChapterInfoByTaskId(guideTaskId)
	self:RefreshBoxEffect(taskRewardInfo)
	if taskRewardInfo then
		local num, startTask, endTask = TaskConfig.GetTaskPointProgress(taskRewardInfo)
		local maxCount = Config.DataTask.data_task_Countbyid[guideTaskId]
		local value = num / maxCount
		self.rewardBoxProgress_img.fillAmount = value
	end	
end

function FightGuidePanel:RefreshBoxEffect(taskRewardInfo)
	local chapterInfo = taskRewardInfo or TaskConfig.GetTaskChapterInfoByTaskId(mod.TaskCtrl:GetGuideTaskId())
	local isRed = false
	if chapterInfo then
		isRed = mod.TaskCtrl:CheckNowTaskChapterIsRed(chapterInfo.id)
	end
	self.UI_rewardBox.transform:SetActive(isRed)
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

function FightGuidePanel:OnClickOpenTaskChapterWindow()
	WindowManager.Instance:OpenWindow(TaskChapterWindow, {mainView = true })
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
	if self.forceTipsGuide then 
		state = false
	end

	local task = Fight.Instance.taskManager:GetGuideTask()
	if task then
		local inArea = Fight.Instance.taskManager:IsInTimeArea(task.taskId)
		state = inArea and state
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

	pointer.object:SetActive(true)
	return pointer
end

function FightGuidePanel:DelayAnim(anim, showTip)
	if showTip ~= nil then
		self.TipPart:SetActive(showTip)
	end

	local widthScale = self.TaskTip_rect.sizeDelta.x / self.subTextWidth

	if anim then
		self.TaskGuide_ShowNode:SetActive(anim)
		self.playableDirector.time = 0.02
	else
		local timerFunc = function ()
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

function FightGuidePanel:LeaveDuplicate()
	self.forceTipsGuide = false
	self:GuideTaskChange()
	self:SetTaskGuideDisState(true)
	self:ShowMercenaryGuid()
end

function FightGuidePanel:SetTipGuideState(state)
	UtilsUI.SetActive(self.TipPart, state)
	self.tipPartState = state
	self:ResetTipsGuideState()
end

function FightGuidePanel:SetLevelPartState(state)
	UtilsUI.SetActive(self.LevelPart, state)
	self.tipLevelPart = state
	self:ResetTipsGuideState()
end

function FightGuidePanel:SetMercenaryGuidState(state)
	UtilsUI.SetActive(self.MercenaryGuid, state)
	self.tipMercenaryGuid = state
	self:ResetTipsGuideState()
end
function FightGuidePanel:ResetTipsGuideState()
	if self.tipPartState or self.tipLevelPart or self.tipMercenaryGuid then
		UtilsUI.SetActive(self.TipsGuide, true)
	else
		UtilsUI.SetActive(self.TipsGuide, false)
	end
end

--TODO 迭代了,还有地方在用先留着
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

	self:ClearSubTipsTemp()
	--脏标记，临时处理一下
	self.showOldTips = true
	self.forceTipsGuide = true

	self:SetTipGuideState(true)
	UtilsUI.SetActive(self.SubTipsGroup, true)
	UtilsUI.SetActive(self.TraceIcon, true)
	UtilsUI.SetActive(self.TraceEffect,true)
	UtilsUI.SetActive(self.TaskIcon, false)
	self:SetTaskGuideDisState(self.TaskTipDis, false)

	self.TipPart_btn.interactable = false
	
	self:SetMercenaryGuidState(false)
	UtilsUI.SetActive(self.MercenaryGuid, false)
	
	self.TaskTip_txt.text = string.format(tipsConfig.content, ...)
	--self:RefreshBox(true)
	UtilsUI.SetActive(self.SubTipsGroup, tipsConfig ~= nil)
	if tipsConfig then
		self.TaskBtn:SetActive(false)
		for i = 1, #tipsConfig.sub_content do
			local obj = self:GetSubTipsTemp()
			obj.SubTipsTemp_txt.text = tipsConfig.sub_content[i]
			obj.object:SetActive(true)
			LayoutRebuilder.ForceRebuildLayoutImmediate(obj.SubTipsTemp.transform)
			table.insert(self.subTipsOnShow, { obj = obj })
		end
	end

	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipsGuide.transform)
	end)
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

function FightGuidePanel:HideOldTips()
	if self.showOldTips then
		self.showOldTips = false
		self.forceTipsGuide = false
		TipQueueManger.Instance:LevelTipChanged(FightEnum.FightTipsType.GuideTips)
	end
end

function FightGuidePanel:SetTipsGuideDescV2(tipsUniqueId, tipsConfig)
	-- 先回收一下之前的tips 以及停掉对应的timer
	for k, v in pairs(self.subTipsTimer) do
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[k])
		self.subTipsTimer[k] = nil
	end

	self:ClearSubTipsTemp()

	self.forceTipsGuide = true

	self:SetTipGuideState(true)
	UtilsUI.SetActive(self.SubTipsGroup, true)
	UtilsUI.SetActive(self.TraceIcon, true)
	UtilsUI.SetActive(self.TraceEffect,true)
	UtilsUI.SetActive(self.TaskIcon, false)
	self:SetTaskGuideDisState(self.TaskTipDis, false)

	if not tipsConfig.icon or tipsConfig.icon == "" then
		local icon = AssetConfig.GetTaskTypeIcon(0)
		SingleIconLoader.Load(self.TraceIcon, icon)
	else
		SingleIconLoader.Load(self.TraceIcon, tipsConfig.icon)
	end

	self.TipPart_btn.interactable = false
	self:SetMercenaryGuidState(false)

	local info = TipQueueManger.Instance:GetLevelSubTipsInfo(tipsUniqueId)
	self.TaskTip_txt.text = info.content
	
	UtilsUI.SetActive(self.SubTipsGroup, true)
	self.TaskBtn:SetActive(false)
	for i = 1, #tipsConfig.sub_content do
		local obj = self:GetSubTipsTemp()
		obj.SubTipsTemp_txt.text = info.subContent[i] or tipsConfig.sub_content[i]
		obj.object:SetActive(true)
		LayoutRebuilder.ForceRebuildLayoutImmediate(obj.SubTipsTemp.transform)
		table.insert(self.subTipsOnShow, { obj = obj })
	end

	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipsGuide.transform)
	end)
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

function FightGuidePanel:EnterTaskTimeArea()
	self:ShowTaskGuide()
	self:SetTaskGuideDisState(true)
end

function FightGuidePanel:ShowTaskGuide(immediately)
    if self.forceTipsGuide and not immediately then
        return
    end
    self.forceTipsGuideV2 = false
    self.forceTipsGuide = false
    for k, v in pairs(self.subTipsTimer) do
        LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[k])
        self.subTipsTimer[k] = nil
    end
    self:ClearSubTipsTemp()

    
    UtilsUI.SetActive(self.TraceIcon, false)
    UtilsUI.SetActive(self.TaskIcon, true)
    self:SetTaskGuideDisState(self.TaskTipDis, true)

    self.TipPart_btn.interactable = true
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
    if isOpen then
        self:SetMercenaryGuidState(true)
    end

    local guideTask = Fight.Instance.taskManager:GetGuideTask()
	UtilsUI.SetActive(self.SubTipsGroup, guideTask and next(guideTask))
	self:SetTipGuideState(guideTask ~= nil)
    if guideTask and next(guideTask) then
        local taskConfig = mod.TaskCtrl:GetGuideTaskConfig()
        self.TaskTip_txt.text = taskConfig.task_name
        local taskType = mod.TaskCtrl:GetTaskType(guideTask.taskId)
        if taskType then
            local icon = AssetConfig.GetTaskTypeIcon(taskType)
            SingleIconLoader.Load(self.TaskIcon, icon)
        end
		local obj = self:GetSubTipsTemp()
		obj.SubTipsTemp_txt.text = taskConfig.task_goal
		obj.object:SetActive(true)
		LayoutRebuilder.ForceRebuildLayoutImmediate(obj.SubTipsTemp.transform)
		table.insert(self.subTipsOnShow, { obj = obj })
    end
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipsGuide.transform)
    end)
end


--显示多目标任务
function FightGuidePanel:ShowMulTargetsTask(taskId)
do--TODO 2405月版本 先把多目标的屏蔽掉了
return
end
	local taskCfg = mod.TaskCtrl:GetTaskConfig(taskId)
	if taskCfg then
		if taskCfg.show_id~= 0 or not taskCfg.show_id then
			taskId = taskCfg.show_id
		end
	end

	local targets = mod.TaskCtrl:GetTaskTargets(taskId)

 	UtilsUI.SetActive(self.TraceIcon, false)
	UtilsUI.SetActive(self.TraceEffect,false)
	UtilsUI.SetActive(self.TaskIcon, true)
	self:SetTaskGuideDisState(self.TaskTipDis, true)

	if #targets==0 and #self.subTipsOnShow > 0 then
		self:ClearSubTipsTemp()
		UtilsUI.SetActive(self.SubTipsGroup, false)
		return
	end

	--当子任务传来时
	for i = 1, #self.subTipsOnShow, 1 do
		if self.subTipsOnShow[i].config.id == taskId then
			return
		end
	end

	--显示排序按钮
	if #targets>0 then
		UtilsUI.SetActive(self.SubTipsGroup, true)
		self.TaskBtn:SetActive(true)
	else
		UtilsUI.SetActive(self.SubTipsGroup, false)
	end

	self:CreateSubTipTemp(targets)

	if #targets>0  then
		self.TaskBtn.transform:SetSiblingIndex(#targets+1)
	end
	
end

function FightGuidePanel:CreateSubTipTemp(targets)
    if #self.subTipsOnShow > 0 then
        local guideTask = Fight.Instance.taskManager:GetGuideTask()
        if guideTask.taskId == self.subTipsOnShow[1].id then
            return
        end
    end

    -- 先清除
    self:ClearSubTipsTemp()

    -- 再成列表
    for i = 1, #targets do
        local obj = self:GetSubTipsTemp()
        obj.SubTipsTemp_txt.text = targets[i].task_goal
        obj.object:SetActive(true)
        if not self.subTipsOnShow[i] then
            self.subTipsOnShow[i] = {}
        end
        self.subTipsOnShow[i].obj = obj
        self.subTipsOnShow[i].config = targets[i]
        if i == 1 then
            self.TaskTip_txt.text = targets[i].task_goal
            obj.object:SetActive(false)
        end
    end

    self:SetTaskBtnPos(#targets)

    self:SetTipsTaskTargets()
end


--刷新多目标任务
function FightGuidePanel:UpdateMulTargetsTask(taskId)
	do--TODO 2405月版本 先把多目标的屏蔽掉了
	return
	end
	local isChangeTask = true
	for i, v in ipairs(self.subTipsOnShow) do
		if taskId == v.config.id then
			local step = mod.TaskCtrl:GetTaskStep(taskId)
			local sumStep = mod.TaskCtrl:GetTaskStepCount(taskId)
			if step == sumStep then --判断任务是否已经完成
				local nowText = v.config.task_goal
				local obj = table.remove(self.subTipsOnShow, i)
		        UnityUtils.SetActive(obj.obj.object, false)
		        table.insert(self.subTipsCaches, obj.obj)
				--若子任务全部完成则隐藏按钮
				if #self.subTipsOnShow <=1 then
					self.TaskBtn:SetActive(false)
					isChangeTask = false
				end
			else
				--获取当前步骤
				local config = mod.TaskCtrl:GetTaskConfig(taskId,step+1)
				v.obj.SubTipsTemp_txt.text = config.task_goal
				UtilsUI.SetActive(v.obj.FinishIcon, false)
				UtilsUI.SetTextColor(v.obj.SubTipsTemp_txt, "#ffffff")
			end
		end
	end

	if isChangeTask then
		self:OnClickChangeTask()
	end
end
function FightGuidePanel:ChangeTask(data)
	if #self.subTipsOnShow == 0 then
		return
	end

	if not self.subTipsOnShow[1].config then
		self:ShowTaskGuide(true)
	elseif self.subTipsOnShow[1].config.id ~= data.id then
		self:OnClickChangeTask()
	else
		return
	end
	-- self:ChangeTask(data)
end

--切换任务和追踪目标
function FightGuidePanel:OnClickChangeTask()
	local count = #self.subTipsOnShow

	local obj = table.remove(self.subTipsOnShow, count)
	table.insert(self.subTipsOnShow, 1, obj)
	self:SetTaskBtnPos(count)
	self:SetTipsTaskTargets()
	SoundManager.Instance:PlaySound("UIMissionObjectiveChange")
end

function FightGuidePanel:SetTipsTaskTargets()
	--切换追踪目标
	if #self.subTipsOnShow == 0 then
		return
	end
	local taskId = self.subTipsOnShow[1].config.id
	mod.TaskCtrl:SetMulTarget(self.subTipsOnShow[1].config)
	self.TaskTip_txt.text = self.subTipsOnShow[1].obj.SubTipsTemp_txt.text
	UtilsUI.SetActive(self.subTipsOnShow[1].obj.FinishIcon, false)
	UtilsUI.SetTextColor(self.subTipsOnShow[1].obj.SubTipsTemp_txt, "#ffffff")
	
	for i, v in ipairs(self.subTipsOnShow) do
		if i == 1 or not v.config then
			v.obj.object.transform:SetActive(false)
		else
			v.obj.object.transform:SetActive(true)
		end
	end
	--更换追踪目标如果子任务不能追踪那么追踪父任务(现在没有父任务了所以注释了)
	if not self.subTipsOnShow[1].config.is_hide_task  then
		mod.TaskCtrl:SetGuideTaskId(taskId)
	else
		--要取消掉追踪标
		-- local taskId = self.subTipsOnShow[1].config.show_id
		-- mod.TaskCtrl:SetGuideTaskId(taskId)
	end
	
end

--todo 待维护多目标任务切换任务
function FightGuidePanel:SetTaskBtnPos(count)
	if not self.subTipsOnShow then
		return
	end
	if not self.subTipsOnShow[count] then
		return
	end

	self.subTipsOnShow[count].obj.SubTipsTemp:SetActive(true)

	local str = self.subTipsOnShow[count].obj.SubTipsTemp_txt.text
	local Width = self:GetByteCount(str)*25
	UnityUtils.SetSizeDelata(self.TaskBtn.transform,Width,0)
end

function FightGuidePanel:ShowLevelOccupancyTips(args)
	self:SetLevelPartState(args.isShow)
	if args.display then
		self:OnClickLevelPart()
	end
end

function FightGuidePanel:OnClickLevelPart()
	PanelManager.Instance:OpenPanel(LevelOccupancyTips)
end

function FightGuidePanel:GetByteCount(str)
    local realByteCount=#str
    local length=0
    local curBytePos=1
    while(true) do
        local step=1 --遍历字节的递增值
        local byteVal=string.byte(str,curBytePos)
 
        if byteVal>239 then
            step=4
        elseif byteVal>223 then
            step=3
        elseif byteVal>191 then
            step=2
        else
            step=1
        end
        curBytePos=curBytePos+step
        length=length+1
        if curBytePos>realByteCount then
            break
        end
    end
    return length
end

function FightGuidePanel:GetSubTipsTemp()
	local obj
	if self.subTipsCaches and next(self.subTipsCaches) then
		obj = table.remove(self.subTipsCaches)
	else
		obj = self:PopUITmpObject("SubTipsTemp")
		UtilsUI.GetContainerObject(obj.objectTransform, obj)
		obj.objectTransform:SetParent(self.SubTipsContent.transform)
		UtilsUI.SetActive(obj.FinishIcon, false)
		UtilsUI.SetTextColor(obj.SubTipsTemp_txt, "#ffffff")
		UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
		UtilsUI.GetContainerObject(obj.objectTransform, obj)
	end
	UtilsUI.SetActive(obj.FinishIcon, false)
    return obj
end

function FightGuidePanel:ClearSubTipsTemp()
	for i = #self.subTipsOnShow, 1 , -1 do
		local obj = table.remove(self.subTipsOnShow)
		if obj.obj then
			UnityUtils.SetActive(obj.obj.object, false)
			table.insert(self.subTipsCaches, obj.obj)
		end
	end
end
function FightGuidePanel:ShowMercenaryGuid()
	self.mainId = mod.MercenaryHuntCtrl:GetMainId()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
	self:SetMercenaryGuidState(isOpen)
	if isOpen and self.mainId > 0 then
		self:InitMercenaryBar()
		self:UpdateMercenaryGuid()
	end
end

function FightGuidePanel:UpdateMercenaryGuid(tipsId)
	self:InitMercenaryBar()

	local mainCfg = MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId)
	local maxNum = mainCfg.promote_num_limit
    local curPromoteNum = mod.MercenaryHuntCtrl:GetCurPromoteNum()
	
	self.PromoteTip_txt.text = string.format(TI18N("晋升次数 ： %d/%d"), curPromoteNum, maxNum)

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
		UtilsUI.SetActive(self.DescContent,true)
		self.DailyTask_rect.sizeDelta = Vector2(self.DailyTask_rect.sizeDelta.x, 80)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(tipsId).tip
		self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, 3, timerFunc)
		self:ShowMercenaryDescEffect()
		return
	end
	if self.tipsTimer ~= nil then return end
    if Fight.Instance.mercenaryHuntManager:CheckNearbyMercenary() then
		UtilsUI.SetActive(self.DescContent,true)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(4).tip
		self:ShowMercenaryDescEffect()
    elseif mod.MercenaryHuntCtrl:CheckHasMercenaryChase() then
		UtilsUI.SetActive(self.DescContent,true)
        self.DescText_txt.text = MercenaryHuntConfig.GetMercenaryTip(6).tip
		self:ShowMercenaryDescEffect()
	else
		UtilsUI.SetActive(self.DescContent,false)
    end
end

function FightGuidePanel:ShowMercenaryDescEffect()
	if self.descEffectTimer then
		return
	end
	self.DescEffect:SetActive(true)
	self.descEffectTimer = LuaTimerManager.Instance:AddTimer(1, 2, function ()
		self.DescEffect:SetActive(false)
		LuaTimerManager.Instance:RemoveTimer(self.descEffectTimer)
		self.descEffectTimer = nil
	end)
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

--TODO 迭代了,还有地方在用先留着
function FightGuidePanel:ChangeSubTipsDesc(index, tipId, ...)
	if not self.forceTipsGuide or not self.subTipsOnShow[index] then
		return
	end

	local tipsConfig = Config.DataTips.data_tips[tipId]
	if not tipsConfig or not next(tipsConfig) then
		return
	end

	local desc = tipsConfig.sub_content[index]
	UtilsUI.SetActive(self.subTipsOnShow[index].obj.FinishIcon, false)
	UtilsUI.SetTextColor(self.subTipsOnShow[index].obj.SubTipsTemp_txt, "#ffffff")
	desc = string.format(desc, ...)
	self.subTipsOnShow[index].obj.SubTipsTemp_txt.text = desc
	local timerFunc = function()
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil

		if not self.subTipsOnShow[index] then
			return
		end

		local length = self.subTipsOnShow[index].obj.SubTipsTemp_rect.sizeDelta.x / self.subTextWidth
		UnityUtils.SetActive(self.subTipsOnShow[index].obj.SubTipsEffect, true)
	end

	if self.subTipsTimer[index] then
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil
	end

	UnityUtils.SetActive(self.subTipsOnShow[index].obj.SubTipsEffect, false)
	local timer = LuaTimerManager.Instance:AddTimer(1, 0.03, timerFunc)
	self.subTipsTimer[index] = timer
end

function FightGuidePanel:ChangeSubTipsV2Success(index, tipsUniqueId, state)
	if not self.forceTipsGuide or not self.subTipsOnShow[index] then
		return
	end
	UtilsUI.SetActive(self.subTipsOnShow[index].obj.FinishIcon, state)
	if state then
		UtilsUI.SetTextColor(self.subTipsOnShow[index].obj.SubTipsTemp_txt, "#d4d3d3")
	else
		UtilsUI.SetTextColor(self.subTipsOnShow[index].obj.SubTipsTemp_txt, "#ffffff")
	end
end

function FightGuidePanel:ChangeSubTipsDescV2(index, tipsUniqueId)
	if not self.forceTipsGuide or not self.subTipsOnShow[index] then
		return
	end

	local info = TipQueueManger.Instance:GetLevelSubTipsInfo(tipsUniqueId)
	self:ChangeSubTipsV2Success(index, tipsUniqueId, false)
	self.subTipsOnShow[index].obj.SubTipsTemp_txt.text = info.subContent[index]

	local timerFunc = function()
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil

		if not self.subTipsOnShow[index] then
			return
		end

		local length = self.subTipsOnShow[index].obj.SubTipsTemp_rect.sizeDelta.x / self.subTextWidth
		UnityUtils.SetActive(self.subTipsOnShow[index].obj.SubTipsEffect, true)
	end

	if self.subTipsTimer[index] then
		LuaTimerManager.Instance:RemoveTimer(self.subTipsTimer[index])
		self.subTipsTimer[index] = nil
	end

	UnityUtils.SetActive(self.subTipsOnShow[index].obj.SubTipsEffect, false)
	local timer = LuaTimerManager.Instance:AddTimer(1, 0.03, timerFunc)
	self.subTipsTimer[index] = timer
end

function FightGuidePanel:OutPrison()
	UtilsUI.SetActive(self.TipsGuide,true)
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

	if self.descEffectTimer then
		LuaTimerManager.Instance:RemoveTimer(self.descEffectTimer)
		self.descEffectTimer = nil
	end
end

function FightGuidePanel:HideSelf()
	UtilsUI.SetActive(self.FightGuidePanel_Exit, true)
end