TaskBehavior102240802 = BaseClass("TaskBehavior102240802")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240802.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240802:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId = 102250201 --前往旅馆时播
end

function TaskBehavior102240802:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.dialogState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.dialogState = 1
	end
end