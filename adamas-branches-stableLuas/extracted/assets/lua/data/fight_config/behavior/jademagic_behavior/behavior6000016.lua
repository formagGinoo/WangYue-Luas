Behavior6000016 = BaseClass("Behavior6000016",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000016.GetGenerates()
end

function Behavior6000016.GetMagics()
end

function Behavior6000016:Init()
	self.me = self.instanceId --记录自己
end

function Behavior6000016:Update()
	
	if not BF.CheckEntityForeground(self.me) and BF.HasBuffKind(self.me,6000017) then
		BF.RemoveBuff(self.me,6000017)
	end
end

--角色从后台登场，获得buff
function Behavior6000016:ChangeForeground(instanceId)
	if instanceId == self.me then
		BF.AddBuff(self.me,self.me,6000017,1) --元素伤害减免buff
	end
end