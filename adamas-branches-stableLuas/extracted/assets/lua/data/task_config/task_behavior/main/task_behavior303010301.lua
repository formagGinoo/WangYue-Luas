TaskBehavior303010301 = BaseClass("TaskBehavior303010301")
--开车到达终点

function TaskBehavior303010301:__init(taskInfo)
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

function TaskBehavior303010301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303010301:Init()
end

function TaskBehavior303010301:Update()
if self.missionState == 0 then
	self.time = BehaviorFunctions.GetFightFrame()		--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()		--获取控制实体

		--获取设置当前驾驶车实体，npc上车前任意车辆都行，上车后存carCur
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
	end
end
--走路到达任务开始区域
function TaskBehavior303010301:EnterArea(triggerInstanceId, areaName, logicName)
if self.missionState == 0 then
	if triggerInstanceId == self.role and areaName == "MissionBeginsArea" then
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
		if self.car ~= nil then
			BehaviorFunctions.SendTaskProgress(self.taskId,self.spedId,1)
			BehaviorFunctions.CarBrake(self.car,true)	--强制刹车
			BehaviorFunctions.SetDisableGetOffCar(self.car,false)
			BehaviorFunctions.GetOffCar(self.car)
			self.initState = 999
			self.missionState = 999
		else
			self.initState = 999
			self.missionState = 999
		end
	end
end
end
end