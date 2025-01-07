TaskBehavior303010101 = BaseClass("TaskBehavior303010101")
--开车到达终点

function TaskBehavior303010101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.spedId = 2
	self.missionState = 0
	self.missionsped = 0

	--任务ID标签
	self.walkMission = 0
	self.carMission = 0
end

function TaskBehavior303010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303010101:Init()
end

function TaskBehavior303010101:Update()
if self.missionState == 0 then
	self.time = BehaviorFunctions.GetFightFrame()		--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()		--获取控制实体

	--检测任务是否完成
	--走路到达终点
		if self.missionsped < 1 then
			local playerWalk = BehaviorFunctions.CheckTaskStepIsFinish(3030102,1)
			if playerWalk == true and self.walkMission == 0 then
				self.missionsped = self.missionsped + 1
				self.walkMission = 1
			end
		end
	--开车到达终点
		if self.missionsped < 1 then
			local playerCar = BehaviorFunctions.CheckTaskStepIsFinish(3030102,1)
			if playerCar == true and self.carMission == 0 then
				self.missionsped = self.missionsped + 1
				self.carMission = 1
			end
		end
	if self.missionsped == 1 then
		BehaviorFunctions.SendTaskProgress(self.taskId, self.spedId, 1)
		print("TaskBehavior303010101任务结束")
		self.missionState = 999
	end
end
end