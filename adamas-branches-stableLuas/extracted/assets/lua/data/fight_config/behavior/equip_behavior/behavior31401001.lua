Behavior31401001 = BaseClass("Behavior31401001",EntityBehaviorBase)

--消耗日相释放e技能后，有a%的概率返还b%本次消耗的日相数量，此效果每c秒才能生效一次。
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType


function Behavior31401001.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior31401001.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior31401001:Init()
	self.Me = self.instanceId
end
function Behavior31401001:Update()
	if not self.mission then
		self.CdFrame = self.customParam[3] * 30
		self.mission = true
	end
end

--消耗日相释放e技能后，有a%的概率返还b%本次消耗的日相数量，此效果每c秒才能生效一次。
function Behavior31401001:SkillPointChangeAfter(instanceId, type, oldValue, curValue, changedValue)
	if instanceId == self.Me and type == FE.RoleSkillPoint.Normal and oldValue > curValue and BF.Probability(self.customParam[1]) 
		and self.CdFrame < BF.GetFightFrame() then
		BF.AddSkillPoint(self.Me,1201,math.abs(changedValue) * self.customParam[2]/10000)
		self.CdFrame = self.CdFrame + BF.GetFightFrame()
	end
end