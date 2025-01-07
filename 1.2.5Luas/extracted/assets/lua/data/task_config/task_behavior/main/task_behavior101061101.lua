TaskBehavior101061101 = BaseClass("TaskBehavior101061101")
--任务11：司命觉得青乌累了

function TaskBehavior101061101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101061101:__init(taskInfo)
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
		[1] = {Id = 101061101,state = self.dialogStateEnum.NotPlaying},
	}
	self.trace = false
	self.initSetting = false
end

function TaskBehavior101061101:Update()
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
	--司命觉得青乌累了
	if self.missionState == 0 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101061101","Logic10020001_6")
		if inArea then
			if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				self.dialogList[1].state = self.dialogStateEnum.Playing
			end
		end
		local inArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010611Area02","Logic10020001_6")
		if inArea2 then
			BehaviorFunctions.SendTaskProgress(101061101,1,1)
			self.missionState = 1
		end
	end
end

--死亡事件
function TaskBehavior101061101:Death(instanceId,isFormationRevive)

end


function TaskBehavior101061101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101061101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if self.missionState == 1 and dialogId == self.dialogList[1].Id then
				--self.missionState = 2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end