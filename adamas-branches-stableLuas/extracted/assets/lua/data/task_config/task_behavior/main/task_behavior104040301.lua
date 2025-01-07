TaskBehavior104040301 = BaseClass("TaskBehavior104040301")
--拾取神荼的佩从玉

function TaskBehavior104040301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior104040301:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.peicongyuEcoId = 3201001010002
    self.dialogId = {}
    self.dialogState = 0
	self.peicongyu = nil
end

function TaskBehavior104040301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if not self.peicongyu then
        self.peicongyu = BehaviorFunctions.GetEcoEntityByEcoId(self.peicongyuEcoId)
    end
	--通过检测生态实体是否已经被hit判断任务完成
	if self.taskState == 0 and BehaviorFunctions.CheckEntityEcoState(nil,self.peicongyuEcoId) == false then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
		self.taskState = 1
	end
end