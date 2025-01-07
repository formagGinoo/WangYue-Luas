TaskBehavior302050201 = BaseClass("TaskBehavior302050201")
--支线任务组：寻找脉灵
--子任务1：最后的对白
--完成条件：完成对话

function TaskBehavior302050201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior302050201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.dialogId = 202050901
	self.missionState = 0
	self.progressNum = 0
end

function TaskBehavior302050201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

end


function TaskBehavior302050201:StoryStartEvent(dialogId)
	if dialogId == self.dialogId then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		if self.zhixianGuide
			and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
			BehaviorFunctions.RemoveEntity(self.zhixianGuide)
		end
	end
end


function TaskBehavior302050201:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end	
end


function TaskBehavior302050201:Death(instanceId,isFormationRevive)
	if instanceId == self.role then
		if isFormationRevive == true then
			if self.zhixianGuide
				and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
				BehaviorFunctions.RemoveEntity(self.zhixianGuide)
			end
			self.progressNum = 0
		end
	end
end