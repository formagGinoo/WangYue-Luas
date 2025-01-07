TaskBehavior102240702 = BaseClass("TaskBehavior102240702")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240702.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240702:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.guideId = 1024 --和窑教学指引
	self.dialogId = 102240301 --和窑教程结束播
end

function TaskBehavior102240702:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if BehaviorFunctions.CheckGuideFinish(self.guideId) == true then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end