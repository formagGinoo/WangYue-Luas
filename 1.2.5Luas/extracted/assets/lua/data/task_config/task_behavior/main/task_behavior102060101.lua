TaskBehavior102060101 = BaseClass("TaskBehavior102060101")
--大世界任务组5：清除中拒点
--子任务1：离开村子
--完成条件：离开村子

function TaskBehavior102060101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102060101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102060101
end
function TaskBehavior102060101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30

end
function TaskBehavior102060101:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end

function TaskBehavior102060101:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "TownArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.taskState = 1
		end
	end
end