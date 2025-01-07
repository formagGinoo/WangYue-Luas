TaskBehavior102040302 = BaseClass("TaskBehavior102040302")
--大世界任务组3：去城镇
--子任务3：去警察局
--完成条件：靠近警察局

function TaskBehavior102040302.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040302:__init(taskInfo)
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
		[1] = {Id = 102220601,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102220701,state = self.dialogStateEnum.NotPlaying},
	}

end
function TaskBehavior102040302:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102040302:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "PoliceGateArea" and logicName == "TaskMain002" then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.taskState = 1
		end
	end
end

function TaskBehavior102040302:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogList[1].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end