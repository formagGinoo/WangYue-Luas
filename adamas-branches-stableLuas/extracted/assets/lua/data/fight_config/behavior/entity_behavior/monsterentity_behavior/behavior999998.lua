Behavior999998 = BaseClass("Behavior999998",EntityBehaviorBase)
--资源预加载
function Behavior999998.GetGenerates()
	local generates = {}
	return generates
end




function Behavior999998:Init()

	self.myState = 0
	self.me = self.instanceId
	self.timeStart = 0
	self.frame = 0
	self.RanderFrame = 0
	self.cd = 0
	self.FightState = 0


	--状态入口管理
	self.SkillState = 0
	self.WanderLRState = 0
	self.WanderFState = 0
	self.WanderBState = 0
	self.WalkState = 0
	self.RanderTime = 2
	self.RanderBTime = 2
	self.RanderBFrame = 2
	self.RanderSwitchTime = 1
	self.RanderSwitchState = 0
	self.RanderTFrame = 0	
	
end



function Behavior999998:Update()
	--BehaviorFunctions.DoMagic(self.me,self.me,900000007)

	if self.myState ~= FightEnum.EntityState.FightIdle then
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
	end



end


function Behavior999998:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
	end
end