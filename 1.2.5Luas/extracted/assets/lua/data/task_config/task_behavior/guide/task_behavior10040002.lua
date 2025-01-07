TaskBehavior10040002 = BaseClass("TaskBehavior10040002")
--在激活赐福之前隐藏小地图
function TaskBehavior10040002:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.transportEcoList = {1101,1102,1103,1104,1105}
end

function TaskBehavior10040002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if 	self.taskState == 0  then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --地图
		self.taskState = 1
	end
	if self.taskState == 1 then
		for i = 1, 5 do
			if BehaviorFunctions.GetEcoEntityByEcoId(self.transportEcoList[i]) then
				local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.transportEcoList[i])
				if BehaviorFunctions.CheckEntityEcoState(instanceId) then
					self.taskState = 2
				end
			end
			
		end
	end
	if self.taskState == 2  then
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true) --地图
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.taskState = 3
	end
end

function TaskBehavior10040002:RemoveTask()
	
end

function TaskBehavior10040002:EnterArea(triggerInstanceId, areaName)

end
function TaskBehavior10040002:ExitArea(triggerInstanceId, areaName)
	
end