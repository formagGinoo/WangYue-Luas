

TaskDupWindow = BaseClass("TaskDupWindow",BaseWindow)

local _insert = table.insert
local TabName = {
	"进行中", "主线任务", "支线任务", "回忆任务"
}

function TaskDupWindow:__init()
	self:SetAsset("Prefabs/UI/Task/TaskDupUI.prefab")
	self.curSelect = 0
	self.selectTaskInfo = nil
	self.taskObjList = {}
	self.rewardItemObjs = {}
end

function TaskDupWindow:__delete()
	for _, v in pairs(self.rewardItemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.rewardItemObjs = {}
end

function TaskDupWindow:__CacheObject()
    self.VLayout = LuaBoxLayout.New(self.TaskList, {axis = BoxLayoutAxis.Y, cspacing = 0, scrollRect = self.TaskPanel.transform})
end

function TaskDupWindow:__BindListener()
	self.BtnGo_btn.onClick:AddListener(self:ToFunc("OnFight"))
	self.BtnReturn_btn.onClick:AddListener(function() WindowManager.Instance:CloseWindow(TaskDupWindow) end)
	self.BtnOpenArrow_btn.onClick:AddListener(function() self:OpenTaskDescPanel(true) end)
	self.BtnCloseArrow_btn.onClick:AddListener(function() self:OpenTaskDescPanel(false)end)
end

function TaskDupWindow:__Create()
	local toggleList = {
		self["btnTab1_tog"], self["btnTab2_tog"], self["btnTab3_tog"], self["btnTab4_tog"]
	}
    self.toggleTab = ToggleTab.New()
    self.toggleTab:InitByToggles(toggleList, function(curSelect)
        self:SelectTab(curSelect)
    end, 1, false)
end

function TaskDupWindow:__Show()
	self.openTargetTaskId = self.args

	MainDebugManager.Instance.model:CloseMainUI()
	-- 测试条件
	local roleLevel = 10
	self.taskList = {}
	self.taskTypeList = {}
	local taskTypeList = mod.TaskCtrl:GetTastTypeMap()

	local onSort = function (a, b)
		return a.taskConfig.order > b.taskConfig.order
	end

	for taskType, taskList in pairs(taskTypeList) do
		if next(taskList) then
			local list = self.taskTypeList[taskType] or {}
			for k, v in pairs(taskList) do
				if roleLevel >= v.taskConfig.accept_lv then
					_insert(list, v)
					_insert(self.taskList, v)
				end
			end

			table.sort(list, onSort)
			self.taskTypeList[taskType] = list
		end
	end

	table.sort(self.taskList, onSort)

	self:SelectTab(1)
end

function TaskDupWindow:GetTaskList(taskType)
	if taskType == 0 then
		return self.taskList
	else
		return self.taskTypeList[taskType]
	end
end

function TaskDupWindow:SelectTab(curSelect)
	self.curSelect = curSelect

	local taskList = self:GetTaskList(curSelect - 1)
	for k, v in pairs(self.taskObjList) do
		v.imgSelectObj:SetActive(false)
		self:PushUITmpObject("TaskItem", v)
	end

	self.taskObjList = {}
	self.TaskType_txt.text = TabName[curSelect]
	self.PanelDetail:SetActive(false)
	if not taskList then
		return
	end
	self.selectTaskInfo = nil
	self.VLayout:ReSet()

    for i=1, #taskList do
    	local data = taskList[i]
        local taskInfo, new = self:PopUITmpObject("TaskItem")
        if new then
			local objectTransform = taskInfo.objectTransform
            taskInfo.taskNameText = UtilsUI.GetText(objectTransform:Find("TaskName"))
            taskInfo.imgSelectObj =  objectTransform:Find("ImgSelect").gameObject
			taskInfo.btnTaskItemBtn = objectTransform:Find("BtnTaskItem"):GetComponent(Button)
        end
		taskInfo.taskNameText.text = data.taskConfig.task_name
		local onCallBack = function ()
			self:SelectTaskInfo(taskInfo)
		end
		taskInfo.data = data
		taskInfo.btnTaskItemBtn.onClick:RemoveAllListeners()
		taskInfo.btnTaskItemBtn.onClick:AddListener(onCallBack)
		
        self.VLayout:AddCell(taskInfo.object)
        table.insert(self.taskObjList, taskInfo)

        if not self.openTargetTaskId then
			if not self.selectTaskInfo then
				self:SelectTaskInfo(taskInfo)
			end
		else
			if data.taskId == self.openTargetTaskId then
				self:SelectTaskInfo(taskInfo)
				self.openTargetTaskId = nil
			end
		end
    end
end

function TaskDupWindow:SelectTaskInfo(taskInfo)
	if self.selectTaskInfo then
		self.selectTaskInfo.imgSelectObj:SetActive(false)
	end

	self.PanelDetail:SetActive(true)

	local data = taskInfo.data
	local taskConfig = data.taskConfig
	self.TaskName_txt.text = data.taskConfig.task_name
	self.TaskChildType_txt.text  = TaskConfig.GetChildTypeName(taskConfig.type, taskConfig.sec_type)
	CompExtensions.SetTextWithEllipsis(self.TaskChildType_txt, taskConfig.task_desc)
	self.TaskDescOpen_txt.text = taskConfig.task_desc
	self:UpdateRewardGroup(taskConfig.award)
	self:OpenTaskDescPanel(false)

	-- local duplicateConfig = Config.DataDuplicate.data_duplicate[taskConfig.duplicate_id]
	-- self.TaskPoint_txt.text = duplicateConfig.desc

	--for i = 1, 4 do 
		--local select = i == duplicateConfig.time_section
		--self["taskTime"..i]:SetActive(not select)
		--self["taskTimeS"..i]:SetActive(select)
	--end

	self.selectTaskInfo = taskInfo
	self.selectTaskInfo.imgSelectObj:SetActive(true)
end

function TaskDupWindow:UpdateRewardGroup(award)
	for _, v in pairs(self.rewardItemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.rewardItemObjs = {}
	if award and next(award) then
		for k, itemInfoData in pairs(award) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 0.8}
			local item = ItemManager.Instance:GetItem(self.RewardGroup, itemInfo)
			table.insert(self.rewardItemObjs, item)
		end
	end
end

function TaskDupWindow:OpenTaskDescPanel(isOpen)
	self.openTaskDesc = isOpen
	self.DescPanel:SetActive(self.openTaskDesc)
	self.PanelTarget:SetActive(not self.openTaskDesc)
	self.BtnOpenArrow:SetActive(not isOpen)
	self.TaskDesc:SetActive(not isOpen)
end

function TaskDupWindow:OnFight()
	if not self.selectTaskInfo then
		return
	end
	local data = self.selectTaskInfo.data
	WindowManager.Instance:CloseWindow(TaskDupWindow)
	-- mod.TaskCtrl:OnFight(data)
end

