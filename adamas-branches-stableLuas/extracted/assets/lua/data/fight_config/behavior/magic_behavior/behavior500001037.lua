Behavior500001037 = BaseClass("Behavior500001037",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType


function Behavior500001037.GetGenerates()


end

function Behavior500001037.GetMagics()
	local generates = {}
	return generates
end

function Behavior500001037:Init()
	self.me = self.instanceId
	self.role = nil
end


function Behavior500001037:LateInit()

end




function Behavior500001037:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
end



function Behavior500001037:AfterDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	--普攻造成额外的金属性伤害
	if BF.CheckEntityInFormation(attackInstanceId) and self.role == attackInstanceId then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then
			BehaviorFunctions.DoMagic(attackInstanceId,hitInstanceId,500001038,nil,nil,nil,attackInstanceId)
		end
	end
end
