TaskBehavior103080103 = BaseClass("TaskBehavior103080103")
--调查昏迷人员

function TaskBehavior103080103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior103080103:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior103080103:Update()

end

--进入调查模式回调
function TaskBehavior103080103:ExploreStartEvent(dialogId)
	LogError("进入调查"..dialogId)
end

--退出调查模式回调
function TaskBehavior103080103:ExploreEndEvent(dialogId)
	LogError("退出调查"..dialogId)
end

--线索完成回调
function TaskBehavior103080103:ClueUnlock(dialogId,clueId)
	LogError("线索开启："..clueId)
end

--线索全解锁
function TaskBehavior103080103:ClueFullUnlock(dialogId)
	LogError("已解锁全部线索："..dialogId)
	BehaviorFunctions.ForceExitStory()
	BehaviorFunctions.SendTaskProgress(self.taskId, self.taskStepId, 1)
end

