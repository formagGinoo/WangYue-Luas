TaskBehavior900000003 = BaseClass("TaskBehavior900000003")
--刺杀教学

function TaskBehavior900000003.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior900000003:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
end

function TaskBehavior900000003:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--有刺杀仲魔开始检测
	if self.role and BehaviorFunctions.HasEntitySign(self.role,62001003) then
		local target = BehaviorFunctions.SearchEntities(self.role,20,315,45,2,1,900000053,1004,0,0,2,false,true,0.2,0.8,false,false,true)
		if next(target) and self.taskState == 0 then
			BehaviorFunctions.ShowGuideImageTips(20022)
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end

function TaskBehavior900000003:EnterArea(instanceId,Area)

end