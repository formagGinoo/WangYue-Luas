TaskBehavior102140401 = BaseClass("TaskBehavior102140401")
--大世界任务组4：寻找刻刻
--子任务5：与守卫对话
--完成条件：完成对话102140401

function TaskBehavior102140401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102140401:__init(taskInfo)
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
		[1] = {Id = 102140401,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 102150101,state = self.dialogStateEnum.NotPlaying},
	}
	self.taskFinish = false
	self.transport = nil
	self.trace = false
end

function TaskBehavior102140401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.trace == false then
		if BehaviorFunctions.CheckEntityInArea(self.role,"TownArea","Task_Main_001") then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.trace = true
		end
	end
end

function TaskBehavior102140401:StoryDialogEnd(dialogID)
	if dialogID == self.dialogList[1].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
	end
end