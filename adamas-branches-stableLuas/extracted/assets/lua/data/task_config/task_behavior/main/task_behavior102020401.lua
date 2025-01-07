TaskBehavior102020401 = BaseClass("TaskBehavior102020401")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--刻刻瞄准教学创建关卡，对话在关卡里管理

function TaskBehavior102020401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.levelState = 0
	self.guideId = 1019 --切换刻刻指引
end

function TaskBehavior102020401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.levelState == 0 and BehaviorFunctions.CheckGuideFinish(self.guideId) == true then
		--创建关卡
		BehaviorFunctions.AddLevel(102020401)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.levelState = 1	
	end
end