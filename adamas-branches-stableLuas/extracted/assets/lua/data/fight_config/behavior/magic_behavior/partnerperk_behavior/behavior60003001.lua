Behavior60003001 = BaseClass("Behavior60003001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60003001.GetGenerates()
end

function Behavior60003001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60003001:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior60003001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--普通攻击时无视目标a%的防御。
	if BF.HasBuffKind(ownerInstanceId,60003001) then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then		
				BF.ChangeDamageParam(FE.DamageParam.IgnoreDef,self.customParam[1])
		end
	end
end