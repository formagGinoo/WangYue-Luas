Behavior2002 = BaseClass("Behavior2002", EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum

function Behavior2002.GetGenerates()
    local generates = {}
    return generates
end

function Behavior2002.GetMagics()
	local generates = {}
	return generates
end

function Behavior2002:Init()
    self.monsterGroupAI = BF.CreateBehavior("MonsterGroupAI", self)
end

function Behavior2002:BeforeUpdate()
    self.monsterGroupAI:BeforeUpdate()
end

function Behavior2002:Update()
    self.monsterGroupAI:Update()
end