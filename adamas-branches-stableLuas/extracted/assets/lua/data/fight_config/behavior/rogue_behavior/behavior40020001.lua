Behavior40020001 = BaseClass("Behavior40020001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40020001.GetGenerates()
end

function Behavior40020001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40020001:Init()
	self.Me = self.instanceId
end

function Behavior40020001:Update()
	self.partnerList = BF.GetPartnerInfoList()
	
end

function Behavior40020001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	local bullet = BF.GetEntityTemplateId(instanceId)
	if bullet == 62001004001 or bullet == 62001009001 then
		if BehaviorFunctions.Probability(self.customParam[1]) then
			BF.DoMagic(self.Me,hitInstanceId,40019004)
		end
	end
end