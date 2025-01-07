TaskBehavior105010501 = BaseClass("TaskBehavior105010501")
--启动大悬钟前半

function TaskBehavior105010501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105010501:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = 601010301   --飞天timeline第一段
    self.dialogState = 0
	self.dazhongxuanEcoId = 1001002020012
end

function TaskBehavior105010501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.dazhongxuan then
		self.dazhongxuan = BehaviorFunctions.GetEcoEntityByEcoId(self.dazhongxuanEcoId)
	end
end

function TaskBehavior105010501:WorldInteractClick(uniqueId,instanceId)
    if instanceId == self.dazhongxuan then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end