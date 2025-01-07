TaskBehavior104030601 = BaseClass("TaskBehavior104030601")
--第三章通用模板

function TaskBehavior104030601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104030601:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        
    }

    --功能判断
    self.isCheckLevel = true
    self.isDialog = false
end

function TaskBehavior104030601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        
        if self.isDialog then
            BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        end

        if self.isCheckLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId - 100) then
            BehaviorFunctions.AddLevel(self.taskId - 100)
        end
    self.taskState = 1
    end
end