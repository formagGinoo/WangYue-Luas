TaskBehavior900000006 = BaseClass("TaskBehavior900000006")
--地图UI显示判断

function TaskBehavior900000006.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior900000006:__init(taskInfo)
	self.taskInfo = taskInfo
	self.initChck = false
	self.taskFinish = false
end

function TaskBehavior900000006:Update()
	--开始接到任务时，检查一下大悬钟任务有没有完成，如果没完成则隐藏小地图图标
	if self.initChck == false then
		local test = BehaviorFunctions.CheckTaskIsFinish(102010501)
		if not test then
			BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false)
		end
		self.initChck = true
	else
		--持续检查有没有完成大悬钟任务
		if self.taskFinish == false then
			local test = BehaviorFunctions.CheckTaskIsFinish(102010501)
			if test then
				BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true)
				BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
				self.taskFinish = true
			end
		end
	end
end
