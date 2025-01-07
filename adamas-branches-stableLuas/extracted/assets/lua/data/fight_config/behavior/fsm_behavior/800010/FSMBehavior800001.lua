FSMBehavior800001 = BaseClass("FSMBehavior800001",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态总控
--打电话和发短信属于特殊逻辑，需要在总控中实现表演
--npc进入巡逻有2种情况：
--1.npc有巡逻路线，但当前不在路线开始点
--2.npc有巡逻路线，且当前正在路线中，没走完
--初始化
function FSMBehavior800001:Init()
	self.me = self.instanceId
	self.npcId = nil
	self.defaultDialogId = nil
	self.name = "NPC表无配置"
	self.callState = 0
	self.CallStateEnum = {
		NotIn = 0,
		In = 1,
		Loop = 2,
		Out = 3,	
		}
	self.textState = 0
	self.TextStateEnum = {
		NotIn = 0,
		In = 1,
		Loop = 2,
		Out = 3,
	}
	self.startCallSkillId = 80001055
	self.endCallSkillId = 80001056
	self.startTextSkillId = 80001057
	self.endTextSkillId = 80001058
	self.noHackLastTime = 100
	self.phoneStartFrame = nil
	self.inHack = false
	--气泡对话
	self.bubbleId = nil
	self.inBubbleCd = false
	self.bubbleCd = 30
end


--初始化结束
function FSMBehavior800001:LateInit()
	--从总控获取参数
	if self.ParentBehavior.npcId then
		self.npcId = self.ParentBehavior.npcId
		--BehaviorFunctions.CheckNpcCanMail(self.npcId)
		self.name = BehaviorFunctions.GetNpcName(self.npcId)
	end
	BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,self.name)
end

--帧事件
function FSMBehavior800001:Update()
	self.myFSMState = BehaviorFunctions.GetCustomFSMSubState(self.me)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	--LogError(self.myFSMState)
	--气泡对话
	if self.ParentBehavior.bubbleId and not self.inBubbleCd then
		self:Bubble()
		self.inBubbleCd = true
	end
	if self.ParentBehavior.defaultDialogId and self.ParentBehavior.defaultDialogId > 0 then
		self.defaultDialogId = self.ParentBehavior.defaultDialogId
		BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
	else
		BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
	end
	
	--打电话发短信传递
	self.onCall = self.ParentBehavior.onCall
	self.onText = self.ParentBehavior.onText
	--打电话表演
	if  self.callState == self.CallStateEnum.NotIn and self.onCall then	
		if BehaviorFunctions.CanCtrl(self.me) then
			self.ParentBehavior.onCall = false
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.ClearPathFinding(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.startCallSkillId)
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",true)
			self.callState = self.CallStateEnum.In
			self.phoneStartFrame = self.myFrame
		end
	end
	if self.callState == self.CallStateEnum.Loop then
		BehaviorFunctions.SetNpcCallState(self.me,true)
		if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
			local aniName = BehaviorFunctions.GetPlayingAnimationName(self.me,0)
			if aniName ~= "PhoneWalk" then
				BehaviorFunctions.StopMove(self.me)
				BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","PhoneWalk")
				BehaviorFunctions.PlayAnimation(self.me,"Walk")
			end
		elseif BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Idle then
			local aniName = BehaviorFunctions.GetPlayingAnimationName(self.me,0)
			if aniName ~= "PhoneStand_loop" then
				BehaviorFunctions.SetAnimationTranslate(self.me,"Stand1","PhoneStand_loop")
				BehaviorFunctions.PlayAnimation(self.me,"Stand1")
			end
		end
		if self.phoneStartFrame then
			if self.myFrame - self.phoneStartFrame >= 30*self.noHackLastTime and not self.inHack then
				self.callState = self.CallStateEnum.Out
			end
		end

	end
	if self.callState == self.CallStateEnum.Out then
		if BehaviorFunctions.CanCtrl(self.me) then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.endCallSkillId)
			BehaviorFunctions.SetNpcCallState(self.me,false)
			self.callState = self.CallStateEnum.NotIn
		end
	end
	
	--发短信表演
	if  self.textState == self.TextStateEnum.NotIn and self.onText then	
		if BehaviorFunctions.CanCtrl(self.me) then
			self.ParentBehavior.onText = false
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.startTextSkillId)
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",true)
			self.textState = self.TextStateEnum.In
			self.phoneStartFrame = self.myFrame
		end
	end
	if self.textState == self.TextStateEnum.Loop then
		BehaviorFunctions.SetNpcMailState(self.me,true)
		if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
			local aniName = BehaviorFunctions.GetPlayingAnimationName(self.me,0)
			if aniName ~= "TextWalk" then
				BehaviorFunctions.StopMove(self.me)
				BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","TextWalk")
				BehaviorFunctions.PlayAnimation(self.me,"Walk")
			end

		elseif BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Idle then
			local aniName = BehaviorFunctions.GetPlayingAnimationName(self.me,0)
			if aniName ~= "TextStand_loop" then
				BehaviorFunctions.SetAnimationTranslate(self.me,"Stand1","TextStand_loop")
				BehaviorFunctions.PlayAnimation(self.me,"Stand1")
			end
		end
		if self.phoneStartFrame then
			if self.myFrame - self.phoneStartFrame >= 30*self.noHackLastTime and not self.inHack then
				self.textState = self.TextStateEnum.Out
			end
		end
	end
	if self.textState == self.TextStateEnum.Out then
		if BehaviorFunctions.CanCtrl(self.me) then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.endTextSkillId)
			BehaviorFunctions.SetNpcMailState(self.me,false)
			self.textState = self.TextStateEnum.NotIn
		end
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
function FSMBehavior800001:Bubble()
	--设置气泡对话内容
	BehaviorFunctions.ChangeNpcBubbleId(self.ParentBehavior.npcId,self.ParentBehavior.bubbleId)
	--显示气泡对话
	BehaviorFunctions.SetNpcBubbleVisible(self.ParentBehavior.npcId,true)
	self.bubbleDelayCall = BehaviorFunctions.AddDelayCallByTime(self.bubbleCd,self,self.Assignment,"inBubbleCd",false)
end

--赋值
function FSMBehavior800001:Assignment(variable,value)
	self[variable] = value
end

--骇入回调
function FSMBehavior800001:NpcHack(npcid,type,state)
	if self.npcId and npcid == self.npcId then
		if type == FightEnum.NpcHackType.Mail then
			if state == FightEnum.NpcHackState.Start then
				self.inHack = true
			elseif state == FightEnum.NpcHackState.Finish then
				self.inHack = false
			elseif state == FightEnum.NpcHackState.UnFinish then
				self.inHack = false
			end
		elseif type == FightEnum.NpcHackType.PhoneCall then
			if state == FightEnum.NpcHackState.Start then
				self.inHack = true
			elseif state == FightEnum.NpcHackState.Finish then
				self.inHack = false
			elseif state == FightEnum.NpcHackState.UnFinish then
				self.inHack = false
			end
		end
	end
end

--退出当前状态
function FSMBehavior800001:OnLeaveState()
	BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
	--恢复正常走路
	BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
	--恢复站姿
	BehaviorFunctions.SetAnimationTranslate(self.me,"Stand1","Stand1")
	--隐藏手机
	if BehaviorFunctions.CheckHasTransform(self.me,"Phone") then
		BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",false)
	end
	BehaviorFunctions.SetNpcCallState(self.me,false)
	BehaviorFunctions.SetNpcMailState(self.me,false)
	--delaycall处理
	if self.bubbleDelayCall then
		BehaviorFunctions.RemoveDelayCall(self.bubbleDelayCall)
		self.bubbleDelayCall = nil
	end
end

--技能结束
function FSMBehavior800001:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == self.startCallSkillId then
			self.callState = self.CallStateEnum.Loop
			self.onCall = false
		elseif skillId == self.startTextSkillId then
			self.textState = self.TextStateEnum.Loop
			self.onText = false
		elseif skillId == self.endCallSkillId or skillId == self.endTextSkillId then
			BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
			BehaviorFunctions.SetAnimationTranslate(self.me,"Stand1","Stand1")
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",false)
		end	
	end
end

--技能打断
function FSMBehavior800001:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		if skillId == self.startCallSkillId then
			self.callState = self.CallStateEnum.Loop
		elseif skillId == self.startTextSkillId then
			self.textState = self.TextStateEnum.Loop
		elseif skillId == self.endCallSkillId or skillId == self.endTextSkillId then
			BehaviorFunctions.SetAnimationTranslate(self.me,"Walk","Walk")
			BehaviorFunctions.SetAnimationTranslate(self.me,"Stand1","Stand1")
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",false)
		end
	end
end