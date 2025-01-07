TaskBehavior105010401 = BaseClass("TaskBehavior105010401")
--第四章，没有通用模板（悲）

function TaskBehavior105010401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105010401:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102280101
    }
	self.xuanzhongEcoId = 1001002020012
end

function TaskBehavior105010401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    local XuanzhongState = BehaviorFunctions.GetEcoEntityState(self.xuanzhongEcoId)
    --大悬钟在上面的时候完成任务（判断可能不完善）
    if self.taskState == 0 and XuanzhongState == 0 then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
        self.taskState = 1
    end
end