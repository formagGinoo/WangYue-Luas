TaskBehavior102130401 = BaseClass("TaskBehavior102130401")
--大世界任务组3：去城镇
--子任务3：和温罗对话
--完成条件：结束timeline102130401

function TaskBehavior102130401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102130401:__init(taskInfo)
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
		[1] = {Id = 102130401,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102130501,state = self.dialogStateEnum.NotPlaying},
		[3] = {Id = 102130601,state = self.dialogStateEnum.NotPlaying},
	}
	self.missionState = 0
end
function TaskBehavior102130401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.missionState == 0 then
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	end
end
function TaskBehavior102130401:StoryEndEvent(dialogId)

end

