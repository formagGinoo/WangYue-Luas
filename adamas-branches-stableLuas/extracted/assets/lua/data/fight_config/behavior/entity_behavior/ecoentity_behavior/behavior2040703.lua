Behavior2040703 = BaseClass("Behavior2040703",EntityBehaviorBase)
--实机演示大平原流程实体

function Behavior2040703.GetGenerates()
	local generates = {2040803,900091,900092,900093,900094}
	return generates
end

function Behavior2040703:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.createState = 0
	self.createState1 = 0
	self.police1 = 0
	self.police2 = 0
	self.police3 = 0
	self.police4 = 0
	self.time = 0
	self.delayOn = 0
end

function Behavior2040703:Update()
	--self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleTemId = BehaviorFunctions.GetEntityTemplateId(self.role)
	if self.delayOn == 1 then
		self.time = self.time + 1
		if self.time >= 120 then 
			local pPos = BehaviorFunctions.GetTerrainPositionP("XW1",10020004,"PV999")
			self.police1 = BehaviorFunctions.CreateEntityByEntity(self.me,900091,pPos.x,pPos.y,pPos.z,nil,nil,nil)
			self.delayOn = 11
			self.time = 0
		end
	end
end

function Behavior2040703:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and areaName == "Chase1" then
		if self.createState == 0 then
			self.delayOn = 1
			self.npcEntity = BehaviorFunctions.GetNpcEntity(8010245)
			BehaviorFunctions.PlayAnimation(self.npcEntity.instanceId,"Yell")
			BehaviorFunctions.StartStoryDialog(601011301) --靠近车辆旁白
			self.createState = 1
		end
	end
	
	if triggerInstanceId == self.role and areaName == "Chase2" then
		if self.police1 then
			BehaviorFunctions.RemoveEntity(self.police1)
		end
		if self.createState1 == 0 then
			local pPos2 = BehaviorFunctions.GetTerrainPositionP("XW31",10020004,"PV999")
			local pPos3 = BehaviorFunctions.GetTerrainPositionP("XW21",10020004,"PV999")
			local pPos4 = BehaviorFunctions.GetTerrainPositionP("XW41",10020004,"PV999")
			self.police2 = BehaviorFunctions.CreateEntityByEntity(self.me,900093,pPos2.x,pPos2.y,pPos2.z,nil,nil,nil)
			self.police3 = BehaviorFunctions.CreateEntityByEntity(self.me,900092,pPos3.x,pPos3.y,pPos3.z,nil,nil,nil)
			self.police4 = BehaviorFunctions.CreateEntityByEntity(self.me,900094,pPos4.x,pPos4.y,pPos4.z,nil,nil,nil)
			self.createState1 = 1
		end
	end
end

function Behavior2040703:ExitArea(triggerInstanceId, areaName, logicName)

end