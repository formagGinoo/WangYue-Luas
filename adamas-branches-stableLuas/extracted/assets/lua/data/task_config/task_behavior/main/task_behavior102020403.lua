TaskBehavior102020403 = BaseClass("TaskBehavior102020403")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--本任务用于配合管理刻刻武器升级引导、旁白播放时机、任务完成显示时机

function TaskBehavior102020403.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020403:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.dialogId = 102210901 --前往据点路上的旁白
	self.dialogState = 0
end

function TaskBehavior102020403:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.CheckGuideFinish(1023) == true then   --刻刻升级引导
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.dialogState = 1
		end
	end
end