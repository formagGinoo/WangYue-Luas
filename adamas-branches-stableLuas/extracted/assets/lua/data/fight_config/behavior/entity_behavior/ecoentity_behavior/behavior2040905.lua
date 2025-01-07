Behavior2040905 = BaseClass("Behavior2040905",EntityBehaviorBase)
--通风管
function Behavior2040905.GetGenerates()
	local generates = {2040901}
	return generates
end

function Behavior2040905:Init()
	self.me = self.instanceId
	self.time = 0
	self.ecoId = nil
	self.groupMember = nil
	self.groupTable  = {}
	self.AtomizeConfig = nil
	self.isSet = false

	self.CallFA = nil
	self.CallFB = nil
end

function Behavior2040905:LateInit()
	self.ecoId = self.sInstanceId
	if self.ecoId then
		self.groupMember = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
		for i,v in pairs(self.groupMember) do
			table.insert(self.groupTable,v)
		end
		self.AtomizeConfig = {
			{
				ecoId = self.groupTable[1],
			},

			{
				ecoId = self.groupTable[2],
			},
		}
	else
		self.AtomizeConfig = nil
	end
end

function Behavior2040905:Update()
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	if not BehaviorFunctions.GetEntityValue(self.me,"isOpen") then
		
		self.canOpen = false
	else
		if not self.ani then
			self.CallFA = BehaviorFunctions.AddDelayCallByFrame(50,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.me,"Open")
			self.CallFB = BehaviorFunctions.AddDelayCallByFrame(95,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.me,"Opened")
			self.ani = 1
			self.canOpen = true
		end
	end
	
	if not self.AtomizeConfig then
		self.AtomizeConfig = BehaviorFunctions.GetEntityValue(self.me,"AtomizeConfig")
		
	elseif self.AtomizeConfig then
		if (BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[1].ecoId) and BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[2].ecoId))
			or (BehaviorFunctions.GetEntity(self.AtomizeConfig[1].instanceId) and BehaviorFunctions.GetEntity(self.AtomizeConfig[2].instanceId))
			and not self.isSet and self.AtomizeConfig then
			BehaviorFunctions.SetAtomizePointsConfig(self.AtomizeConfig)
			self.isSet = true
		end
		
		--判断距离添加移除示意特效

		if self.distance < 5 then
			
			BehaviorFunctions.DoMagic(1,self.me,200000904,1)
			
		else
			BehaviorFunctions.RemoveBuff(self.me,200000901)
			BehaviorFunctions.RemoveBuff(self.me,200000904)
		end

		
	end
end

function Behavior2040905:WorldInteractClick(uniqueId,instanceId)
	if self.canOpen then
		if self.me == instanceId then
			BehaviorFunctions.DoCrossSpace(instanceId)
		end
	else
		if self.me == instanceId then
			BehaviorFunctions.ShowTip(2040901)
		end	
		BehaviorFunctions.AddEntitySign(self.role,62003010,-1,false)
	end
end

function Behavior2040905:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.CallFA then
			BehaviorFunctions.RemoveDelayCall(self.CallFA)
			self.CallFA = nil
		end
		if self.CallFB then
			BehaviorFunctions.RemoveDelayCall(self.CallFB)
			self.CallFB = nil
		end
	end
end