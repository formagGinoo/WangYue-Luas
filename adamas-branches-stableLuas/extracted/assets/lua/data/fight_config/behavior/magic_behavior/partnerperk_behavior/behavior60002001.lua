Behavior60002001 = BaseClass("Behavior60002001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60002001.GetGenerates()
end

function Behavior60002001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60002001:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior60002001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--元素技能（E技能）的伤害
	if BF.CheckEntityInFormation(ownerInstanceId) then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Skill) then
			if atkElementType ~= 1 and atkElementType ~= 0 then
				BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
			end
		end
	end
end