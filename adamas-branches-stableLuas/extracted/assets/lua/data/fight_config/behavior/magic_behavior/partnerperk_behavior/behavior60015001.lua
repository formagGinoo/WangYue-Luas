Behavior60015001 = BaseClass("Behavior60015001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60015001.GetGenerates()
end

function Behavior60015001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60015001:Init()
	self.Me = self.instanceId
end

--获取计算公式参数前
function Behavior60015001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--大招被动伤害+a%。
	if BF.CheckEntityInFormation(ownerInstanceId) then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		end
	end
end