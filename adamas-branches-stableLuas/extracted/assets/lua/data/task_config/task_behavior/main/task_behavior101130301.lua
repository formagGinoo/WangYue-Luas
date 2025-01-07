TaskBehavior101130301 = BaseClass("TaskBehavior101130301")
--完成引导完成任务（废弃，用封装好的完成条件）

function TaskBehavior101130301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101130301:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.guideId = 1014  --吸收残念升级角色
    self.dialogId = {
        
    }
    self.dialogState = 0
end

function TaskBehavior101130301:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	--BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)  --先直接完成，引导还没配(配好啦)
	
	if BehaviorFunctions.CheckGuideFinish(self.guideId) then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
	end
end



--这是检测步骤的
--function TaskBehavior101130301:OnGuideFinish(guideId, stage)
    --if guideId == self.guideId then
        --BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    --end
--end