Behavior40015001 = BaseClass("Behavior40015001",EntityBehaviorBase)
--在没有被发现的状态下消灭一名敌人时，可以立即移除佩从的主动技能冷却时间。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40015001.GetGenerates()
end

function Behavior40015001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40015001:Init()
	self.Me = self.instanceId
end

function Behavior40015001:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
end

--击杀回调
function Behavior40015001:Kill(attackInstanceId, instanceId)
	if attackInstanceId == self.Me or attackInstanceId == self.partner then
		if not BF.CheckPlayerInFight() then
			BehaviorFunctions.SetBtnSkillCDTime(self.partner,FightEnum.KeyEvent.Partner,0)
		end
	end
end