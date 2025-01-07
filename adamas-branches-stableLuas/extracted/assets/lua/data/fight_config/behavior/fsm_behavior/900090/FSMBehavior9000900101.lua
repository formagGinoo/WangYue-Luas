FSMBehavior9000900101 = BaseClass("FSMBehavior9000900101",FSMBehaviorBase)
--NPC通用AI-子状态机-默认状态：播动作

--初始化
function FSMBehavior9000900101:Init()
	self.me = self.instanceId
	self.npcId = nil
	--默认动作
	self.actList = nil
	self.defaultActing = nil
	self.defaultActNum = 1
	self.defaultActState = 0
	self.defaultActStateEnum = {
		Default = 0, --默认
		In = 1, --进入
		Loop = 2, --持续
		Out = 3, --退出
		End = 4, --结束
	}
end


--初始化结束
function FSMBehavior9000900101:LateInit()
	if self.sInstanceId then
		self.npcId = self.sInstanceId
		self.actList = BehaviorFunctions.GetNpcConfigByKey(self.npcId,"act_list")
	end
	if self.actList and next(self.actList) then
		self.actList = self:GetActList(self.actList)
	end
end

--帧事件
function FSMBehavior9000900101:Update()
	--默认动作
	if self.actList and next(self.actList) then
		self:DefaultAct()
	end
end

--默认动作轮播
function FSMBehavior9000900101:DefaultAct()
	if self.defaultActState == self.defaultActStateEnum.Default then
		self.defaultActState = self.defaultActStateEnum.In
	end
	--开始
	if self.defaultActState == self.defaultActStateEnum.In and not self.defaultActing then
		local aniName = self.actList[self.defaultActNum].aniName.."_in"
		local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
		--判断动作是performLayer还是defaultLayer
		if aniFrame ~= -1 then
			--是performLayer，直接播
			BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Loop)
			BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
		else
			--是defaultLayer，改名再播，直接跳到完成
			aniName = self.actList[self.defaultActNum].aniName
			BehaviorFunctions.PlayAnimation(self.me,aniName)
			BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastTime*30,self,self.Assignment,"defaultActState",self.defaultActStateEnum.End)
			BehaviorFunctions.AddDelayCallByFrame(self.actList[self.defaultActNum].lastTime*30,self,self.Assignment,"defaultActing",nil)
		end
		self.defaultActing = true
	end
	--持续
	if self.defaultActState == self.defaultActStateEnum.Loop and not self.defaultActing then
		local aniName = self.actList[self.defaultActNum].aniName.."_loop"
		BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
		local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
		if self.actList[self.defaultActNum].lastTime and self.actList[self.defaultActNum].lastTime*30 >= aniFrame then
			aniFrame = self.actList[self.defaultActNum].lastTime*30
		end
		self.defaultActing = true
		BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.Out)
		BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
	end
	--退出
	if self.defaultActState == self.defaultActStateEnum.Out and not self.defaultActing then
		local aniName = self.actList[self.defaultActNum].aniName.."_end"
		BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
		local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
		self.defaultActing = true
		BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActState",self.defaultActStateEnum.End)
		BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"defaultActing",nil)
	end
	--结束
	if self.defaultActState == self.defaultActStateEnum.End then
		--获取下一个对话动作
		if self.defaultActNum < #self.actList  then
			self.defaultActNum = self.defaultActNum + 1
		elseif self.defaultActNum == #self.actList  then
			self.defaultActNum = 1
		end
		self.defaultActState = self.defaultActStateEnum.Default
	end
end

--解析ActList
function FSMBehavior9000900101:GetActList(list)
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
function FSMBehavior9000900101:Assignment(variable,value)
	self[variable] = value
end