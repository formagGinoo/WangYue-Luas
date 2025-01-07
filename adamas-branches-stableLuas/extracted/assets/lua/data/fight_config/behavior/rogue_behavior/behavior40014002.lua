Behavior40014002 = BaseClass("Behavior40014002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40014002.GetGenerates()
end

function Behavior40014002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40014002:Init()
	self.me = self.instanceId
	self.buildLimit = BehaviorFunctions.GetPlayerAttrVal(657)
end

function Behavior40014002:Update()
	--检测玩家的额外拼装上限是否到10
	if self.attrChange == false then
		if BehaviorFunctions.GetPlayerAttrVal(657) ~= self.buildLimit + self.customParam[1] then
			BehaviorFunctions.ChangePlayerAttr(657,self.customParam[1])
			self.attrChange = true
		end
	end
end