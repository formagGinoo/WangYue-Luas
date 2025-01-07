Behavior6000011 = BaseClass("Behavior60000011",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000011.GetGenerates()
end

function Behavior6000011.GetMagics()
end

function Behavior6000011:Init()
	self.me = self.instanceId --记录自己
end

function Behavior6000011:Update()
	if not BF.CheckEntityForeground(self.me) and BF.HasBuffKind(self.me,6000012) then
		BF.RemoveBuff(self.me,6000012)
	end
end

--角色从后台登场，获得buff
function Behavior6000011:ChangeForeground(instanceId)
	if instanceId == self.me then
		BF.AddBuff(self.me,self.me,6000012,1) --元素伤害和治疗效果增加
	end
end