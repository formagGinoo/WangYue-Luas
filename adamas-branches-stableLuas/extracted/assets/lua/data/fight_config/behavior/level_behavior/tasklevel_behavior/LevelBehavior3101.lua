LevelBehavior3101 = BaseClass("LevelBehavior3101",LevelBehaviorBase)

function LevelBehavior3101.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior3101:__init(fight)
	self.fight = fight
end

function LevelBehavior3101:Init()	
	self.role = nil	
	self.missionState = 0	
	self.interPointGroup = 
	{
		[1] = {instanceId = nil,pointName = "InterPoint1",processId = 1,processVal = 0,interSwitch = false,interUniqueId = nil},
		[2] = {instanceId = nil,pointName = "InterPoint2",processId = 2,processVal = 0,interSwitch = false,interUniqueId = nil},
		[3] = {instanceId = nil,pointName = "InterPoint3",processId = 3,processVal = 0,interSwitch = false,interUniqueId = nil},
		[4] = {instanceId = nil,pointName = "InterPoint4",processId = 4,processVal = 0,interSwitch = false,interUniqueId = nil},
		[5] = {instanceId = nil,pointName = "InterPoint5",processId = 5,processVal = 0,interSwitch = false,interUniqueId = nil},
	}
	self.exitIns = {instanceId = nil,pointName = "pb1",interSwitch = false,interUniqueId = nil}
	self.totalProcess = 0	
	self.reviveIns = nil
end

function LevelBehavior3101:LateInit()
	
end
	
function LevelBehavior3101:Update()
	if self.missionState == 0 then
		self:GetlevelProcess()
		self:CreateInterPoint()
		self.missionState = 1
		
	elseif self.missionState == 1 then
		
		if self.totalProcess == 5 then
			BehaviorFunctions.SetDuplicateResult(true)
			--创建退出路牌
			local pos = BehaviorFunctions.GetTerrainPositionP(self.exitIns.pointName,self.levelId)
			self.exitIns.instanceId = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId) -- 创建路牌交互特效
			self.missionState = 2
		end
	end
end

function LevelBehavior3101:GetlevelProcess()
	if self.interPointGroup then
		for i,v in ipairs(self.interPointGroup) do
			if v.processId then
				local val = BehaviorFunctions.GetDuplicateProgress(v.processId)
				if val then
					self.totalProcess = self.totalProcess + val
					v.processVal = val
				end
			end
		end
		local pos = BehaviorFunctions.GetDuplicateRevivePos()
		self.reviveIns = BehaviorFunctions.CreateEntity(200000102,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	end
end

function LevelBehavior3101:CreateInterPoint()
	if self.interPointGroup then
		for i,v in ipairs(self.interPointGroup) do
			if v.processVal == 0 then
				--创建路牌
				local pos = BehaviorFunctions.GetTerrainPositionP(v.pointName,self.levelId)
				v.instanceId = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId) -- 创建路牌交互特效
			end
		end
	end
end

function LevelBehavior3101:WorldInteractClick(uniqueId,instanceId)
	for i,v in ipairs(self.interPointGroup) do
		if instanceId == v.instanceId then
			BehaviorFunctions.WorldInteractRemove(v.instanceId)
			local pos = BehaviorFunctions.GetTerrainPositionP(v.pointName,self.levelId)
			BehaviorFunctions.UpdateDuplicateRevivePos(pos)
			BehaviorFunctions.DoSetPositionP(self.reviveIns,pos)
			BehaviorFunctions.SendDuplicateProgress(v.processId,1)
			BehaviorFunctions.RemoveEntity(v.instanceId)
			self.totalProcess = self.totalProcess + 1
		end
	end
	if instanceId == self.exitIns.instanceId then
		BehaviorFunctions.ExitDuplicate()
	end
end

function LevelBehavior3101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.interPointGroup) do
		if triggerInstanceId == v.instanceId and v.interSwitch == false then
			v.interSwitch = true
			v.interUniqueId = BehaviorFunctions.WorldInteractActive(v.instanceId,1,nil,"和实体交互")
		end
	end
	if triggerInstanceId == self.exitIns.instanceId then
		self.exitIns.interSwitch = true
		self.exitIns.interUniqueId = BehaviorFunctions.WorldInteractActive(self.exitIns.instanceId,1,nil,"退出关卡")
	end
end

function LevelBehavior3101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	for i,v in ipairs(self.interPointGroup) do
		if triggerInstanceId == v.instanceId and v.interSwitch == true then
			v.interSwitch = false
			BehaviorFunctions.WorldInteractRemove(v.instanceId,v.interUniqueId)
		end
	end
	if triggerInstanceId == self.exitIns.instanceId then
		self.exitIns.interSwitch = false
		BehaviorFunctions.WorldInteractRemove(self.exitIns.instanceId,self.exitIns.interUniqueId)
	end
end










