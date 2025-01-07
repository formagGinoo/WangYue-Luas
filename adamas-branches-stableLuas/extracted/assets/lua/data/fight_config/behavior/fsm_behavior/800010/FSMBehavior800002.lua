FSMBehavior800002 = BaseClass("FSMBehavior800002",FSMBehaviorBase)
--NPC通用AI：受威胁状态

--初始化
function FSMBehavior800002:Init()
	self.me = self.instanceId
	self.inHit = false
	self.inThreatenedAct = false
	self.squatHit = false
	self.pushSkillId = 80001001
	self.afraidSkillId = 80001002
	self.afraidOutSkillId = 80001006
	self.squatInSkillId = 80001003
	self.squatOutSkillId = 80001004
	self.hitSkillId = 80001051
	self.isCoward = false --是否胆小（胆小害怕，否则反击）
	self.threatenedActMode = 0
	self.ThreatenedActModeEnum = {
		Afraid = 1, --害怕
		Push = 2, --推搡
		Squat =3, --下蹲		
		}
	self.inAfraid = false --害怕过程
	self.afraidStartFrame = 0 --害怕计时
	self.outAfraidTime = 5 --害怕持续时间
	self.waitStartFrame = nil --下蹲计时
	self.squatStartFrame = nil
	self.canSquat = false	--准备蹲
	self.canEscape = false  --准备跑
	self.ActToSquatTime = 2 --表演后下蹲计时
	self.SquatToRunTime = 5 --下蹲后逃跑计时
end


--初始化结束
function FSMBehavior800002:LateInit()
	if self.sInstanceId  then
		self.npcId = self.sInstanceId
		self.isCoward = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"is_coward")
	end

end

--帧事件
function FSMBehavior800002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--通过瞄准进，还是通过受击进入
	if (self.ParentBehavior.onHit or self.ParentBehavior.aimLock) and BehaviorFunctions.CanCtrl(self.me) and  self.inHit == false then
		
		--受击进：播放受击表演技能
		if self.ParentBehavior.onHit then
			self.ParentBehavior.onHit = false
			self.inHit = true
			BehaviorFunctions.CastSkillByTarget(self.me,self.hitSkillId,self.role)
		elseif self.ParentBehavior.aimLock then
			self.ParentBehavior.aimLock = false
		end	
		--设置害怕或反击mode
		if self.isCoward == true then
			self.threatenedActMode = self.ThreatenedActModeEnum.Afraid
		else
			self.threatenedActMode = self.ThreatenedActModeEnum.Push
		end
	end
	
	--威胁mode
	if not self.inHit then
		--懦夫mode
		if self.threatenedActMode == self.ThreatenedActModeEnum.Afraid and not self.inThreatenedAct then
			--害怕
			BehaviorFunctions.CastSkillByTarget(self.me,self.afraidSkillId,self.role)
			self.waitStartFrame = self.frame
			self.inAfraid = true
			self.afraidStartFrame = self.frame
			self.inThreatenedAct = true
			
		--硬汉mode
		elseif self.threatenedActMode == self.ThreatenedActModeEnum.Push and not self.inThreatenedAct  then
			--推搡
			BehaviorFunctions.CastSkillByTarget(self.me,self.pushSkillId,self.role)
			self.inThreatenedAct = true
		end
	end
	
	--开始计时，再次受击抱头下蹲，否则回到正常状态
	if self.waitStartFrame and self.threatenedActMode ~= self.ThreatenedActModeEnum.Squat 
		and not self.inAfraid then
		--超时退出收威胁状态
		if self.frame - self.waitStartFrame > self.ActToSquatTime*30 then
			BehaviorFunctions.CustomFSMTryChangeState(self.me)
			return
		else
			if self.canSquat == true then
				BehaviorFunctions.CastSkillByTarget(self.me,self.squatInSkillId,self.role)
				self.threatenedActMode = self.ThreatenedActModeEnum.Squat
				self.squatStartFrame = self.frame
			end
		end
	end
	
	--害怕计时
	if self.inAfraid and self.frame - self.afraidStartFrame > 30*self.outAfraidTime
		and BehaviorFunctions.GetSkill(self.me) == self.afraidSkillId then
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillByTarget(self.me,self.afraidOutSkillId,self.role)
		self.inAfraid = false
	end
	--害怕中持续被瞄准，刷新害怕时间
	if self.ParentBehavior.aimCheck and BehaviorFunctions.GetSkill(self.me) == self.afraidSkillId then
		if BehaviorFunctions.GetAimTargetInstanceId(self.role) == self.me
			and BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <5
			and BehaviorFunctions.CompEntityLessAngle(self.me,self.role,45) then
			self.afraidStartFrame = self.frame
			self.waitStartFrame = self.frame
		end
	end
	
	--下蹲流程：再次受击或超过时间就开始逃跑
	if self.threatenedActMode == self.ThreatenedActModeEnum.Squat and self.frame - self.squatStartFrame >self.SquatToRunTime*30 then
		--超过时间站起来开始跑
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillByTarget(self.me,self.squatOutSkillId,self.role)
		self.canEscape = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	elseif self.threatenedActMode == self.ThreatenedActModeEnum.Squat and self.squatHit == true then
		BehaviorFunctions.BreakSkill(self.me)
		self.canEscape = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

--受击
function FSMBehavior800002:OnAttackNpc(attackInstanceId,hitInstanceId,instanceId,attackType,skillType)
	--在角色附近受击
	if hitInstanceId == self.me	and attackInstanceId == BehaviorFunctions.GetCtrlEntity() and BehaviorFunctions.GetDistanceFromTarget(hitInstanceId,attackInstanceId) <= 3 then
		if self.waitStartFrame and self.threatenedActMode ~= self.ThreatenedActModeEnum.Squat and not self.inAfraid then
			self.canSquat = true
		elseif  self.threatenedActMode == self.ThreatenedActModeEnum.Squat then
			self.squatHit = true
		elseif self.inAfraid then
			BehaviorFunctions.BreakSkill(self.me)
			self.inAfraid =false
			self.canSquat = true
		end
	end
end

--赋值
function FSMBehavior800002:Assignment(variable,value)
	self[variable] = value
end

--赋值
function FSMBehavior800002:MainBehaviorAssignment(variable,value)
	self.ParentBehavior[variable] = value
end


function FSMBehavior800002:__delete()
	Log("tstststs")
end

--技能结束
function FSMBehavior800002:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me and skillId == self.hitSkillId then
		self.inHit = false
	elseif instanceId == self.me and skillId == self.pushSkillId then
		self.waitStartFrame = self.frame
	end
end