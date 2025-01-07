Behavior35501001 = BaseClass("Behavior35501001",EntityBehaviorBase)

--核心被动造成的伤害提高a%。每造成1次伤害便会提高装备者a%暴击率，持续4秒，最多获得b%暴击率提升。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior35501001.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior35501001.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior35501001:Init()
	self.Me = self.instanceId
	
end
function Behavior35501001:Update()
	
end

--获取计算公式参数前
function Behavior35501001:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	--核心被动造成的伤害提高a%。
	if ownerInstanceId == self.Me and BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Core) then
		--BF.ChangeChangeParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		
		BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,self.customParam[1])
		
	end
end

--攻击每命中一次目标时，便会提高装备者b%暴击率，持续T秒，最多获得c%暴击率提升。
function Behavior35501001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType,atkElement)
	if attackInstanceId == self.Me then
		BF.AddBuff(self.Me,self.Me,35501002,self._level,FE.MagicConfigFormType.Equip,false)
	end
end