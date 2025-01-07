Behavior40011002 = BaseClass("Behavior40011002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40011002.GetGenerates()
end

function Behavior40011002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40011002:Init()
	self.me = self.instanceId
end

--获取计算公式参数前
function Behavior40011002:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--炮台提升10%的伤害,检测当前攻击者是否是炮台
	if BehaviorFunctions.GetEntityTemplateId(ownerInstanceId) == 2030508 or BehaviorFunctions.GetEntityTemplateId(ownerInstanceId) == 203050800 then
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
	end
end