Behavior6000021 = BaseClass("Behavior6000021",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000021.GetGenerates()
end

function Behavior6000021.GetMagics()
end

function Behavior6000021:Init()
	self.me = self.instanceId --记录自己
	self.damageUp = 1.15      --增加伤害比率
end

--BehaviorFunctions.AddBuff(2,2,6000001,1)
--BehaviorFunctions.RemoveBuff(2,6000001)

--免疫【中毒】效果在“【中毒】6000030”中实现一部分
function Behavior6000021:Update()
	if BF.HasBuffKind(self.me,1009) then
		BF.RemoveBuffByKind(self.me,1009)
	end
end

--攻击有【施毒】的敌人伤害增加
function Behavior6000021:BeforeCalculateDamage(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	
	--判断受击方是否有【施毒】状态
	if ownerInstanceId == self.me and BF.HasBuffKind(hitInstanceId,6000030) then	
		BehaviorFunctions.ChangeDamageParam(FightEnum.DamageParam.DmgAtkPercent, self.damageUp - 1)
	end
end