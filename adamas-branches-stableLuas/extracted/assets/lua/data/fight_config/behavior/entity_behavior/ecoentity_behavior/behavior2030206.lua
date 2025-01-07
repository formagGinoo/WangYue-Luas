Behavior2030206 = BaseClass("Behavior2030206",EntityBehaviorBase)
--炸药桶
function Behavior2030206.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030206:Init()
	self.me = self.instanceId
	self.magicState = 0
end


function Behavior2030206:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		self.magicState = 1
	end
end

function Behavior2030206:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.me then
		BehaviorFunctions.DoMagic(1,self.me,900000010)
		BehaviorFunctions.CreateEntity(203020601,self.me) --特效
		local pos = BehaviorFunctions.GetPositionP(self.me)
		BehaviorFunctions.CreateEntity(2030206001,self.me,pos.x,pos.y,pos.z)	--子弹
	end
end