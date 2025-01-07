Behavior60018001 = BaseClass("Behavior60018001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60018001.GetGenerates()
end

function Behavior60018001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60018001:Init()
	self.Me = self.instanceId
end


function Behavior60018001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

--获取治疗公式前
function Behavior60018001:BeforeCalculateCure(healer,treatee,magicId)
	if healer == self.Me or healer == self.partner then
		BF.ChangeCureParam(FE.CureParam.CurePercent, self.customParam[1])
	end
end