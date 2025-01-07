TaskBehavior101062501 = BaseClass("TaskBehavior101062501")
--任务13：整备结束，前往山顶

function TaskBehavior101062501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101062501:__init(taskInfo)
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
		[1] = {Id = 101064401,state = self.dialogStateEnum.NotPlaying},--升级后播放
	}
	self.trace = false
	self.initSetting = false
	self.guideFinish = false
end

function TaskBehavior101062501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--初始化设置
	if self.initSetting == false then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		self.initSetting = true
	end
	
	if self.trace == false then
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--整备结束，进入timeline
	if self.missionState == 0 then
		--检查角色升级引导是否完成
		if BehaviorFunctions.CheckGuideFinish(1014) == true and self.guideFinish == false then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.guideFinish = true
			self.missionState = 1
		end
		
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(101062501,1,1)	
	end
end

--死亡事件
function TaskBehavior101062501:Death(instanceId,isFormationRevive)

end


function TaskBehavior101062501:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101062501:StoryEndEvent(dialogId)
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