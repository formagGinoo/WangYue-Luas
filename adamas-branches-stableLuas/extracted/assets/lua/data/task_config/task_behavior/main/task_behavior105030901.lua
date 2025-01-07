TaskBehavior105030901 = BaseClass("TaskBehavior105030901")
--取监视器状态，播102321201，判断完成任务

function TaskBehavior105030901.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030901:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {
        102321201
    }
    self.monitorEcoId = 2201001010001
end

function TaskBehavior105030901:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.monitor then
		self.monitor = BehaviorFunctions.GetEcoEntityByEcoId(self.monitorEcoId)
	end
end

--骇入摄像头的时候播对话
function TaskBehavior105030901:CameraHack(instanceId,hacking)
    if instanceId == self.monitor and hacking == true then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
    end
end

--退出骇入，任务结束
function TaskBehavior105030901:StopHacking(instanceId)
    if instanceId == self.monitor then
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end