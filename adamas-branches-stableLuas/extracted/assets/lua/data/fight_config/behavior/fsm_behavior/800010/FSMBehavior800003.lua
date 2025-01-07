FSMBehavior800003 = BaseClass("FSMBehavior800003",FSMBehaviorBase)
--NPC通用AI：碰撞状态
--进碰撞状态：onCollide = true
--退出碰撞状态：手动调

--初始化
function FSMBehavior800003:Init()
	self.me = self.instanceId
	self.inCollide = false
	self.frontCollideSkillId = 80001052
	self.backCollideSkillId = 80001053
	self.dodgeSkillId = 80001054
end


--初始化结束
function FSMBehavior800003:LateInit()
	
end

--帧事件
function FSMBehavior800003:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--碰撞来自正面
	if not self.inCollide and BehaviorFunctions.CanCtrl(self.me) then
		BehaviorFunctions.DoMagic(1,self.me,900000027)
		if self.ParentBehavior.collideAct == self.ParentBehavior.CollideActEnum.Collide then
			if BehaviorFunctions.CompEntityLessAngle(self.me,self.role,90) then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
				BehaviorFunctions.CastSkillByTarget(self.me,self.frontCollideSkillId,self.role)				
				--碰撞来自背面
			else
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
				local pos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,180)
				BehaviorFunctions.DoLookAtPositionImmediately(self.me,pos.x,pos.y,pos.z)
				BehaviorFunctions.CastSkillByTarget(self.me,self.backCollideSkillId,self.role)
			end
		elseif self.ParentBehavior.collideAct == self.ParentBehavior.CollideActEnum.Dodge then
			BehaviorFunctions.CastSkillByTarget(self.me,self.dodgeSkillId,self.role)				
		end
	
		self.inCollide = true
	end
end

--赋值
function FSMBehavior800003:Assignment(variable,value)
	self[variable] = value
end

--赋值
function FSMBehavior800003:MainBehaviorAssignment(variable,value)
	self.ParentBehavior[variable] = value
end

--技能结束
function FSMBehavior800003:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me 
		and skillId == self.frontCollideSkillId or skillId == self.backCollideSkillId or skillId == self.dodgeSkillId then
		self.inCollide = false
		--回默认状态
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

function FSMBehavior800003:OnLeaveState()
	if BehaviorFunctions.HasBuffKind(self.me,900000027) then
		BehaviorFunctions.RemoveBuff(self.me,900000027)
	end
end