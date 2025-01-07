TaskBehavior102010101 = BaseClass("TaskBehavior102010101")
--大世界任务组1：激活传送点
--子任务1：提示飞到传送点
--完成条件：无

function TaskBehavior102010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.trace = false
	self.taskState = 0
	self.levelState = 0
	self.transport = 0
	self.teachState = 0
	self.isClose = false
	self.insure = false
end

function TaskBehavior102010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.teachState == 0 then
		local closeCallback = function()
			self.isClose = true
		end
		BehaviorFunctions.ShowGuideImageTips(20013,closeCallback)
		self.teachState = 1
	end

	if self.isClose == true then
		BehaviorFunctions.PlayGuide(2201)
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		self.isClose = false
	end

	--重创刺杀教学关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102010301) then
			BehaviorFunctions.AddLevel(102010301)
		end
		self.levelState = 1
	end
end

--死亡事件
function TaskBehavior102010101:Death(instanceId,isFormationRevive)

end

function TaskBehavior102010101:RemoveTask()

end