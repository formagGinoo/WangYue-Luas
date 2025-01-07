LevelBehavior3102 = BaseClass("LevelBehavior3102",LevelBehaviorBase)

function LevelBehavior3102.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior3102:__init(fight)
	self.fight = fight
end

function LevelBehavior3102:Init()	
	self.role = nil	
	self.missionState = 0	
	self.interPointGroup = 
	{
		[1] = {instanceId = nil,pointName = "InterPoint1",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
		[2] = {instanceId = nil,pointName = "InterPoint2",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
		[3] = {instanceId = nil,pointName = "InterPoint3",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
		[4] = {instanceId = nil,pointName = "InterPoint4",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
		[5] = {instanceId = nil,pointName = "InterPoint5",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
	}
	self.exitIns = {instanceId = nil,pointName = "pb1",interSwitch = false,interUniqueId = nil}
	self.totalProcess = 0	
	self.reviveIns = nil
	
	self.countDown = false	
	
	self.dupCountDown = nil
end

function LevelBehavior3102:LateInit()

end
	
function LevelBehavior3102:Update()
	
	if self.missionState == 0 then
		self:GetlevelProcess()
		self:CreateInterPoint()
		self.missionState = 1
		
	elseif self.missionState == 1 then
		self.totalProcess = BehaviorFunctions.GetDuplicateProgress(1)

		if self.totalProcess and self.totalProcess >= 1 then
			if self.countDown == false then
				BehaviorFunctions.OpenDuplicateCountdown(true)
				self.countDown = true
			end
		end
		
		if self.totalProcess == 5 then
			BehaviorFunctions.OpenDuplicateCountdown(false)
			BehaviorFunctions.SetDuplicateResult(true)
			self.missionState = 2
		end
		
	elseif self.missionState == 998 then
		BehaviorFunctions.SetDuplicateResult(false)
		self.missionState = 999
	end
end

function LevelBehavior3102:GetlevelProcess()
	if self.interPointGroup then
		self.totalProcess = BehaviorFunctions.GetDuplicateProgress(1)
		local pos = BehaviorFunctions.GetDuplicateRevivePos()
		self.reviveIns = BehaviorFunctions.CreateEntity(200000102,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		for i,v in ipairs(self.interPointGroup) do
			if self.totalProcess and i <= self.totalProcess then
				v.processVal = 1
			else
				BehaviorFunctions.OpenDuplicateCountdown(false)
			end
		end
	end
end

function LevelBehavior3102:CreateInterPoint()
	if self.interPointGroup then
		for i,v in ipairs(self.interPointGroup) do
			if v.processVal == 0 then
				--创建路牌
				local pos = BehaviorFunctions.GetTerrainPositionP(v.pointName,self.levelId)
				v.instanceId = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId) -- 创建路牌交互特效
				break
			end
		end
	end
end

function LevelBehavior3102:WorldInteractClick(uniqueId,instanceId)
	for i,v in ipairs(self.interPointGroup) do
		if instanceId == v.instanceId then
			v.processVal = 1
			BehaviorFunctions.ResetDuplicateCountdown()
			BehaviorFunctions.WorldInteractRemove(v.instanceId)
			local pos = BehaviorFunctions.GetTerrainPositionP(v.pointName,self.levelId)
			BehaviorFunctions.UpdateDuplicateRevivePos(pos)
			BehaviorFunctions.DoSetPositionP(self.reviveIns,pos)
			BehaviorFunctions.SendDuplicateProgress(v.processId,i)
			BehaviorFunctions.RemoveEntity(v.instanceId)
			self:CreateInterPoint()
		end
	end
end

function LevelBehavior3102:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.interPointGroup) do
		if triggerInstanceId == v.instanceId and v.interSwitch == false then
			v.interSwitch = true
			v.interUniqueId = BehaviorFunctions.WorldInteractActive(v.instanceId,1,nil,"和实体交互")
		end
	end
end

function LevelBehavior3102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.interPointGroup) do
		if triggerInstanceId == v.instanceId and v.interSwitch == true then
			v.interSwitch = false
			BehaviorFunctions.WorldInteractRemove(v.instanceId,v.interUniqueId)
		end
	end
end

function LevelBehavior3102:DuplicateCountdownFinish()
	self.missionState = 998
end










