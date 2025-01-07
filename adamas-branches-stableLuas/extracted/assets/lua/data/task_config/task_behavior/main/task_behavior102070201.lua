TaskBehavior102070201 = BaseClass("TaskBehavior102070201")
--大世界任务组2：清除小拒点
--子任务4：开门救人

function TaskBehavior102070201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102070201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102030401
end
function TaskBehavior102070201:Update()
	if self.trace == false then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
end
function TaskBehavior102070201:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end