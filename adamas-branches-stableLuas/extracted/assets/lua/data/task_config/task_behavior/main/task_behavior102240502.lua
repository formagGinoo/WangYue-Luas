TaskBehavior102240502 = BaseClass("TaskBehavior102240502")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102240502.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102240502:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
end

function TaskBehavior102240502:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--创建关卡
	if not BehaviorFunctions.CheckLevelIsCreate(102240503) then
		if self.levelState == 0 then
			BehaviorFunctions.AddLevel(102240503)
		end
		self.levelState = 1
	end
end