TaskBehavior102130701 = BaseClass("TaskBehavior102130701")
--大世界任务组3：去城镇
--子任务3：再次和温罗对话
--完成条件：在102130701对话选项中选择帮助温罗寻找刻刻

function TaskBehavior102130701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102130701:__init(taskInfo)
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
		[1] = {Id = 102130701,state = self.dialogStateEnum.NotPlaying},
	}
	self.missionState = 0
	self.finishiTask = false
end
function TaskBehavior102130701:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	if BehaviorFunctions.CheckTaskIsFinish(102130602) then
		if not BehaviorFunctions.CheckTaskIsFinish(102130701) and not self.finishiTask then
			BehaviorFunctions.SendTaskProgress(102130701,1,1)
			self.finishiTask = true
		end
	end
end

function TaskBehavior102130701:StorySelectEvent(dailogId)
	--选项：嗯，就接下来吧
	if dailogId == 102130705 then
		BehaviorFunctions.SendTaskProgress(102130602,1,1)
		BehaviorFunctions.SendTaskProgress(102130701,1,1)
	end
end

function TaskBehavior102130701:StoryEndEvent(dialogId)

end

