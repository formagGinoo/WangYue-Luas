TaskBehavior104020101 = BaseClass("TaskBehavior104020101")
--第三章通用模板

function TaskBehavior104020101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104020101:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102260501
    }

    --功能判断
    self.isAddLevel = false
    self.isDialog = true
end

function TaskBehavior104020101:Update()
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