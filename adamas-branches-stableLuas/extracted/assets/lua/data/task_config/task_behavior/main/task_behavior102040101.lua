TaskBehavior102040101 = BaseClass("TaskBehavior102040101")
--大世界任务组3：去城镇
--子任务1：去城镇的路上
--完成条件：离开据点

function TaskBehavior102040101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId = 102220101  --往熙来飞播
	self.taskState = 0
end

function TaskBehavior102040101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end

function TaskBehavior102040101:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "QuitSmallArea" and logicName == "TaskMain002" then
		if self.taskState == 0 then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.taskState = 1
		end
	end
end