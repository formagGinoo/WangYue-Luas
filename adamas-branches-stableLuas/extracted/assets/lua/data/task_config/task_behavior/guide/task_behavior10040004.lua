TaskBehavior10040004 = BaseClass("TaskBehavior10040004")
--赐福教学
function TaskBehavior10040004:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.tip1State = 0
	self.tip2State = 0
end

function TaskBehavior10040004:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
end

function TaskBehavior10040004:RemoveTask()
	
end

function TaskBehavior10040004:EnterArea(triggerInstanceId, areaName)

end
function TaskBehavior10040004:ExitArea(triggerInstanceId, areaName)
	
end