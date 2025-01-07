TaskBehavior103090110 = BaseClass("TaskBehavior103090110")
--解锁建造

function TaskBehavior103090110.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior103090110:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	self.tipsState = 0
end

function TaskBehavior103090110:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.tipsState == 0  then
		--创建教学
		MsgBoxManager.Instance:ShowTips(TI18N("请手动将箴石之劣佩从提升至8级，并装备建造能力"), 4)
		self.tipsState = 1
	end
	if self.missionState == 0 and BehaviorFunctions.CheckAbilityWheelHasAbility(102) then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)
		self.missionState = 1
	end

end