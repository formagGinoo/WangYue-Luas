Behavior100701 = BaseClass("Behavior100701",EntityBehaviorBase)
--资源预加载
local BF = BehaviorFunctions
local FES = FightEnum.EntityState

function Behavior100701.GetGenerates()
	local generates = {}
	return generates
end


function Behavior100701:Init()
	self.skillState = 0
	self.me = self.instanceId
end

function Behavior100701:LateInit()
	
end



function Behavior100701:Update()
	self:skill()
end

--出生释放技能
function Behavior100701:skill()

	if self.skillState == 0 then
		BF.CastSkillBySelfPosition(self.me,100701011)
		self.skillState = 1
	end
	
end

--完成技能后销毁自身
function Behavior100701:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == 100701011 then
			BehaviorFunctions.RemoveEntity(self.me)
		end
	end
end


