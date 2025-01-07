Behavior60011001 = BaseClass("Behavior60011001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior60011001.GetGenerates()
end

function Behavior60011001.GetMagics()
	local generates = {}
	return generates
end

function Behavior60011001:Init()
	self.Me = self.instanceId
	self.count = 0
end


--伤害后
function Behavior60011001:AfterDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt,camp)
	--如果技能类型是大招
	if attackInstanceId == self.Me and self.count <= 0 then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			self.RoleList = BehaviorFunctions.GetCurFormationEntities()	--获取全队id
			for i,v in pairs(self.RoleList) do
				if not BF.CheckEntityForeground(self.RoleList[i]) then
					BF.DoMagic(self.Me,self.RoleList[i],60011002,self._level)	--除了自己以外全队加攻击
				end
			end
			self.count = self.count + 1
		end
	end
end

function Behavior60011001:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and skillType == FE.SkillType.Unique then
		self.count = 0
	end
end

function Behavior60011001:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.Me and skillType == FE.SkillType.Unique then
		self.count = 0
	end
end