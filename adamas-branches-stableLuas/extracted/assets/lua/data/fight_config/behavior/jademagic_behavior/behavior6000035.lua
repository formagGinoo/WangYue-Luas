Behavior6000035 = BaseClass("Behavior6000035",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000035.GetGenerates()

end
function Behavior6000035.GetMagics()

end

function Behavior6000035:Init()
	self.me = self.instanceId		--记录自己
end

function Behavior6000035:Update()
	
end

--BehaviorFunctions.ChangeDamageParam(FightEnum.DamageParam.TempCrit, 0.2)
--BehaviorFunctions.GetDamageParam(type)
--BeforeCalculateDamage
--元素攻击判断
function Behavior6000035:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, 
	damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.me and atkElementType ~= 1 then
		BehaviorFunctions.ChangeDamageParam(FightEnum.DamageParam.TempCrit, 0.2)
	end
end
		
