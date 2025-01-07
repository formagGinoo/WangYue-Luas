LevelBehavior102610101 = BaseClass("LevelBehavior102610101",LevelBehaviorBase)
--脉灵投喂&骇入

function LevelBehavior102610101.GetGenerates()
	local generates = {}
	return generates
end


function LevelBehavior102610101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
end


function LevelBehavior102610101:Update()
	if self.taskState == 0 then
		--LogError("脉灵投喂&骇入".."___完成___")
		BehaviorFunctions.FinishLevel(self.levelId)
		--BehaviorFunctions.SendTaskProgress(1026101,4,1,1)
		self.taskState = 1
	end
end