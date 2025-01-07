TaskBehavior105030601 = BaseClass("TaskBehavior105030601")
--再次和悬天干架，怪是箴石之猎

function TaskBehavior105030601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030601:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102320201
    }
	self.isCheckLevel = true
end

function TaskBehavior105030601:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.taskState == 0 then
		if self.isCheckLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId - 100) then
			BehaviorFunctions.AddLevel(self.taskId - 100)
		end
		self.taskState = 1
	end
end

--受击回调
function TaskBehavior105030601:Hit(attackInstanceId,hitInstanceId,hitType)
    if attackInstanceId == self.role or hitInstanceId == self.role then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
    end
end