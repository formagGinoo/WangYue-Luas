TaskBehavior101110401 = BaseClass("TaskBehavior101110401")
--和车交互完成任务


function TaskBehavior101110401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101110401:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.carEcoId = 2003001010001
    self.dialogId = {
        
    }
    self.dialogState = 0
end

function TaskBehavior101110401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    --获得车的实体
    if not self.car then
        self.car = BehaviorFunctions.GetEcoEntityByEcoId(self.carEcoId)
    end
end

function TaskBehavior101110401:WorldInteractClick(uniqueId,instanceId)
    if instanceId == self.car then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end