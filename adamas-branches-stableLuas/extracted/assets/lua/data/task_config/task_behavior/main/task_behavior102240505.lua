TaskBehavior102240505 = BaseClass("TaskBehavior102240505")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240505.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240505:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
	self.dialogState = 0
end

function TaskBehavior102240505:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--创建关卡
	if not BehaviorFunctions.CheckLevelIsCreate(102240505) then
		if self.levelState == 0 then
			BehaviorFunctions.AddLevel(102240505)
		end
		self.levelState = 1
	end
end