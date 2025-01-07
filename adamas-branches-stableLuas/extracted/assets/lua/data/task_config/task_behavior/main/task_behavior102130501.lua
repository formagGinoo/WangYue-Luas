TaskBehavior102130501 = BaseClass("TaskBehavior102130501")
--大世界任务组3：去城镇
--子任务3：和温罗对话
--完成条件：结束timeline102130501

function TaskBehavior102130501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102130501:__init(taskInfo)
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
		[1] = {Id = 102130501,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102130501,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 102130601,state = self.dialogStateEnum.NotPlaying},
	}
	self.missionState = 0
end
function TaskBehavior102130501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.missionState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 1
	end
end
function TaskBehavior102130501:StoryEndEvent(dialogId)

end

