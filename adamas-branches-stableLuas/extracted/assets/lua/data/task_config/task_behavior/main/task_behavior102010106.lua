TaskBehavior102010106 = BaseClass("TaskBehavior102010106")
--任务

function TaskBehavior102010106.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010106:__init()
	self.role = 0
	self.missionState = 0
	self.dialogList =
	{
		[1] = {id = 102330201}
	}
end

function TaskBehavior102010106:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		if BehaviorFunctions.CheckEntityDrive(self.role) == true then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].id)
			self.missionState = 1
		end
	end
end