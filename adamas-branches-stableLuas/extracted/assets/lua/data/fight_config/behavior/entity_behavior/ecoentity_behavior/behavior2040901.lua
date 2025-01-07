Behavior2040901 = BaseClass("Behavior2040901",EntityBehaviorBase)
--通风口

function Behavior2040901.GetGenerates()
	local generates = {2040901}
	return generates
end

function Behavior2040901:Init()
	self.me = self.instanceId
	self.time = 0
	self.ecoId = nil
	self.groupMember = nil
	self.groupTable  = {}
	self.AtomizeConfig = nil
	self.isSet = false
end

function Behavior2040901:LateInit()
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

function Behavior2040901:Update()
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	
	if not self.AtomizeConfig then
		self.AtomizeConfig = BehaviorFunctions.GetEntityValue(self.me,"AtomizeConfig")
	elseif self.AtomizeConfig then
		if (BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[1].ecoId) and BehaviorFunctions.GetEcoEntityByEcoId(self.AtomizeConfig[2].ecoId))
			or (BehaviorFunctions.CheckEntity(self.AtomizeConfig[1].instanceId) and BehaviorFunctions.CheckEntity(self.AtomizeConfig[2].instanceId))
			and not self.isSet and self.AtomizeConfig then
			BehaviorFunctions.SetAtomizePointsConfig(self.AtomizeConfig)
			self.isSet = true
		end
		--判断距离添加移除示意特效
		--if BehaviorFunctions.HasEntitySign(self.role,62003) then
		if self.distance < 5 then
			if BehaviorFunctions.GetEntityTemplateId(self.me) == 2040901 or BehaviorFunctions.GetEntityTemplateId(self.me) == 2040902 then
				BehaviorFunctions.DoMagic(self.me,self.me,200000901,1)
			elseif BehaviorFunctions.GetEntityTemplateId(self.me) == 2040903 or BehaviorFunctions.GetEntityTemplateId(self.me) == 2040904 then
				BehaviorFunctions.DoMagic(self.me,self.me,200000904,1)
			end
		else
			BehaviorFunctions.RemoveBuff(self.me,200000901)
			BehaviorFunctions.RemoveBuff(self.me,200000904)
		end
	end
end


function Behavior2040901:WorldInteractClick(uniqueId,instanceId)
	if self.me == instanceId then
		BehaviorFunctions.DoCrossSpace(instanceId)
		BehaviorFunctions.AddEntitySign(self.role,62003010,-1,false)
	end
end