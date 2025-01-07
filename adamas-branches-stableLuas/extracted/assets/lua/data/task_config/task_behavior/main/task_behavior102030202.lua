TaskBehavior102030202 = BaseClass("TaskBehavior102030202")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围

--重创关卡中据点第一波关卡

function TaskBehavior102030202.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030202:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
end

function TaskBehavior102030202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102030202) then
			BehaviorFunctions.AddLevel(102030202)
		end
		self.levelState = 1
	end
end