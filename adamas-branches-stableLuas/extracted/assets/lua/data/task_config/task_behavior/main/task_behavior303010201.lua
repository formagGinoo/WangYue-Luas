TaskBehavior303010201 = BaseClass("TaskBehavior303010201")
--走路到达终点

function TaskBehavior303010201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.spedId = 1
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.createState = 0
	self.tipState = 0
	self.car = 0
	self.carCur = 0 --上车后存车的实体
	self.pos = 0
	self.npc = 0
	self.monster1 = 0
	self.monster2 = 0
	self.position = 0
	self.guideEntity = 0
	self.getOffCarGuideEntity = 0
	self.showtip02 = false		--请开车前往目标地点
end

function TaskBehavior303010201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303010201:Init()
end

function TaskBehavior303010201:Update()
if self.missionState == 0 then
	self.time = BehaviorFunctions.GetFightFrame()		--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()		--获取控制实体
end
end

--走路到达任务开始区域
function TaskBehavior303010201:EnterArea(triggerInstanceId, areaName, logicName)
if self.missionState == 0 then
	if triggerInstanceId == self.role and areaName == "MissionBeginsArea" then
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
		if self.car ~= nil then
			self.initState = 999
			self.missionState = 999
		else
			BehaviorFunctions.SendTaskProgress(self.taskId,self.spedId,1)
			self.initState = 999
			self.missionState = 999
		end
	end
end
end