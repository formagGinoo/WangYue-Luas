TaskBehavior102240506 = BaseClass("TaskBehavior102240506")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240506.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240506:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId = 102230701 --采完药播
end

function TaskBehavior102240506:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102240506:WorldInteractClick(uniqueId,instanceId)
	if instanceId == BehaviorFunctions.GetEcoEntityByEcoId(3001002020009) then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end