FSMBehavior8000 = BaseClass("FSMBehavior8000",FSMBehaviorBase)
--NPC通用AI：状态机总控

--初始化
function FSMBehavior8000:Init()
	self.me = self.instanceId
	self.inHit = false
end


--初始化结束
function FSMBehavior8000:LateInit()

end

--帧事件
function FSMBehavior8000:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.magicState then
		BehaviorFunctions.DoMagic(1,self.me,900000001) --免疫受击
		BehaviorFunctions.DoMagic(1,self.me,900000013)--免疫锁定
		BehaviorFunctions.DoMagic(1,self.me,900000020)--免疫受击朝向
		BehaviorFunctions.DoMagic(1,self.me,900000022)--免疫伤害
		BehaviorFunctions.DoMagic(1,self.me,900000023)--免疫伤害
		self.magicState = true
	end

end

--受击
function FSMBehavior8000:FirstCollide(attackInstanceId,hitInstanceId,instanceId)
	--在角色附近受击
	if hitInstanceId == self.me	and BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= 3 then
		self.inHit = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

--移动碰撞
function FSMBehavior8000:OnEntityCollision(instanceId,collisionInstanceId)
	--互相碰撞
	if (instanceId == self.me  and collisionInstanceId == self.role) or (instanceId == self.role  and collisionInstanceId == self.me) then
		--BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end