TaskBehavior102020301 = BaseClass("TaskBehavior102020301")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--此处创建遇见刻刻关卡--

function TaskBehavior102020301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId = 102020301
end
function TaskBehavior102020301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 then
		BehaviorFunctions.AddLevel(102020301)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end