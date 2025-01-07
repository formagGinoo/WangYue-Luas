TaskBehavior101062401 = BaseClass("TaskBehavior101062401")
--任务12：司命提议先升级

function TaskBehavior101062401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101062401:__init(taskInfo)
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
		[1] = {Id = 101062401,state = self.dialogStateEnum.NotPlaying},
	}
	self.trace = false
	self.initSetting = false
end

function TaskBehavior101062401:Update()
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
	
	--即将面对贝露贝特，司命提出整备一下
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010624Area01","Logic10020001_6")
		if inArea then
			if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
				BehaviorFunctions.LeaveFighting()
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				self.dialogList[1].state = self.dialogStateEnum.Playing
			end
			self.missionState = 1
		end
		
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(101062401,1,1)
	end
end

--死亡事件
function TaskBehavior101062401:Death(instanceId,isFormationRevive)

end


function TaskBehavior101062401:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101062401:StoryEndEvent(dialogId)
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