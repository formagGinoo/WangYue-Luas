Behavior800020 = BaseClass("Behavior800020",EntityBehaviorBase)

--初始化
function Behavior800020:Init()
	--逻辑参数
	self.me = self.instanceId
	self.myFrame = 0
	self.magicState = 0
	self.extraParam = nil
	self.defaultDialogId = nil
	self.bubbleList = nil


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
	--巡逻相关
	self.patrolList = nil
	self.patrolNum = 1
	self.inReturen = false
	self.canReturn = true
	self.patrolState = 0
	self.patrolStateEnum = {
		Default = 0, --默认
		Patroling = 1, --正在巡逻
		Arrive = 2, --到达
		Turn = 3, --到达转身
		Act = 4, --演出
	}
	self.actState = 0
	self.actStateEnum = {
		Default = 0, --默认
		In = 1, --进入
		Loop = 2, --持续
		Out = 3, --退出
		End = 4, --结束
	}
	self.patrolActing = nil
	self.pathFindingArrive = nil

	--对话相关
	self.startTalkPos = nil
	self.startTalkLookPos = nil
	self.talkTurn = nil
	self.beforePos = nil
	self.beforelookPos = nil

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

	--状态切换
	self.myState = 0
	self.myStateEnum = {
		Default = 0, --默认
		Patrol = 1, --巡逻
		Talk = 2, --对话
		BeHit = 3, --受击
		BeCollide = 4, --碰撞
		Turn = 5, --位移转身
	}
	self.talkState = 0
	self.talkStateEnum = {
		Default = 0, --默认
		Talking = 1, --正在
		Ending = 2, --退出
	}
	--开放参数
	self.canBeHit = true
	self.beHitAnimationName = "Afraid"
	self.canBeCollide = true
	self.dialogId=nil
	self.missionState=0
	self.talkInitialList="Motou-5|Stanshou-3"
	self.actDefault=nil
	
end



--帧事件
function Behavior800020:Update()
	--if self.npcId == 8010203 then
	--Log("myState"..self.myState)
	--end
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.magicState == 0 then

		self.magicState = 1
	end
	
	--获得npc的默认对话
	if self.missionState==0 then
		self.actDefault=BehaviorFunctions.GetEntityValue(self.me,"act")
		if self.actDefault then
			BehaviorFunctions.PlayAnimation(self.me,self.actDefault)
			self.missionState=1
		end	
	end
	
	
	
	
	

	if BehaviorFunctions.GetEntityValue(self.me,"actList") 
		and self.actList==nil then
		self.actInitialList=BehaviorFunctions.GetEntityValue(self.me,"actList")
		local actList = self:SplitParam(self.actInitialList,"|")
		self.actList = self:GetAniList(actList)
		
		
	end
	

	
	
	if self.talkList==nil then
		local talkList = self:SplitParam(self.talkInitialList,"|")
		self.talkList = self:GetAniList(talkList)
	end
	
	if self.dialogId==nil then
		self.dialogId=BehaviorFunctions.GetEntityValue(self.me,"dialogId")
	end

	--巡逻

	--对话动作
	self:TalkAct()
	--默认动作
	
	
	if self.actList 
		and not self.actDefault then
		self:DefaultAct()
	end
	

end


--点击交互:播放默认对话
function Behavior800020:WorldInteractClick(uniqueId)
	if self.dialogId~=nil then


		if self.interactUniqueId and self.interactUniqueId == uniqueId then


			--记录初始点位，朝向
			if self.myState == self.myStateEnum.BeHit or self.myState == self.myStateEnum.BeCollide then
				self.startTalkPos = self.beforePos
				self.startTalkLookPos = self.beforelookPos
			else
				self.startTalkPos = BehaviorFunctions.GetPositionP(self.me)
				self.startTalkLookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
			end
			--设置Talk状态
			if self.myState ~= self.myStateEnum.Talk then
				self.myState = self.myStateEnum.Talk
				if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.me)
					BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
				end
				--停止巡逻
				BehaviorFunctions.ClearPathFinding(self.me)
				--停止巡逻演出
				self.actState = self.actStateEnum.Default
				if self.dialogId then
					BehaviorFunctions.StartStoryDialog(self.dialogId)
				end

				BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
				local rolePos = BehaviorFunctions.GetPositionP(self.role)
				self.talkTurn = true
				self:Turn(self.startTalkPos,rolePos)

				local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Standback")
				BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkState",self.talkStateEnum.Talking)

				----判断角度转身
				--if not BehaviorFunctions.CompEntityLessAngle(self.me,self.role,45) then
				--local rolePos = BehaviorFunctions.GetPositionP(self.role)
				--self.talkTurn = true
				--self:Turn(self.startTalkPos,rolePos)
				--local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Standback")
				--BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkState",self.talkStateEnum.Talking)
				--else
				--self.talkState = self.talkStateEnum.Talking
				--end
				self.isTrigger = nil
			end
		end
	end

end

--进入交互范围，添加交互列表
function Behavior800020:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.dialogId~=nil then

		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		if self.myState ~= self.myStateEnum.Talk  then
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"对话")
		end
	end


end

--退出交互范围，移除交互列表
function Behavior800020:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.dialogId~=nil then
		if self.isTrigger and triggerInstanceId == self.me then
			self.isTrigger = nil
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		end
	end
end

--对话结束
function Behavior800020:StoryEndEvent(dialogId)
	if dialogId == self.dialogId and self.myState == self.myStateEnum.Talk then
		if self.talkTurn  then
			self.talkState = self.talkStateEnum.Ending
			if not BehaviorFunctions.GetEntityValue(self.me,"talkEnd") then
				self:Turn(self.startTalkPos,self.startTalkLookPos)
			elseif BehaviorFunctions.GetEntityValue(self.me,"talkEnd")=="noReaction" then
			
			elseif BehaviorFunctions.GetEntityValue(self.me,"talkEnd")=="resetState" then
				self.missionState=0
			end
		else
			self.myState = self.myStateEnum.Default
		end
	end
end


--位移转身
function Behavior800020:Turn(pos,lookPos)
	if self.myState ~= self.myStateEnum.Turn then
		--talk有专有talkturen，其他都是turn
		if self.myState ~= self.myStateEnum.Talk then
			self.myState = self.myStateEnum.Turn
		end
		

		if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
			BehaviorFunctions.StopMove(self.me)
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
		end
		BehaviorFunctions.DoSetPositionP(self.me,pos)
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,lookPos.x,myPos.y,lookPos.z,false,180,460)
		BehaviorFunctions.PlayAnimation(self.me,"Standback")
		local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Standback")
		--默认情况
		if self.myState ~= self.myStateEnum.Talk then
			self.AssignmentDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"myState",self.myStateEnum.Default)
		elseif self.talkTurn and self.talkState == self.talkStateEnum.Ending then
			--对话结束的talkturn
			BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkTurn",nil)
			BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkState",self.talkStateEnum.Default)
			self.AssignmentDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"myState",self.myStateEnum.Default)
		end
	end
end


--对话动作轮播
function Behavior800020:TalkAct()
	if self.talkState == self.talkStateEnum.Talking and self.myState == self.myStateEnum.Talk then
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
	end
end

--气泡对话
function Behavior800020:Bubble(list)

end

--注视IK
function Behavior800020:CanLook(Can)

end

--默认动作轮播
function Behavior800020:DefaultAct()
	if self.myState == self.myStateEnum.Default then
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
end


--赋值
function Behavior800020:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end

--解析AniList
function Behavior800020:GetAniList(list)
	local beforeList = list
	local afterList = {}
	for i = 1, #beforeList do
		local stepList = self:SplitParam(beforeList[i],"-")
		if #stepList == 1 then
			table.insert(afterList,{posName = stepList[1]})
		else
			table.insert(afterList,{aniName = stepList[1],lastTime = tonumber(stepList[2])})
		end
	end
	return afterList
end

--拆分字符串
function Behavior800020:SplitParam(string,sep)
	local list = {}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end