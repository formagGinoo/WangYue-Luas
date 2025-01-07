TaskBehavior102010102 = BaseClass("TaskBehavior102010102")
--大世界任务组1：激活传送点
--子任务1：提示飞到传送点
--完成条件：无

function TaskBehavior102010102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102010102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.trace = false
	self.taskState = 0
	self.levelState = 0
	self.transport = 0
	self.teachState = 0
	self.isClose = false
	self.insure = false
end

function TaskBehavior102010102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
	--if self.taskState == 0 then
		--BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		--self.taskState = 1 
	--end
	
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
function TaskBehavior102010102:Death(instanceId,isFormationRevive)
	
end

function TaskBehavior102010102:RemoveTask()

end

--function TaskBehavior102010102:ExitArea(triggerInstanceId, areaName,logicName)
	--if triggerInstanceId == self.role and areaName == "FlyTeachOutArea" and logicName == "LogicWorldTest01" then
		--if self.insure == false and self.taskState ~= 1 then
			--BehaviorFunctions.FinishGuide(2201,1)
			--BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			--self.insure = true
		--end
	--end
--end