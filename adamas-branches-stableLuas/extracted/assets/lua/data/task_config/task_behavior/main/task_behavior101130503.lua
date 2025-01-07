TaskBehavior101130502 = BaseClass("TaskBehavior101130502")
--完成引导完成任务


function TaskBehavior101130502.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101130502:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.guideId = 1013  --换武器升级武器
    self.dialogId = {
        
    }
    self.dialogState = 0
end

function TaskBehavior101130502:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	--BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)  --先直接完成，引导还没配

    if BehaviorFunctions.CheckGuideFinish(self.guideId) then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
	end
end

-- function TaskBehavior101130502:OnGuideFinish(guideId, stage)
--     if guideId == self.guideId then
--         BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
--     end
-- end