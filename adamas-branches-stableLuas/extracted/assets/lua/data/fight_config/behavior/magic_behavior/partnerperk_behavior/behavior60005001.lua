Behavior60005001 = BaseClass("Behavior60005001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60005001.GetGenerates()
end

function Behavior60005001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60005001:Init()
	self.Me = self.instanceId
end

function Behavior60005001:Update()
	--身边的敌人数量超过a个时，将会提高b%五行属性伤害。
	self.enemyNum = BF.SearchNpcCount(self.Me, 6 , {2,3}, {0,1,2,3}, nil, nil, false)
	if self.enemyNum and self.enemyNum >= self.customParam[1] then
		if BF.GetBuffCount(self.Me,60005002) <= 0 then
			BF.AddBuff(self.Me,self.Me,60005002,self._level)
		end	
	else
		BF.RemoveBuff(self.Me,60005002)
	end
end