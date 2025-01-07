FSMBehavior800002 = BaseClass("FSMBehavior800002",FSMBehaviorBase)
--NPC通用AI：受击状态

--初始化
function FSMBehavior800002:Init()
	self.me = self.instanceId
	self.beHitAnimationName = "Afraid"
	self.hitOver = false
end


--初始化结束
function FSMBehavior800002:LateInit()

end

--帧事件
function FSMBehavior800002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.ParentBehavior.inHit then
		if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
		end
		self.beforePos = BehaviorFunctions.GetPositionP(self.me)
		self.beforelookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
		BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
		BehaviorFunctions.PlayAnimation(self.me,self.beHitAnimationName)
		local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,self.beHitAnimationName)
		BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"hitOver",true)
		BehaviorFunctions.AddDelayCallByFrame(animationFrame,BehaviorFunctions,BehaviorFunctions.CustomFSMTryChangeState,self.me)
		--BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"ParentBehavior.inHit",false)
		self.ParentBehavior.inHit = false
	end
end


--赋值
function FSMBehavior800002:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end