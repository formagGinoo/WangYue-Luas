FSMBehavior800007 = BaseClass("FSMBehavior800007",FSMBehaviorBase)
--NPC通用AI：对话状态

--初始化
function FSMBehavior800007:Init()
	self.me = self.instanceId
	self.pointSkillId = 80001005
	self.inTalk = false
	self.dialogId = nil
	--对话相关
	self.talkList = nil
	self.talk = nil
	self.talkActNum = 1
	self.talkActState = 0
	self.talkActStateEnum = {
		Default = 0, --默认
		In = 1, --进入
		Loop = 2, --持续
		Out = 3, --退出
		End = 4, --结束
	}
	self.inPoint = false
end


--初始化结束
function FSMBehavior800007:LateInit()
	if self.ParentBehavior.npcId then
		self.npcId = self.ParentBehavior.npcId
	end
	if self.npcId then
		self.talkList = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"talk_list")
	end
	if self.talkList and next(self.talkList) then
		self.talkList = self:GetActList(self.talkList)
	end
	if self.ParentBehavior.inDefaultTalk then
		self.dialogId = self.ParentBehavior.defaultDialogId
	elseif self.ParentBehavior.inAlertTalk then
		self.dialogId = self.ParentBehavior.alertDialogId
	end
end

--帧事件
function FSMBehavior800007:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.inTalk and self.dialogId then
		BehaviorFunctions.StartNPCDialog(self.dialogId,self.me)
		BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,false)		
		self.inTalk = true
	end
	if self.inTalk and self.ParentBehavior.inDefaultTalk and self.talkList and next(self.talkList) then
		if self.talkActState == self.talkActStateEnum.Default then
			self.talkActState = self.talkActStateEnum.In
		end
		--开始
		if self.talkActState == self.talkActStateEnum.In and not self.talkActing then
			local aniName = self.talkList[self.talkActNum].aniName.."_in"
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			if aniFrame ~= -1 then
				--是performLayer，直接播
				BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActState",self.talkActStateEnum.Loop)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActing",nil)
			else
				--是defaultLayer，改名再播，直接跳到完成
				aniName = self.talkList[self.talkActNum].aniName
				BehaviorFunctions.PlayAnimation(self.me,aniName)
				BehaviorFunctions.AddDelayCallByFrame(self.talkList[self.talkActNum].lastTime*30,self,self.Assignment,"talkActState",self.talkActStateEnum.End)
				BehaviorFunctions.AddDelayCallByFrame(self.talkList[self.talkActNum].lastTime*30,self,self.Assignment,"talkActing",nil)
			end
			self.talkActing = true
		end
		--持续
		if self.talkActState == self.talkActStateEnum.Loop and not self.talkActing then
			local aniName = self.talkList[self.talkActNum].aniName.."_loop"
			BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			if self.talkList[self.talkActNum].lastTime and self.talkList[self.talkActNum].lastTime*30 >= aniFrame then
				aniFrame = self.talkList[self.talkActNum].lastTime*30
			end
			self.talkActing = true
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActState",self.talkActStateEnum.Out)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActing",nil)
		end
		--退出
		if self.talkActState == self.talkActStateEnum.Out and not self.talkActing then
			local aniName = self.talkList[self.talkActNum].aniName.."_end"
			BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
			local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
			self.talkActing = true
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActState",self.talkActStateEnum.End)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"talkActing",nil)
		end
		--结束
		if self.talkActState == self.talkActStateEnum.End then
			--获取下一个对话动作
			if self.talkActNum < #self.talkList  then
				self.talkActNum = self.talkActNum + 1
			elseif self.talkActNum == #self.talkList  then
				self.talkActNum = 1
			end
			self.talkActState = self.talkActStateEnum.Default
		end
	elseif self.inTalk and self.ParentBehavior.inAlertTalk then
		if BehaviorFunctions.CanCtrl(self.me) and not self.inPoint then
			BehaviorFunctions.CastSkillByTarget(self.me,self.pointSkillId,self.role)
			self.inPoint =true
		end
	end
end

--对话结束
function FSMBehavior800007:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		self.inTalk = false
		self.ParentBehavior.inDefaultTalk = false
		self.ParentBehavior.inAlertTalk = false
		self.ParentBehavior.chooseSorry = false
		self.ParentBehavior.chooseRefuse = false
		if self.npcId then
			BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,true)
		end
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

--选项：道歉或放下
function FSMBehavior800007:StoryPassEvent(dialogId)
	if dialogId == self.ParentBehavior.sorryDialogId then
		Log("此处应当讨价还价")
	elseif dialogId == self.ParentBehavior.refuseDialogId then
		if not BehaviorFunctions.GetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime) then
			local myPos = BehaviorFunctions.GetPositionP(self.me)
			BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime,myPos)
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.SetEntityBineVisible(self.me,"Phone",true)
			BehaviorFunctions.PlayAnimation(self.me,"PhoneStand_loop")
		end
	end
end

--解析ActList
function FSMBehavior800007:GetActList(list)
	local beforeList = list
	local afterList = {}
	for i = 1, #beforeList do
		local stepList = beforeList[i]
		if stepList[1]~="" and stepList[2]>0 then
			table.insert(afterList,{aniName = stepList[1],lastTime = stepList[2]})
		end
	end
	return afterList
end

--赋值
function FSMBehavior800007:Assignment(variable,value)
	self[variable] = value
end