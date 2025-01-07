TaskBehavior303050101 = BaseClass("TaskBehavior303050101")
--开车到达终点

function TaskBehavior303050101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.spedId = 1
	self.dialogId = 3030501
	self.missionState = 0
	self.missionsped = 0	

	--任务ID标签
	self.baoMission = 0
	self.ruMission = 0
	self.CertMission = 0
end

function TaskBehavior303050101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303050101:Init()
end

function TaskBehavior303050101:Update()
if self.missionState == 0 then
	self.time = BehaviorFunctions.GetFightFrame()		--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()		--获取控制实体

	--检测任务是否完成
	--包崇对话
	if self.missionsped < 2 then

			local Bao = BehaviorFunctions.CheckTaskStepIsFinish(3030601,1)
			if Bao == true and self.baoMission == 0  then
				self.missionsped = self.missionsped + 1
				self.baoMission = 1
			end

		--如影对话

			local Ru = BehaviorFunctions.CheckTaskStepIsFinish(3030701,1)
			if Ru == true and self.ruMission == 0 then
				self.missionsped = self.missionsped + 1
				self.ruMission = 1
			end

		--证书

			local Cert = BehaviorFunctions.CheckTaskStepIsFinish(3030801,2)
			if Cert == true and self.CertMission == 0 then
				self.missionsped = self.missionsped + 1
				self.CertMission = 1
			end

	end

	if self.missionsped == 2 then
		BehaviorFunctions.SendTaskProgress(self.taskId, self.spedId, 1)
		self.missionState = 1
	end
	end
end