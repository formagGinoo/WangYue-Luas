TaskBehavior105030921 = BaseClass("TaskBehavior105030921")
--驾驶无人机

function TaskBehavior105030921.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030921:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102321501
    }
    self.wurenjiEcoId = 2201001010002

    --功能判断
    self.isAddLevel = true
    self.isDialog = false
end

function TaskBehavior105030921:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if not self.wurenji then
        self.wurenji = BehaviorFunctions.GetEcoEntityByEcoId(self.wurenjiEcoId)
    end
    if self.taskState == 0 then
        BehaviorFunctions.AddLevel(self.taskId)   --创怪
        self.taskState = 1
    end
end

--骇入无人机的时候播对话
function TaskBehavior105030921:OnDriveDrone(instanceId)
    if instanceId == self.wurenji then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
    end
end

--退出骇入，任务结束
function TaskBehavior105030921:OnStopDriveDrone(instanceId)
    if instanceId == self.wurenji then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end