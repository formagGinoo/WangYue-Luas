LevelBehavior102650101 = BaseClass("LevelBehavior102650101",LevelBehaviorBase)
--室内潜入副本

function LevelBehavior102650101.GetGenerates()
	local generates = {}
	return generates
end


function LevelBehavior102650101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
end


function LevelBehavior102650101:Update()
	if self.taskState == 0 then
		BehaviorFunctions.FinishLevel(self.levelId)
		--BehaviorFunctions.SendTaskProgress(1026501,1,1,1)
		self.taskState = 1
	end
end