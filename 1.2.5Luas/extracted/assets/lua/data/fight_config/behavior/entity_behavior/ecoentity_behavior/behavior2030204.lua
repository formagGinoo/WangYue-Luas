Behavior2030204 = BaseClass("Behavior2030204",EntityBehaviorBase)
--可破坏木箱
function Behavior2030204.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030204:Init()
	self.me = self.instanceId
	self.magicState = 0
end


function Behavior2030204:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		self.magicState = 1
	end
end

function Behavior2030204:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.me then
		BehaviorFunctions.DoMagic(1,self.me,900000010)
		BehaviorFunctions.CreateEntity(200000107,self.me)
	end
end