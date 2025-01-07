Behavior100705 = BaseClass("Behavior100705",EntityBehaviorBase)
--资源预加载
local BF = BehaviorFunctions
local FES = FightEnum.EntityState

function Behavior100705.GetGenerates()
	local generates = {}
	return generates
end


function Behavior100705:Init()
	self.skillState = 0
	self.me = self.instanceId
	self.player = BehaviorFunctions.GetCtrlEntity()
end

function Behavior100705:LateInit()
	
end



function Behavior100705:Update()
	self:skillTest()
end


function Behavior100705:skillTest()

	if self.skillState == 0 then
			local t1 = BF.GetEntityValue(self.player,"AttackTarget")
			local t2 = BF.GetEntityValue(self.player,"LockTarget")
			if t1 ~= 0 then
				BF.CastSkillByTarget(self.me,100705011,t1)
			elseif t2 ~= 0 then
				BF.CastSkillByTarget(self.me,100705011,t2)
			else
				BF.CastSkillByPositionP(self.me,100705011,BehaviorFunctions.GetPositionOffsetBySelf(self.me,50,0))
			end
			self.skillState = 1
	end
	
end

function Behavior100705:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == 100705011 then
			BehaviorFunctions.RemoveEntity(self.me)
		end
	end
end

function Behavior100705:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType,camp)
	if attackInstanceId == self.me then
		BehaviorFunctions.AddBuff(self.me,self.me,10070501)
	end
end