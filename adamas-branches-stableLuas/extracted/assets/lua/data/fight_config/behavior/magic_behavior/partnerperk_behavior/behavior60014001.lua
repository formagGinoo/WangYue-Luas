Behavior60014001 = BaseClass("Behavior60014001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60014001.GetGenerates()
end

function Behavior60014001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60014001:Init()
	self.Me = self.instanceId
	self.UltState = 0
	self.RollAdd = 0
end

--释放技能
function Behavior60014001:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and (SkillConfigSign == 50 or SkillConfigSign == 51) then
		self.UltState = 1
	end
end

--技能打断
function Behavior60014001:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and (SkillConfigSign == 50 or SkillConfigSign == 51) and self.UltState == 1 then
		self.UltState = 0
	end
end

--技能完成
function Behavior60014001:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and (SkillConfigSign == 50 or SkillConfigSign == 51) and self.UltState == 1 then
		self.UltState = 0
	end
end


--计算伤害后
function Behavior60014001:AfterDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	if self.UltState == 1 and attackInstanceId == self.Me then
		local R = BF.Random(1,10000)
		
		if R <= self.customParam[1] + self.RollAdd then
			BF.AddSkillPoint(self.Me,1201,self.customParam[2])
			self.RollAdd = 0
		elseif  R >= self.customParam[1] + self.RollAdd then
			self.RollAdd = self.RollAdd + self.customParam[3]
		end
		self.UltState = 0
	end
			
end