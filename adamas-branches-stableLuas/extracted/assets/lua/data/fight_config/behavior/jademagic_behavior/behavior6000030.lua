Behavior6000030 = BaseClass("Behavior6000030",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000030.GetGenerates()

end
function Behavior6000030.GetMagics()

end

function Behavior6000030:Init()
	self.me = self.instanceId		--记录自己
end

function Behavior6000030:Update()
	
end

--伤害添加中毒判断
function Behavior6000030:AfterDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,
		attackType,partType,damageInfo,attackInstanceId,isCirt)
	if attackInstanceId == self.me and not BF.HasBuffKind(hitInstanceId,6000021) and damageType ~= 99 then
		BF.AddBuff(self.me,hitInstanceId,6000031,1)
	end
end