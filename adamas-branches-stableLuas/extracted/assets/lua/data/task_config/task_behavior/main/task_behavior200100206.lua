TaskBehavior200100206 = BaseClass("TaskBehavior200100206",LevelBehaviorBase)
--带着于静回熙来
function TaskBehavior200100206:__init(taskInfo)
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

function TaskBehavior200100206:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		BehaviorFunctions.SendTaskProgress(200100213,1,1)
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.taskState = 1
	end
	if self.taskState == 2 then
		BehaviorFunctions.StartStoryDialog(42001,{})
		self.timeLineState = self.StoryStateEnum.Playing
		self.taskState = 3
	end
	
	if self.taskState == 3 then
		BehaviorFunctions.SendTaskProgress(200100211,1,1)
		self.taskState = 4
	end
end

function TaskBehavior200100206:RemoveTask()
	
end

function TaskBehavior200100206:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior200100206:EnterArea(triggerInstanceId, areaName)
	local area = self:CheckAreaName("Village","MVP_1",areaName)
	if area == true and self.taskState == 1 then
		BehaviorFunctions.ShowCommonTitle(1,"熙来",false)
		self.taskState = 2
	end
end

function TaskBehavior200100206:ExitArea(triggerInstanceId, areaName)

end

function TaskBehavior200100206:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100206:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end