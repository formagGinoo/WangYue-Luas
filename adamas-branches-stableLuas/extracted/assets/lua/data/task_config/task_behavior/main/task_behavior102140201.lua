TaskBehavior102140201 = BaseClass("TaskBehavior102140201")
--大世界任务组4：寻找刻刻
--子任务5：与商人1对话
--完成条件：完成timeline102140201

function TaskBehavior102140201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102140201:__init(taskInfo)
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
		[1] = {Id = 102140101,state = self.dialogStateEnum.NotPlaying},
	}
	self.taskFinish = false
	self.transport = nil
	self.trace = false
end
function TaskBehavior102140201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.trace == false then
		if BehaviorFunctions.CheckEntityInArea(self.role,"TownArea","Task_Main_001") then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.trace = true
		end
	end
end