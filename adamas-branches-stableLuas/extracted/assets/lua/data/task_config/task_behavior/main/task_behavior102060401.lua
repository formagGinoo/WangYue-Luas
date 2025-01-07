TaskBehavior102060401 = BaseClass("TaskBehavior102060401")
--大世界任务组5：清除中拒点
--子任务4：上网

function TaskBehavior102060401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102060401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102060501
end
function TaskBehavior102060401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	local pos = BehaviorFunctions.GetTerrainPositionP("Computer",10020001,"LogicWorldTest01")
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local dis = BehaviorFunctions.GetDistanceFromPos(pos,rolePos)
	if self.taskState == 0 and dis < 3 then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.taskState = 1
	end
end
function TaskBehavior102060401:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end