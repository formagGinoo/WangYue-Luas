TaskBehavior102020302 = BaseClass("TaskBehavior102020302")
--大世界任务组2：清除小拒点
--子任务1：在往据点去的中途
--完成条件：离开钟楼区域

--此处重创遇见刻刻关卡，对话在关卡里管理
--完成任务后获得刻刻（任务奖励），开启编队系统、解锁刻刻切换编队指引（condition表）

function TaskBehavior102020302.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102020302:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.levelState = 0
end

function TaskBehavior102020302:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--重创关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102020301) then
			BehaviorFunctions.AddLevel(102020301)
		end
		self.levelState = 1
	end
end