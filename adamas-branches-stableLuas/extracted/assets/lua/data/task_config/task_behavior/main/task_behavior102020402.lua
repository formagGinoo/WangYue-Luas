TaskBehavior102020402 = BaseClass("TaskBehavior102020402")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--重创刻刻瞄准教学关卡

function TaskBehavior102020402.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020402:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.levelState = 0
end

function TaskBehavior102020402:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102020401) then
			BehaviorFunctions.AddLevel(102020401)
		end
		self.levelState = 1
	end
end