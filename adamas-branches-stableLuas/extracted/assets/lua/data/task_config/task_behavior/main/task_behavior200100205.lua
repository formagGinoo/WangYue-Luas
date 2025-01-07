TaskBehavior200100205 = BaseClass("TaskBehavior200100205",LevelBehaviorBase)
--救下于静
function TaskBehavior200100205:__init(taskInfo)
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

function TaskBehavior200100205:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
	end
	
	if self.taskState == 2 then
		BehaviorFunctions.CreateDuplicate(1006)
		BehaviorFunctions.StartStoryDialog(40001,{})
		self.timeLineState = self.StoryStateEnum.Playing
		self.taskState = 3
	end
	
	if self.taskState == 3 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			--BehaviorFunctions.SetGuideTask(200100210)
			self.taskState = 4
		end
	end
end

function TaskBehavior200100205:RemoveTask()
	
end

function TaskBehavior200100205:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100205:EnterArea(triggerInstanceId, areaName)
	local area = self:CheckAreaName("Mission210Area","Logic10020001_5",areaName)
	if area == true and self.taskState == 1 then
		--BehaviorFunctions.SendTaskProgress(200100209,1,1)
		self.taskState = 2
	end
end

function TaskBehavior200100205:ExitArea(triggerInstanceId, areaName)

end


function TaskBehavior200100205:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100205:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end

function TaskBehavior200100205:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		self.taskState = 0
	end
end