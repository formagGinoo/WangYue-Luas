TaskBehavior102240904 = BaseClass("TaskBehavior102240904")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240904.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240904:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId = 102250701 --靠近旅馆播
end

function TaskBehavior102240904:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102240904:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId == self.role and areaName == "HotelArea" and logicName == "TaskMain002" then
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.dialogState = 1
		end
	end
end

function TaskBehavior102240904:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end