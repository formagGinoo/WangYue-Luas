TaskBehavior102240601 = BaseClass("TaskBehavior102240601")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId = 102230801 --回村后播
end

function TaskBehavior102240601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102240601:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId == self.role and areaName == "OutSideTownArea" and logicName == "TaskMain002" then
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.dialogState = 1
		end
	end
end
