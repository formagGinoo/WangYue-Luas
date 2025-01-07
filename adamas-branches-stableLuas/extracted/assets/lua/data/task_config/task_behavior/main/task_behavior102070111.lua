TaskBehavior102070111 = BaseClass("TaskBehavior102070111")
--寻找接线人

function TaskBehavior102070111.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102070111:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
	self.dialogId = nil
	self.taskState = 0
	self.npcId = 5991022
	self.hackState = 0
    self.hackMail = false
end

function TaskBehavior102070111:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	--获取NPC实例id
	self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	if self.npcEntity then
		self.npcInstanceId = self.npcEntity.instanceId
	end
	if self.npcInstanceId then
		BehaviorFunctions.SetEntityHackEffectIsTask(self.npcInstanceId, true)
		BehaviorFunctions.SetNpcMailState(self.npcInstanceId,true)
	end
end

--进入窃听中
function TaskBehavior102070111:HackingClickUp(instanceId)
	if instanceId == self.npcInstanceId and self.hackMail == false then
		self.hackMail = true
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.ShowCommonTitle, 7,"已拦截到关键信息",true)
	end
end

--进入骇入模式
function TaskBehavior102070111:Hacking(instanceId)	
	
end

function TaskBehavior102070111:ExitHacking()
	if self.hackMail == true then
		BehaviorFunctions.SendTaskProgress(self.taskId, self.taskStepId, 1)
	end
end