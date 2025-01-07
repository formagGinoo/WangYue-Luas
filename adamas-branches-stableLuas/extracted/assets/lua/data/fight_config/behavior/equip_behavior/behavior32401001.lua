Behavior32401001 = BaseClass("Behavior32401001",EntityBehaviorBase)

--任意攻击命中后，攻击力提升a%，持续8秒，最多叠加5层。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior32401001.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior32401001.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior32401001:Init()
	self.Me = self.instanceId
	
end
function Behavior32401001:Update()
	
end

--任意攻击命中后，攻击力提升a%，持续8秒，最多叠加5层。
function Behavior32401001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,camp)
	if attackInstanceId == self.Me then
		BF.AddBuff(self.Me,self.Me,32401002,self._level,FightEnum.MagicConfigFormType.Equip,false)
	end
end