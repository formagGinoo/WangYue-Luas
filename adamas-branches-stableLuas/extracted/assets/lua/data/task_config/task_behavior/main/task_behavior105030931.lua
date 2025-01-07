TaskBehavior105030931 = BaseClass("TaskBehavior105030931")
--第三章通用模板

function TaskBehavior105030931.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030931:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.isCheckLevel = true
end

function TaskBehavior105030931:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        if self.isCheckLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId - 100) then
            BehaviorFunctions.AddLevel(self.taskId - 10)
        end
        self.taskState = 1
    end
end