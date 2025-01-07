TaskBehavior102030401 = BaseClass("TaskBehavior102030401")
--大世界任务组2：清除小拒点
--子任务4：开门救人
--完成条件：和门交互

function TaskBehavior102030401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogState = 0
	self.trace = false
	self.dialogId = 102030401
end
function TaskBehavior102030401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.dialogState == 0 and BehaviorFunctions.GetTaskProgress(self.taskInfo.taskId,1) == 0 then
		BehaviorFunctions.StartStoryDialog(102030301) --清除据点的旁白
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.dialogState = 1
	end	
	if not BehaviorFunctions.CheckEntityEcoState(nil,3002020003) and self.taskState == 0 then
		local a = BehaviorFunctions.CheckEntityEcoState(nil,3002020003)
		local pos = Vec3.New(410,113.8,1445)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1) --任务完成后会播放对话，走任务表配置
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.DoSetPositionP,self.role,pos)
		self.taskState = 1
	end
end