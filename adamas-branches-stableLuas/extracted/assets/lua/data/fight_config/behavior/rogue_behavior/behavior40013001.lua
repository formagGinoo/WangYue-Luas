Behavior40013001 = BaseClass("Behavior40013001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40013001.GetGenerates()
end

function Behavior40013001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40013001:Init()
	self.me = self.instanceId
	self.attrChange = false
end

function Behavior40013001:Update()
	--如果检测到玩家耗电属性不是-500，就会设置成-500（耗电速度降低5%）
	if BehaviorFunctions.GetPlayerAttrVal(656) ~= self.customParam[1] then
		BehaviorFunctions.ChangePlayerAttr(656,1-self.customParam[1])
		self.attrChange = true
	end
end