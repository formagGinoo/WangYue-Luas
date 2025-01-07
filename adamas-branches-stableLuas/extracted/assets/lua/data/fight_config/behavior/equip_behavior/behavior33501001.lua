Behavior33501001 = BaseClass("Behavior33501001",EntityBehaviorBase)

--大招命中敌人时，获得a%装备者自身五行类型的五行伤害加成，持续4秒，最多叠加8层。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior33501001.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior33501001.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior33501001:Init()
	self.Me = self.instanceId
	
end

function Behavior33501001:Update()
	
end

--获取计算公式参数前
function Behavior33501001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	--元素技能（E技能）的伤害
	if ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Skill) then
			local hp = BF.GetEntityAttrVal(self.Me,1)--获取最大生命值
			BF.ChangeDamageParam(FE.DamageParam.Extra, hp * self.customParam[1]/10000)
		end
	end
end