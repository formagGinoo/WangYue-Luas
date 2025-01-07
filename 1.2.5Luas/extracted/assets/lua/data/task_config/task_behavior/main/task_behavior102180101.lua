TaskBehavior102180101 = BaseClass("TaskBehavior102180101")
--大世界任务组5：回城镇找阿一
--子任务5：回城镇找阿一
--完成条件：结束timeline102180101

function TaskBehavior102180101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102180101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 102180101,state = self.dialogStateEnum.NotPlaying},
	}
	self.missionState = 0
end
function TaskBehavior102180101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.missionState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	end
end
function TaskBehavior102180101:StoryEndEvent(dialogId)

end

