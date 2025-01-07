TaskBehavior102030101 = BaseClass("TaskBehavior102030101")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

function TaskBehavior102030101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.guideState = 0
	self.taskState = 0
	self.trace = false
	self.dialogId = 102030101
end
function TaskBehavior102030101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.guideState == 0  and BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1) == 0  then
		--BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true)
		BehaviorFunctions.PlayGuide(2205)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.guideState = 1	
	end
end