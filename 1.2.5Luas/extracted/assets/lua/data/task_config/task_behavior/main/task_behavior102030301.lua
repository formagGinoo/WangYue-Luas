TaskBehavior102030301 = BaseClass("TaskBehavior102030301")
--大世界任务组2：清除小拒点
--子任务3：解决拒点
--完成条件：清空据点

function TaskBehavior102030301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
	self.dialogId = 102030301
end
function TaskBehavior102030301:Update()

end