TaskBehavior105020101 = BaseClass("TaskBehavior105020101")
--第三章通用模板

function TaskBehavior105020101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105020101:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102310101
    }

    --功能判断
    self.isAddLevel = true
    self.isDialog = true
end

function TaskBehavior105020101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        self.taskState = 1
    end
end

--剧情结束回调(没用这个)
function TaskBehavior105020101:StoryEndEvent(dialogId)
    if dialogId == 601010301 then
        
    end
end