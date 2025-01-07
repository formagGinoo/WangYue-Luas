TaskBehavior102030401 = BaseClass("TaskBehavior102030401")
--大世界任务组2：清除小拒点
--子任务4：开门救人
--完成条件：和门交互

--中据点第二波关卡创建

function TaskBehavior102030401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
end

function TaskBehavior102030401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.levelState == 0 then
		BehaviorFunctions.AddLevel(102030401)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.levelState = 1
	end
end