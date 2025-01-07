TaskBehavior102240504 = BaseClass("TaskBehavior102240506")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240504.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240504:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
end

function TaskBehavior102240504:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102240504:WorldInteractClick(uniqueId,instanceId)
	if instanceId == BehaviorFunctions.GetEcoEntityByEcoId(3001002020007) then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end