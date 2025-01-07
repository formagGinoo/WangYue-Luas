
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
	self:SetAsset("Prefabs/UI/Task/TaskMainWindow.prefab")
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
	-- allMainType这里有写死 后续改成通过策划配置动态生成类型
	self.allTaskMainType = TaskConfig.GetAllTaskMainType()
end

function TaskMainWindow:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end

	for _, v in pairs(self.rewardItemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.rewardItemObjs = {}
	
	if self.cacheFOV then
		BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(self.cacheFOV, FightEnum.CameraState.Operating)
		self.cacheFOV = nil
	end
end

function TaskMainWindow:__CacheObject()
	self.cacheTransform = self.cacheNode.transform
end

function TaskMainWindow:__BindListener()
	--self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClickClose_CallBack"),self:ToFunc("OnClick_CloseBtn"))

	self.btnGo_btn.onClick:AddListener(self:ToFunc("OnTaskTarget"))
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
    if not self.blurBack then
		local setting = {blurRadius = 1, playAnim = "BlurBack_In_2", bindNode = self.BlurNode}
		self.blurBack = BlurBack.New(self, setting, {passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 0})
    end
	local callBack = function ()
		if BehaviorFunctions.fight.clientFight.cameraManager:GetCameraState() == FightEnum.CameraState.Operating then
			BehaviorFunctions.fight.clientFight.cameraManager:SetFOV(60)
		end
	end
    self.blurBack:Show({callBack})
end

function TaskMainWindow:__Show()
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
				if v.taskConfig.is_hide_task then
					goto continue
				end

				local childType = v.taskConfig.sec_type
				if not v.taskConfig.show_parent then
					childType = 0
				end
				local childTaskInfo = typeMap.typeChildMap[childType]
				
				if not childTaskInfo then
					childTaskInfo = { taskItemMap = {} }
					childTaskInfo.name = TaskConfig.GetChildTypeName(taskType, childType)
					childTaskInfo.subhead = TaskConfig.GetChildTypeSubhead(taskType, childType)
					childTaskInfo.childType = childType
					typeMap.typeChildMap[childType] = childTaskInfo
				end
	
				_insert(childTaskInfo.taskItemMap, {taskId = v.taskId, data = v})

				::continue::
			end

			local typeChildList = {}
			for __, vv in pairs(typeMap.typeChildMap) do
				local onTaskSort = function (a, b)
					return a.data.taskConfig.order > b.data.taskConfig.order
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
	if type == TaskUICacheType.Group then
	elseif type == TaskUICacheType.GroupChild then
		objectInfo.isOpenItems = true
		objectInfo.isSelect = false
	elseif type == TaskUICacheType.TaskItem or type == TaskUICacheType.GroupTaskItem then
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
		self.Titletext_txt.text = TI18N("进行中")
	else
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

	for _, v in ipairs(taskTypeInfo.typeChildList) do
		self:ShowTaskGroupChild(objectTransform, v)
	end
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
		self.taskIdMap[v.taskId] = v
		self:ShowTaskGroupItem(childGroupInfo, v, taskItemParent)
	end
	-- if childGroupInfo.objectInfo then
	-- 	childGroupInfo.objectInfo.taskChild:SetAsLastSibling()
	-- end
	LayoutRebuilder.ForceRebuildLayoutImmediate(parent:GetComponent(RectTransform))
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.TaskRoot_rect)
end

function TaskMainWindow:ShowTaskGroupItem(groupInfo, taskInfo, parent)
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

function TaskMainWindow:UpdateTaskItem(taskId)
	local taskInfo = self.taskIdMap[taskId]
	local objectInfo = taskInfo.objectInfo
	local taskConfig = taskInfo.data.taskConfig

	-- 测试
	local roleLevel = 10
	local visibleCond = roleLevel < taskConfig.accept_lev
	if visibleCond then
		objectInfo.Cond_txt.text = TI18N("需要等级"..taskConfig.accept_lev)
	else
		objectInfo.Cond_txt.text = ""
	end
	objectInfo.visibleCond = visibleCond
	objectInfo.Desc_txt.text = taskConfig.task_name
	local task = Fight.Instance.taskManager:GetGuideTask()
	if task and task.taskConfig and task.taskConfig.id == taskConfig.id then
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
	
	UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#e5e5e5")
	UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#e5e5e5")
end

function TaskMainWindow:UpdateTaskSelect(taskInfo, btnSelect)
	if taskInfo == self.selectTaskInfo then
		return
	end

	if self.selectTaskInfo then
		self:SetTaskSelect(self.selectTaskInfo, false)
	end

	self:SetTaskSelect(taskInfo, true)

	self.selectTaskInfo = taskInfo
	self:UpdateTaskContent()

end

function TaskMainWindow:SetTaskSelect(taskInfo, visible)

	taskInfo.objectInfo.BgImg:SetActive(not visible)
	taskInfo.objectInfo.Select:SetActive(visible)
	if visible then
		taskInfo.objectInfo.Desc_txt.fontSize = 22
		UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#2d3740")
		UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#2d3740")
	else
		taskInfo.objectInfo.Desc_txt.fontSize = 20
		UtilsUI.SetTextColor(taskInfo.objectInfo.Desc_txt, "#e5e5e5")
		UtilsUI.SetTextColor(taskInfo.objectInfo.Distance_txt, "#e5e5e5")
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

-- TODO 测试逻辑
local DataReward = Config.DataItem.data_reward
function TaskMainWindow:UpdateTaskContent()
	local taskConfig = self.selectTaskInfo.data.taskConfig
	local taskPosition
	if next(taskConfig.task_position) then
		taskPosition = BehaviorFunctions.GetTerrainPositionP(taskConfig.task_position[1][2], taskConfig.position_id, taskConfig.task_position[1][1])
	elseif next(taskConfig.trace_eco_id) then
		taskPosition = BehaviorFunctions.GetEcoEntityBornPosition(taskConfig.trace_eco_id[1])
	end

	UnityUtils.SetActive(self.TaskAreaObj, false)
	if taskPosition then
		local areaInfo, areaType, bigAreaInfo = Fight.Instance.mapAreaManager:GetAreaInfoByPosition(taskPosition)
		if areaInfo then
			self.TaskArea_txt.text = bigAreaInfo.name.."·"..areaInfo.name
			UnityUtils.SetActive(self.TaskAreaObj, true)
		end
	end

	self.taskName_txt.text = taskConfig.task_name
	-- self.taskTips1_txt.text = taskConfig.task_goal or ""
	self:ShowTaskTarget(taskConfig)
	self.taskTips2_txt.text = taskConfig.task_desc
	self.DetailPanel:SetActive(false)
	self.DetailPanel:SetActive(true)
	local guideTask = Fight.Instance.taskManager:GetGuideTask()
	if mod.TaskCtrl:GetTaskPositionById(taskConfig.id) then
		self.btnGo:SetActive(true)
	else
		self.btnGo:SetActive(false)
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
		for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 0.8}
			local item = ItemManager.Instance:GetItem(self.RewardGroup.transform, itemInfo)
			table.insert(self.rewardItemObjs, item)
		end
	end
end

function TaskMainWindow:ShowTaskTarget(config)
	local targets = mod.TaskCtrl:GetTaskTargets(config)
	if not self.taskTargetOnShow then
		self.taskTargetOnShow = {}
	end

	if #self.taskTargetOnShow < #targets then
		for i = 1, #targets - #self.taskTargetOnShow do
			table.insert(self.taskTargetOnShow, self:GetTaskTargetObj())
		end
	elseif #self.taskTargetOnShow > #targets then
		for i = #self.taskTargetOnShow, #self.taskTargetOnShow - #targets + 1, -1 do
			local obj = table.remove(self.taskTargetOnShow)
			UnityUtils.SetActive(obj.object, false)
			table.insert(self.taskTargetObjPool, obj)
		end
	end

	for i = 1, #self.taskTargetOnShow do
		self.taskTargetOnShow[i].TargetDesc_txt.text = targets[i]
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
	local task = Fight.Instance.taskManager:GetGuideTask()
	if not self.selectTaskInfo then
		return
	end
	if task and task.taskConfig and self.selectTaskInfo.data.taskId == task.taskConfig.id then
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

	if task and task.taskConfig then
		local taskInfo = self.taskIdMap[task.taskConfig.id]
		local objectInfo = taskInfo.objectInfo
		for i = 1, #self.allTaskMainType - 1 do
			objectInfo["imgType"..i]:SetActive(false)
		end
	end

	local guideObject = self.selectTaskInfo.objectInfo
	for i = 1, #self.allTaskMainType - 1 do
		guideObject["imgType"..i]:SetActive(i == self.selectTaskInfo.data.taskType)
	end

	local id, cmd = mod.TaskCtrl:ChangeGuideTask(self.selectTaskInfo.data.taskId)
	mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
		self.btnGoText_txt.text = TI18N("追踪中")
	end)
end

function TaskMainWindow:OnClick_CloseBtn()
	local anim = self.gameObject:GetComponent(Animator)
	self.blurBack.gameObject:GetComponent(Animator):Play("BlurBack_Out_2")
	anim:Play("TaskMainUIRe_appear_z_exit")
	if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function TaskMainWindow:OnClickClose_CallBack()
	WindowManager.Instance:CloseWindow(TaskMainWindow)
end
