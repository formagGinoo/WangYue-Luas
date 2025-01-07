TaskBehavior102040401 = BaseClass("TaskBehavior102040401")
--大世界任务组3：去城镇
--子任务4：进入警察局
--完成条件：进入警察局

function TaskBehavior102040401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId1 = 102040401
	self.dialogId2 = 102040501
end
function TaskBehavior102040401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
end
function TaskBehavior102040401:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId1 then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end

function TaskBehavior102040401:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "PoliceOffice" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId1)
			self.taskState = 1
		end
	end
end