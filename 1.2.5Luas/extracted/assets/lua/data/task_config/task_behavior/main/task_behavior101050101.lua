TaskBehavior101050101 = BaseClass("TaskBehavior101050101")
--任务8：青乌发现了淤脉

function TaskBehavior101050101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101050101:__init(taskInfo)
	self.taskInfo = taskInfo
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
		[1] = {Id = 101050101,state = self.dialogStateEnum.NotPlaying},
		[2] = {Id = 101040301,state = self.dialogStateEnum.NotPlaying},
	}
	self.trace = false
end

function TaskBehavior101050101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--叙慕前往淤脉前的对话
	if self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101040301","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
			self.dialogList[2].state = self.dialogStateEnum.Playing
		end
	end
	
	--叙慕在附近发现了淤脉
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101050101","Logic10020001_6")
		if inArea then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 1
		end
	end

	if self.missionState == 2  then
		--图片引导治愈气脉竹
		BehaviorFunctions.ShowGuideImageTips(20004)
		BehaviorFunctions.SendTaskProgress(101050101,1,1)
		self.missionState = 3
	end
end

function TaskBehavior101050101:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
end

--死亡事件
function TaskBehavior101050101:Death(instanceId,isFormationRevive)

end


function TaskBehavior101050101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101050101:StoryEndEvent(dialogId)
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