TaskBehavior101102802 = BaseClass("TaskBehavior101102802")
--工地死亡保底

function TaskBehavior101102802.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102802:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.inArea = false
	self.tp = false
	self.taskFinish = false
end

function TaskBehavior101102802:Update()
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.inArea == false and BehaviorFunctions.CheckEntityInArea(self.role,"BuildingArea","Task_main_01") then
		local pos = BehaviorFunctions.GetTerrainPositionP("BuildRevivePos01",10020005,"Task_main_01")
		BehaviorFunctions.SetReviveTransportPos(pos.x,pos.y,pos.z)
		self.inArea = true
	elseif self.inArea == true and not BehaviorFunctions.CheckEntityInArea(self.role,"BuildingArea","Task_main_01") then
		BehaviorFunctions.SetReviveTransportPos(nil,nil,nil)
		self.inArea = false
	end
	--if self.inArea == true and self.tp == false then
		--local pos = BehaviorFunctions.GetTerrainPositionP("BuildRevivePos01",10020005,"Task_main_01")
		--BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		--self.tp = true
	--end

end

function TaskBehavior101102802:Death(instanceId,isformation)

end

