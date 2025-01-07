TaskBehavior101050101 = BaseClass("TaskBehavior101050101")
--传送至天台且移除室内场景

function TaskBehavior101050101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101050101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
end

function TaskBehavior101050101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		
		BehaviorFunctions.ShowBlackCurtain(true,0)
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101050101TP01",10020005,"Task_main_00")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		local rotate = BehaviorFunctions.GetTerrainRotationP("Task101050101TP01",10020005,"Task_main_00")
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		
		BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0)
		BehaviorFunctions.CameraPosReduction(0)
		--BehaviorFunctions.FinishLevel(101010101)
		
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		self.missionState = 1
	end
end