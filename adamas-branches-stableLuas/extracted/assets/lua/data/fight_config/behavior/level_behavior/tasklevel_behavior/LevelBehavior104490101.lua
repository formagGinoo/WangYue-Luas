LevelBehavior104490101 = BaseClass("LevelBehavior104490101",LevelBehaviorBase)


function LevelBehavior104490101.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior104490101:__init(taskInfo)
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
	self.isTalking = false

end

function LevelBehavior104490101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.trace == false then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task104490101Area01","Logic10449010101") then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.trace = true
		end
	end
end

function LevelBehavior104490101:StoryDialogEnd(dialogID)
	if dialogID == self.dialogList[1].Id then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
	end
end

function LevelBehavior104490101:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and self.isTalking == false and areaName == "Task104490101Area01" and logicName == "Logic10449010101" then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.isTalking = true
	end
end




function LevelBehavior104490101:__delete()

end
