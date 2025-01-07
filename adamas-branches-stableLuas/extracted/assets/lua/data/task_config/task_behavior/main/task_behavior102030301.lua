TaskBehavior102030301 = BaseClass("TaskBehavior102030301")
--大世界任务组2：清除小拒点
--子任务3：解决拒点
--完成条件：清空据点

--刻刻装备从士弓引导结束后播旁白，完成任务

function TaskBehavior102030301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.guideState = 0
	self.guideId = 1021 --刻刻装备佩从
	self.dialogId = 102211401 --装备完佩从对话
end

function TaskBehavior102030301:Update()
	if BehaviorFunctions.CheckGuideFinish(self.guideId) == true and self.guideState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.guideState = 1
	end
end