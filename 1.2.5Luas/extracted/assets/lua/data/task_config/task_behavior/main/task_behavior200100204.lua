TaskBehavior200100204 = BaseClass("TaskBehavior200100204",LevelBehaviorBase)
--救辉光蜻蜓员工阿飞
function TaskBehavior200100204:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.createLevelState = 0
	self.subTask = {

	} 
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
		}
	self.subTaskPlayingId = 0

end

function TaskBehavior200100204:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
	end
	
	if self.taskState == 1 then
		self.taskState = 1.5
	end
	
	if self.taskState == 2 then
		BehaviorFunctions.CreateDuplicate(1005)
		BehaviorFunctions.StartStoryDialog(37001,{})
		self.timeLineState = self.StoryStateEnum.Playing
		self.taskState = 3
	end
	
	if self.taskState == 3 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			--BehaviorFunctions.SetGuideTask(200100208)
			self.taskState = 4
		end
	end
end

function TaskBehavior200100204:RemoveTask()
	
end

function TaskBehavior200100204:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100204:EnterArea(triggerInstanceId, areaName)
	local area = self:CheckAreaName("Mission203Area","Logic10020001_5",areaName)
	if area == true and self.taskState == 1.5 then
		--BehaviorFunctions.SendTaskProgress(200100207,1,1)
		self.taskState = 2
	end
end

function TaskBehavior200100204:ExitArea(triggerInstanceId, areaName)

end

function TaskBehavior200100204:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100204:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end

function TaskBehavior200100204:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		self.taskState = 0
	end
end
