Behavior2030201 = BaseClass("Behavior2030201",EntityBehaviorBase)
--可破坏花
function Behavior2030201.GetGenerates()
	 --local generates = {203020102,203020202}
	 --return generates
end

function Behavior2030201:Init()
	self.me = self.instanceId
	self.magicState = 0
end 


function Behavior2030201:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		if self.entityId == 2030201 then
			self.Effect = BehaviorFunctions.CreateEntity(203020101,self.me)
		elseif self.entityId == 2030202 then
			self.Effect = BehaviorFunctions.CreateEntity(203020201,self.me)
		end
		self.magicState = 1
	end
end

function Behavior2030201:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.me then
		BehaviorFunctions.RemoveEntity(self.Effect)
		BehaviorFunctions.DoMagic(1,self.me,900000028)
		if self.entityId == 2030201 then
			BehaviorFunctions.CreateEntity(203020102,self.me)
		elseif self.entityId == 2030209 then
			BehaviorFunctions.CreateEntity(203020102,self.me)
		elseif self.entityId == 2030202 then
			BehaviorFunctions.CreateEntity(203020202,self.me)
		end
	end
end

function Behavior2030201:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.Effect and BehaviorFunctions.CheckEntity(self.Effect) then
			BehaviorFunctions.RemoveEntity(self.Effect)
		end
	end
end