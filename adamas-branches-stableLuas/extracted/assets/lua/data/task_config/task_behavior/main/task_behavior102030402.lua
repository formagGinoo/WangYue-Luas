TaskBehavior102030402 = BaseClass("TaskBehavior102030402")
--大世界任务组2：清除小拒点
--子任务4：开门救人
--完成条件：和门交互

--重创第二波关卡--

function TaskBehavior102030402.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030402:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
end

function TaskBehavior102030402:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102030401) then 
			BehaviorFunctions.AddLevel(102030401)
		end
		self.levelState = 1
	end
end