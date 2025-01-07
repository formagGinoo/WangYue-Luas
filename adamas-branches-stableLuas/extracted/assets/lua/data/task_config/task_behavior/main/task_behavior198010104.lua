TaskBehavior198010104 = BaseClass("TaskBehavior198010104")
--五月版本演示任务：追踪板子

function TaskBehavior198010104.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior198010104:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.missionState = 0	
	self.teachPos = Vec3.New(2191,102,964)
	self.bellPos = Vec3.New(2194.10, 101.96, 1055.30)
end

function TaskBehavior198010104:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	--文字提示
	if self.missionState == 0 then
		BehaviorFunctions.SetTaskGuidePosition(self.taskId,self.teachPos,"靠近岸边",5)
		self.missionState = 1
	elseif self.missionState == 1 then
		local rolePos = BehaviorFunctions.GetPositionP(self.role)
		local distance = BehaviorFunctions.GetDistanceFromPos(self.teachPos,rolePos)
		if distance < 5 then
			BehaviorFunctions.SetTaskGuidePosition(self.taskId,self.bellPos,"调查大钟悬",40)
			self.missionState = 2
		end
	end
end