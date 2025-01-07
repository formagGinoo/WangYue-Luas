TaskBehavior302040201 = BaseClass("TaskBehavior302040201")
--支线任务组：寻找脉灵
--子任务1：进行脉灵追逐游戏
--完成条件：完成交互

--初始化
function TaskBehavior302040201.GetGenerates()
	local generates = {50002, 801200102, 801200104, 801200106, 801200107}
	return generates
end

function TaskBehavior302040201:__init(taskInfo)
	self.taskInfo = taskInfo
    self.missionState = 0
end

function TaskBehavior302040201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.missionState == 0 then
        BehaviorFunctions.AddLevel(302040201)
        self.missionState = 1
    end
end