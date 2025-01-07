TaskBehavior102140101 = BaseClass("TaskBehavior102140101")
--大世界任务组4：寻找刻刻
--子任务5：激活大钟悬
--完成条件：传送点激活

function TaskBehavior102140101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102140101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102140101
	self.taskFinish = false
	self.transport = nil
	self.trace = false
end
function TaskBehavior102140101:Update()
	--self.transport = BehaviorFunctions.GetEcoEntityByEcoId(1002020012)
	--if self.transport then
		--self.isActive = BehaviorFunctions.CheckEntityEcoState(self.transport)
	--end
	--if self.isActive == true and self.taskFinish == false then
		--BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		--self.taskFinish = true
	--end
	if BehaviorFunctions.CheckTaskIsFinish(102130602) then
		if not BehaviorFunctions.CheckTaskIsFinish(102130603) then
			BehaviorFunctions.SendTaskProgress(102130603,1,1)
		end
	end
	if self.trace == false then
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
end