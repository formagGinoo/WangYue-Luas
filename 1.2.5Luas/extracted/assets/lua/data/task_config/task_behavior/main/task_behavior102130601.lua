TaskBehavior102130601 = BaseClass("TaskBehavior102130601")
--大世界任务组3：去城镇
--子任务3：和温罗对话
--完成条件：结束timeline102130601

function TaskBehavior102130601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102130601:__init(taskInfo)
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
function TaskBehavior102130601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.missionState == 0 then
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	elseif self.missionState == 2 then
		--BehaviorFunctions.SendTaskProgress(102130601,1,1)
		self.missionState = 3
	end
end

function TaskBehavior102130601:StorySelectEvent(dialogId)
	--选项：嗯，就接下来吧
	if dialogId == 102130616 then
		BehaviorFunctions.SendTaskProgress(102130601,1,1)
		BehaviorFunctions.SendTaskProgress(102130602,1,1)
		self.missionState = 2
	--选项：我思考一下
	elseif dialogId == 102130619 then
		BehaviorFunctions.SendTaskProgress(102130601,1,1)
		BehaviorFunctions.SendTaskProgress(102130603,1,1)
		self.missionState = 2
	end
end

function TaskBehavior102130601:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
	elseif dialogId == self.dialogList[2].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
	--跳过对话时，默认接受任务
	elseif dialogId == self.dialogList[3].Id then
		BehaviorFunctions.SendTaskProgress(102130601,1,1)
		BehaviorFunctions.SendTaskProgress(102130602,1,1)
		self.missionState = 2
	end
end

