TaskBehavior303010102 = BaseClass("TaskBehavior303010102")
--提醒玩家开车前往目标地点

function TaskBehavior303010102:__init(taskInfo)
	self.taskInfo = taskInfo
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

function TaskBehavior303010102.GetGenerates()
	local generates = {2040802,2040803,900040,900050,900070,8011001}
	return generates
end

function TaskBehavior303010102:Init()
end

function TaskBehavior303010102:Update()
if self.missionState == 0 then
	self.time = BehaviorFunctions.GetFightFrame()		--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()		--获取控制实体
	-- print("TaskBehavior303010102初始化成功")

		--获取设置当前驾驶车实体，npc上车前任意车辆都行，上车后存carCur
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
		-- print("获取玩家载具",self.car)
	end

	--检测玩家如果没有上车，就加提示
	if BehaviorFunctions.CheckEntityDrive(self.role) == false then
		-- print("玩家没有上车")
		if self.showtip02 == false then
			BehaviorFunctions.ShowTip(303010102) --请开车前往目标地点
			self.showtip02 = true
			-- print("玩家还没上车")
		end
	end

	if BehaviorFunctions.CheckEntityDrive(self.role) == true then
		BehaviorFunctions.SetDisableGetOffCar(self.car,false)
	end
end
end

--驾车或者走路到达任务开始区域
function TaskBehavior303010102:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and areaName == "MissionBeginsArea" then
		-- print("303010102玩家进入MissionBeginsArea")
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
		if self.car ~= nil then
			-- print("303010102玩家正在开车",self.car)
			BehaviorFunctions.CarBrake(self.car,true)	--强制刹车
			BehaviorFunctions.SetDisableGetOffCar(self.car,false)

			
			BehaviorFunctions.GetOffCar(self.car)
		end
		-- print("303010102脚本结束")
		self.initState = 999
		self.missionState = 999
	end
end

--赋值
function TaskBehavior303010102:Assignment(variable,value)
	self[variable] = value
end