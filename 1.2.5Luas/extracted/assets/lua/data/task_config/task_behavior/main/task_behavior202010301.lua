TaskBehavior202010301 = BaseClass("TaskBehavior202010301")
--任务3：叙慕跌落崖底timeline

function TaskBehavior202010301.GetGenerates()
	local generates = {900040,910040,800020}
	return generates
end

function TaskBehavior202010301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	self.missionState=0
	self.monsterNum=0
	self.animationFinish=false
	self.dialogId=202010301
	self.animationFrame=47
	self.animationTotalFrame=92
	self.initialKey=true


end

function TaskBehavior202010301:Update()

	
	

end

function TaskBehavior202010301:StoryStartEvent(dialogId)

end

function TaskBehavior202010301:StoryEndEvent(dialogId)

end

function TaskBehavior202010301:Die(attackInstanceId,dieInstanceId)
	
end


function TaskBehavior202010301:Death(instanceId,isFormationRevive)

	
end





function TaskBehavior202010301:PathFindingEnd(instanceId,result)
	
end


function TaskBehavior202010301:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId==self.role
		and areaName=="Area1"
		and self.missionState==1
		and logicName=="Logic202010101" then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.missionState=2
		BehaviorFunctions.AddLevel(202010101)
		
	end
end
