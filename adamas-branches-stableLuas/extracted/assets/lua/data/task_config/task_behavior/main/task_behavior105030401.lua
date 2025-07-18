TaskBehavior105030401 = BaseClass("TaskBehavior105030401")
--第三章通用模板

function TaskBehavior105030401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030401:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102320201
    }

    --功能判断
    self.isAddLevel = false
    self.isDialog = true
end

function TaskBehavior105030401:Update()
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