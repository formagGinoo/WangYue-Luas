FSMBehavior90009002 = BaseClass("FSMBehavior90009002",FSMBehaviorBase)
--NPC通用AI：受威胁状态

--初始化
function FSMBehavior90009002:Init()
	self.me = self.instanceId
	self.inHit = false
	self.hitSkillId = 900090901	
	self.questionSkillId = 900090904
	self.inQuestion = false
	self.questionDialogId = 601019201
	self.sorryDialogId = 601019202
	self.fightDialogId = 601019203
	self.chooseSorry = false
	self.chooseFight = false
end

--帧事件
function FSMBehavior90009002:Update()
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
	end
	if not self.inHit and not self.inQuestion then
		self.inQuestion = true
		BehaviorFunctions.CastSkillByTarget(self.me,self.questionSkillId,self.role)
		BehaviorFunctions.StartNPCDialog(self.questionDialogId,self.me)
		--BehaviorFunctions.CustomFSMTryChangeState(self.me)	
	end
	
end

--赋值
function FSMBehavior90009002:Assignment(variable,value)
	self[variable] = value
end

--赋值
function FSMBehavior90009002:MainBehaviorAssignment(variable,value)
	self.ParentBehavior[variable] = value
end

function FSMBehavior90009002:__delete()
	--Log("tstststs")
end

--技能结束
function FSMBehavior90009002:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me and skillId == self.hitSkillId then
		self.inHit = false
	end
end

--对话选项
function FSMBehavior90009002:StoryPassEvent(dialogId)
	if dialogId == self.sorryDialogId then
		self.chooseSorry = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	elseif dialogId == self.fightDialogId then
		self.chooseFight = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end