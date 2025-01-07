FSMBehavior90009001 = BaseClass("FSMBehavior90009001",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态总控
--打电话和发短信属于特殊逻辑，需要在总控中实现表演
--npc进入巡逻有2种情况：
--1.npc有巡逻路线，但当前不在路线开始点
--2.npc有巡逻路线，且当前正在路线中，没走完
--初始化
function FSMBehavior90009001:Init()
	self.me = self.instanceId
	self.npcId = nil
	self.defaultDialogId = nil
	self.name = "NPC表无配置"
	--气泡对话
	self.bubbleId = nil
	self.inBubbleCd = false
	self.bubbleCd = 30
end


--初始化结束
function FSMBehavior90009001:LateInit()
	--从总控获取参数
	if self.ParentBehavior.npcId then
		self.npcId = self.ParentBehavior.npcId
		--BehaviorFunctions.CheckNpcCanMail(self.npcId)
		self.name = BehaviorFunctions.GetNpcName(self.npcId)
	end
	BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,self.name)
	--隐藏血条
	BehaviorFunctions.SetEntityLifeBarVisibleType(self.me,3)
end

--帧事件
function FSMBehavior90009001:Update()
	self.myFSMState = BehaviorFunctions.GetCustomFSMSubState(self.me)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	--LogError(self.myFSMState)
	--气泡对话
	if self.ParentBehavior.bubbleId and not self.inBubbleCd then
		self:Bubble()
		self.inBubbleCd = true
	end
	if self.ParentBehavior.defaultDialogId then
		self.defaultDialogId = self.ParentBehavior.defaultDialogId
		BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
	end
	--巡逻传递
	self.nextPoint = self.ParentBehavior.nextPoint
	self.curPoint = self.ParentBehavior.curPoint
	self.needPatrol =self.ParentBehavior.needPatrol

	if self.needPatrol and self.ParentBehavior.FSMSubState ~= self.ParentBehavior.DefaultSubStateEnum.Patrol then
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	elseif not self.needPatrol and self.ParentBehavior.FSMSubState == self.ParentBehavior.DefaultSubStateEnum.Patrol then
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end

end

--气泡对话
function FSMBehavior90009001:Bubble()
	--设置气泡对话内容
	BehaviorFunctions.ChangeNpcBubbleId(self.ParentBehavior.npcId,self.ParentBehavior.bubbleId)
	--显示气泡对话
	BehaviorFunctions.SetNpcBubbleVisible(self.ParentBehavior.npcId,true)
	self.bubbleDelayCall = BehaviorFunctions.AddDelayCallByTime(self.bubbleCd,self,self.Assignment,"inBubbleCd",false)
end

--赋值
function FSMBehavior90009001:Assignment(variable,value)
	self[variable] = value
end


--退出当前状态
function FSMBehavior90009001:OnLeaveState()
	BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
	--恢复正常走路
	BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
end

--技能结束
function FSMBehavior90009001:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == self.startCallSkillId then
			self.callState = self.CallStateEnum.Loop
			self.onCall = false
		elseif skillId == self.startTextSkillId then
			self.textState = self.TextStateEnum.Loop
			self.onText = false
		elseif skillId == self.endCallSkillId or skillId == self.endTextSkillId then
			BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",false)
		end
	end
end

--技能打断
function FSMBehavior90009001:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == self.startCallSkillId then
			self.callState = self.CallStateEnum.Loop
			self.onCall = false
		elseif skillId == self.startTextSkillId then
			self.textState = self.TextStateEnum.Loop
			self.onText = false
		elseif skillId == self.endCallSkillId or skillId == self.endTextSkillId then
			BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",false)
		end
	end
end