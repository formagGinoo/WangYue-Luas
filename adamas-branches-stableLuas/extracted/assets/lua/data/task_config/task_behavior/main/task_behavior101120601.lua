TaskBehavior101120601 = BaseClass("TaskBehavior101120601")
--完成引导完成任务（已废弃）


function TaskBehavior101120601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101120601:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.guideId = 1035  --升级佩从箴石之猎开启骇入功能
    self.dialogId = {
        
    }
    self.dialogState = 0
end

function TaskBehavior101120601:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	--BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)  --先直接完成，引导还没配

    if BehaviorFunctions.CheckGuideFinish(self.guideId) then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
	end
end

-- function TaskBehavior101120601:OnGuideFinish(guideId, stage)
--     if guideId == self.guideId then
--         BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
--     end
-- end