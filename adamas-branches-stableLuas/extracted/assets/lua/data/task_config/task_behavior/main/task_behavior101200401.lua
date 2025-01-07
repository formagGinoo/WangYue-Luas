TaskBehavior101200401 = BaseClass("TaskBehavior101200401")
--黑幕传送

function TaskBehavior101200401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101200401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101200401:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		--传送玩家
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101200401TP01",10020005,"Task_main_00")
		local rotate = BehaviorFunctions.GetTerrainRotationP("Task101200401TP01",10020005,"Task_main_00")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		--传送黑幕
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",2)
		self.missionState = 1
		
	elseif self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		self.missionState = 3
	end
end

--赋值
function TaskBehavior101200401:Assignment(variable,value)
	self[variable] = value
end
