DailyActivityPanel = BaseClass("DailyActivityPanel", BasePanel)

--local DefaultInfo = {
	--value = 480,
	--control_id = 1,
	--task_list = {
		--{is_finish = true, task_id = 1010001},
		--{is_finish = false, task_id = 1010002},
		--{is_finish = true, task_id = 1010003},
		--{is_finish = false, task_id = 1010004}
	--},
	--can_get = {300, 400},
	--has_get = {100, 200},
--}

local DefaultInfo = {
	value = 0,
	control_id = 1,
	task_list = {},
	can_get = {},
	has_get = {},
}

function DailyActivityPanel:__init()
    self:SetAsset("Prefabs/UI/DailyActivity/DailyActivityPanel.prefab")
	
	self.activationNodes = {}
	self.missionItemObjs = {}
	self.cacheTask = {}
	
	self.info = mod.DailyActivityCtrl:GetInfo()
	self.fullActivation = mod.DailyActivityCtrl:IsFullActivation()
	self:UpdateCacheTask()
	
	if not self.info or not next(self.info) then
		LogError("[每日活跃]获取不到每日活跃数据")
		self.info = DefaultInfo
	end
	
	DailyActivityConfig.SortTaskList(self.info.task_list)
end

function DailyActivityPanel:__delete()
	self.activationNodes = {}
	self.missionItemObjs = {}
	self.cacheTask = {}

	for _, v in pairs(self.activationNodes) do
		if v.cacheObjList then
			for _, obj in pairs(v.cacheObjList) do
				ItemManager.Instance:PushItemToPool(obj)
			end
			v.cacheObjList = {}
		end
	end
	
	self.showRewawrd = nil
	
	EventMgr.Instance:RemoveListener(EventName.UpdateDailyActivity, self:ToFunc("OnUpdateDailyActivity"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskFinish, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskChange, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskUpdate, self:ToFunc("OnSystemTaskUpdate"))
end

function DailyActivityPanel:__BindListener()
	self.TipsBtn_btn.onClick:AddListener(self:ToFunc("ShowPanelTips"))
	self:SetHideNode("DailyActivityPanel_Exit")
	--UtilsUI.SetHideCallBack(self.DailyActivityPanel_Exit, self:ToFunc("Close_CallBack"))

	EventMgr.Instance:AddListener(EventName.UpdateDailyActivity, self:ToFunc("OnUpdateDailyActivity"))
	EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("OnSystemTaskUpdate"))
	EventMgr.Instance:AddListener(EventName.SystemTaskUpdate, self:ToFunc("OnSystemTaskUpdate"))
end

function DailyActivityPanel:__Create()
	if self.MissionGroup_recyceList then
		self.MissionGroup_recyceList:SetLuaCallBack(self:ToFunc("OnMissionScroll"))
		self.MissionGroup_recyceList:SetCellNum(#self.info.task_list)
	end
end

function DailyActivityPanel:__Show()
	self:InitUI(self.info)
end

function DailyActivityPanel:__Hide()
	self.showRewawrd = nil
	
	for _, v in pairs(self.activationNodes) do
		if v.cacheObjList then
			for _, obj in pairs(v.cacheObjList) do
				ItemManager.Instance:PushItemToPool(obj)
			end
			v.cacheObjList = {}
		end
	end
	
	self.currencyBarClass:OnCache()
	self.currencyBarClass = nil
end

function DailyActivityPanel:InitUI(info)
	local data = DailyActivityConfig.GetDailyActivityConfig(info.control_id)
	local maxProgress = DailyActivityConfig.GetMaxActivation(info.control_id)
	self:InitActivityProgress(info.value, maxProgress, info.can_get, info.has_get, data)
	self:InitRefreshTime()
	
	self:InitRewardGroup()
	self:InitCurrencyBar()
end

function DailyActivityPanel:InitCurrencyBar()
	self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBarClass:init(self.CurrencyBar, 5)
end

function DailyActivityPanel:InitRewardGroup()
	UnityUtils.SetActive(self.RewardGroupBack, false)
	
	local dragBehaviour = self.RewardGroupBack:GetComponent(UIDragBehaviour)
	if not dragBehaviour then
		dragBehaviour = self.RewardGroupBack:AddComponent(UIDragBehaviour)
		dragBehaviour.ignorePass = false
	end
	
	dragBehaviour.onPointerUp = function(data)
		self.clickReward = self.showRewawrd
		LuaTimerManager.Instance:AddTimer(1, 0.01, function()
				if self.clickReward then
					self:ToggleRewardGroup(self.clickReward, false)
					self.showRewawrd = nil
				end
				self.clickReward = nil
			end)
	end
end

function DailyActivityPanel:UpdateCacheTask()
	if not self.info then
		return 
	end
	
	TableUtils.ClearTable(self.cacheTask)
	for _, v in pairs(self.info.task_list) do
		table.insert(self.cacheTask, v.task_id)
	end
end

function DailyActivityPanel:TaskListChange()
	for _, v in pairs(self.info.task_list) do
		local hasTask = false
		for _, vv in pairs(self.cacheTask) do
			if vv == v.task_id then
				hasTask = true
			end
		end
		
		if not hasTask then
			return true
		end
	end
	
	return false
end

function DailyActivityPanel:UpdateMission()
	local taskList = self.info.task_list
	--任务更新后重新排序
	DailyActivityConfig.SortTaskList(taskList)
	
	for i = 1, #taskList do
		local taskId = taskList[i].task_id
		if taskId then
			local item = self.missionItemObjs[i]
			if item and item.taskId ~= taskId then
				item.taskId = taskId
				item.taskConfig = DailyActivityConfig.GetTaskConfig(taskId)
			end
			if item and item.gameObject then
				self:RefreshMission(item)
			end
		end
	end
end

function DailyActivityPanel:OnUpdateDailyActivity(info, fullActivation)
	self.info = info
	DailyActivityConfig.SortTaskList(self.info.task_list)
	
	self.fullActivation = fullActivation
	
	local data = DailyActivityConfig.GetDailyActivityConfig(info.control_id)
	self:RefreshActivityProgress(info.value, info.can_get, info.has_get, data)
	
	if self:TaskListChange() then
		self.missionItemObjs = {}
		self.MissionGroup_recyceList:SetCellNum(#self.info.task_list)
		self:OnSystemTaskUpdate()
		self:UpdateCacheTask()
	end
	
end

function DailyActivityPanel:OnMissionScroll(index, gb)
	local task = self.info.task_list[index]
	local taskId = task and task.task_id
	if not taskId then
		if index > #self.info.task_list then
			local canvasGroup = gb:GetComponent(CanvasGroup)
			if canvasGroup then
				canvasGroup.alpha = 0
			end
		else
			LogError("[每日活跃]任务索引异常："..index)
			UnityUtils.SetActive(gb, false)
		end
		return
	end
	
	local item = self.missionItemObjs[index]
	if not item then
		item = {}
		item.taskId = taskId
		item.finish = task.is_finish
		item.taskConfig = DailyActivityConfig.GetTaskConfig(taskId)
		
		self.missionItemObjs[index] = item
	end
	
	if not item.gameObject or gb ~= item.gameObject then
		item.gameObject = gb
		item.transform = gb.transform
		item.node = UtilsUI.GetContainerObject(item.transform)
		item.node.self_canvas = gb:GetComponent(CanvasGroup)
		
		UtilsUI.SetEffectSortingOrder(item.node["22125"], self.canvas.sortingOrder + 1)
		item.node.Position_canvas = item.transform:Find("Postion").gameObject:GetComponent(CanvasGroup)
		item.node.DailyActivityMissionItem_Click_hcb.HideAction:RemoveAllListeners()
		item.node.DailyActivityMissionItem_Click_hcb.HideAction:AddListener(
			function()
				self:UpdateMission()
			end)
	end
	
	local gb = item.gameObject
	for _, v in pairs(self.missionItemObjs) do
		if taskId ~= v.taskId and v.gameObject == gb then
			v.gameObject = nil
			break
		end
	end

	self:RefreshMission(item)
end

local MissionRewardTipsStr = TI18N("活跃度")
local MissionRewardStr = TI18N("+%d")
local MissionProcessStr = TI18N("<size=28>%d</size>/%d")
local FullActivationStr = TI18N("本日活跃度已满")
local HadReceivedStr = TI18N("已领取")
local InProcessStr = TI18N("进行中")
local FinishCanvasAlpha = 0.7
local FinishDescAlpha = Color(0, 0, 0, 0.3)
local NormalDescAlpha = Color(0, 0, 0, 1)
function DailyActivityPanel:RefreshMission(missionItem)
	local taskId = missionItem.taskId
	local nodes = missionItem.node
	local config = missionItem.taskConfig
	if not config then
		LogError("[每日活跃]拿不到任务配置："..taskId)
		return 
	end
	
	--任务描述
	nodes.MissionDesc_txt.text = config.desc
	
	--活跃度
	local missionActivation = DailyActivityConfig.GetTaskActivation(config.reward)
	nodes.RewardText_txt.text = string.format(MissionRewardStr, missionActivation)
	--nodes.RewardTips_txt.text = MissionRewardTipsStr
	
	-- 完成状态 1:未完成 2:完成未领取 3:已领取
	local progress, maxProgress = DailyActivityConfig.GetTaskProgress(taskId)
	local finishType = progress == -1 and 3 or 1
	if progress >= maxProgress then
		progress = maxProgress
		finishType = 2
	end
	
	-- 是否达成
	UnityUtils.SetActive(nodes.MissionFinished, finishType == 3)
	nodes.self_canvas.alpha = 1
	nodes.MissionDesc_txt.color = NormalDescAlpha
	nodes.MissionDesc_canvas.alpha = 1
	nodes.Position_canvas.alpha = 1
	if finishType == 3 then
		progress = maxProgress
		nodes.self_canvas.alpha = FinishCanvasAlpha
		nodes.MissionDesc_txt.color = FinishDescAlpha
	end
	
	-- 更新进度
	nodes.ProcessText_txt.text = string.format(MissionProcessStr, progress, maxProgress)
	
	local fullActivation = mod.DailyActivityCtrl:IsFullActivation()
	local showMissionTypeText = false
	local showText = nil
	
	-- 满活跃
	if self.fullActivation then
		showMissionTypeText = true
		showText = FullActivationStr
		
	-- 已领取
	elseif finishType == 3 then
		showMissionTypeText = true
		showText = HadReceivedStr
	end
	
	-- 提交按钮
	local showReceiveBtn = not self.fullActivation and finishType == 2
	UnityUtils.SetActive(nodes.ReceiveBtn, showReceiveBtn)
	if showReceiveBtn then
		local func = function()
			--print("Commit Task:"..taskId)
			self.waitForReciveFunc = function()
				UnityUtils.SetActive(nodes.DailyActivityMissionItem_Click, true)
			end
			mod.SystemTaskCtrl:SystemTaskCommit(taskId)
		end
		
		nodes.ReceiveBtn_btn.onClick:RemoveAllListeners()
		nodes.ReceiveBtn_btn.onClick:AddListener(func)
	end
	UnityUtils.SetActive(nodes.FrameReceive, showReceiveBtn)
	UnityUtils.SetActive(nodes.FrameInProgress, not showReceiveBtn)
	
	-- 跳转按钮
	local jumpId = config.jump_id
	local showJumpBtn = not self.fullActivation and finishType == 1 and jumpId ~= 0
	UnityUtils.SetActive(nodes.JumpBtn, showJumpBtn)
	if showJumpBtn then
		local func = function()
			--print("System Jump:"..jumpId)
			JumpToConfig.DoJump(jumpId)
		end

		nodes.JumpBtn_btn.onClick:RemoveAllListeners()
		nodes.JumpBtn_btn.onClick:AddListener(func)
	end
	
	-- 没有按钮，任务中
	local showInProcessText = not self.fullActivation and finishType == 1 and jumpId == 0
	if showInProcessText then
		showMissionTypeText = true
		showText = InProcessStr
	end
	
	UnityUtils.SetActive(nodes.MissionTypeText, showMissionTypeText)
	if showMissionTypeText then
		nodes.MissionTypeText_txt.text = showText
	end
	
end

local ReceiveTypeBtns = {
	"ReceiveTypeBtn1_btn",	
	"ReceiveTypeBtn2_btn",	
	"ReceiveTypeBtn3_btn",	
}
function DailyActivityPanel:InitActivityProgress(progress, maxProgress, canGetList, hasGetList, data)
	if #data ~= self.ProcessNodeGroup.transform.childCount then
		LogError("[每日活跃]档位数量不一致："..#data)
		return 
	end
	
	TableUtils.ClearTable(self.activationNodes)
	for i = 1, #data do
		self.activationNodes[i] = {}
		
		local activationNode = self.activationNodes[i]
		local config = data[i]
		activationNode.config = config
		
		local nodeTransform = self["ActivityProcessNode"..i].transform
		activationNode.transform = nodeTransform
		
		local nodes = UtilsUI.GetContainerObject(nodeTransform)
		activationNode.node = nodes
		
		UnityUtils.SetActive(nodes.RewardFrame, false)
		activationNode.loadReward = false
		
		for j = 1, #ReceiveTypeBtns do
			local clickFunc = function()
				self:OnClickActivityNode(activationNode, j)
			end
			
			nodes[ReceiveTypeBtns[j]].onClick:RemoveAllListeners()
			nodes[ReceiveTypeBtns[j]].onClick:AddListener(clickFunc)
		end
		
		UtilsUI.SetEffectSortingOrder(nodes["22124"], self.canvas.sortingOrder + 1)
		UtilsUI.SetEffectSortingOrder(nodes["22126"], self.canvas.sortingOrder + 1)
		UtilsUI.SetEffectSortingOrder(nodes["22127"], self.canvas.sortingOrder + 1)
		
		nodes.DailyActivity_type_gou_hcb.HideAction:RemoveAllListeners()
		nodes.DailyActivity_type_gou_hcb.HideAction:AddListener(
			function()
				UnityUtils.SetActive(nodes.ReceiveType2, false)
				UnityUtils.SetActive(nodes.ReceiveType3, true)
				
			end)

	end
	
	self.ActivityProcessBar_img.fillAmount = progress / maxProgress
	self:RefreshActivityProgress(progress, canGetList, hasGetList, data)
end

local singleStep = 0.02
function DailyActivityPanel:ProgressAnim()
	self.step = self.step + singleStep
	local amount = self.curAmount + self.step
	amount = amount > self.nextAmount and self.nextAmount or amount
	self.ActivityProcessBar_img.fillAmount = amount
	
	if amount >= self.nextAmount then
		self.playAnim = false
		self.curAmount = nil
		self.nextAmount = nil
		self.step = 0
		if self.updateTimer then
			LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
		end
	end
end

local DefaultMaxActivation = 500
function DailyActivityPanel:RefreshActivityProgress(progress, canGetList, hasGetList, data)
	local maxProgress = data[#data].activation or DefaultMaxActivation
	self.ActivityProcessText_txt.text = progress <= maxProgress and tostring(progress) or maxProgress
	
	local finish = 0
	for i = 1, #data do
		local activationNode = self.activationNodes[i]
		if self:UpdateActivationNode(activationNode, progress, canGetList, hasGetList) then
			finish = i
		end
	end
	
	--每一节的进度不一定一致，分开算
	local fillAmount = 1
	if finish < #data then
		local singleProgress = 1 / #data
		local curActivation = finish == 0 and 0 or self.activationNodes[finish].config.activation
		local nextActivation = self.activationNodes[finish + 1].config.activation
		fillAmount = (finish + (progress - curActivation) / (nextActivation - curActivation)) * singleProgress
	end
	
	self.step = self.step or 0
	self.curAmount = self.curAmount or self.ActivityProcessBar_img.fillAmount
	self.nextAmount = fillAmount
	
	if not self.playAnim and self.curAmount < self.nextAmount then
		self.playAnim = true
		self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.02, self:ToFunc("ProgressAnim"))
	end
	--self.ActivityProcessBar_img.fillAmount = fillAmount
end

function DailyActivityPanel:UpdateActivationNode(activationNode, progress, canGetList, hasGetList)
	local nodes = activationNode.node
	local config = activationNode.config
	
	nodes.NodeText_txt.text = config.activation

	local rewardReciveType = DailyActivityConfig.GetRewardReciveType(config, progress, canGetList, hasGetList)
	local finish = rewardReciveType > 1

	UnityUtils.SetActive(nodes.UnfinishedNode, not finish)
	UnityUtils.SetActive(nodes.FinishedNode, finish)
	
	if nodes.ReceiveType1.activeSelf and finish == 2 then
		UnityUtils.SetActive(nodes.DailyActivity_type_Open, true)
	end

	UnityUtils.SetActive(nodes.ReceiveType1, not finish) --未完成
	if nodes.ReceiveType2.activeSelf and rewardReciveType >= 3 then
		UnityUtils.SetActive(nodes.DailyActivity_type_gou, true)
	else
		UnityUtils.SetActive(nodes.ReceiveType2, rewardReciveType == 2) --可领取
		UnityUtils.SetActive(nodes.ReceiveType3, rewardReciveType >= 3) --已领取
	end
	
	return finish
end

local RefreshStr = TI18N("刷新时间 %d小时%d分钟")
function DailyActivityPanel:InitRefreshTime()
	local curTimeStamp = TimeUtils.GetCurTimestamp()
	local nextTimeStamp = TimeUtils.getNextClosestHour()
	local seconds = nextTimeStamp - curTimeStamp
	local remainTime = TimeUtils.convertSecondsToDHMs(seconds)
	
	self.RefreshText_txt.text = string.format(RefreshStr, remainTime.hours, remainTime.minutes)
end

function DailyActivityPanel:OnClickActivityNode(activationNode, receiveType)
	local curActivation = activationNode and activationNode.config.activation or self.showRewawrd
	if receiveType == 2 then --领取
		mod.DailyActivityCtrl:ReceiveActivityReward(curActivation)
	else --显示奖励
		self.clickReward = nil
		if self.showRewawrd == activationNode then
			self:ToggleRewardGroup(activationNode, false)
			self.showRewawrd = nil
			return
		end
		self:ToggleRewardGroup(self.showRewawrd, false)
		self:ToggleRewardGroup(activationNode, true)
		self:SetRewardItem(activationNode)
		self.showRewawrd = activationNode
	end
end

local RewardWidth = 78 --Item大小:120 * 0.65
local EdgeWdith = 12 --边缘宽度
function DailyActivityPanel:SetRewardItem(activationNode)
	if activationNode.loadReward then
		return 
	end
	
	
	local config = activationNode.config
	local rewardList = DailyActivityConfig.GetRewardList(config.reward_id)
	
	activationNode.cacheObjList = activationNode.cacheObjList or {}

	if rewardList then
		for i = 1, #rewardList do
			local rewardConfig = rewardList[i]
			local itemInfo = {template_id = rewardConfig[1], count = rewardConfig[2], can_lock = false, scale = 0.65}

			local item = activationNode.cacheObjList[i]
			if not item then
				item = ItemManager.Instance:GetItem(activationNode.node.RewardItemGroup.transform, itemInfo)
				table.insert(activationNode.cacheObjList, item)
			else
				item:SetItem(itemInfo)
				item:Show()
			end
		end
	end

	local transform = activationNode.node.RewardBg.transform
	local width = RewardWidth * #rewardList + EdgeWdith
	UnityUtils.SetSizeDelata(transform, width, transform.sizeDelta.y)
	
	activationNode.loadReward = true
end

function DailyActivityPanel:ShowReward(activationNode)
	local nodeTransform = activationNode.transform
	local activityProgressAnchoredPosition = self.ActivityProgress.transform.anchoredPosition
	local processNodeGroupAnchoredPosition = self.ProcessNodeGroup.transform.anchoredPosition
	
	local x = activityProgressAnchoredPosition.x + processNodeGroupAnchoredPosition.x + nodeTransform.anchoredPosition.x
	local y = activityProgressAnchoredPosition.y + processNodeGroupAnchoredPosition.y - 105 --相对偏移值
	UnityUtils.SetAnchoredPosition(self.RewardFrame.transform, x, y)
end

function DailyActivityPanel:ToggleRewardGroup(activationNode, active)
	if not activationNode then
		return 
	end
	
	if active then
		UnityUtils.SetActive(self.RewardGroupBack, true)
		UnityUtils.SetActive(activationNode.node.RewardFrame, true)
		UnityUtils.SetActive(activationNode.node.DailyActivity_arrow_Open, true)
	else
		UnityUtils.SetActive(self.RewardGroupBack, false)
		UnityUtils.SetActive(activationNode.node.DailyActivity_arrow_Exit, true)
	end
end

function DailyActivityPanel:ShowPanelTips()
	local controlId = self.info and self.info.control_id or 1
	local teachId = DailyActivityConfig.GetDailyActivityTeachId(controlId)
	BehaviorFunctions.ShowGuideImageTips(teachId)
end

function DailyActivityPanel:OnSystemTaskUpdate()
	if not self.info or not self.info.task_list then
		return 
	end
	
	if self.waitForReciveFunc then
		self.waitForReciveFunc()
		self.waitForReciveFunc = nil
	else
		self:UpdateMission()
	end
end

function DailyActivityPanel:ShowCloseNode()
    self.DailyActivityPanel_Exit:SetActive(true)
end