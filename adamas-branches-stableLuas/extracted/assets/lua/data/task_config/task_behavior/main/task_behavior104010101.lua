TaskBehavior104010101 = BaseClass("TaskBehavior104010101")

function TaskBehavior104010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104010101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.dialogId = 102260101 --到达维安司播
end

function TaskBehavior104010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	local pos1 = BehaviorFunctions.GetTerrainPositionP("Weiansi",10020001,"MainTask03")
	local pos2 = BehaviorFunctions.GetPositionP(self.role)
	local dis = BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
	if dis <= 5 then
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.dialogState = 1
		end
	end
end

function TaskBehavior104010101:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end