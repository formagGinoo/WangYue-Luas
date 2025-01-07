TaskBehavior101030101 = BaseClass("TaskBehavior101030101")
--天台追踪临时脚本

function TaskBehavior101030101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	
	self.traceArea = 
	{
		[1] = {AreaName = "Task1010301Area01" , inArea = false ,pos = "Task101030101Target02" , trace = false },
		[2] = {AreaName = "Task1010301Area02" , inArea = false ,pos = "Task101030101Target03" , trace = false},
	}
	
	self.trace = false
end

function TaskBehavior101030101:LateInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	for i,v in ipairs(self.traceArea) do
		if BehaviorFunctions.CheckEntityInArea(self.role,v.AreaName,"Task_main_00") then
			v.inArea = true
		end
	end
end

function TaskBehavior101030101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	for i,v in ipairs(self.traceArea) do
		if BehaviorFunctions.CheckEntityInArea(self.role,v.AreaName,"Task_main_00") then
			v.inArea = true
		end
	end
	if self.traceArea[2].inArea == true and self.traceArea[2].trace == false then
		local position = BehaviorFunctions.GetTerrainPositionP(self.traceArea[2].pos,10020005,"Task_main_00")
		BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, "前往天台", 0, false)
		self.trace = false
		self.traceArea[2].trace = true
		
	elseif self.traceArea[1].inArea == true and self.traceArea[1].trace == false then
		local position = BehaviorFunctions.GetTerrainPositionP(self.traceArea[1].pos,10020005,"Task_main_00")
		BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, "前往天台", 0, false)	
		self.trace = false
		self.traceArea[1].trace = true
		
	elseif self.traceArea[1].inArea == false and self.traceArea[2].inArea == false then
		if self.trace == false then
			local position = BehaviorFunctions.GetTerrainPositionP("Task101030101Target01",10020005,"Task_main_00")
			BehaviorFunctions.SetTaskGuidePosition(self.taskId, position, "前往天台", 0, false)
			self.trace = true
		end
	end
end

function TaskBehavior101030101:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		for i,v in ipairs(self.traceArea) do
			if areaName == v.AreaName and logicName == "Task_main_00" then
				v.inArea = true
			end
		end
	end
end

function TaskBehavior101030101:ExitArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		for i,v in ipairs(self.traceArea) do
			if areaName == v.AreaName and logicName == "Task_main_00" then
				v.inArea = false
				v.trace = false
			end
		end
	end
end