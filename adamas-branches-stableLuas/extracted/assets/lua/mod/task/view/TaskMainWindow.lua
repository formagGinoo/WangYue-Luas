
TaskMainWindow = BaseClass("TaskMainWindow",BaseWindow)

local _insert = table.insert

local TaskUICacheType =
{
	Group = 1,      -- 主类型UI
	GroupChild = 2, -- 子类型UI
	TaskItem = 3,   -- 任务UI
	GroupTaskItem = 4, -- 主类型任务UI
	Max = 4,
} 

local TaskUIObjName =
{
	[TaskUICacheType.Group] = "TaskGroup",
	[TaskUICacheType.GroupChild] = "TaskGroupChild",
	[TaskUICacheType.TaskItem] = "TaskItem",
	[TaskUICacheType.GroupTaskItem] = "GroupTaskItem",
}

function TaskMainWindow:__init()
	self:SetAsset("Prefabs/UI/Task/TaskMainWindowV2.prefab")
	self.curSelect = 1

	self.uiObjCache = {}
	for i = 1, TaskUICacheType.Max do
		self.uiObjCache[i] = {}
	end

	self.taskTypeMap = {}
	self.taskIdMap = {}
	self.rewardItemObjs = {}

	self.taskTargetObjPool = {}
	self.taskTargetOnShow = {}

	self.taskTabObj = {}

	self.taskNode = {}
	self.selectIndex = 1

	-- allMainType这里有写死 后续改成通过策划配置动态生成类型
	self.allTaskMainType = TaskConfig.GetAllTaskMainType()
end

function TaskMainWindow:__delete()

	for _, v in pairs(self.rewardItemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.rewardItemObjs = {}
	
	if self.cacheFOV then
		BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(self.cacheFOV, FightEnum.CameraState.Operating)
		self.cacheFOV = nil
	end
	self.chapterRewardBG_btn.onClick:RemoveAllListeners()
end

function TaskMainWindow:__CacheObject()
	self.cacheTransform = self.cacheNode.transform
end

function TaskMainWindow:__BindListener()
	--self:SetHideNode("TaskMainWindow_out")
	self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
	self.chapterRewardBG_btn.onClick:AddListener(self:ToFunc("OnClickChapterWindow"))
	self.btnGo_btn.onClick:AddListener(self:ToFunc("OnTaskTarget"))
	self.ReviewBtn_btn.onClick:AddListener(self:ToFunc("OnClickReviewBtn"))
end

function TaskMainWindow:__BindEvent()
	self:BindRedPoint(RedPointName.TaskChapter, self.chapterRewardRed)
end

function TaskMainWindow:__Create()
	local toggleList = {
		self["btnTab1_tog"], self["btnTab2_tog"], self["btnTab3_tog"], self["btnTab4_tog"], self["btnTab5_tog"]
	}
    self.toggleTab = ToggleTab.New()
    self.toggleTab:InitByToggles(toggleList, function(curSelect)
        self:SelectTab(curSelect)
    end)

	for i = 1, #toggleList do
		local objs = {}
		UtilsUI.GetContainerObject(self["btnTab"..i], objs)
		self.taskTabObj[i] = objs
	end
end

function TaskMainWindow:__ShowComplete()
end

function TaskMainWindow:__Show()
	local setting = {blurRadius = 1, playAnim = "BlurBack_In_2", bindNode = self.BlurNode, passEvent = UIDefine.BlurBackCaptureType.Scene}
	local callBack = function ()
		if BehaviorFunctions.fight.clientFight.cameraManager:GetCameraState() == FightEnum.CameraState.Operating then
			BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(60)
		end
	end
	self:SetBlurBack(setting, callBack)
	self.cacheFOV = BehaviorFunctions.fight.clientFight.cameraManager:GetFOV()
	if BehaviorFunctions.fight.clientFight.cameraManager:GetCameraState() == FightEnum.CameraState.Operating then
		BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(65)
	end
	self.taskTypeMap = {}

	local taskTypeList = mod.TaskCtrl:GetTastTypeMap()
	for taskType, taskList in pairs(taskTypeList) do
		if next(taskList) then
			local typeMap = { taskType = taskType, typeChildMap = {}}
			for k, v in pairs(taskList) do
				for taskId, bool in pairs(v) do
					local isMulTask = mod.TaskCtrl:CheckTaskIsMultarget(taskId)
					local mulTasks
					local taskStepCount = Config.DataTask.data_task_Countbyid[taskId]
					--当有多目标任务时
					if isMulTask then
						mulTasks = mod.TaskCtrl:GetTaskTargets(taskId)
						taskStepCount = #mulTasks
					end
					if not taskStepCount then
						taskStepCount =0
					end

					for i = 1, taskStepCount, 1 do
						local taskConfig
					   if isMulTask then
						taskConfig = mulTasks[i]
					   else
						taskConfig = Config.DataTask.data_task[taskId.."_"..i]
						if not taskConfig or taskConfig.is_hide_task or (taskConfig.show_id~=0) then
							goto continue
						end
					   end

					   local mType,childType = mod.TaskCtrl:GetTaskType(taskId)
					   if not childType then
						   LogError("获取任务类型失败，任务Id = %s",taskId)
						   return
					   end

					    local childTaskInfo = typeMap.typeChildMap[childType] --章节
					
					    if not childTaskInfo then
						    childTaskInfo = { taskItemMap = {} }
						    childTaskInfo.name = TaskConfig.GetChildTypeName(taskType, childType)
						    childTaskInfo.subhead = TaskConfig.GetChildTypeSubhead(taskType, childType)
						    childTaskInfo.childType = childType
						    typeMap.typeChildMap[childType] = childTaskInfo
					    end
					
					    if not self.taskNode[taskId] then
						    self.taskNode[taskId] = {}
					    end

					    _insert(self.taskNode[taskId],taskConfig)

					    for index, v in ipairs(typeMap.typeChildMap[childType].taskItemMap) do
							if not isMulTask then
								if v.taskId == taskConfig.id then
									goto continue
								 end
							else
								if v.taskId == taskConfig.show_id then
									goto continue
								 end
							end
						    
					    end
					    _insert(childTaskInfo.taskItemMap, {taskId = taskId, data = self.taskNode[taskId]})
					    ::continue::
					end
				end
			end

			local typeChildList = {}
			for __, vv in pairs(typeMap.typeChildMap) do
				local onTaskSort = function (a, b)
					return a.taskId < b.taskId
				end
				table.sort(vv.taskItemMap, onTaskSort)
				table.insert(typeChildList, vv)
			end

			local onChildTypeSort = function (a, b)
				return a.childType > b.childType
			end
			table.sort(typeChildList, onChildTypeSort)

			typeMap.typeChildList = typeChildList
			self.taskTypeMap[taskType] = typeMap
		end
	end

	self:SelectTab(1)
end

function TaskMainWindow:GetTaskList(taskType)
	if taskType == 0 then
		return self.taskTypeMap
	else
		return {self.taskTypeMap[taskType]}
	end
end

function TaskMainWindow:PopUIObject(type, parent)
	local objectInfo = self:PopUITmpObject(type, parent)
	if objectInfo.Select then
		objectInfo.Select:SetActive(false)
	end
	if objectInfo.itemTimer then
		LuaTimerManager.Instance:RemoveTimer(objectInfo.itemTimer)
		objectInfo.itemTimer = nil
	end

	local objectTransform = objectInfo.object.transform
	if type == TaskUIObjName[TaskUICacheType.Group]  then
	elseif type == TaskUIObjName[TaskUICacheType.GroupChild ] then
		objectInfo.isOpenItems = true
		objectInfo.isSelect = false
	elseif type ==  TaskUIObjName[TaskUICacheType.TaskItem] or type == TaskUIObjName[TaskUICacheType.GroupTaskItem] then
		objectInfo.isSelect = false
	end

	objectInfo.objectTransform = objectTransform

	return objectInfo
end

function TaskMainWindow:ClearUITaskList()
	self.taskIdMap = {}
	self.selectTaskInfo = nil

	self:PushAllUITmpObject(TaskUIObjName[TaskUICacheType.Group], self.cacheNode_rect)
	self:PushAllUITmpObject(TaskUIObjName[TaskUICacheType.GroupChild], self.cacheNode_rect)
	self:PushAllUITmpObject(TaskUIObjName[TaskUICacheType.TaskItem], self.cacheNode_rect)
	self:PushAllUITmpObject(TaskUIObjName[TaskUICacheType.GroupTaskItem], self.cacheNode_rect)
	for _, v in pairs(self.taskTypeMap) do
		v.objectInfo = nil
		for __, vv in pairs(v.typeChildMap) do
			vv.objectInfo = nil
			for ___, vvv in pairs(vv.taskItemMap) do
				vvv.objectInfo = nil
			end
		end
	end
end

function TaskMainWindow:SelectTab(curSelect)
	self.curSelect = curSelect
	for i = 1, #self.taskTabObj do
		UnityUtils.SetActive(self.taskTabObj[i].Icon, i == curSelect)
		UnityUtils.SetActive(self.taskTabObj[i].imgSelect, i == curSelect)
		UnityUtils.SetActive(self.taskTabObj[i].UIcon, i ~= curSelect)
	end
	self.DetailPanel:SetActive(false)
	if curSelect == 1 then
		self.topTitle.transform:SetActive(true)
		self.Titletext_txt.text = TI18N("进行中")
	elseif curSelect == 2 then
		self.topTitle.transform:SetActive(true)
		self.Titletext_txt.text = TI18N("进行中")
	else
		self.topTitle.transform:SetActive(true)
		self.Titletext_txt.text = self.allTaskMainType[curSelect - 1]
	end

	self:ClearUITaskList()
	
	local taskTypeList = self:GetTaskList(curSelect - 1)
	if not next(taskTypeList) then
		self.TaskNullPanel:SetActive(true)
		self.TaskScroll:SetActive(false)
		return
	else
		self.TaskNullPanel:SetActive(false)
		self.TaskScroll:SetActive(true)
	end

	for k, v in pairs(taskTypeList) do
		self:ShowTaskType(v)
	end

	UnityUtils.SetLocalPosition(self.TaskRoot_rect, 0,0,0)
end

function TaskMainWindow:ShowTaskType(taskTypeInfo)
	if not taskTypeInfo.typeChildList or not next(taskTypeInfo.typeChildList) then
		return
	end

	local objectInfo = self:PopUIObject(TaskUIObjName[TaskUICacheType.Group], self.TaskRoot_rect)
	taskTypeInfo.objectInfo = objectInfo
	local objectTransform = objectInfo.objectTransform

	objectInfo.TaskTypeText_txt.text = self.allTaskMainType[taskTypeInfo.taskType]

	for i = 1, #self.allTaskMainType - 1 do
		objectInfo["imgType"..i]:SetActive(taskTypeInfo.taskType == i)
	end

	for _, v in ipairs(taskTypeInfo.typeChildList) do --章节列表
		self:ShowTaskGroupChild(objectTransform, v)
	end
	self:UpdateLayout(objectInfo.objectTransform)
end

function TaskMainWindow:UpdateLayout(transform)
	LayoutRebuilder.ForceRebuildLayoutImmediate(transform:GetComponent(RectTransform))
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.TaskRoot_rect)
end

function TaskMainWindow:ShowTaskGroupChild(parent, childGroupInfo) 
	local taskItemParent = parent
	if childGroupInfo.childType > 0 then
		local objectInfo = self:PopUIObject(TaskUIObjName[TaskUICacheType.GroupChild], parent)
		childGroupInfo.objectInfo = objectInfo
		local objectTransform = objectInfo.objectTransform
		taskItemParent = objectTransform

		local onCallBack = function ()
			local visible = not objectInfo.isOpenItems
			local time = -0.03
			for _, v in pairs(childGroupInfo.taskItemMap) do
				if objectInfo.itemTimer then
					LuaTimerManager.Instance:RemoveTimer(objectInfo.itemTimer)
					objectInfo.itemTimer = nil
				end

				if visible then
					time = time + 0.03
					v.objectInfo.object:SetActive(false)
					local function playAnimZ()
						v.objectInfo.object:SetActive(true)
						self:UpdateLayout(parent)
					end
					v.objectInfo.itemTimer = LuaTimerManager.Instance:AddTimer(1, time, playAnimZ)	
				else
					time = time + 0.03
					local function playAnimS()
						v.objectInfo.object:SetActive(false)
						self:UpdateLayout(parent)
					end
					v.objectInfo.itemTimer = LuaTimerManager.Instance:AddTimer(1, time, playAnimS)	
				end
			end
			objectInfo.isOpenItems = visible

			self:UpdateLayout(parent)

		end

		local taskChildBtn = objectInfo.TaskChildBtn_btn
		taskChildBtn.onClick:RemoveAllListeners()
		taskChildBtn.onClick:AddListener(onCallBack)

		objectInfo.Name_txt.text = childGroupInfo.name
		objectInfo.Detail_txt.text = childGroupInfo.subhead

		local arrowRotaionZ = objectInfo.isOpenItems and 0 or 90
		CustomUnityUtils.SetLocalEulerAngles(objectInfo.Arrow_rect,0,0,arrowRotaionZ)
	end

	for _, v in pairs(childGroupInfo.taskItemMap) do
		self.taskIdMap[v.taskId] = v--TODO
		self:ShowTaskGroupItem(childGroupInfo, v, taskItemParent)
	end

	LayoutRebuilder.ForceRebuildLayoutImmediate(parent:GetComponent(RectTransform))
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.TaskRoot_rect)
end

function TaskMainWindow:ShowTaskGroupItem(groupInfo, taskInfo, parent)--更新任务列表的前置操作
	taskInfo.groupInfo = groupInfo
	-- local parent = groupInfo.objectInfo.objectTransform
	local objectInfo
	if groupInfo.childType > 0 then
		objectInfo = self:PopUIObject(TaskUIObjName[TaskUICacheType.TaskItem], parent)
	else
		objectInfo = self:PopUIObject(TaskUIObjName[TaskUICacheType.GroupTaskItem], parent)
	end

	taskInfo.objectInfo = objectInfo
	

	self:UpdateTaskItem(taskInfo.taskId)

	if not self.selectTaskInfo then
		self.btnGo:SetActive(not objectInfo.visibleCond)
		self:UpdateTaskSelect(taskInfo)
	end
end

function TaskMainWindow:UpdateTaskItem(taskId) --更新任务列表
	local taskInfo = self.taskIdMap[taskId]
	local objectInfo = taskInfo.objectInfo
	local step =  mod.TaskCtrl:GetTaskStep(taskId)
	
	local taskConfig = taskInfo.data[step]

	if not taskConfig then
		return
	end

	if mod.TaskCtrl:CheckTaskIsMultarget(taskId) then
		taskConfig = Config.DataTask.data_task[taskId.."_"..step]
	end

	local info = mod.WorldLevelCtrl:GetAdventureInfo()
	local roleLevel = info.lev
	local acceptLev = Config.DataTaskNode.data_task_node[Config.DataTaskNode.FindTasksInfo[taskConfig.id].id].accept_lev
	local visibleCond = roleLevel < acceptLev
	if visibleCond then
		objectInfo.Cond_txt.text = string.format(TI18N("需要等级%s"), acceptLev)
	else
		objectInfo.Cond_txt.text = ""
	end
	objectInfo.visibleCond = visibleCond
	objectInfo.Desc_txt.text = taskConfig.task_name
	local task = Fight.Instance.taskManager:GetGuideTask()
	if task and task.taskConfig and task.taskConfig.id == taskConfig.id then--TODO
		for i = 1, #self.allTaskMainType - 1 do
			local res = (i == task.taskConfig.type)
			objectInfo["imgType"..i]:SetActive(res)

			if res then
				objectInfo["imgType"..i.."_rect"]:GetChild(0):SetActive(false)
				self.timer = LuaTimerManager.Instance:AddTimer(1, 0.3, function ()
					objectInfo["imgType"..i.."_rect"].transform:GetChild(0):SetActive(true)
				end)
			end
		end
	else
		for i = 1, #self.allTaskMainType - 1  do
			objectInfo["imgType"..i]:SetActive(false)
		end
	end

	if mod.TaskCtrl:GetTaskPositionById(taskId) then
		local pos1 = mod.TaskCtrl:GetTaskPositionById(taskId)
		local pos2 = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().transformComponent.position
		objectInfo.Distance_txt.text = math.floor(Vector3.Distance(pos1, pos2)).."m"
	else
		objectInfo.Distance_txt.text = ""
	end

	local onCallBack = function ()
		self:UpdateTaskSelect(taskInfo, true)
	end

	local taskItemBtn = objectInfo.TaskItemBtn_btn
	taskItemBtn.onClick:RemoveAllListeners()
	taskItemBtn.onClick:AddListener(onCallBack)

	taskInfo.objectInfo.BgImg:SetActive(true)
	
	UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#393F4A")
	UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#5A5B68")
end

function TaskMainWindow:UpdateTaskSelect(taskInfo, btnSelect)--当点击主任务时的前置条件设置
	if taskInfo == self.selectTaskInfo then
		return
	end
	
	if self.selectTaskInfo then
		self:SetTaskSelect(self.selectTaskInfo, false)
	end

	self:SetTaskSelect(taskInfo, true)

	self.selectTaskInfo = taskInfo
	mod.TaskCtrl:SetSelectTaskInfo(taskInfo)
	self.selectIndex = 1
	self:UpdateTaskContent(taskInfo)
end

function TaskMainWindow:SetTaskSelect(taskInfo, visible)

	taskInfo.objectInfo.BgImg:SetActive(not visible)
	taskInfo.objectInfo.Select:SetActive(visible)
	if visible then
		taskInfo.objectInfo.Desc_txt.fontSize = 32
		UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#F6F6F6")
		UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#A6A5A5")
	else
		taskInfo.objectInfo.Desc_txt.fontSize = 32
		UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#393F4A")
		UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#5A5B68")
	end
	
	local groupObjectInfo = taskInfo.groupInfo.objectInfo
	if groupObjectInfo and self.selectTaskInfo then
		local selectGroupObjectInfo = self.selectTaskInfo.groupInfo.objectInfo
		if selectGroupObjectInfo and groupObjectInfo.object ~= selectGroupObjectInfo.object then
			selectGroupObjectInfo.Select:SetActive(false)
		end
	elseif not groupObjectInfo and self.selectTaskInfo then
		local selectGroupObjectInfo = self.selectTaskInfo.groupInfo.objectInfo
		if selectGroupObjectInfo then
			selectGroupObjectInfo.Select:SetActive(false)
		end
	end
	
	if groupObjectInfo and not groupObjectInfo.Select.activeSelf then
		groupObjectInfo.Select:SetActive(visible)
	end
end

local DataReward = Config.DataReward.Find
function TaskMainWindow:UpdateTaskContent(taskInfo)

	local step =  mod.TaskCtrl:GetTaskStep(taskInfo.taskId)
	local taskConfig = taskInfo.data[step]
	local count = #self.selectTaskInfo.data
	--生成多目标任务列表
	if  not mod.TaskCtrl:CheckTaskIsMultarget(taskInfo.taskId) then
		count = 0
	end
	self:ShowTaskTarget(count)
	local taskCfg = nil
	if count >0  then
		taskCfg = mod.TaskCtrl:GetMulTarget()
	end
	
	if taskCfg then
		for i = 1, count, 1 do
			if taskCfg.id == taskInfo.data[i].id then
				self.selectIndex = i
				break
			end
		end
		self:ShowTaskContent(taskCfg)
	else
		self.selectIndex = 1
		self:ShowTaskContent(taskConfig)
	end
end

function TaskMainWindow:ShowTaskContent(taskConfig)
	
	if not taskConfig then
		return
	end

	if #self.taskTargetOnShow>0 then
		self.taskTargetOnShow[self.selectIndex].LogicGuide:SetActive(true)
	end

	local taskPosition
	if next(taskConfig.task_position) then
		taskPosition = BehaviorFunctions.GetTerrainPositionP(taskConfig.task_position[2], taskConfig.position_id, taskConfig.task_position[1])
	elseif taskConfig.trace_eco_id and taskConfig.trace_eco_id~=0 then
		taskPosition = BehaviorFunctions.GetEcoEntityPosition(taskConfig.trace_eco_id)
	end

	self.taskName_txt.text = taskConfig.task_name
	
	UnityUtils.SetActive(self.TaskAreaObj, false)
	if taskPosition then
		local areaInfo, areaType, bigAreaInfo = Fight.Instance.mapAreaManager:GetAreaInfoByPosition(taskPosition, taskConfig.position_id)
		if areaInfo then
			self.TaskArea_txt.text = bigAreaInfo.name.."·"..areaInfo.name
			UnityUtils.SetActive(self.TaskAreaObj, true)
		end
	end

	self.taskTips2_txt.text = taskConfig.task_desc
	self.DetailPanel:SetActive(false)
	self.DetailPanel:SetActive(true)

	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	if mod.TaskCtrl:GetTaskPositionById(taskConfig.id) then
		self.btnGo:SetActive(true)
	else
		-- 角色不在任务区域时也显示追踪按钮
		if taskConfig.map_id == mod.WorldMapCtrl.mapId then
			self.btnGo:SetActive(false)
		end
		if mod.TaskCtrl:CheckTaskIsMultarget(taskConfig.id) then
			self.btnGo:SetActive(true)
		end
	end

	if guideTask and guideTask.taskId == taskConfig.id then
		self.btnGoText_txt.text = TI18N("追踪中")
	else
		self.btnGoText_txt.text = TI18N("追踪")
	end

	for _, v in pairs(self.rewardItemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.rewardItemObjs = {}
	if taskConfig.show_award and taskConfig.show_award ~= 0 then
		local rewardCfg = DataReward[taskConfig.show_award]
		if not rewardCfg then
			LogError("没有这个奖励配置 rewardId = "..taskConfig.show_award.." 任务ID = "..taskConfig.id)
			return
		end

		for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 0.8}
			local item = ItemManager.Instance:GetItem(self.RewardGroup.transform, itemInfo)
			table.insert(self.rewardItemObjs, item)
		end
	end

end


function TaskMainWindow:ShowTaskTarget(count)
	local targets = self.selectTaskInfo.data
	local targetCount = count

	if not self.taskTargetOnShow then
		self.taskTargetOnShow = {}
	end

	if #self.taskTargetOnShow < targetCount then
		for i = 1,targetCount - #self.taskTargetOnShow do
			table.insert(self.taskTargetOnShow, self:GetTaskTargetObj())
		end
	elseif #self.taskTargetOnShow > targetCount then
		for i = #self.taskTargetOnShow,  targetCount +1, -1 do
			local obj = table.remove(self.taskTargetOnShow)
			UnityUtils.SetActive(obj.object, false)
			table.insert(self.taskTargetObjPool, obj)
		end
	end

	for i = 1, #self.taskTargetOnShow do
		local onCallBack = function ()
			if self.selectIndex ~= 0 then
				self.taskTargetOnShow[self.selectIndex].LogicGuide:SetActive(false)
			end
			self.selectIndex = i
			self:ShowTaskContent(self.selectTaskInfo.data[self.selectIndex])
		end
		self.taskTargetOnShow[i].TargetDesc_txt.text = targets[i].task_goal
	    self.taskTargetOnShow[i].TargetBtn_btn.onClick:AddListener(onCallBack)
	end
end

function TaskMainWindow:GetTaskTargetObj()
	if self.taskTargetObjPool and next(self.taskTargetObjPool) then
		local obj = table.remove(self.taskTargetObjPool)
		UnityUtils.SetActive(obj.object, true)
		return obj
	end
	local obj = self:PopUITmpObject("TaskTargetTemp")
	obj.objectTransform:SetParent(self.TaskTargetContent.transform)
	UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
	UnityUtils.SetActive(obj.object, true)
	UtilsUI.GetContainerObject(obj.objectTransform, obj)

	return obj
end

function TaskMainWindow:OnTaskTarget()
	self.btnGo_btn.enabled = false --防止连续点击先失活
	if not self.selectTaskInfo then
		return
	end
	local task = Fight.Instance.taskManager:GetGuideTask() --获取当前指引任务
	local taskInfo = self.selectTaskInfo.data[self.selectIndex] -- 当前选择的任务
	local result =  self:ExitTask(task)
	if result then
		return
	end
	if task and mod.TaskCtrl:CheckTaskIsMultarget(task.taskId) then --检查下是否是多目标任务
		task.taskConfig = taskInfo --将任务信息替换为当前选择的子任务
	end
	LuaTimerManager.Instance:AddTimer(1,0.3, function () --恢复按钮状态
		self.btnGo_btn.enabled = true
	end)
	
	if taskInfo then--如果是多目标任务的子任务
		if taskInfo.show_id~= 0 and taskInfo.show_id then
			mod.TaskCtrl:SetMulTarget(taskInfo) --将目标任务设置成当前的子任务
			EventMgr.Instance:Fire(EventName.MulTaskChange,taskInfo) --更改面板左侧任务显示
		end
	end
	--self:ChangeTaskTarget(task)
end

function TaskMainWindow:ChangeTaskTarget(task)
    --取消任务追踪
	if task and task.taskConfig and self.selectTaskInfo.data[self.selectIndex].id == task.taskConfig.id then
		local guideObject = self.selectTaskInfo.objectInfo
		for i = 1, #self.allTaskMainType - 1 do
			guideObject["imgType"..i]:SetActive(false)
		end

		local id, cmd = mod.TaskCtrl:ChangeGuideTask(0)
		mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
			mod.TaskCtrl:SetGuideTaskId()
		end)

		LuaTimerManager.Instance:AddTimer(1,0.13, function ()
			self.btnGoText_txt.text = TI18N("追踪")
		end)
		return
	end
	--任务追踪
	local taskCfg
	if not task then
		local id =  self.selectTaskInfo.data[self.selectIndex].id
		taskCfg = self.taskIdMap[id]
	else
		taskCfg = self.taskIdMap[task.taskConfig.id]
	end

	if taskCfg then
		local objectInfo = taskCfg.objectInfo
		if objectInfo then
			for i = 1, #self.allTaskMainType - 1 do
				objectInfo["imgType"..i]:SetActive(false)
			end
		end
	end

	local guideObject = self.selectTaskInfo.objectInfo

	for i = 1, #self.allTaskMainType - 1 do
		guideObject["imgType"..i]:SetActive(i == mod.TaskCtrl:GetTaskType(self.selectTaskInfo.data[self.selectIndex].id))
	end

	local id, cmd = mod.TaskCtrl:ChangeGuideTask(self.selectTaskInfo.data[self.selectIndex].id)
	mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
		self.btnGoText_txt.text = TI18N("追踪中")
		task = Fight.Instance.taskManager:GetGuideTask()
		local taskConfig = task.taskConfig
		local mapId = Fight.Instance:GetFightMap()
		if task and mod.TaskCtrl:CheckTaskIsMultarget(task.taskId) then
			taskConfig = self.selectTaskInfo.data[self.selectIndex]
		end
		if taskConfig and taskConfig.map_id ~= mapId then
			--不在同一个地图弹出tips
			local mapName = Config.DataMap.data_map[taskConfig.map_id].name
			MsgBoxManager.Instance:ShowTips(string.format("目标位于[%s]，请前往此场景以进行任务", mapName))
		end
	end)

end

function TaskMainWindow:ExitTask(task)
	if not task then
		self:ChangeTaskTarget(task)
	else
		local taskId = task.taskId
        local taskConfig = mod.TaskCtrl:GetTaskConfig(taskId)

        if not taskConfig then
			self:ChangeTaskTarget(task)
            return
        end

        if not taskConfig.exit_task then
		    self:ChangeTaskTarget(task)
			return
        end

        local function confimFunc()
		    local levelId = taskConfig.trigger[2][1]
            if levelId then
                BehaviorFunctions.RemoveLevel(tonumber(levelId))--关闭关卡
            end
            local stepId = mod.TaskCtrl:GetTaskStep(taskId)
			mod.TaskCtrl:SetExitTask(taskId)
            EventMgr.Instance:Fire(EventName.TaskBehaviorStateChange, taskId,stepId,false)--暂停状态
			--EventMgr.Instance:Fire(EventName.ExitTask)
			self:ChangeTaskTarget(task)
            return false
        end
    local function cancelFunc()
        return true
    end
    local function closeFunc()
        return true
    end
    --弹出提示窗口
    MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否要退出当前关卡?"),confimFunc,cancelFunc,closeFunc)
		
	end
	
end

function TaskMainWindow:OnClickChapterWindow()
	WindowManager.Instance:OpenWindow(TaskChapterWindow, {mainView = false , notTempHide = true})
end

function TaskMainWindow:OnClickReviewBtn()
	WindowManager.Instance:OpenWindow(TaskReviewMainWindow)
end
function TaskMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end