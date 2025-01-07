Behavior40017003 = BaseClass("Behavior40017003",EntityBehaviorBase)
--钻地的移动速度提升a%，敌人发现范围减少a%
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40017003.GetGenerates()
end

function Behavior40017003.GetMagics()
	local generates = {}
	return generates
end

function Behavior40017003:Init()
	self.Me = self.instanceId
end

function Behavior40017003:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

function Behavior40017003:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.partner then
		BF.DoMagic(self.Me,self.Me,40017004)	--加攻击
	end
end
