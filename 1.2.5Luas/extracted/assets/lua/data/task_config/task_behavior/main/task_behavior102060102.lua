TaskBehavior102060102 = BaseClass("TaskBehavior102060102")
--大世界任务组5：清除中拒点
--子任务1：遇到刻刻
--完成条件：靠近据点

function TaskBehavior102060102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102060102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId1 = 102060201
	self.dialogId2 = 102060301
end
function TaskBehavior102060102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--local pos = BehaviorFunctions.GetTerrainPositionP("Mid1",10020001,"LogicWorldTest01")
	--local rolePos = BehaviorFunctions.GetPositionP(self.role)
	--local dis = BehaviorFunctions.GetDistanceFromPos(pos,rolePos)
	--if self.taskState == 0 and dis < 3 then
		--BehaviorFunctions.StartStoryDialog(self.dialogId1)
		--self.taskState = 1
	--end
	--if self.taskState == 10  then
		--BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		--self.taskState = 99
	--end
end

function TaskBehavior102060102:StoryEndEvent(dialogId)
	--if dialogId ==  self.dialogId1 then
		--BehaviorFunctions.StartStoryDialog(self.dialogId2)
	--end
	--if dialogId ==  self.dialogId2 then
		--self.taskState = 10
	--end
end