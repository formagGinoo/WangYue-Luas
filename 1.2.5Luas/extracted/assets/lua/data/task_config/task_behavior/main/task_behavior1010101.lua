TaskBehavior1010101 = BaseClass("TaskBehavior1010101")
--任务1：玩家在timeline中起名

function TaskBehavior1010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior1010101:__init(taskInfo)
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
		[1] = {Id = 101010101,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101010201,state = self.dialogStateEnum.NotPlaying}
	}
end

function TaskBehavior1010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--起名前timeline
	if self.missionState == 0 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 1
	--如果起完名了
	elseif self.missionState == 2 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 3
	elseif self.missionState == 4 then
		BehaviorFunctions.SendTaskProgress(1010101,1,1)
	end
end

function TaskBehavior1010101:PlayStoryDialog(dialogId)
	local nowPlaying = BehaviorFunctions.GetNowPlayingId()
	if nowPlaying == nil then
		BehaviorFunctions.StartStoryDialog(dialogId)
	elseif nowPlaying ~= nil then
		self.currentDialog = nowPlaying
	end
end

function TaskBehavior1010101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				self.missionState = 2
			elseif self.missionState == 3 and dialogId == self.dialogList[2].Id then
				self.missionState = 4
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end