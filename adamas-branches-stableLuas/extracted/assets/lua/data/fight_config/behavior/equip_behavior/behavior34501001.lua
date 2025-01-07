Behavior34501001 = BaseClass("Behavior34501001",EntityBehaviorBase)

--大招命中敌人时，获得a%装备者自身五行类型的五行伤害加成，持续4秒，最多叠加8层。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior34501001.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior34501001.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior34501001:Init()
	self.Me = self.instanceId
	
end

function Behavior34501001:Update()
	
end

--大招命中敌人时，获得a%装备者自身五行类型的五行伤害加成，持续4秒，最多叠加8层。
function Behavior34501001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType,atkElement,attackRoot)
	if (attackInstanceId == self.Me or attackRoot == self.Me) and BF.AnalyseSkillType(skillType,FE.SkillType.Unique)then
		if atkElement == FE.ElementType.Gold then
			BF.AddBuff(self.Me,self.Me,34501002,self._level,4,false)
		elseif atkElement == FE.ElementType.Wood then
			BF.AddBuff(self.Me,self.Me,34501003,self._level,4,false)
		elseif atkElement == FE.ElementType.Water then
			BF.AddBuff(self.Me,self.Me,34501004,self._level,4,false)
		elseif atkElement == FE.ElementType.Fire then
			BF.AddBuff(self.Me,self.Me,34501005,self._level,4,false)
		elseif atkElement == FE.ElementType.Earth then
			BF.AddBuff(self.Me,self.Me,34501006,self._level,4,false)
		end
	end
end