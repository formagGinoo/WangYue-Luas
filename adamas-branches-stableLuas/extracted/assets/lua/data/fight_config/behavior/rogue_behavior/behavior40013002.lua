Behavior40013002 = BaseClass("Behavior40013002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40013002.GetGenerates()
end

function Behavior40013002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40013002:Init()
	self.me = self.instanceId
	self.attrChange = false
end

function Behavior40013002:Update()
	--如果检测到玩家耗电属性不是-1000，就会设置成-1000（耗电速度降低10%）
	if BehaviorFunctions.GetPlayerAttrVal(656) ~= self.customParam[1] then
		BehaviorFunctions.ChangePlayerAttr(656,self.customParam[1])
		self.attrChange = true
	end
end