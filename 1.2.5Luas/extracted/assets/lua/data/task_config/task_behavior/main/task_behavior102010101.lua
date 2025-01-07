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
	self.dialogId = 102010101
end

function TaskBehavior102010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
	if self.taskState == 0 then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020001,"LogicWorldTest01")
		BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoSetPositionP,self.role,pos)
		self.taskState = 1 
	end
end

--死亡事件
function TaskBehavior102010101:Death(instanceId,isFormationRevive)
	
end

function TaskBehavior102010101:RemoveTask()

end