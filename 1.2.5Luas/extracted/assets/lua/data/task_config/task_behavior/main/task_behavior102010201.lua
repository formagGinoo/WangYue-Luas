TaskBehavior102010201 = BaseClass("TaskBehavior102010201")
--大世界任务组1：激活传送点
--子任务2：起飞之后
--完成条件：起飞1s
function TaskBehavior102010201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102010201
	self.teachState = 0
	self.isClose = false
	self.insure = false
end

function TaskBehavior102010201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.teachState == 0 then
		local closeCallback =function()
			self.isClose = true
		end
		BehaviorFunctions.ShowGuideImageTips(20013,closeCallback)
		self.teachState = 1
	end
	if self.isClose == true then
		BehaviorFunctions.PlayGuide(2201)
		self.isClose = false
	end
	if self.taskState == 0 and BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Glide then
		self.timeStart = self.time
		self.taskState = 1
	end
	if self.taskState == 1 and BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Glide 
		and self.time - self.timeStart > 0.3 then
		BehaviorFunctions.FinishGuide(2201,1)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskState =2
	end

end

function TaskBehavior102010201:ExitArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "FlyTeachOutArea" and logicName == "LogicWorldTest01" then
		if self.insure == false and self.taskState ~= 1 then
			BehaviorFunctions.FinishGuide(2201,1)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.insure = true
		end
	end
end