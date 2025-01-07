Behavior40030004 = BaseClass("Behavior40030004",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40030004.GetGenerates()
end

function Behavior40030004.GetMagics()
	local generates = {}
	return generates
end

function Behavior40030004:Init()
	
end


--获取计算公式参数前
function Behavior40030004:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--获取5%伤害减免
	local i = BF.CheckEntityInFormation(hitInstanceId)
	local l = BehaviorFunctions.HasBuffKind(hitInstanceId,40030004)
	if BF.CheckEntityInFormation(hitInstanceId) and BehaviorFunctions.HasBuffKind(hitInstanceId,40030004) then
			BF.ChangeDamageParam(FE.DamageParam.DmgDefercent,500)
	end
end