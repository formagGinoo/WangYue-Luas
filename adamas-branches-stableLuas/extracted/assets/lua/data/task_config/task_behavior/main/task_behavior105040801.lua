TaskBehavior105040801 = BaseClass("TaskBehavior105040801")
--商人依盖队

function TaskBehavior105040801.GetGenerates()
	local generates = {900070}
	return generates
end

function TaskBehavior105040801:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.me = self.instanceId
	self.role = nil
	self.npcId = 8010705   --商贩隐于世
end

function TaskBehavior105040801:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
        --local pos = BehaviorFunctions.GetTerrainPositionP("Businessman", 10020004, "MainTask04")
        --self.Yigaidui = BehaviorFunctions.CreateEntity(900070, nil, pos.x, pos.y, pos.z)    --不清楚是否要用byEntity
		BehaviorFunctions.AddLevel(self.taskId)
        self.taskState = 1
    end
end

--function TaskBehavior105040801:Death(instanceId,isFormationRevive)
    ----杀死商人完成任务
    --if instanceId == self.Yigaidui then
        --BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    --end
--end