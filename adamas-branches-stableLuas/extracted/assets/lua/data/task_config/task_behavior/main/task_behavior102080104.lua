TaskBehavior102080104 = BaseClass("TaskBehavior102080104")
--灭火

function TaskBehavior102080104.GetGenerates()
	local generates = {2030802}
	return generates
end

function TaskBehavior102080104:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
	self.dialogId = nil
	self.taskState = 0
	self.imageTipId = 20013
end

function TaskBehavior102080104:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--显示灭火器
	if self.taskState == 0 then
		if self.imageTipId then
			BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
		end
		local pos = BehaviorFunctions.GetTerrainPositionP("Xuantianxianjing", 10020005, "Main02_1")
		self.baojingqi = BehaviorFunctions.CreateEntity(2030802, nil, pos.x, pos.y, pos.z, nil, nil, nil)
		self.taskState = 1
	end

	local isOff = BehaviorFunctions.GetEntityValue(self.baojingqi,"isOff")
	if isOff == true then
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)
	end
end
