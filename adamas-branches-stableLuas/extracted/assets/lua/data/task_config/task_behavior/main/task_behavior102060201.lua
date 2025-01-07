TaskBehavior102060201 = BaseClass("TaskBehavior102060201")
--大世界任务组5：清除中拒点
--子任务1：遇到刻刻
--完成条件:刻刻入队
function TaskBehavior102060201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102060201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.trace = false
end
function TaskBehavior102060201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--处理角色
	if self.taskState == 0 then
		if BehaviorFunctions.CheckRoleExist(1001002) == true then
			--把角色放入编队
			if BehaviorFunctions.CheckRoleInCurFormation(1001002) == false then
				BehaviorFunctions.UpdateCurFomration({1001001,1001002})
			elseif BehaviorFunctions.CheckRoleInCurFormation(1001002) == true then
				BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
				self.taskState	= 10
			end
		end
	end
end