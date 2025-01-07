Behavior60019001 = BaseClass("Behavior60019001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60019001.GetGenerates()
end

function Behavior60019001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60019001:Init()
	self.Me = self.instanceId
end


function Behavior60019001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

--治疗后
function Behavior60019001:AfterCure(healer,treatee,magicId,cure)
	if healer == self.Me then
		self.RoleList = BF.GetCurFormationEntities()	--获取全队id
		for i,v in pairs(self.RoleList) do
			BF.DoMagic(self.Me,self.RoleList[i],60019002,self._level)	--全队加攻击
		end
	end
end