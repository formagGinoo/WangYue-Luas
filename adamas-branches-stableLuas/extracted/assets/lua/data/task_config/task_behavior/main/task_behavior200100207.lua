TaskBehavior200100207 = BaseClass("TaskBehavior200100207",LevelBehaviorBase)
--救回人民后于用和温度莎的对话
function TaskBehavior200100207:__init(taskInfo)
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
	
	self.NPCIdentity = {
		{name = '于用',ecoID = 403, taskDialogID = 43001,clueState = false,uniqueID = nil,instanceID = nil},
		{name = '温度纱',ecoID = 406, taskDialogID = 46001,clueState = false,uniqueID = nil,instanceID = nil},
	}
	self.timeLineState = 0
	self.totalClue = 0
end



function TaskBehavior200100207:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

end

function TaskBehavior200100207:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	for index,value in ipairs(self.NPCIdentity) do
		if ecoID == self.NPCIdentity[index].ecoID and self.NPCIdentity[index].clueState == false then
			BehaviorFunctions.SetEntityValue(triggerInstanceId,"taskDialog",self.NPCIdentity[index].taskDialogID)
			self.NPCIdentity[index].uniqueID = BehaviorFunctions.GetEntityValue(triggerInstanceId,"UniID")
			self.NPCIdentity[index].instanceID = triggerInstanceId
		end
	end
end


function TaskBehavior200100207:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)

end

function TaskBehavior200100207:WorldInteractClick(uniqueId)

end

function TaskBehavior200100207:RemoveTask()
	
end

function TaskBehavior200100207:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function TaskBehavior200100207:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
end
