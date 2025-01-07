Behavior6000040 = BaseClass("Behavior6000040",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000040.GetGenerates()

end
function Behavior6000040.GetMagics()

end

function Behavior6000040:Init()
	self.me = self.instanceId		--记录自己

end

function Behavior6000040:Update()

end

--伤害暴击判断
function Behavior6000040:BeforeDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	if attackInstanceId == self.me and isCirt == true then
		BF.AddBuff(self.me,hitInstanceId,6000041,1)
	end
end
		
