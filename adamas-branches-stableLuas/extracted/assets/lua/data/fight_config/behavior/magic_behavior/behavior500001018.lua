Behavior500001018 = BaseClass("Behavior500001018",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType


function Behavior500001018.GetGenerates()


end

function Behavior500001018.GetMagics()
	local generates = {}
	return generates
end

function Behavior500001018:Init()
	self.me = self.instanceId
	
	self.max = 0
	self.now = 0
	self.per = 0
end


function Behavior500001018:LateInit()

	--获得体力上限
	self.max = BehaviorFunctions.GetPlayerAttrVal(642)
	self.now = BehaviorFunctions.GetPlayerAttrVal(1642)

	self.per = self.max * self.customParam[1]/10000
	--体力增加
	BehaviorFunctions.ChangePlayerAttr(1642,self.per)
	
	--print("最大体力",self.max)
	--print("当前体力",self.now)
	--print("增加体力",self.per)

end




function Behavior500001018:Update()
	
end