TaskBehavior105030701 = BaseClass("TaskBehavior105030701")
--拾取箴石之猎的佩从玉

function TaskBehavior105030701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030701:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.peicongyuEcoId = 3201001010001
    self.dialogId = {102321101}
    self.dialogState = 0
end

function TaskBehavior105030701:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if not self.peicongyu then
        self.peicongyu = BehaviorFunctions.GetEcoEntityByEcoId(self.peicongyuEcoId)
    end
end

function TaskBehavior105030701:WorldInteractClick(uniqueId,instanceId)
    if instanceId == self.peicongyu and self.dialogState == 0 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        self.dialogState = 1
    end
end