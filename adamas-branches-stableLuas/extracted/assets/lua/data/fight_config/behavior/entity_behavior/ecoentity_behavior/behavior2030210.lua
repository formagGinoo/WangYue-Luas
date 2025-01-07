Behavior2030210 = BaseClass("Behavior2030210",EntityBehaviorBase)
--炸药桶
function Behavior2030210.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030210:Init()
	self.me = self.instanceId
	self.magicState = 0
end


function Behavior2030210:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000020)
		BehaviorFunctions.DoMagic(1,self.me,900000022)
		self.magicState = 1
	end
end

function Behavior2030210:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.me then
		BehaviorFunctions.DoMagic(1,self.me,900000010)
		BehaviorFunctions.CreateEntity(203021001,self.me) --特效
		local pos = BehaviorFunctions.GetPositionP(self.me)
		BehaviorFunctions.CreateEntity(2030210001,self.me,pos.x,pos.y,pos.z)	--子弹
	end
end