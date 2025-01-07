TaskBehavior102070110 = BaseClass("TaskBehavior102070110")
--寻找接线人

function TaskBehavior102070110.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102070110:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
	self.dialogId = nil
	self.taskState = 0
	self.npcId = 5991022
	self.hackState = 0
end

function TaskBehavior102070110:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 0 then
		BehaviorFunctions.ShowTip(100000003,"利用骇入视线寻找任务目标")
		BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.HideTip,100000003)
		--BehaviorFunctions.SendTaskProgress(self.taskId, self.taskStepId, 1)
		self.taskState = 1
	end
	--获取NPC实例id
	self.npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
	if self.npcEntity then
		self.npcInstanceId = self.npcEntity.instanceId
		BehaviorFunctions.SetEntityHackEffectIsTask(self.npcInstanceId, true)
	end
		
end

--进入骇入模式
function TaskBehavior102070110:Hacking(instanceId)	
	if self.hackState == 0 then
		
		self.hackState = 1
	end
	--如果骇入对象是接线人
	if instanceId == self.npcInstanceId and self.hackState == 1 then
		BehaviorFunctions.ShowCommonTitle(7,"已发现任务目标：接线人",true)
		BehaviorFunctions.SendTaskProgress(self.taskId, self.taskStepId, 1)
		self.hackState = 2
	end
end