TaskBehavior102030203 = BaseClass("TaskBehavior102030203")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：前往据点

--重创中据点第一波关卡，关卡完成后完成任务，任务完成后弹刻刻装备佩从引导


function TaskBehavior102030203.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030203:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.levelState = 0
end

function TaskBehavior102030203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102030203) then
			BehaviorFunctions.AddLevel(102030203)
		end
		self.levelState = 1
	end
end