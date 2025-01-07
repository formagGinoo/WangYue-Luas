TaskBehavior301010406 = BaseClass("TaskBehavior301010406")
--和车交互完成任务


function TaskBehavior301010406.GetGenerates()
	local generates = {200000101}
	return generates
end

function TaskBehavior301010406:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.carEcoId = 2003001030001
	self.car = nil
	self.button = nil
end

function TaskBehavior301010406:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.car = BehaviorFunctions.GetEcoEntityByEcoId(2003001030001)
	
	if self.car == nil then
		
		
	end
	--local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.car)
	
	
	if self.taskState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("CarPos2",10020005,"LogicWuKeLaiDian")
		local rot = BehaviorFunctions.GetTerrainRotationP("CarPos2",10020005,"LogicWuKeLaiDian")
		BehaviorFunctions.TransportByInstanceId(self.car,pos.x,pos.y,pos.z,0)
		self.taskState = 1
	end
	
	
	if self.taskState == 1 then
		--if distance <= 10 then
			--BehaviorFunctions.SendTaskProgress(301010406,1,1)
			--self.taskState = 1
		--end
	end
end
