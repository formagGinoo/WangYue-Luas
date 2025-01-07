Behavior40010002 = BaseClass("Behavior40010002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40010002.GetGenerates()
end

function Behavior40010002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40010002:Init()
	self.me = self.instanceId
end

function Behavior40010002:Die(attackInstanceId,dieInstanceId)
	if BehaviorFunctions.IsBuildEntity(attackInstanceId) then
		--获得电量上限
		self.powerMax = BehaviorFunctions.GetPlayerAttrVal(1650)
		--获得10%电量的值
		self.powerPer = self.powerMax * self.customParam[1]/10000
		--当前电量增加5%
		BehaviorFunctions.ChangePlayerAttr(1650,self.powerPer)
	end
end