TaskBehavior102610104 = BaseClass("TaskBehavior102610104")
--骇入脉灵

function TaskBehavior102610104.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102610104:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior102610104:Update()

end

--进入调查模式回调
function TaskBehavior102610104:ExploreStartEvent(dialogId)
end

--退出调查模式回调
function TaskBehavior102610104:ExploreEndEvent(dialogId)
end

--线索完成回调
function TaskBehavior102610104:ClueUnlock(dialogId,clueId)
end

--线索全解锁
function TaskBehavior102610104:ClueFullUnlock(dialogId)
	if dialogId == 101204701 then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		--BehaviorFunctions.AddDelayCallByFrame(150,BehaviorFunctions,BehaviorFunctions.ForceExitStory)
	end
end