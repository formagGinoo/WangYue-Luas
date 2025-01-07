TaskBehavior105040601 = BaseClass("TaskBehavior105040601")
--和传书印记交互

function TaskBehavior105040601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105040601:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.chuanshuEcoId = 2201001010003
    self.dialogState = 0
end

function TaskBehavior105040601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if not self.chuanshu then
	    self.chuanshu = BehaviorFunctions.GetEcoEntityByEcoId(self.chuanshuEcoId)
    end
end

function TaskBehavior105040601:WorldInteractClick(uniqueId,instanceId)
    if instanceId == self.chuanshu then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end