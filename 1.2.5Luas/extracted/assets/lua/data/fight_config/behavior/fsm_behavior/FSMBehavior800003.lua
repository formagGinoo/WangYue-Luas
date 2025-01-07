FSMBehavior800003 = BaseClass("FSMBehavior800003",FSMBehaviorBase)
--NPC通用AI：状态机总控

--初始化
function FSMBehavior800003:Init()
	--逻辑参数
	self.me = self.instanceId
	self.myFrame = 0
	self.magicState = 0
	self.extraParam = nil
	self.defaultDialogId = nil
	self.bubbleId = nil
	self.inBubbleCd = false
	self.bubbleCd = 30

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
end


--初始化结束
function FSMBehavior800003:LateInit()
	if self.sInstanceId then

		self.npcId = self.sInstanceId
		--获取ExtraParam

		self.name = BehaviorFunctions.GetNpcName(self.npcId)
		self.extraParam = BehaviorFunctions.GetNpcExtraParam(self.npcId)

		--ExtraParam处理
		for i = 1, #self.extraParam do
			--logicName
			if self.extraParam[i].logicName then
				self.logicName = self.extraParam[i].logicName
			end
			--patrolList
			if self.extraParam[i].patrolList then
				local patrolList = self:SplitParam(self.extraParam[i].patrolList,"|")
				self.patrolList = self:GetPatrolList(patrolList)
			end
			--patrolReturn
			if self.extraParam[i].patrolReturn then
				local patrolReturn = self.extraParam[i].patrolReturn
				if patrolReturn == "FALSE" then
					self.canReturn = false
				else
					self.canReturn = true
				end
			end
			--actList
			if self.extraParam[i].actList then
				local actList = self:SplitParam(self.extraParam[i].actList,"|")
				self.actList = self:GetAniList(actList)
			end
			--talkList
			if self.extraParam[i].talkList then
				local talkList = self:SplitParam(self.extraParam[i].talkList,"|")
				self.talkList = self:GetAniList(talkList)
			end
			--canBeHit
			if self.extraParam[i].canBeHit then
				local canBeHit = self.extraParam[i].canBeHit
				if canBeHit == "FALSE" then
					self.canBeHit = false
				else
					self.canBeHit = true
				end
			end
			--beHitAnimationName
			if self.extraParam[i].beHitAnimationName then
				self.beHitAnimationName = self.extraParam[i].beHitAnimationName
			end
			--canBeCollide
			if self.extraParam[i].canBeCollide then
				local canBeCollide = self.extraParam[i].canBeCollide
				if canBeCollide == "FALSE" then
					self.canReturn = false
				else
					self.canReturn = true
				end
			end
		end

	end

end

--帧事件
function FSMBehavior800003:Update()
	--if self.npcId == 8010203 then
	--Log("myState"..self.myState)
	--end
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.magicState == 0 then
		BehaviorFunctions.DoMagic(1,self.me,900000001) --免疫受击
		BehaviorFunctions.DoMagic(1,self.me,900000013)--免疫锁定
		BehaviorFunctions.DoMagic(1,self.me,900000020)--免疫受击朝向
		BehaviorFunctions.DoMagic(1,self.me,900000022)--免疫伤害
		BehaviorFunctions.DoMagic(1,self.me,900000023)--免疫伤害
		self.magicState = 1
	end
	--会根据任务变化，所以需要每帧数判断
	if self.npcId then
		self.isInTask = BehaviorFunctions.CheckNpcIsInTask(self.npcId)
		self.defaultDialogId = BehaviorFunctions.GetNpcDialogId(self.npcId)
		self.bubbleId = BehaviorFunctions.GetNpcBubbleId(self.npcId)
	end
	--巡逻
	if self.patrolList then
		self:Patrol()
	end
	--对话动作
	if self.talkList then
		self:TalkAct()
	end
	--默认动作
	if self.actList then
		self:DefaultAct()
	end
	--气泡对话
	if self.bubbleId and not self.inBubbleCd then
		self:Bubble()
		self.inBubbleCd = true
	end
end


--点击交互:播放默认对话
function FSMBehavior800003:WorldInteractClick(uniqueId)
	if self.defaultDialogId	 then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			--停止状态赋值
			if self.AssignmentDelay then
				BehaviorFunctions.RemoveDelayCall(self.AssignmentDelay)
				self.AssignmentDelay = nil
				if self.talkState == self.talkStateEnum.Ending then
					self.talkState = self.talkStateEnum.Default
				end
			end
			--停止位移转身
			if self.CollideDelay then
				BehaviorFunctions.RemoveDelayCall(self.CollideDelay)
				self.CollideDelay = nil
			end
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
				if self.patrolState == self.patrolStateEnum.Patroling then
					self.patrolState = self.patrolStateEnum.Default
				end
				BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
				BehaviorFunctions.StartStoryDialog(self.defaultDialogId)
				BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,false)
				--判断角度转身
				if not BehaviorFunctions.CompEntityLessAngle(self.me,self.role,45) then
					local rolePos = BehaviorFunctions.GetPositionP(self.role)
					self.talkTurn = true
					self:Turn(self.startTalkPos,rolePos)
					local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Standback")
					BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Assignment,"talkState",self.talkStateEnum.Talking)
				else
					self.talkState = self.talkStateEnum.Talking
				end
				self.isTrigger = nil
			end
		end
	end

end

--进入交互范围，添加交互列表
function FSMBehavior800003:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.defaultDialogId
		and self.defaultDialogId > 0
		and self.myState ~=  self.myStateEnum.BeHit
		and self.myState ~=  self.myStateEnum.BeCollide
		and self.myState ~=  self.myStateEnum.Turn
		and self.talkState ~= self.talkStateEnum.Ending
		and self.myState ~=  self.myStateEnum.Talk then
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		if self.myState ~= self.myStateEnum.Talk then
			self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,self.name)
		end
	end

end

--退出交互范围，移除交互列表
function FSMBehavior800003:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = nil
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

--对话结束
function FSMBehavior800003:StoryEndEvent(dialogId)
	if dialogId == self.defaultDialogId and self.myState == self.myStateEnum.Talk then
		BehaviorFunctions.SetNpcHeadInfoVisible(self.npcId,true)
		if self.talkTurn  then
			self.talkState = self.talkStateEnum.Ending
			self:Turn(self.startTalkPos,self.startTalkLookPos)
		else
			self.myState = self.myStateEnum.Default
		end
	end
end

--巡逻
function FSMBehavior800003:Patrol()
	if self.myState == self.myStateEnum.Default or self.myState == self.myStateEnum.Patrol then
		if self.myState ~= self.myStateEnum.Patrol then
			self.myState = self.myStateEnum.Patrol
		end
		--目标点
		local nextPosition = BehaviorFunctions.GetTerrainPositionP(self.patrolList[self.patrolNum].posName,10020001,self.logicName)
		--当前点
		local myPosition = BehaviorFunctions.GetPositionP(self.me)
		--目标点和当前点的距离
		local distance = BehaviorFunctions.GetDistanceFromPos(myPosition,nextPosition)

		--巡逻状态
		if self.patrolState == self.patrolStateEnum.Default then
			self.patrolState = self.patrolStateEnum.Patroling
			if BehaviorFunctions.CanCtrl(self.me) == true and self:PathFindingBegin() then
				if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
					BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
				end
			end
		end
		--到达
		if self.patrolState == self.patrolStateEnum.Patroling and self.pathFindingArrive then
			if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
				BehaviorFunctions.StopMove(self.me)
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
			end
			self.pathFindingArrive = nil
			self.patrolState = self.patrolStateEnum.Arrive
		end
		--到达转身
		if self.patrolState == self.patrolStateEnum.Arrive then
			local pos = BehaviorFunctions.GetPositionP(self.me)
			local lookPos = nil
			--会表演，转向表演方向
			if self.patrolList[self.patrolNum].aniName then
				--玩家出生且看向
				local rotate = BehaviorFunctions.GetTerrainRotationP(self.patrolList[self.patrolNum].posName,10020001,self.logicName)
				local tpos = BehaviorFunctions.GetTerrainPositionP(self.patrolList[self.patrolNum].posName,10020001,self.logicName)
				local zero = Vec3.New(0,0,1)
				local targetPos = BehaviorFunctions.GetPositionOffsetWithRot(tpos,zero,10,rotate.y)
				self:Turn(pos,targetPos)
				self.patrolState = self.patrolStateEnum.Turn
				self.actState = self.actStateEnum.In
				--不会表演，转向下一个目标点，完成后继续巡逻
			else
				self:NextPatrolNum()
				local targetPos = BehaviorFunctions.GetTerrainPositionP(self.patrolList[self.patrolNum].posName,10020001,self.logicName)
				self:Turn(pos,targetPos)
				self.patrolState = self.patrolStateEnum.Turn
			end
		end
		--转身完成
		if self.myState ~=self.myStateEnum.Turn and self.patrolState == self.patrolStateEnum.Turn then
			--没有演出，继续巡逻
			if self.actState == self.actStateEnum.Default then
				self.patrolState = self.patrolStateEnum.Default
				--演出
			elseif self.actState == self.actStateEnum.In then
				self.patrolState = self.patrolStateEnum.Act
			end
		end
		--演出
		if self.patrolState == self.patrolStateEnum.Act then
			--开始
			if self.actState == self.actStateEnum.In and not self.patrolActing then
				local aniName = self.patrolList[self.patrolNum].aniName.."_in"
				local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
				--判断动作是performLayer还是defaultLayer
				if aniFrame ~= -1 then
					--是performLayer，直接播
					BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
					BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"actState",self.defaultActStateEnum.Loop)
					BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"patrolActing",nil)
				else
					--是defaultLayer，改名再播，直接跳到完成
					aniName = self.patrolList[self.patrolNum].aniName
					BehaviorFunctions.PlayAnimation(self.me,aniName)
					BehaviorFunctions.AddDelayCallByFrame(self.patrolList[self.patrolNum].lastTime*30,self,self.Assignment,"actState",self.actStateEnum.End)
					BehaviorFunctions.AddDelayCallByFrame(self.patrolList[self.patrolNum].lastTime*30,self,self.Assignment,"patrolActing",nil)
				end
				self.patrolActing = true
			end
			--持续
			if self.actState == self.actStateEnum.Loop and not self.patrolActing then
				local aniName = self.patrolList[self.patrolNum].aniName.."_loop"
				BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
				local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
				if self.patrolList[self.patrolNum].lastTime and self.patrolList[self.patrolNum].lastTime*30 >= aniFrame then
					aniFrame = self.patrolList[self.patrolNum].lastTime*30
				end
				self.patrolActing = true
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"actState",self.actStateEnum.Out)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"patrolActing",nil)
			end
			--退出
			if self.actState == self.actStateEnum.Out and not self.patrolActing then
				local aniName = self.patrolList[self.patrolNum].aniName.."_end"
				BehaviorFunctions.PlayAnimation(self.me,aniName,FightEnum.AnimationLayer.PerformLayer)
				local aniFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,aniName)
				self.patrolActing = true
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"actState",self.actStateEnum.End)
				BehaviorFunctions.AddDelayCallByFrame(aniFrame,self,self.Assignment,"patrolActing",nil)
			end
			--结束
			if self.actState == self.actStateEnum.End then
				self:NextPatrolNum()
				self.patrolState = self.patrolStateEnum.Default
				self.actState = self.actStateEnum.Default
			end
		end
	end
end

function FSMBehavior800003:PathFindingBegin()
	local nextPosition = BehaviorFunctions.GetTerrainPositionP(self.patrolList[self.patrolNum].posName,10020001,self.logicName)
	local result = BehaviorFunctions.SetPathFollowPos(self.me,nextPosition)
	if result == true then
		return true
	else
		--LogError("无路径可供寻路")
		return false
	end
end

function FSMBehavior800003:PathFindingEnd(instanceId,result)
	if instanceId == self.me and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(self.me)
		self.pathFindingArrive = true
	elseif instanceId == self.me and result == false then
		--寻路异常
		BehaviorFunctions.ClearPathFinding(self.me)
		--LogError("无法抵达该地点，已停止跟随")
	end
end

function FSMBehavior800003:NextPatrolNum()
	--获取下一个目标点
	--不会折返
	if self.canReturn == false then
		if self.patrolNum < #self.patrolList  then
			self.patrolNum = self.patrolNum + 1
		elseif self.patrolNum == #self.patrolList  then
			self.patrolNum = 1
		end
		--会折返
	elseif self.canReturn == true then
		--没开始折返，正常巡逻
		if self.inReturen == false then
			if self.patrolNum < #self.patrolList  then
				self.patrolNum = self.patrolNum + 1
			elseif self.patrolNum == #self.patrolList  then
				self.inReturen = true
			end
			--开始折返，反向巡逻
		elseif self.inReturen == true then
			if self.patrolNum > 1  then
				self.patrolNum = self.patrolNum - 1
			elseif self.patrolNum == 1 then
				self.inReturen = false
			end
		end
	end
end

--受击
function FSMBehavior800003:FirstCollide(attackInstanceId,hitInstanceId,instanceId)
	if self.canBeHit then
		if  self.interactUniqueId then
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			self.isTrigger = nil
		end
		if (self.myState == self.myStateEnum.Default or self.myState == self.myStateEnum.Patrol)
			and hitInstanceId == self.me
			and BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= 3 then
			if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
				BehaviorFunctions.StopMove(self.me)
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
			end
			self.beforePos = BehaviorFunctions.GetPositionP(self.me)
			self.beforelookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
			BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
			BehaviorFunctions.PlayAnimation(self.me,self.beHitAnimationName)
			local animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,self.beHitAnimationName)
			self.myState = self.myStateEnum.BeHit
			self.CollideDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Turn,self.beforePos,self.beforelookPos)
		end
	end
end

--移动碰撞
function FSMBehavior800003:OnEntityCollision(instanceId,collisionInstanceId)
	if self.canBeCollide then
		if (self.myState == self.myStateEnum.Default or self.myState == self.myStateEnum.Patrol)
			--发生碰撞
			and ((instanceId == self.me  and collisionInstanceId == self.role) or (instanceId == self.role  and collisionInstanceId == self.me))
			--角色状态
			and self:BeCollideRule() then

			if  self.interactUniqueId then
				BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
				self.isTrigger = nil
			end

			if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
				BehaviorFunctions.StopMove(self.me)
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
			end
			self.beforePos = BehaviorFunctions.GetPositionP(self.me)
			self.beforelookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
			local animationFrame = nil
			--碰撞来自正面
			if BehaviorFunctions.CompEntityLessAngle(self.me,self.role,90) then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
				BehaviorFunctions.PlayAnimation(self.me,"Fhit")
				animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Fhit")
				self.myState = self.myStateEnum.BeCollide
				--碰撞来自背面
			else
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
				local pos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,180)
				BehaviorFunctions.DoLookAtPositionImmediately(self.me,pos.x,pos.y,pos.z)
				BehaviorFunctions.PlayAnimation(self.me,"Bhit")
				animationFrame = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Bhit")
				self.myState = self.myStateEnum.BeCollide
			end
			if self.myState ~= self.myStateEnum.Talk then
				self.CollideDelay = BehaviorFunctions.AddDelayCallByFrame(animationFrame,self,self.Turn,self.beforePos,self.beforelookPos)
			end
		end
	end
end

--移动碰撞条件
function FSMBehavior800003:BeCollideRule()
	if BehaviorFunctions.GetSubMoveState(self.role) == FightEnum.EntityMoveSubState.RunStart then
		return true
	elseif BehaviorFunctions.GetSubMoveState(self.role) == FightEnum.EntityMoveSubState.Run then
		return true
	elseif BehaviorFunctions.GetSubMoveState(self.role) == FightEnum.EntityMoveSubState.Sprint then
		return true
	elseif BehaviorFunctions.GetSkillSign(self.role,10000007) then
		return true
	else
		return false
	end
end


--位移转身
function FSMBehavior800003:Turn(pos,lookPos)
	if self.myState ~= self.myStateEnum.Turn then
		--talk有专有talkturen，其他都是turn
		if self.myState ~= self.myStateEnum.Talk then
			self.myState = self.myStateEnum.Turn
		end
		--巡逻重置
		BehaviorFunctions.ClearPathFinding(self.me)
		if self.patrolState == self.patrolStateEnum.Patroling then
			self.patrolState = self.patrolStateEnum.Default
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

--默认动作轮播
function FSMBehavior800003:DefaultAct()
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

--对话动作轮播
function FSMBehavior800003:TalkAct()
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
function FSMBehavior800003:Bubble()
	--设置气泡对话内容
	BehaviorFunctions.ChangeNpcBubbleId(self.npcId,self.bubbleId)
	--显示气泡对话
	BehaviorFunctions.SetNpcBubbleVisible(self.npcId,true)
	BehaviorFunctions.AddDelayCallByTime(self.bubbleCd,self,self.Assignment,"inBubbleCd",false)
end

--注视IK
function FSMBehavior800003:CanLook(Can)

end

--解析patrolList
function FSMBehavior800003:GetPatrolList(list)
	local beforeList = list
	local afterList = {}
	for i = 1, #beforeList do
		local stepList = self:SplitParam(beforeList[i],"-")
		if #stepList == 1 then
			table.insert(afterList,{posName = stepList[1]})
		elseif #stepList == 3 then
			table.insert(afterList,{posName = stepList[1],aniName = stepList[2],lastTime = tonumber(stepList[3])})
		end
	end
	return afterList
end

--解析AniList
function FSMBehavior800003:GetAniList(list)
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
function FSMBehavior800003:SplitParam(string,sep)
	local list = {}
	if string == nil then
		return nil
	end
	string.gsub(string,'[^'..sep..']+',function (w)
			table.insert(list,w)
		end)
	return list
end

--赋值
function FSMBehavior800003:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end