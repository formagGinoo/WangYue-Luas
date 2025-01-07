GuideManager = BaseClass("GuideManager")

local DataGuideGroup = Config.DataGuide.data_guide
local DataGuideStage = Config.DataGuide.data_guide_stage

local GuidingType = 
{
	NotStart = 1,
	Guiding = 2,
	WaitForCallback = 3,
	WaitForUIOpen = 4,
}

local PanelFilter = {
	CommonLeftTabPanel = 1,	
}

function GuideManager:__init(clientFight)
	if UtilsUI.CheckPCPlatform() then
		DataGuideStage = Config.DataGuide.data_guide_stage_pc
	end
	
	self.clientFight = clientFight
	
	self.curWindow = nil
	self.curPanel = {}
	
	self.guidingData = {}
	self.guideMaskPanel = nil
	self.guidingType = GuidingType.NotStart
	
	self.showCount = 1
end

function GuideManager:StartFight()
	EventMgr.Instance:AddListener(EventName.OnWindowOpen, self:ToFunc("OnWindowOpen"))
	EventMgr.Instance:AddListener(EventName.OnPanelOpen, self:ToFunc("OnPanelOpen"))
	EventMgr.Instance:AddListener(EventName.TipHideEvent, self:ToFunc("OnTipHideEvent"))
	EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("OnStoryStart"))
	EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryEnd"))
	
	if not self.guideMaskPanel then
		self.guideMaskPanel = PanelManager.Instance:OpenPanel(GuideMaskPanel)
	end
	
	self:AddConditionListener()
end

function GuideManager:__delete()
	self.guidingData = {}
	
	if self.guideMaskPanel then
		PanelManager.Instance:ClosePanel(self.guideMaskPanel, true)
		self.guideMaskPanel = nil
	end
	
	self.curWindow = nil
	self.curPanel = nil
	self.guidingType = GuidingType.NotStart
	
	EventMgr.Instance:RemoveListener(EventName.OnWindowOpen, self:ToFunc("OnWindowOpen"))
	EventMgr.Instance:RemoveListener(EventName.OnPanelOpen, self:ToFunc("OnPanelOpen"))
	EventMgr.Instance:RemoveListener(EventName.TipHideEvent, self:ToFunc("OnTipHideEvent"))
	EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("OnStoryStart"))
	EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("OnStoryEnd"))
end

function GuideManager:CheckUIOpen(window, panel, nullPanel)
	if not window or window == "" then
		return true
	end
	
	if not self.curWindow or self.curWindow == "" then
		return false
	end
	
	--剧情引导特判
	if window == "StoryDialogPanelV2" then
		return self.curPlayDialogId ~= nil
	end

	--FightMainUIView特判
	if self.curWindow == "FightMainUIView" then
		return self.curWindow == window
	end
	
	if panel and panel ~= "" and nullPanel then
		return false
	end
	
	if not panel or panel == "" then
		return self.curWindow == window
	end
	
	if window == "CanvasContainer" then
		return self.curPanel[panel] ~= nil
	end
	
	return self.curWindow == window and self.curPanel[panel] ~= nil
end

function GuideManager:OnStoryStart(dialogId)
	self.curPlayDialogId = dialogId
end

function GuideManager:OnStoryEnd(dialogId, selectList)
	if self.curPlayDialogId == dialogId then
		self.curPlayDialogId = nil
	end
end

function GuideManager:CheckGuideEligible(groupGuide, stageGuide, priority, needCondition, nullPanel, showTips)
	--检查是否一次性且已完成
	if mod.GuideCtrl:CheckGuideFinish(groupGuide.id) then
		if showTips then LogError("指引已完成："..groupGuide.id) end
		return false
	end
	
	local windowName = stageGuide and stageGuide.window_name or groupGuide.window_name
	local panelName = stageGuide and stageGuide.panel_name or groupGuide.panel_name
	if not self:CheckUIOpen(windowName, panelName, nullPanel) then
		if showTips then LogError(string.format("未到达指定界面：%s %s", windowName, panelName)) end
		return false
	end

	--检查是否符合条件
	local conditionId = groupGuide.condition_id
	if needCondition and conditionId == 0 then
		return false
	end
	
	if not self.clientFight.fight.conditionManager:CheckConditionByConfig(conditionId) then
		if showTips then LogError("条件未达成："..conditionId) end
		return false
	end

	if groupGuide.priority <= priority then
		return false
	end

	return true
end

function GuideManager:GetGuideStageData(guideId)
	local stageData = {}
	local count = 0
	for k, v in pairs(DataGuideStage) do
		if v.group_id == guideId then
			stageData[v.stage] = v
			count = count + 1
		end
	end

	return stageData, count
end

function GuideManager:CanPlayGuide()
	return self.guidingType == GuidingType.NotStart or self.guidingType == GuidingType.WaitForUIOpen or 
		(self.guideMaskPanel and self.guideMaskPanel.targetHide)
end

function GuideManager:GetPlayingGuide()
	if self.guidingType == GuidingType.NotStart
		or not self.guidingData or not next(self.guidingData) then
		return
	end
	
	return self.guidingData.id, self.guidingData.playStage
end


function GuideManager:PlayGuideGroup(guideId, stage, check, showTips)

	if not self:CanPlayGuide() then
		Log("已存在指引："..self.guidingData.id)
		return false
	end
	
	if self.guidingType == GuidingType.WaitForUIOpen then
		self:ClearGuidingData()
	end
	
	local groupGuide = DataGuideGroup[guideId]
	if not groupGuide then
		LogError("未找到指引配置："..guideId)
		return false
	end

	local stageGuide, amount = self:GetGuideStageData(guideId)
	
	if check and not self:CheckGuideEligible(groupGuide, stageGuide[stage], -1, nil, nil, showTips) then
		LogError("指引检查不满足："..guideId)
		return false
	end
	
	self.guidingData = {
		id = guideId,
		groupData = groupGuide,
		stageData = stageGuide,
		playStage = stage or 1,
		stageAmount = amount,
	}
	
	local skipFunc
	if self.guidingData.groupData.skip then
		skipFunc = function()
			self:SkipGuide(self.guidingData.groupData.skip_group_id)
			self:ClearGuidingData()
		end
	end
	self.guideMaskPanel:SetSkipCallback(skipFunc)
	self.guideMaskPanel:ToggleGuideMask(true)
	
	self.guidingType = GuidingType.Guiding
	self:DoGuideStage(self.guidingData.playStage)
	return true
end

function GuideManager:DoGuideStage(stage)
	if stage > self.guidingData.stageAmount then
		LogError(string.format("指引[%d]错误的指引步骤：%d", self.guidingData.id, stage))
		self:ClearGuidingData()
		return
	end
	
	local data = self.guidingData.stageData[stage]
	if not data then
		LogError(string.format("指引[%d]错误的指引步骤：%d", self.guidingData.id, stage))
		self:ClearGuidingData()
		return
	end
	
	--type为2时是执行脚本
	if data.type == 2 then
		if (not data.guide_lua) or data.guide_lua == "" then
			LogError(string.format("指引[%d]错误的指引步骤：%d 该步骤应该执行Lua判断, 但是没有配Lua脚本", self.guidingData.id, stage))
			self:ClearGuidingData()
			return
		end
		if GuideBrancherConfig[data.guide_lua] then
			local stage = GuideBrancherConfig[data.guide_lua]()
			self:DoGuideStage(stage)
			return
		else
			LogError(string.format("指引[%d]错误的指引步骤：%d 该步骤应该执行Lua判断, 但是没有找到Lua脚本对应函数", self.guidingData.id, stage))
			self:ClearGuidingData()
			return
		end
		
	end

	self.guidingData.playStage = stage

	if not self:CheckUIOpen(data.window_name, data.panel_name) then
		self.guidingType = GuidingType.WaitForUIOpen
		return
	end

	--按鍵屏蔽
	if data.click_node ~= "" then
		self.curClickNode = data.click_node
		BehaviorFunctions.SetOnlyKeyInput(data.click_node, true)
		InputManager.Instance:SetGuideCanNotBackState(false)
	else
		self.curClickNode = nil
		BehaviorFunctions.SetOnlyKeyInput(nil, false)
		InputManager.Instance:SetGuideCanNotBackState(true)
	end

	self.showCount = 0
	self:ShowGuide(data)
end

function GuideManager:DelayShowGuide()
	if self.showCount >= 5 then
		LogError(string.format("指引[%d]指引步骤：%d控件获取错误，跳过指引", self.guidingData.id, self.guidingData.playStage))
		if self.guidingData.groupData.skip then
			self:SkipGuide(self.guidingData.groupData.skip_group_id)
		end
		self:ClearGuidingData()
		return
	end
	
	local func = function()
		self.showCount = self.showCount + 1
		self:ShowGuide(self.guidingData.stageData[self.guidingData.playStage])
	end
	
	self.showTimer = LuaTimerManager.Instance:AddTimer(1, 0.6, func)
end

function GuideManager:ShowGuide(data)
	--LogInfo("ShowGuide")
	--LogTable("ShowGuide", data)
	local delayTime = data.delay
	if not delayTime or delayTime <= 0 then
		--至少延迟一帧调用，避免mask还没关闭重新打开后显示错误
		delayTime = 0.01
	end
	
	--1、2都是程序驱动，3-等待策划完成
	if data.end_condition == 3 then
		self.guidingType = GuidingType.WaitForCallback
	else
		self.guidingType = GuidingType.Guiding
	end
	local callback = function() self:OnFinishGuideStage(data.group_id, data.stage) end
		
	
	local func = function()
		self.clientFight.fight.entityManager:CallBehaviorFun("OnGuideStart", self.guidingData.id, data.stage)
		
		self.guideMaskPanel:ShowGuide(data, callback, self:ToFunc("DelayShowGuide"))
	end

	if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
		self.delayTimer = nil
	end
	self.delayTimer = LuaTimerManager.Instance:AddTimer(1, delayTime, func)
	self.guideMaskPanel:ToggleGuideMask(true)
end

function GuideManager:OnFinishGuideStage(groupId, stage)
	if not self.guidingData or not self.guidingData.id then
		return 
	end
	local stageData = self.guidingData.stageData[stage]

	if not groupId or not stage then
		LogError("完成指引传入数据有误")
		return
	end
	
	if groupId ~= self.guidingData.id or stage ~= self.guidingData.playStage then
		--self:ClearGuidingData()
		return
	end
	
	self:RemoveTimer()
	if self.guideMaskPanel then
		self.guideMaskPanel:GuideFinish()
	end
	
	self.clientFight.fight.entityManager:CallBehaviorFun("OnGuideFinish", groupId, stage)
	
	local groupData = self.guidingData.groupData
	if groupData.type == 1 and stageData.is_finish then
		self:SendFinishGuideId(groupId)
	end
	
	local nextStage
	if stageData.next_step and stageData.next_step ~= 0 then
		nextStage = stageData.next_step
	end

	if not nextStage and ((stage + 1 > self.guidingData.stageAmount) or (stageData.is_last)) then
		self:ClearGuidingData()
		
		local nextGroupInfo = groupData.next_id
		if #nextGroupInfo > 0 then
			local groupId = nextGroupInfo[1]
			local startStage = nextGroupInfo[2]
			InputManager.Instance:SetGuideCanNotBackState(true)
			LuaTimerManager.Instance:AddTimer(1, groupData.wait_time or 0.03, function ()
				InputManager.Instance:SetGuideCanNotBackState(false)
				self:PlayGuideGroup(groupId, startStage, true)
			end)
		else
			Log("Guide Finish:"..groupId)
		end
		return
	end

	if not nextStage then
		nextStage = stage + 1
	end

	self:DoGuideStage(nextStage)
end

function GuideManager:ClearGuidingData()
	BehaviorFunctions.SetOnlyKeyInput(nil, false)
	InputManager.Instance:SetGuideCanNotBackState(false)
	self.curClickNode = nil
	TableUtils.ClearTable(self.guidingData)
	self.guidingType = GuidingType.NotStart
	if self.guideMaskPanel then
		self.guideMaskPanel:GuideFinish()
		self.guideMaskPanel:ToggleGuideMask(false)
		self.guideMaskPanel:SetSkipCallback()
	end
	self:RemoveTimer()
end

function GuideManager:SkipGuide(skipGroupId)
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		local data = DataGuideGroup[notFinishIdList[i]]
		if data.skip_group_id == skipGroupId and data.finish_stage ~= 0 then
			self:SendFinishGuideId(data.id)
		end
	end
end

function GuideManager:OnWindowOpen(name)
	self.curWindow = name
	--self.curPanel = nil
	--print("OnWindowOpen", name)
	if not mod.GuideCtrl:GuideInit() then return end
	
	if not self.guideMaskPanel or not self.guideMaskPanel.isShow then
		return
	end
	
	if self.guidingType == GuidingType.WaitForUIOpen then
		local stageData = self.guidingData.stageData[self.guidingData.playStage]
		if self:CheckUIOpen(stageData.window_name, stageData.panel_name, stageData.panel_name == "") then
			self:DoGuideStage(self.guidingData.playStage)
			return
		end
	end
	
	if not self:CanPlayGuide() then
		return
	end
	
	local guideId
	local priority = -1
	local getGuide = false
	if self.guidingType == GuidingType.WaitForUIOpen then
		guideId = self.guidingData.id
		priority = self.guidingData.groupData.priority
	end
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		if notFinishIdList[i] ~= guideId then
			local data = DataGuideGroup[notFinishIdList[i]]
			if self:CheckGuideEligible(data, nil, priority, true, true) then
				guideId = data.id
				priority = data.priority
				getGuide = true
			end
		end
	end
	
	if getGuide then
		self:PlayGuideGroup(guideId)
	end
end

function GuideManager:OnPanelOpen(name)
	if PanelFilter[name] then
		return 
	end
	
	self.curPanel[name] = true
	--print("OnPanelOpen", name)
	if not mod.GuideCtrl:GuideInit() then return end
	
	if not self.guideMaskPanel or not self.guideMaskPanel.isShow then
		return 
	end
	
	if self.guidingType == GuidingType.WaitForUIOpen then
		local stageData = self.guidingData.stageData[self.guidingData.playStage]
		if self:CheckUIOpen(stageData.window_name, stageData.panel_name) then
			self:DoGuideStage(self.guidingData.playStage)
			return
		end
	end
	
	if not self:CanPlayGuide() then
		return 
	end
	
	local guideId
	local priority = -1
	local getGuide = false
	if self.guidingType == GuidingType.WaitForUIOpen then
		guideId = self.guidingData.id
		priority = self.guidingData.groupData.priority
	end
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		if notFinishIdList[i] ~= guideId then
			local data = DataGuideGroup[notFinishIdList[i]]
			if self:CheckGuideEligible(data, nil, priority, true, false) then
				guideId = data.id
				priority = data.priority
				getGuide = true
			end
		end
	end

	if getGuide then
		self:PlayGuideGroup(guideId)
	end
end

function GuideManager:OnTipHideEvent(name)
	self.curPanel[name] = nil
end

function GuideManager:SendFinishGuideId(guideId)
	if not mod.GuideCtrl:GuideInit() then return end
	mod.GuideCtrl:SendFinishGuideId(guideId)
end

function GuideManager:AddConditionListener()
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		local data = DataGuideGroup[notFinishIdList[i]]
		if data.condition_id ~= 0 then
			self.clientFight.fight.conditionManager:AddListener(data.condition_id, self:ToFunc("OnConditionsMet"))
		end
	end
end

function GuideManager:OnConditionsMet(conditionId)
	if not self:CanPlayGuide() then
		return 
	end
	
	local guideId
	local priority = -1
	local getGuide = false
	if self.guidingType == GuidingType.WaitForUIOpen then
		guideId = self.guidingData.id
		priority = self.guidingData.groupData.priority
	end
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		if notFinishIdList[i] ~= guideId then
			local data = DataGuideGroup[notFinishIdList[i]]
			if conditionId == data.condition_id then
				if self:CheckGuideEligible(data, nil, priority, true, true) then
					guideId = data.id
					priority = data.priority
					getGuide = true
				end
			end
		end

	end

	if getGuide then
		self:PlayGuideGroup(guideId)
	end
end

function GuideManager:RemoveTimer()
	if self.delayTimer then
		LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
		self.delayTimer = nil
	end
	
	if self.showTimer then
		LuaTimerManager.Instance:RemoveTimer(self.showTimer)
		self.showTimer = nil
	end
end

function GuideManager:GetGuidingType()
	return self.guidingType
end