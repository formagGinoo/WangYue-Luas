Behavior6002200011 = SimpleBaseClass("Behavior6002200011",EntityBehaviorBase)
--佩戴毛毛枭佩从的角色，每次释放E技能，都会减少月灵主动技a秒CD

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior6002200011.GetGenerates()
end

function Behavior6002200011.GetMagics()
	local generates = {}
	return generates
end

function Behavior6002200011:Init()
	self.me = self.instanceId	--定义自己
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取前台角色
	self.canEPerk == true
end

function Behavior600220:Update()
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取前台角色
end

--Lua回调，首次命中时触发
function Behavior6002200011:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,skillType, atkElement)

	--E技能命中时叠1层buff，每次E只能触发1次
	if BehaviorFunctions.HasEntitySign(self.me,60022001) then
		if attackInstanceId == self.ctrlRole and skillType == FightEnum.SkillType.Skill and self.canEPerk == true then
			BehaviorFunctions.ChangeBtnSkillCDTime(self.ctrlRole,FightEnum.KeyEvent.Partner,-2)
			self.canEPerk = false
		end
	end
end

--Lua回调，技能结束触发
function Behavior600220:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	self:SuperFunc("__FinishSkill", true, instanceId,skillId,SkillConfigSign,skillType)
	--E技能结束时，允许perk再次叠层
	if instanceId == self.ctrlRole and skillType == FightEnum.SkillType.Skill then
		self.canEPerk = true
	end
end

--Lua回调，技能打断触发
function Behavior600220:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	self:SuperFunc("__BreakSkill", true, instanceId,skillId,SkillConfigSign,skillType)
	--E技能被打断时，允许perk再次叠层
	if instanceId == self.ctrlRole and skillType == FightEnum.SkillType.Skill then
		self.canEPerk = true
	end
end