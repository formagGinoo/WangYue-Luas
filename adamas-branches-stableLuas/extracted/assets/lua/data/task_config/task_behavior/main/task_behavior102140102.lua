TaskBehavior102140102 = BaseClass("TaskBehavior102140102")
--大世界任务组4：寻找刻刻
--子任务5：激活大钟悬
--完成条件：传送点激活

function TaskBehavior102140102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102140102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.taskFinish = false
	self.transport = nil
	self.guide = false
	self.sendMessage = false
	self.time = nil
	self.startTime = nil
	self.mapOpen = false
end
function TaskBehavior102140102:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	if not BehaviorFunctions.CheckGuideFinish(2202) and self.mapOpen == false then
		self.startTime = BehaviorFunctions.GetFightFrame()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true)
		self.mapOpen = true
	end
	if not BehaviorFunctions.CheckGuideFinish(2202) and self.guide == false then
		if self.time - self.startTime >= 30 then
			BehaviorFunctions.PlayGuide(2204)
			self.guide = true
		end
	elseif BehaviorFunctions.CheckGuideFinish(2202) then
		if not BehaviorFunctions.CheckTaskIsFinish(self.taskInfo.taskId) and self.sendMessage == false then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.sendMessage = true
		end
	end
end