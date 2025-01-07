Behavior40019003 = BaseClass("Behavior40019003",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40019003.GetGenerates()
end

function Behavior40019003.GetMagics()
	local generates = {}
	return generates
end

function Behavior40019003:Init()
	self.Me = self.instanceId
end

function Behavior40019003:Update()
	self.partner = BF.GetPartnerInstanceId(self.Me)
	self.assingTarget = BF.GetEntityValue(self.partner,"assingTarget")
	--如果不在暗杀中，且缓存了暗杀目标
	if not BF.HasEntitySign(self.assingTarget,62001001) then
		if self.assingTarget and self.assingTarget ~= 0 and BF.CheckEntity(self.assingTarget) then
			--if BF.GetHitType(self.assingTarget) ~= FightEnum.EntityHitState.StandUp and BF.GetHitType(self.assingTarget) ~= FightEnum.EntityHitState.Lie then
				BF.DoMagic(self.Me,self.assingTarget,40019006)
				--self.assingTarget = 0
				BF.SetEntityValue(self.partner,"assingTarget",0)
			--end
		end
	end
	
	--如果刚结束刺杀，则给怪物上眩晕buff
	--if self.curTarget and self.curTarget ~= 0 and BF.CheckEntity(self.curTarget) then
		--if not BF.HasEntitySign(self.curTarget,62001001) and not BF.CheckEntityState(self.curTarget,FightEnum.EntityState.Hit) or BF.GetHitType(self.curTarget) == FightEnum.EntityHitState.StandUp then
			--BF.DoMagic(self.Me,self.curTarget,40019004)
			--self.curTarget = 0
		--end
	--end
end

--function Behavior40019003:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)
	--local bullet = BF.GetEntityTemplateId(instanceId)
	--if bullet == 62001004001 or bullet == 62001009001 then
		--if BehaviorFunctions.Probability(self.customParam[1]) then
			--self.curTarget = hitInstanceId
		--else
			--self.curTarget = 0
		--end
	--end
--end