TaskBehavior1010201 = BaseClass("TaskBehavior1010201")
--任务2：玩家摩托战逃离巴西利克斯追杀

function TaskBehavior1010201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior1010201:__init(taskInfo)
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 101020101,state = self.dialogStateEnum.NotPlaying}
	}
end

function TaskBehavior1010201:Update()
	if self.missionState == 0 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(1010201,1,1)
	end
end

function TaskBehavior1010201:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior1010201:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				self.missionState = 2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end