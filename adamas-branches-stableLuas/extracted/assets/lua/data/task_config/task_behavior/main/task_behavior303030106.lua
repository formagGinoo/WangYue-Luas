TaskBehavior303030106 = BaseClass("TaskBehavior303030106")

function TaskBehavior303030106.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303030106:__init(taskInfo)
	
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
	self.dialogId = nil
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
end

function TaskBehavior303030106:Update()
	-- print("TaskBehavior303030106初始化")
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	if self.missionState == 0 then
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		-- print("TaskBehavior303030106传送黑幕")
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		BehaviorFunctions.AddDelayCallByFrame(40,BehaviorFunctions,BehaviorFunctions.ShowTip,303010105)
		-- BehaviorFunctions.ShowTip(303010105)
		self.missionState = 1
	elseif self.missionState == 1 then
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.SendTaskProgress,3031401,3,1,1)
		-- BehaviorFunctions.SendTaskProgress(3030501,6,1,1)
		self.missionState = 3
		-- print("TaskBehavior303030106任务结束")
	end
end