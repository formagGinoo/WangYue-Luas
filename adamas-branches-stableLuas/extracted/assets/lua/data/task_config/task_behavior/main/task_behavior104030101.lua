TaskBehavior104030101 = BaseClass("TaskBehavior104030101")
--第三章通用模板

function TaskBehavior104030101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104030101:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102280101
    }

    --功能判断
    self.isAddLevel = false
    self.isDialog = true
end

function TaskBehavior104030101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        
        if self.isDialog then
            BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        end

        if self.isAddLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
            BehaviorFunctions.AddLevel(self.taskId)
        end
        self.taskState = 1
    end
end