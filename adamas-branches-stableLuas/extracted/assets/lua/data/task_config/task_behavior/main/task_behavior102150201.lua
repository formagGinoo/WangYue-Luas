TaskBehavior102150201 = BaseClass("TaskBehavior102150201")
--大世界任务组4：寻找刻刻
--子任务5：前往城镇外
--完成条件：靠近目标点5米

function TaskBehavior102150201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102150201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 102150201,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102150301,state = self.dialogStateEnum.NotPlaying},
	}
	self.dialog1Dstance = 150
	self.dialog2Dstance = 5
	self.taskFinish = false
end

function TaskBehavior102150201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not BehaviorFunctions.CheckTaskIsFinish(102150301) then
		local playerPos = BehaviorFunctions.GetPositionP(self.role)
		local targetPos = BehaviorFunctions.GetTerrainPositionP("OutSideTown3",self.levelId,"Task_Main_001")
		local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,targetPos)

		if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
			if distance <= self.dialog1Dstance and distance >= self.dialog2Dstance then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId)
				self.dialogList[1].state = self.dialogStateEnum.Playing
			end
		end
	else
		if self.taskFinish == false then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId)
			self.taskFinish = true
		end
	end
end

function TaskBehavior102150201:StoryDialogEnd(dialogID)
	if dialogID == self.dialogList[1].Id then
		self.dialogList[1].state = self.dialogStateEnum.PlayOver
	end
end