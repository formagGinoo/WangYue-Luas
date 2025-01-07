TaskBehavior100100102 = BaseClass("TaskBehavior100100102")
--背包指引
function TaskBehavior100100102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
end

function TaskBehavior100100102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local closeCallback = function()
		self:Dooo()
	end
	if self.taskState == 0 then
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,10014,closeCallback)

		BehaviorFunctions.SendTaskProgress(100100102,1,1)
		self.taskState = 10
	end
end

function TaskBehavior100100102:EnterArea(triggerInstanceId, areaName)

end

function TaskBehavior100100102:RemoveTask()

end

function TaskBehavior100100102:Dooo()
	BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowWeakGuide,10007)
end